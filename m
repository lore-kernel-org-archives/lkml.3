Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752733AbaLCQHx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 11:07:53 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:26701 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752623AbaLCQHu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 11:07:50 -0500
X-AuditID: cbfee61a-f79c06d000004e71-6a-547f35537a7d
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: kyungmin.park@samsung.com, b.zolnierkie@samsung.com, pavel@ucw.cz,
        cooloney@gmail.com, rpurdie@rpsys.net, sakari.ailus@iki.fi,
        s.nawrocki@samsung.com, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, Jacek Anaszewski <j.anaszewski@samsung.com>,
        Andrzej Hajda <a.hajda@samsung.com>, Lee Jones <lee.jones@linaro.org>,
        Chanwoo Choi <cw00.choi@samsung.com>, devicetree@vger.kernel.org
Subject: [PATCH/RFC v9 06/19] DT: Add documentation for the mfd Maxim max77693
Date: Wed, 03 Dec 2014 17:06:41 +0100
Message-id: <1417622814-10845-7-git-send-email-j.anaszewski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1417622814-10845-1-git-send-email-j.anaszewski@samsung.com>
References: <1417622814-10845-1-git-send-email-j.anaszewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrILMWRmVeSWpSXmKPExsVy+t9jQd1g0/oQgy0LRSxurTvHarFxxnpW
	i6M7JzJZXP/ynNVi/hGgWP+bhawW516tZLTovfqc0eJs0xt2i/tfjzJaXN41h81i65t1jBY9
	G7ayWiy9fpHJ4u6po2wWE6avZbFo3XuE3WL3rqesFofftLNanNm/ks1BxGPNvDWMHpf7epk8
	ds66y+6xcvkXNo/DXxeyeGxa1cnmcefaHjaPPfN/sHr0bVnF6LFi9Xd2j8+b5AK4o7hsUlJz
	MstSi/TtErgyLl1ex1hwQL3i2KZnjA2MuxS6GDk5JARMJBr/dTFD2GISF+6tZ+ti5OIQEpjO
	KHHg2n0op51JovH0WxaQKjYBQ4mfL14zdTFycIgIREtcOlYPUsMscI5ZouX3TlaQGmEBP4mv
	J28ygdgsAqoSl3qvs4PYvAIeEt3zLoP1SggoSMyZZAMS5hTwlHj64z47SFgIqOTgRP8JjLwL
	GBlWMYqmFiQXFCel5xrqFSfmFpfmpesl5+duYgRHxDOpHYwrGywOMQpwMCrx8FrE1YUIsSaW
	FVfmHmKU4GBWEuF99g0oxJuSWFmVWpQfX1Sak1p8iFGag0VJnPfGzdwQIYH0xJLU7NTUgtQi
	mCwTB6dUA+O8iSn3V+q8Fn95TFLtsz7jMR/5iVIRLzbFrYy1rPb/8pLd5cH2ExnTrqR5bpTT
	jbv4icEkb87eRRe8doVGKTw2+pv+uD0gTEL34g/Z+2w5DxsNa+Mv8K98k7w4dWnkDBONQ15+
	K+IKn6/Rfx67VcjqSFzpFD/pc1M5z5Yl+OsbL8m7kX/qaYESS3FGoqEWc1FxIgCNwR9ghAIA	AA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds device tree binding documentation for
the flash cell of the Maxim max77693 multifunctional device.

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Lee Jones <lee.jones@linaro.org>
Cc: Chanwoo Choi <cw00.choi@samsung.com>
Cc: Bryan Wu <cooloney@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Pawel Moll <pawel.moll@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Ian Campbell <ijc+devicetree@hellion.org.uk>
Cc: Kumar Gala <galak@codeaurora.org>
Cc: <devicetree@vger.kernel.org>
---
 Documentation/devicetree/bindings/mfd/max77693.txt |   89 ++++++++++++++++++++
 1 file changed, 89 insertions(+)

diff --git a/Documentation/devicetree/bindings/mfd/max77693.txt b/Documentation/devicetree/bindings/mfd/max77693.txt
index 01e9f30..25a6e78 100644
--- a/Documentation/devicetree/bindings/mfd/max77693.txt
+++ b/Documentation/devicetree/bindings/mfd/max77693.txt
@@ -41,7 +41,66 @@ Optional properties:
 	 To get more informations, please refer to documentaion.
 	[*] refer Documentation/devicetree/bindings/pwm/pwm.txt
 
+- led : the LED submodule device node
+
+There are two led outputs available - fled1 and fled2. Each of them can
+control a separate led or they can be connected together to double
+the maximum current for a single connected led. One led is represented
+by one child node.
+
+Required properties:
+- compatible : Must be "maxim,max77693-led".
+
+Optional properties:
+- maxim,fleds : Array of current outputs in order: fled1, fled2.
+	Note: both current outputs can be connected to a single led
+	Possible values:
+		MAX77693_LED_FLED_UNUSED - the output is left disconnected,
+		MAX77693_LED_FLED_USED - a diode is connected to the output.
+- maxim,trigger-type : Array of trigger types in order: flash, torch.
+	Possible trigger types:
+		MAX77693_LED_TRIG_TYPE_EDGE - Rising edge of the signal triggers
+			the flash/torch,
+		MAX77693_LED_TRIG_TYPE_LEVEL - Signal level controls duration of
+			the flash/torch.
+- maxim,trigger : Array of flags indicating which trigger can activate given led
+	in order: fled1, fled2.
+	Possible flag values (can be combined):
+		MAX77693_LED_TRIG_FLASHEN - FLASHEN pin of the chip,
+		MAX77693_LED_TRIG_TORCHEN - TORCHEN pin of the chip,
+		MAX77693_LED_TRIG_SOFTWARE - software via I2C command.
+- maxim,boost-mode :
+	In boost mode the device can produce up to 1.2A of total current
+	on both outputs. The maximum current on each output is reduced
+	to 625mA then. If there are two child led nodes defined then boost
+	is enabled by default.
+	Possible values:
+		MAX77693_LED_BOOST_OFF - no boost,
+		MAX77693_LED_BOOST_ADAPTIVE - adaptive mode,
+		MAX77693_LED_BOOST_FIXED - fixed mode.
+- maxim,boost-vout : Output voltage of the boost module in millivolts.
+- maxim,vsys-min : Low input voltage level in millivolts. Flash is not fired
+	if chip estimates that system voltage could drop below this level due
+	to flash power consumption.
+
+Required properties of the LED child node:
+- label : see Documentation/devicetree/bindings/leds/common.txt
+- maxim,fled_id : Identifier of the fled output the led is connected to;
+		MAX77693_LED_FLED1 - FLED1 output of the device - it has to be
+			used also if a single LED is connected to both outputs,
+		MAX77693_LED_FLED2 - FLED2 output of the device.
+
+Optional properties of the LED child node:
+- max-microamp : see Documentation/devicetree/bindings/leds/common.txt
+		Range: 15625 - 250000
+- flash-max-microamp : see Documentation/devicetree/bindings/leds/common.txt
+		Range: 15625 - 1000000
+- flash-timeout-microsec : see Documentation/devicetree/bindings/leds/common.txt
+		Range: 62500 - 1000000
+
 Example:
+#include <dt-bindings/mfd/max77693.h>
+
 	max77693@66 {
 		compatible = "maxim,max77693";
 		reg = <0x66>;
@@ -73,4 +132,34 @@ Example:
 			pwms = <&pwm 0 40000 0>;
 			pwm-names = "haptic";
 		};
+
+		led {
+			compatible = "maxim,max77693-led";
+			maxim,fleds = <MAX77693_LED_FLED_USED
+				       MAX77693_LED_FLED_USED>;
+			maxim,trigger = <MAX77693_LED_TRIG_ALL
+					 (MAX77693_LED_TRIG_TORCHEN |
+					 MAX77693_LED_TRIG_SOFTWARE)>;
+			maxim,trigger-type = <MAX77693_LED_TRIG_TYPE_EDGE
+					      MAX77693_LED_TRIG_TYPE_LEVEL>;
+			maxim,boost-mode = <MAX77693_LED_BOOST_ADAPTIVE>;
+			maxim,boost-vout = <5000>;
+			maxim,vsys-min = <2400>;
+
+			camera1_flash: led1 {
+				maxim,fled_id = <MAX77693_LED_FLED1>;
+				label = "max77693-flash1";
+				max-microamp = <250000>;
+				flash-max-microamp = <625000>;
+				flash-timeout-microsec = <1000000>;
+			};
+
+			camera2_flash: led2 {
+				maxim,fled_id = <MAX77693_LED_FLED2>;
+				label = "max77693-flash2";
+				max-microamp = <250000>;
+				flash-max-microamp = <500000>;
+				flash-timeout-microsec = <1000000>;
+			};
+		};
 	};
-- 
1.7.9.5

