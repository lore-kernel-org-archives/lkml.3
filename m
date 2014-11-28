Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751896AbaK1JU4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 04:20:56 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:27343 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751262AbaK1JUs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 04:20:48 -0500
X-AuditID: cbfee61b-f79d76d0000024d6-60-54783e6e0c5e
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: kyungmin.park@samsung.com, b.zolnierkie@samsung.com, pavel@ucw.cz,
        cooloney@gmail.com, rpurdie@rpsys.net, sakari.ailus@iki.fi,
        s.nawrocki@samsung.com, Jacek Anaszewski <j.anaszewski@samsung.com>,
        Andrzej Hajda <a.hajda@samsung.com>, Lee Jones <lee.jones@linaro.org>,
        SangYoung Son <hello.son@smasung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org
Subject: [PATCH/RFC v8 11/14] DT: Add documentation for the mfd Maxim max77693
Date: Fri, 28 Nov 2014 10:18:03 +0100
Message-id: <1417166286-27685-12-git-send-email-j.anaszewski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1417166286-27685-1-git-send-email-j.anaszewski@samsung.com>
References: <1417166286-27685-1-git-send-email-j.anaszewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrDLMWRmVeSWpSXmKPExsVy+t9jQd08u4oQg1e3JSxurTvHarFxxnpW
	i6M7JzJZzD8C5Pa/Wchq8fHeP1aLc69WMlr0Xn3OaHG26Q27xf2vRxktLu+aw2ax9c06Roue
	DVtZLZZev8hkcffUUTaLCdPXsli07j3CbrF711NWi8Nv2lktzuxfyWZxupvVQdRjzbw1jB6X
	+3qZPHbOusvusXL5FzaPw18XsnhsWtXJ5nHn2h42j3knAz32zP/B6tG3ZRWjx7OP75g9Vqz+
	zu7xeZNcAG8Ul01Kak5mWWqRvl0CV8a8JxOYC74pVOz9u5S9gfGdVBcjB4eEgInEnznpXYyc
	QKaYxIV769m6GLk4hASmM0q0fGhhgnDamST+n33OAlLFJmAo8fPFayaQZhGBaIlLx+pBwswC
	+1kkPrSD2cICfhLTuncwgdgsAqoSxx8tYQWxeQU8Jc4tXccKsVdBYs4kG5AwJ1B47ue1LCBh
	IQEPiUWvUiYw8i5gZFjFKJpakFxQnJSea6RXnJhbXJqXrpecn7uJERwnz6R3MK5qsDjEKMDB
	qMTD+/NfeYgQa2JZcWXuIUYJDmYlEd5TX4FCvCmJlVWpRfnxRaU5qcWHGKU5WJTEeW/czA0R
	EkhPLEnNTk0tSC2CyTJxcEo1MPpEp0lP6PCf17pdsfBBB8OsY2cYQtg3VS6ZILOgqPh/4b6C
	ix7qRbraJTu/xVxjfybiKsJ0QVUsdZFcfolzDEOFaBOvl9AD04i3GzU7tl6/bjnLcGaL6amP
	91Qy52x13BigeviU5/2C2e2pJ/NebdB8tlJFc7HOpqxeDY5dOqsKelrKzSfGKLEUZyQaajEX
	FScCAJDOax+PAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds device tree binding documentation for
the flash cell of the Maxim max77693 multifunctional device.

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Lee Jones <lee.jones@linaro.org>
Cc: SangYoung Son <hello.son@smasung.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Cc: Bryan Wu <cooloney@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Pawel Moll <pawel.moll@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Ian Campbell <ijc+devicetree@hellion.org.uk>
Cc: Kumar Gala <galak@codeaurora.org>
Cc: <devicetree@vger.kernel.org>
---
 Documentation/devicetree/bindings/mfd/max77693.txt |   74 ++++++++++++++++++++
 1 file changed, 74 insertions(+)

diff --git a/Documentation/devicetree/bindings/mfd/max77693.txt b/Documentation/devicetree/bindings/mfd/max77693.txt
index 01e9f30..50a8dad 100644
--- a/Documentation/devicetree/bindings/mfd/max77693.txt
+++ b/Documentation/devicetree/bindings/mfd/max77693.txt
@@ -41,6 +41,62 @@ Optional properties:
 	 To get more informations, please refer to documentaion.
 	[*] refer Documentation/devicetree/bindings/pwm/pwm.txt
 
+- led-flash : the LED submodule device node
+
+There are two led outputs available - fled1 and fled2. Each of them can
+control a separate led or they can be connected together to double
+the maximum current for a single connected led. One led is represented
+by one child node.
+
+Required properties:
+- compatible : must be "maxim,max77693-flash"
+
+Optional properties:
+- maxim,fleds : array of current outputs in order: fled1, fled2
+	Note: both current outputs can be connected to a single led
+	Possible values:
+		0 - the output is left disconnected,
+		1 - a diode is connected to the output.
+- maxim,trigger-type : Array of trigger types in order: flash, torch
+	Possible trigger types:
+		0 - Rising edge of the signal triggers the flash/torch,
+		1 - Signal level controls duration of the flash/torch.
+- maxim,trigger : Array of flags indicating which trigger can activate given led
+	in order: fled1, fled2
+	Possible flag values (can be combined):
+		1 - FLASH pin of the chip,
+		2 - TORCH pin of the chip,
+		4 - software via I2C command.
+- maxim,boost-mode :
+	In boost mode the device can produce up to 1.2A of total current
+	on both outputs. The maximum current on each output is reduced
+	to 625mA then. If there are two child led nodes defined then boost
+	is enabled by default.
+	Possible values:
+		0 - no boost,
+		1 - adaptive mode,
+		2 - fixed mode.
+- maxim,boost-vout : Output voltage of the boost module in millivolts.
+- maxim,vsys-min : Low input voltage level in millivolts. Flash is not fired
+	if chip estimates that system voltage could drop below this level due
+	to flash power consumption.
+
+A child node must be defined per sub-led.
+
+Required properties of the LED child node:
+- label : see Documentation/devicetree/bindings/leds/common.txt
+- maxim,fled_id : identifier of the fled output the led is connected to:
+		1 - FLED1,
+		2 - FLED2.
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
 	max77693@66 {
 		compatible = "maxim,max77693";
@@ -73,4 +129,22 @@ Example:
 			pwms = <&pwm 0 40000 0>;
 			pwm-names = "haptic";
 		};
+
+		led_flash: led-flash {
+			compatible = "maxim,max77693-flash";
+			maxim,fleds = <1 0>;
+			maxim,trigger = <7 0>;
+			maxim,trigger-type = <0 1>;
+			maxim,boost-mode = <0>;
+			maxim,boost-vout = <5000>;
+			maxim,vsys-min = <2400>;
+
+			camera-flash {
+				maxim,fled_id = <1>
+				label = "max77693-flash";
+				max-microamp = <250000>;
+				flash-max-microamp = <1000000>;
+				flash-timeout-microsec = <1000000>;
+			}
+		};
 	};
-- 
1.7.9.5

