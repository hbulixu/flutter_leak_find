
import 'dart:developer';
import 'package:vm_service/utils.dart';
import 'package:vm_service/vm_service.dart' as vs;
import 'package:vm_service/vm_service.dart';
import 'package:vm_service/vm_service_io.dart';

class VMUtils{
  static final VMUtils _vmUtils =  VMUtils._internal();
  factory  VMUtils(){
    return _vmUtils;
  }
  VMUtils._internal();

  Future<VmInfo> connect() async{

    final info = await Service.getInfo();
    final serverUri = info.serverUri;
    final url = convertToWebSocketUrl(serviceProtocolUrl: serverUri);

    var vmClient = await vmServiceConnectUri(url.toString());
    var vm = await vmClient.getVM();
    var mainIsoRef = _getMainIsolates(vm.isolates);
    var mainIso = await vmClient.getIsolate(mainIsoRef.id);
    final rootUrl = mainIso.rootLib.uri.toString();
    var packageName = rootUrl.substring(0, rootUrl.indexOf('/'));

    return VmInfo(vmClient,vm,mainIsoRef,mainIso,packageName);
  }

  Future <List <ClassInfo>> getClassInfo(VmInfo vmInfo, List <String> classNames) async{

    final iso =vmInfo.mainIso;
    final libs = iso.libraries;
    var  packageName = vmInfo.packageName;
    var  vmClient = vmInfo.vmClient;
    final List<vs.LibraryRef> packageLibs = [];
    libs.forEach((lib) {
      final url = lib.uri;
      if (url.contains(packageName)) packageLibs.add(lib);
    });
    final classNameSet = {};
    classNames.forEach((element) {
      classNameSet[element] = element;
    });

    final stateSet = classNameSet.keys.map((e) => 'State<$e>').toSet();
    List<ClassInfo> result = [];
    await Future.forEach<vs.LibraryRef>(packageLibs, (lib) async {
      final vs.Library obj = await vmClient.getObject(iso.id, lib.id);
      var urlString = obj.uri;
      var filePath = 'lib'+urlString.substring(urlString.indexOf('/'));
      final libClasses = obj.classes ?? [];
      await Future.forEach<vs.ClassRef>(libClasses, (cla) async {
        final vs.Class obj = await vmClient.getObject(iso.id, cla.id);
        final isWidget = classNameSet[obj.name] != null;
        final isState = stateSet.contains(obj.superType.name);
        if(isWidget || isState){
          var leakClass = obj;
          if(isState && obj.subclasses.isNotEmpty){
            final subClass = obj.subclasses.first;
            final tarClass = await vmClient.getObject(iso.id, subClass.id);
            leakClass = tarClass;
          }
          var classInfo = ClassInfo( isState, leakClass, filePath);
          result.add(classInfo);
        }
      });
    });
    return result;
  }

 Future<List<LeakObject>> getInstance(VmInfo vmInfo,List <ClassInfo> classInfoList) async{
   var vmClient = vmInfo.vmClient;
   var mainIso = vmInfo.mainIso;
   List<LeakObject> result = [];
    await Future.forEach<ClassInfo>(classInfoList, (element) async{
      final vs.InstanceSet instance = await vmClient.getInstances(mainIso.id, element.leakClass.id, 1);
      if(instance.totalCount>0){
        result.add(LeakObject(instance, instance.totalCount, element));
      }
    });
    return result;
  }

  Future<List<RetainInfo>> getRetainPath (VmInfo vmInfo,String objectId) async{

    var vmClient = vmInfo.vmClient;
    var mainIso = vmInfo.mainIso;
    RetainingPath paths = await vmClient.getRetainingPath(mainIso.id, objectId, 500);
    List<RetainInfo> retainInfoList = [];
    for(int i =0;i<paths.elements.length;i++){

      var ref = paths.elements[i].value;
      var element = paths.elements[i];
      var retainInfo = RetainInfo();
      retainInfo.index = i;
      if (ref is InstanceRef) {
        retainInfo.field = element.parentField??"offset";
        retainInfo.className = ref.classRef.name;
      } else if (ref is FieldRef) {
        retainInfo.field = ref.name;
        retainInfo.className = 'No Value Type';
      } else if (ref is ContextRef) {
        retainInfo.field = element.parentField??"offset";
        retainInfo.className = ref.type;
      }
      retainInfoList.add(retainInfo);
    }
    return retainInfoList;
  }

  vs.IsolateRef _getMainIsolates(List<vs.IsolateRef> isolates){
    for(var isolate in isolates){
      if(isolate.name == 'main'){
        return isolate;
      }
    }
    return null;
  }
}

class VmInfo{

 final vs.VmService vmClient;
 final vs.VM vm;
 final vs.IsolateRef mainIsoRef;
 final vs.Isolate mainIso;
 final String packageName;

 VmInfo(this.vmClient, this.vm, this.mainIsoRef, this.mainIso, this.packageName);
}

class ClassInfo{
 final bool isStateful;
 final vs.Class leakClass;
 final String filePath;
 ClassInfo(this.isStateful, this.leakClass, this.filePath);

}

class LeakObject{
  final vs.InstanceSet instance;
  final int  existCount;
  final ClassInfo classInfo;
  LeakObject(this.instance,this.existCount,this.classInfo,);
}

class RetainInfo{
  String field;
  String className;
  int index;
}