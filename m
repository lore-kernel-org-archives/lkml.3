Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752420AbaIKMzc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 08:55:32 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:22939 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755222AbaIKMy3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 08:54:29 -0400
X-AuditID: cbfee68f-f797f6d000001173-95-54119b83bde1
From: Jaewon Kim <jaewon02.kim@samsung.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
Cc: Chanwoo Choi <cw00.choi@samsung.com>, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org, Jaewon Kim <jaewon02.kim@samsung.com>
Subject: [PATCH v4 4/4] mfd: max77693: Update DT binding to support haptic
Date: Thu, 11 Sep 2014 21:54:22 +0900
Message-id: <1410440062-19963-5-git-send-email-jaewon02.kim@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1410440062-19963-1-git-send-email-jaewon02.kim@samsung.com>
References: <1410440062-19963-1-git-send-email-jaewon02.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOLMWRmVeSWpSXmKPExsWyRsSkULd5tmCIQddhLovrX56zWhxe9ILR
	YkfDEVaL+1+PMlrc/PSN1eLyrjlsFqe7WR3YPXbOusvucefaHjaPeScDPfq2rGL0+LxJLoA1
	issmJTUnsyy1SN8ugStj2XubgpU8FR+uPWNtYJzD1cXIySEhYCJx8OsfJghbTOLCvfVsXYxc
	HEICSxkl5nyeydjFyAFW9He/P0R8EaPE70u32CGcNiaJrlW/2UC62QS0Jb6vX8wKYosIVEr0
	d79gBSliFuhhlFi6aik7SEJYwEtid+sbsAYWAVWJ1tMzwDbwCnhI7N2cCLFMQWLOJBuQCk4B
	T4lb3XPAOoWAKs71rGQBGSkhMJ1d4uvPNqgxAhLfJh9igeiVldh0gBniGUmJgytusExgFF7A
	yLCKUTS1ILmgOCm9yFivODG3uDQvXS85P3cTIzC8T/971r+D8e4B60OMAhyMSjy8FSyCIUKs
	iWXFlbmHGE2BNkxklhJNzgdGUV5JvKGxmZGFqYmpsZG5pZmSOO9CqZ/BQgLpiSWp2ampBalF
	8UWlOanFhxiZODilGhhLxMTcGPprHhpmrKrNeF+zvuD2kxOhr09sa12kd7MgPW7Hzm3m2zLV
	1l26NPGyuhUjj8wlL5WDa1R/BXkZ5mw0CFzzZ6qAZtz5h5LvZi+12lJp5nJ0m6r321ydFrFd
	Kw0X32Oc/P3Bm49Ra5eX5j3x5fttNevspyB9xqVnAhOP/NS0dl8y/SWjEktxRqKhFnNRcSIA
	y4VlnWoCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrIIsWRmVeSWpSXmKPExsVy+t9jAd3m2YIhBnNXMVtc//Kc1eLwoheM
	FjsajrBa3P96lNHi5qdvrBaXd81hszjdzerA7rFz1l12jzvX9rB5zDsZ6NG3ZRWjx+dNcgGs
	UQ2MNhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+AbpumTlAVygp
	lCXmlAKFAhKLi5X07TBNCA1x07WAaYzQ9Q0JgusxMkADCWsYM5a9tylYyVPx4doz1gbGOVxd
	jBwcEgImEn/3+3cxcgKZYhIX7q1n62Lk4hASWMQo8fvSLXYIp41JomvVbzaQKjYBbYnv6xez
	gtgiApUS/d0vWEGKmAV6GCWWrlrKDpIQFvCS2N36BqyBRUBVovX0DEaQbbwCHhJ7NydCLFaQ
	mDPJBqSCU8BT4lb3HLBOIaCKcz0rWSYw8i5gZFjFKJpakFxQnJSea6hXnJhbXJqXrpecn7uJ
	ERw9z6R2MK5ssDjEKMDBqMTDW8EiGCLEmlhWXJl7iFGCg1lJhPfGdKAQb0piZVVqUX58UWlO
	avEhRlOgmyYyS4km5wMjO68k3tDYxMzI0sjc0MLI2FxJnPdAq3WgkEB6YklqdmpqQWoRTB8T
	B6dUA+POSvn7CiqP0pf+kNua0s4RGjP/lqAWj5qA0U6HvXa8nKEH/TutPO9bSFmsttSJvcD2
	JfBQ+/vos1Nr5FtnMAl5tAcvWZz3uTpjldDc69eM7y7ImGZ6PzN68cKADeyXy00qN7AnV++8
	c48ttX3ir6X1e2vWP3ORmS9jVDx17+LHl1onZshfCFNiKc5INNRiLipOBAAKdDkrtAIAAA==
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

