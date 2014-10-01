Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751345AbaJAGoe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 02:44:34 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:23286 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751182AbaJAGoM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 02:44:12 -0400
X-AuditID: cbfee68f-f791c6d000004834-f0-542ba2b600ea
From: Jaewon Kim <jaewon02.kim@samsung.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: Jaewon Kim <jaewon02.kim@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>, linux-kernel@vger.kernel.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH RESEND v5 3/3] mfd: max77693: Update DT binding to support
 haptic
Date: Wed, 01 Oct 2014 15:43:58 +0900
Message-id: <1412145838-7563-4-git-send-email-jaewon02.kim@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1412145838-7563-1-git-send-email-jaewon02.kim@samsung.com>
References: <1412145838-7563-1-git-send-email-jaewon02.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFLMWRmVeSWpSXmKPExsWyRsSkSHf7Iu0Qg+cNrBbXvzxntTi86AWj
	xY6GI6wW978eZbS4vGsOmwOrx85Zd9k97lzbw+bRt2UVo8fnTXIBLFFcNimpOZllqUX6dglc
	Geu2XGYvuM1bsfXQepYGxvXcXYwcHBICJhKzVkV3MXICmWISF+6tZ+ti5OIQEljKKPH8/2M2
	iISJxIw9yxghEtMZJU5+PsME4bQxSSw5u5cJpIpNQFvi+/rFrCBTRQRUJM69MQepYRaYxyhx
	/vYesEnCAsESf84dZgaxWQRUJe6sOwkW5xVwl/j39gQzxEUKEnMm2YCEOQU8JM40H2EHCQsB
	lXx5XgMyUkKgnV1izrqNLBBjBCS+TT7EAtEqK7HpADPEzZISB1fcYJnAKLyAkWEVo2hqQXJB
	cVJ6kbFecWJucWleul5yfu4mRmAQn/73rH8H490D1ocYBTgYlXh4FRK0Q4RYE8uKK3MPMZoC
	bZjILCWanA+MlbySeENjMyMLUxNTYyNzSzMlcd6FUj+DhQTSE0tSs1NTC1KL4otKc1KLDzEy
	cXBKNTAq2Xdx9fAGmtuH7gs7d0h2emyr7i+WkzWMHvdnFl7Z9P6N/LXrW3Ysv/1tSy7vygNu
	NQm+tx+KhM89rpuzfHXxqe2ScbGyeTOKWDvmnH23zuzVFJarbU3S9wtcX3O6zOBomliudf+z
	/jn7NH8t5dbPTlZ+Wxx/lMfpN1ndtf54ecfLExF6U/YrsRRnJBpqMRcVJwIAFfFX3F0CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprKIsWRmVeSWpSXmKPExsVy+t9jQd1ti7RDDB60WFtc//Kc1eLwoheM
	FjsajrBa3P96lNHi8q45bA6sHjtn3WX3uHNtD5tH35ZVjB6fN8kFsEQ1MNpkpCampBYppOYl
	56dk5qXbKnkHxzvHm5oZGOoaWlqYKynkJeam2iq5+AToumXmAC1WUihLzCkFCgUkFhcr6dth
	mhAa4qZrAdMYoesbEgTXY2SABhLWMGas23KZveA2b8XWQ+tZGhjXc3cxcnJICJhIzNizjBHC
	FpO4cG89WxcjF4eQwHRGiZOfzzBBOG1MEkvO7mUCqWIT0Jb4vn4xaxcjB4eIgIrEuTfmIDXM
	AvMYJc7f3sMGUiMsECzx59xhZhCbRUBV4s66k2BxXgF3iX9vTzCD9EoIKEjMmWQDEuYU8JA4
	03yEHSQsBFTy5XnNBEbeBYwMqxhFUwuSC4qT0nMN9YoTc4tL89L1kvNzNzGCo+SZ1A7GlQ0W
	hxgFOBiVeHgVErRDhFgTy4orcw8xSnAwK4nwTqwACvGmJFZWpRblxxeV5qQWH2I0BbppIrOU
	aHI+MILzSuINjU3MjCyNzA0tjIzNlcR5D7RaBwoJpCeWpGanphakFsH0MXFwSjUwTs1ZcsS8
	rZWr6MJ7txT/s4EKWZMb33LouudVmRiUFT6dslBEPKKed0PEfNVLr6/whuXKiXBOCeNh2SAc
	nK06+QiTf9VpBV/ZRVpiuYxiFrdO9mTN/HnljrdMd7zllF1fA53nmf0yvsk0bULQcS6b/4JM
	j6PnsL7kn3FuhcqH7Y1JOdw7Jy1WYinOSDTUYi4qTgQA66k8a6gCAAA=
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

