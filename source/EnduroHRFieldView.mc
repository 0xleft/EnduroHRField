import Toybox.Activity;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.UserProfile;

class EnduroHRFieldView extends WatchUi.DataField {
    hidden var mHeartRate as Number = 0;
    hidden var hrZones as Array<Number> = [];
    hidden var heartIcons as Array<BitmapResource> = [];
    hidden var currentZone as Number = 0;

    hidden const ZONE_COLORS as Array<Graphics.ColorType> = [
        Graphics.COLOR_LT_GRAY,
        Graphics.COLOR_BLUE,
        Graphics.COLOR_GREEN,
        Graphics.COLOR_YELLOW,
        Graphics.COLOR_RED,
    ];

    function initialize() {
        DataField.initialize();
        hrZones = UserProfile.getHeartRateZones(UserProfile.getCurrentSport());

        heartIcons.add(WatchUi.loadResource(Rez.Drawables.HeartIconGray));
        heartIcons.add(WatchUi.loadResource(Rez.Drawables.HeartIconBlue));
        heartIcons.add(WatchUi.loadResource(Rez.Drawables.HeartIconGreen));
        heartIcons.add(WatchUi.loadResource(Rez.Drawables.HeartIconYellow));
        heartIcons.add(WatchUi.loadResource(Rez.Drawables.HeartIconRed));
    }

    function onLayout(dc as Dc) as Void {
        View.setLayout(Rez.Layouts.MainLayout(dc));
    }

    function compute(info as Activity.Info) as Void {
        if(info has :currentHeartRate){
            if(info.currentHeartRate != null){
                mHeartRate = info.currentHeartRate as Number;
            } else {
                mHeartRate = 0;
                currentZone = 0;
            }
        }
    }

    // Display the value you computed here. This will be called
    // once a second when the data field is visible.
    function onUpdate(dc as Dc) as Void {
        View.onUpdate(dc);
        (View.findDrawableById("Background") as Text).setColor(getBackgroundColor());

        drawZones(dc);
        drawHeartRate(dc);
    }

    function drawZones(dc as Dc) as Void {
        var zoneCount = hrZones.size();
        if (zoneCount == 0) {
            return;
        }

        var height = dc.getHeight();
        var zoneY = height / 2 - 20;
        var width = dc.getWidth();
        var zoneWidth = width / (zoneCount - 1);


        for (var i = 0; i < zoneCount - 1; i++) {
            var zoneMin = hrZones[i];
            var zoneMax = hrZones[i + 1];
            var color = ZONE_COLORS[i];

            var centerY = zoneY;
            var centerX = zoneWidth * i + zoneWidth / 2;

            var highlighted = false;
            if (mHeartRate >= zoneMin && mHeartRate < zoneMax) {
                highlighted = true;
                currentZone = i;
            }
            if (i == 0 && mHeartRate < zoneMin) {
                highlighted = true;
                currentZone = 0;
            }

            drawZoneRect(dc, centerX, centerY, zoneMin, zoneMax, color, highlighted);
        }
    }

    function drawZoneRect(dc as Dc, centerX as Number, centerY as Number, zoneMin as Number, zoneMax as Number, color as Graphics.ColorType, highlighted as Boolean) as Void {
        var zoneWidth = getApp().getZoneBoxWidth();
        var zoneHeight = 10;
        
        if (highlighted) {
            zoneWidth = getApp().getZoneBoxWidth() * 1.14;
            zoneHeight = 15;
        }
        
        var rectX = centerX - zoneWidth / 2;
        var rectY = centerY - zoneHeight / 2;

        dc.setColor(color, getBackgroundColor());
        dc.fillRectangle(rectX, rectY, zoneWidth, zoneHeight);
        dc.setColor(Graphics.COLOR_BLACK, getBackgroundColor());
        dc.drawRectangle(rectX - 1, rectY - 1, zoneWidth + 1, zoneHeight + 1);

        if (highlighted) {
            var persentage = (mHeartRate.toFloat() - zoneMin.toFloat()) / (zoneMax.toFloat() - zoneMin.toFloat());

            if (persentage < 0) {
                persentage = 0;
            } else if (persentage > 1) {
                persentage = 1;
            }
            // dc.drawText(0, 20, Graphics.FONT_MEDIUM, persentage.format("%.2f"), Graphics.TEXT_JUSTIFY_LEFT); 

            var markerX = (rectX + zoneWidth * persentage) as Number;
            drawMarker(dc, markerX, centerY);
        }
    }

    function drawMarker(dc as Dc, centerX as Number, centerY as Number) as Void {
        var markerWidth = 5;
        var markerHeight = 20;

        dc.setColor(Graphics.COLOR_WHITE, getBackgroundColor());
        dc.fillRectangle(centerX - markerWidth / 2, centerY - markerHeight / 2, markerWidth, markerHeight);
        dc.setColor(Graphics.COLOR_BLACK, getBackgroundColor());
        dc.drawRectangle(centerX - markerWidth / 2 - 1, centerY - markerHeight / 2 - 1, markerWidth + 1, markerHeight + 1);
    }

    function drawHeart(dc as Dc, x as Number, y as Number, zone as Number) as Void {
        dc.drawBitmap(x, y, heartIcons[currentZone]);
    }

    function drawHeartRate(dc as Dc) as Void {
        var y = dc.getHeight() / 2 + 5;
        var x = dc.getWidth() / 2 - dc.getTextWidthInPixels(mHeartRate.format("%d"), Graphics.FONT_LARGE) / 2 + heartIcons[0].getWidth() / 2;

        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
        dc.drawText(x, y, Graphics.FONT_LARGE, mHeartRate.format("%d"), Graphics.TEXT_JUSTIFY_LEFT);
        
        drawHeart(dc, x - heartIcons[0].getWidth() - 5, y + 5 + getApp().getHeartIconOffset(), ZONE_COLORS[0]); // we presume that all icons are same size
    }
}