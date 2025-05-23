import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;

class EnduroHRFieldApp extends Application.AppBase {
    const HEART_ICON_Y_OFFSET = 4;
    const ZONE_BOX_WIDTH = 35;

    function getZoneBoxWidth() as Number {
        return ZONE_BOX_WIDTH;
    }

    function getHeartIconOffset() as Number {
        return HEART_ICON_Y_OFFSET;
    }

    function initialize() {
        AppBase.initialize();
    }

    // onStart() is called on application start up
    function onStart(state as Dictionary?) as Void {
    }

    // onStop() is called when your application is exiting
    function onStop(state as Dictionary?) as Void {
    }

    //! Return the initial view of your application here
    function getInitialView() as [Views] or [Views, InputDelegates] {
        return [new EnduroHRFieldView()];
    }
}

function getApp() as EnduroHRFieldApp {
    return Application.getApp() as EnduroHRFieldApp;
}