Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753512AbaIDPBz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 11:01:55 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:22784 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750797AbaIDPBv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 11:01:51 -0400
X-AuditID: cbfee68f-f797f6d000001173-96-54087edd8eed
From: Jaewon Kim <jaewon02.kim@samsung.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Jaewon Kim <jaewon02.kim@samsung.com>
Subject: [PATCH v2 4/4] mfd: max77693: Update DT binding to support haptic
Date: Fri, 05 Sep 2014 00:01:31 +0900
Message-id: <1409842891-26549-5-git-send-email-jaewon02.kim@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1409842891-26549-1-git-send-email-jaewon02.kim@samsung.com>
References: <1409842891-26549-1-git-send-email-jaewon02.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrJLMWRmVeSWpSXmKPExsWyRsSkRPduHUeIwcx7whbXvzxntTi86AWj
	xY6GI6wW978eZbS4+ekbq8XlXXPYLE53szqwe+ycdZfd4861PWwe804GevRtWcXo8XmTXABr
	FJdNSmpOZllqkb5dAlfGsvc2BSt5Kj5ce8bawDiHq4uRk0NCwETi7pdTjBC2mMSFe+vZuhi5
	OIQEljJKHHxwjBWm6Mbv3awQiemMEksftDNBOG1MEtcWdLCDVLEJaEt8X78YrENEoFKiv/sF
	WAezQA+jxPf21cwgCWEBL4n7Py+AFbEIqEqsOvaJBcTmFfCQ6Jm9Cmg3B9A6BYk5k2xAwpwC
	nhJdD1aAlQgBlSyY8o0FZKaEwHR2iY4tE9kg5ghIfJt8iAWiV1Zi0wFmiKslJQ6uuMEygVF4
	ASPDKkbR1ILkguKk9CJjveLE3OLSvHS95PzcTYzAED/971n/Dsa7B6wPMQpwMCrx8Ba8YA8R
	Yk0sK67MPcRoCrRhIrOUaHI+MJLySuINjc2MLExNTI2NzC3NlMR5F0r9DBYSSE8sSc1OTS1I
	LYovKs1JLT7EyMTBKdXAqPz13/3Whib2yQ/ddtZy3D1mLen9ScND4fChItMdN+do3hKJv58/
	UXKRgFDrp4NiMWHCrzcc239s5Uf3M3r/WCbuP7e2w6CmtWrP2dzEXW85rt2/9cntt+SilqM+
	GZsLn3OJ9PdGlJ16+3zlpdK50xiZEqcfXs67z39S6Hr9pKv1b1Ze6Dnw7YISS3FGoqEWc1Fx
	IgCU2vKjbAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrMIsWRmVeSWpSXmKPExsVy+t9jQd27dRwhBlc381hc//Kc1eLwoheM
	FjsajrBa3P96lNHi5qdvrBaXd81hszjdzerA7rFz1l12jzvX9rB5zDsZ6NG3ZRWjx+dNcgGs
	UQ2MNhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+AbpumTlAVygp
	lCXmlAKFAhKLi5X07TBNCA1x07WAaYzQ9Q0JgusxMkADCWsYM5a9tylYyVPx4doz1gbGOVxd
	jJwcEgImEjd+72aFsMUkLtxbz9bFyMUhJDCdUWLpg3YmCKeNSeLagg52kCo2AW2J7+sXg3WI
	CFRK9He/YAUpYhboYZT43r6aGSQhLOAlcf/nBbAiFgFViVXHPrGA2LwCHhI9s1cBreAAWqcg
	MWeSDUiYU8BTouvBCrASIaCSBVO+sUxg5F3AyLCKUTS1ILmgOCk911CvODG3uDQvXS85P3cT
	IziCnkntYFzZYHGIUYCDUYmHt+AFe4gQa2JZcWXuIUYJDmYlEV73PI4QId6UxMqq1KL8+KLS
	nNTiQ4ymQEdNZJYSTc4HRndeSbyhsYmZkaWRuaGFkbG5kjjvgVbrQCGB9MSS1OzU1ILUIpg+
	Jg5OqQZGHdkFPHlff5m+57nfxfum19/vvrWv5x//rTc0W7ZUTM3bcmelBMfzvSyP5PXPfu+/
	LMs8yc0iWI1DxC5+ZU3/u2gNk2pmgSvmV+KP6Gr5pKvphF4y/m3eVrZgyVemb2s5uUv7HXgV
	jGwPP53EYTRxx6eWYiGJ22pVsy55Wt7/fbJG4KyZkbsSS3FGoqEWc1FxIgD349YvtgIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add haptic DT binding documentation and example
to support haptic driver in max77693 Multifunction device.

Signed-off-by: Jaewon Kim <jaewon02.kim@samsung.com>
Acked-by: Chanwoo Choi <cw00.choi@samsung.com>
---
 Documentation/devicetree/bindings/mfd/max77693.txt |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/Documentation/devicetree/bindings/mfd/max77693.txt b/Documentation/devicetree/bindings/mfd/max77693.txt
index 11921cc..d178b9e 100644
--- a/Documentation/devicetree/bindings/mfd/max77693.txt
+++ b/Documentation/devicetree/bindings/mfd/max77693.txt
@@ -27,6 +27,17 @@ Optional properties:
 
 	[*] refer Documentation/devicetree/bindings/regulator/regulator.txt
 
+- haptic : The haptic of max77693 have to be instantiated under subnod
+  named "haptic" using the following haptic format in example.
+  Haptic sensation from motor can be changed by changing a period cycle in pwms.
+
+ Required properties:
+	- compatible : Must be "maxim,max77693-hpatic"
+	- haptic-supply : power supply for haptic motor
+		[*] refer Documentation/devicetree/bindings/regulator/regulator.txt
+	- pwms : phandle to the physical PWM device,
+		[*] refer Documentation/devicetree/bindings/pwm/pwm.txt
+
 Example:
 	max77693@66 {
 		compatible = "maxim,max77693";
@@ -52,4 +63,11 @@ Example:
 					regulator-boot-on;
 			};
 		};
+
+		haptic {
+			compatible = "maxim,max77693-haptic";
+			haptic-supply = <&haptic_supply>;
+			pwms = <&pwm 0 40000 0>;
+			pwm-names = "haptic";
+		};
 	};
-- 
1.7.9.5

