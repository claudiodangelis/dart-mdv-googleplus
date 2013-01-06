import 'dart:html';
import 'dart:json';
import 'package:js/js.dart' as js;
import 'package:web_ui/watcher.dart' as watchers;

final String CLIENT_ID = '688110452481.apps.googleusercontent.com';
final String SCOPE = 'https://www.googleapis.com/auth/plus.me';

ButtonElement authBtn = query('#authorize');
ImageElement pic = query('#pic');
DivElement about = query('#about');

bool immediate = true;

String displayName = 'Me';
String tagline = '';
List<String> urls = [];

main(){

  js.scoped((){
    js.context.init = new js.Callback.once(init);
    js.context.auth = new js.Callback.many((){js.context.gapi.client.setApiKey('AIzaSyDOtMNdtbw17o9bs-kW7G6O3S05p0H8wYM');
      js.context.window.setTimeout(
        js.context.gapi.auth.authorize(js.map({
        'client_id':CLIENT_ID,
        'scope':SCOPE,
        'immediate':immediate
        }),
        js.context.onAuthResponse), 1

    );
    });

    
    js.context.onAuthResponse = new js.Callback.many((token){
      if(token!=null){
        authBtn.style.display='none';
        MakeRequest();
      }
      else{
        authBtn.style.display='block';
        immediate = false;
      }
    });

    js.context.MakeRequest = new js.Callback.once(MakeRequest);
    js.context.RequestCallback = new js.Callback.many((js.Proxy jsonResp, var rawResp){
      var data = JSON.parse(rawResp);

      for( var url in data[0]['result']['urls']){
        urls.add(url['value']);
      }
      
      displayName = data[0]['result']['displayName'];
      tagline = data[0]['result']['tagline'];
      pic.src = data[0]['result']['image']['url'];
      about.innerHtml = data[0]['result']['aboutMe'];

      watchers.dispatch();
      
    });
  });

  authBtn.on.click.add(
      (Event e){
      js.scoped((){
        js.context.auth();
        });
      });

  ScriptElement script = new ScriptElement();
  script.src = "http://apis.google.com/js/client.js?onload=init";
  script.type = "text/javascript";
  document.body.children.add(script);

}

void init(){
  js.context.window.setTimeout(js.context.auth, 1);
}

void MakeRequest(){
  js.scoped((){
      js.context.gapi.client.load('plus', 'v1', new js.Callback.many((){
        var request = js.context.gapi.client.plus.people.get(
            js.map({
              'userId':'me',
              'fields':'aboutMe,circledByCount,displayName,image,tagline,urls/value'
                }));
        request.execute(js.context.RequestCallback);
        }));

  });
}
