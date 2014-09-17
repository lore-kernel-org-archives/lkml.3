Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756530AbaIQQkq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 12:40:46 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:45456 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755965AbaIQQkn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 12:40:43 -0400
X-AuditID: cbfee690-f79ce6d00000115a-c2-5419b989566b
From: Jaewon Kim <jaewon02.kim@samsung.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: Chanwoo Choi <cw00.choi@samsung.com>, linux-kernel@vger.kernel.org,
        Jaewon Kim <jaewon02.kim@samsung.com>
Subject: [PATCH v5 3/3] mfd: max77693: Update DT binding to support haptic
Date: Thu, 18 Sep 2014 01:40:26 +0900
Message-id: <1410972026-25189-4-git-send-email-jaewon02.kim@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1410972026-25189-1-git-send-email-jaewon02.kim@samsung.com>
References: <1410972026-25189-1-git-send-email-jaewon02.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrALMWRmVeSWpSXmKPExsWyRsSkRLdzp2SIwaxN1hbXvzxntdjRcITV
	4v7Xo4wWl3fNYXNg8bhzbQ+bR9+WVYwenzfJBTBHcdmkpOZklqUW6dslcGWs23KZveA2b8XW
	Q+tZGhjXc3cxcnJICJhI7JuzlBHCFpO4cG89WxcjF4eQwFJGicdHV7DCFB3/uIIZIrGIUWL2
	x2Z2CKeNSWLm/W1gVWwC2hLf1y8Gsjk4RARUJM69MQcxmQXyJf5vMgOpEBbwkji87CEziM0i
	oCpxavd+MJtXwEPi8p8tjCDlEgIKEnMm2YCEOQU8JRrWXgG7TQio5OC070wgWyUEvrNJzD65
	jxFijoDEt8mHWCB6ZSU2HWCGOFlS4uCKGywTGIUXMDKsYhRNLUguKE5KLzLRK07MLS7NS9dL
	zs/dxAgM2NP/nk3YwXjvgPUhRgEORiUe3g2XJUKEWBPLiitzDzGaAm2YyCwlmpwPjIu8knhD
	YzMjC1MTU2Mjc0szJXHe11I/g4UE0hNLUrNTUwtSi+KLSnNSiw8xMnFwSjUwukfd+sy4Nvyw
	7Vq5J3WdWnKMoruFs1s4lOUVaiWfM1acWd7GVRh7m9emaLthg/wpNZMQtzuv1daunxf8SrCV
	UWj5hckxShM3n1V2FnwVMcV5xvk/1dl9L+uVCxc86TSJ1A4uqFpw2Dg+ZOLenepKe71Ya/5E
	8kxa057jz2bcON2hoYpjUrYSS3FGoqEWc1FxIgC5t727UwIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupikeLIzCtJLcpLzFFi42I5/e+xgG7nTskQg7XLTSyuf3nOarGj4Qir
	xf2vRxktLu+aw+bA4nHn2h42j74tqxg9Pm+SC2COamC0yUhNTEktUkjNS85PycxLt1XyDo53
	jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXLzAFap6RQlphTChQKSCwuVtK3wzQhNMRN1wKmMULX
	NyQIrsfIAA0krGHMWLflMnvBbd6KrYfWszQwrufuYuTkkBAwkTj+cQUzhC0mceHeerYuRi4O
	IYFFjBKzPzazQzhtTBIz729jBaliE9CW+L5+MZDNwSEioCJx7o05iMkskC/xf5MZSIWwgJfE
	4WUPwWayCKhKnNq9H8zmFfCQuPxnCyNIuYSAgsScSTYgYU4BT4mGtVcYQWwhoJKD074zTWDk
	XcDIsIpRNLUguaA4KT3XUK84Mbe4NC9dLzk/dxMjOB6eSe1gXNlgcYhRgINRiYd3w2WJECHW
	xLLiytxDjBIczEoivNYbJUOEeFMSK6tSi/Lji0pzUosPMZoCHTWRWUo0OR8Yq3kl8YbGJmZG
	lkbmhhZGxuZK4rwHWq0DhQTSE0tSs1NTC1KLYPqYODilGhjj99u2FAgdiG/e6PU6ckuGLuvO
	Q7yPZtgcUJmuob16hSfzsue9L5yu17vN7ayKtylPujjrzveKOZ5198UYTiV6nDN6W/7o8qaH
	knGJ3NF8R229PafVHck7yFb3xaFvSbBlH5OjtYNn4MNy/ZXz3lwWNeR4um3K20u7NnZk/V63
	cfqr2xO9q/iUWIozEg21mIuKEwGAY0+GnQIAAA==
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
 Documentation/devicetree/bindings/mfd/max77693.txt |   21 ++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/Documentation/devicetree/bindings/mfd/max77693.txt b/Documentation/devicetree/bindings/mfd/max77693.txt
index 11921cc..01e9f30 100644
--- a/Documentation/devicetree/bindings/mfd/max77693.txt
+++ b/Documentation/devicetree/bindings/mfd/max77693.txt
@@ -27,6 +27,20 @@ Optional properties:
 
 	[*] refer Documentation/devicetree/bindings/regulator/regulator.txt
 
+- haptic : The MAX77693 haptic device utilises a PWM controlled motor to provide
+  users with tactile feedback. PWM period and duty-cycle are varied in
+  order to provide the approprite level of feedback.
+
+ Required properties:
+	- compatible : Must be "maxim,max77693-hpatic"
+	- haptic-supply : power supply for the haptic motor
+	[*] refer Documentation/devicetree/bindings/regulator/regulator.txt
+	- pwms : phandle to the physical PWM(Pulse Width Modulation) device.
+	 PWM properties should be named "pwms". And number of cell is different
+	 for each pwm device.
+	 To get more informations, please refer to documentaion.
+	[*] refer Documentation/devicetree/bindings/pwm/pwm.txt
+
 Example:
 	max77693@66 {
 		compatible = "maxim,max77693";
@@ -52,4 +66,11 @@ Example:
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

