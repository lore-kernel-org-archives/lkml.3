Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932163AbaIELtF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 07:49:05 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:64756 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932068AbaIELtB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 07:49:01 -0400
X-AuditID: cbfee691-f79546d0000011a1-6b-5409a32b18fe
From: Jaewon Kim <jaewon02.kim@samsung.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Jaewon Kim <jaewon02.kim@samsung.com>
Subject: [PATCH v3 4/4] mfd: max77693: Update DT binding to support haptic
Date: Fri, 05 Sep 2014 20:48:22 +0900
Message-id: <1409917702-17009-5-git-send-email-jaewon02.kim@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1409917702-17009-1-git-send-email-jaewon02.kim@samsung.com>
References: <1409917702-17009-1-git-send-email-jaewon02.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrBLMWRmVeSWpSXmKPExsWyRsSkRFdnMWeIwZd9zBbXvzxntTi86AWj
	xY6GI6wW978eZbS4+ekbq8XlXXPYLE53szqwe+ycdZfd4861PWwe804GevRtWcXo8XmTXABr
	FJdNSmpOZllqkb5dAlfGsvc2BSt5Kj5ce8bawDiHq4uRk0NCwESi48EcRghbTOLCvfVsXYxc
	HEICSxklJmzvYoIp+vN/EVRiOqPE7rO3GSGcNiaJxQd2sYFUsQloS3xfv5gVxBYRqJTo737B
	ClLELNDDKPG9fTUzSEJYwEti3bIWsAYWAVWJvs9PWEBsXgEPiT8fnrB3MXIArVOQmDPJBiTM
	KeApsevwIzaQsBBQybN7EiAjJQSms0u0bPnMDDFGQOLb5EMsEK2yEpsOMEMcLSlxcMUNlgmM
	wgsYGVYxiqYWJBcUJ6UXmeoVJ+YWl+al6yXn525iBAb46X/PJu5gvH/A+hCjAAejEg/vj68c
	IUKsiWXFlbmHGE2BNkxklhJNzgfGUV5JvKGxmZGFqYmpsZG5pZmSOK+O9M9gIYH0xJLU7NTU
	gtSi+KLSnNTiQ4xMHJxSDYzlL295TpFuSVPlnR9e8/n/1Yrjb2Pc5r38J9zkE8Cj+GRf5zX9
	KjN5B5M/eV/Ozmap0FwywXfjzI27Zvo9uzKFJzbb9af3tOJdMiu/OO6ccKD/eFvisjcBT3Ki
	TNq2rWW03OV4Nnp11cEJNxLCd3//pfxSQKNAscOAYX7Wx64/1b/jLVfG/PFXYinOSDTUYi4q
	TgQAN2GDMGsCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrEIsWRmVeSWpSXmKPExsVy+t9jQV3txZwhBhuWWFpc//Kc1eLwoheM
	FjsajrBa3P96lNHi5qdvrBaXd81hszjdzerA7rFz1l12jzvX9rB5zDsZ6NG3ZRWjx+dNcgGs
	UQ2MNhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+AbpumTlAVygp
	lCXmlAKFAhKLi5X07TBNCA1x07WAaYzQ9Q0JgusxMkADCWsYM5a9tylYyVPx4doz1gbGOVxd
	jJwcEgImEn/+L2KDsMUkLtxbD2RzcQgJTGeU2H32NiOE08YksfjALrAqNgFtie/rF7OC2CIC
	lRL93S9YQYqYBXoYJb63r2YGSQgLeEmsW9YC1sAioCrR9/kJC4jNK+Ah8efDE/YuRg6gdQoS
	cybZgIQ5BTwldh1+xAYSFgIqeXZPYgIj7wJGhlWMoqkFyQXFSem5hnrFibnFpXnpesn5uZsY
	wfHzTGoH48oGi0OMAhyMSjy8Cz5zhAixJpYVV+YeYpTgYFYS4XWfwhkixJuSWFmVWpQfX1Sa
	k1p8iNEU6KaJzFKiyfnA2M4riTc0NjEzsjQyN7QwMjZXEuc90GodKCSQnliSmp2aWpBaBNPH
	xMEp1cC4+80sMU63uJBg0RtROw4cec2xgqta4MNEng+rYvd6zraZbBg7z3zpjBKu57FmYrMd
	lws7ZSoo+mr+fVN4NvjmilZ7d/Gdm8p2rCnlOOQes/OZr4r97Bi3mQckZlseKzF03y+dyRLc
	Eq30af5dhpbFT+d7vt/FuEGc6br3hIR/W3oXyKhFzEtSYinOSDTUYi4qTgQAwlGMk7UCAAA=
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

