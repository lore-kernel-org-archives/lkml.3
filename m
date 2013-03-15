Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753874Ab3COIGF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 04:06:05 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:37789 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753404Ab3COIEU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 04:04:20 -0400
X-AuditID: cbfee68f-b7f4a6d000001436-09-5142d60255e4
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-samsung-soc@vger.kernel.org, linux-usb@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Cc: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, balbi@ti.com,
        rob.herring@calxeda.com, kgene.kim@samsung.com,
        thomas.abraham@linaro.org, grant.likely@secretlab.ca,
        dianders@chromium.org, jg1.han@samsung.com, p.paneri@samsung.com
Subject: [PATCH v5 1/3] usb: Add device tree bindings for dwc3-exynos
Date: Fri, 15 Mar 2013 13:32:12 +0530
Message-id: <1363334534-21901-2-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.6.5
In-reply-to: <1363334534-21901-1-git-send-email-gautam.vivek@samsung.com>
References: <1363334534-21901-1-git-send-email-gautam.vivek@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrELMWRmVeSWpSXmKPExsWyRsSkVpfpmlOgQe9LHYuFbUtYLC7vmsNm
	MeP8PiaLRctamR1YPD5vkgtgjOKySUnNySxLLdK3S+DKmL+on61gHm/F7GNbWRsYb3F1MXJy
	SAiYSEz5cpoNwhaTuHBvPZDNxSEksJRRYsq1BSwwRWveTIBKLGKU6Hn5gwnCmcIkcW9xJztI
	FZuArkTT212MILaIQLrEgs8fmEBsZoHvjBJ79nKC2MICrhIzHr8AqufgYBFQlfjwLAMkzCvg
	IbH72wxWiGUKEm9uP2MGsTkFPCV+XehjBCkXAqrZ9grsBgmB12wSPX+nga1lERCQ+Db5EAtI
	jYSArMSmA8wQYyQlDq64wTKBUXgBI8MqRtHUguSC4qT0ImO94sTc4tK8dL3k/NxNjMDwPP3v
	Wf8OxrsHrA8xJgONm8gsJZqcDwzvvJJ4Q2MzIwtTE1NjI3NLM9KElcR51VqsA4UE0hNLUrNT
	UwtSi+KLSnNSiw8xMnFwSjUwVlUWfIp+zJBk3e0jUuD9XlN6HWNl3SHGWapmuzRKXk1d+TO3
	VGueSX/+hx1ptQud/q601zhxZpLJJ6H+JmeDXckrKnq6rvndNG1UY1xUeqUxykAsyJFLqH/V
	47xG7R6+uy1LVyxjerrrdohGTHGW0KmCItXTmZ52G/4djPi0rmT2w8mH51xTYinOSDTUYi4q
	TgQAEWDcJWUCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPIsWRmVeSWpSXmKPExsVy+t9jAV2ma06BBv8nK1ssbFvCYnF51xw2
	ixnn9zFZLFrWyuzA4vF5k1wAY1QDo01GamJKapFCal5yfkpmXrqtkndwvHO8qZmBoa6hpYW5
	kkJeYm6qrZKLT4CuW2YO0BIlhbLEnFKgUEBicbGSvh2mCaEhbroWMI0Rur4hQXA9RgZoIGEN
	Y8b8Rf1sBfN4K2Yf28rawHiLq4uRk0NCwERizZsJbBC2mMSFe+uBbC4OIYFFjBI9L38wQThT
	mCTuLe5kB6liE9CVaHq7ixHEFhFIl1jw+QMTiM0s8J1RYs9eThBbWMBVYsbjF0D1HBwsAqoS
	H55lgIR5BTwkdn+bwQqxTEHize1nzCA2p4CnxK8LfYwg5UJANdtesU1g5F3AyLCKUTS1ILmg
	OCk911CvODG3uDQvXS85P3cTIzj4n0ntYFzZYHGIUYCDUYmH90C/Q6AQa2JZcWXuIUYJDmYl
	EV5PL8dAId6UxMqq1KL8+KLSnNTiQ4zJQDdNZJYSTc4HRmZeSbyhsYm5qbGppYmFiZklacJK
	4rwHWq0DhQTSE0tSs1NTC1KLYLYwcXBKNTDamS5eUvjmnfnfh2+bqz8HLj9wvfO3WJFixVF5
	z8NnVmeuzDunI2bTW/98j8BOZr+Npxrv9OZOqMoP6axWb3yl27zeqjb6zNOl7lFmfLXnpvlN
	sXXZts1o+btO2+Jwz60Nrg+CarImZquWHzo4tTWEyaWyZKfeq5Ae75U6Zzovr2U7ujmvyECJ
	pTgj0VCLuag4EQCcziC/wgIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Document device tree binding information as required by the
Samsung' USB 3.0 controller.

Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
---
 .../devicetree/bindings/usb/exynos-usb.txt         |   34 ++++++++++++++++++++
 1 files changed, 34 insertions(+), 0 deletions(-)

diff --git a/Documentation/devicetree/bindings/usb/exynos-usb.txt b/Documentation/devicetree/bindings/usb/exynos-usb.txt
index b3abde7..d967ba1 100644
--- a/Documentation/devicetree/bindings/usb/exynos-usb.txt
+++ b/Documentation/devicetree/bindings/usb/exynos-usb.txt
@@ -48,3 +48,37 @@ Example:
 		clocks = <&clock 285>;
 		clock-names = "usbhost";
 	};
+
+DWC3
+Required properties:
+ - compatible: should be "samsung,exynos5250-dwusb3" for USB 3.0 DWC3
+	       controller.
+ - #address-cells, #size-cells : should be '1' if the device has sub-nodes
+				 with 'reg' property.
+ - ranges: allows valid 1:1 translation between child's address space and
+	   parent's address space
+ - clocks: Clock IDs array as required by the controller.
+ - clock-names: names of clocks correseponding to IDs in the clock property
+
+Sub-nodes:
+The dwc3 core should be added as subnode to Exynos dwc3 glue.
+- dwc3 :
+   The binding details of dwc3 can be found in:
+   Documentation/devicetree/bindings/usb/dwc3.txt
+
+Example:
+	usb@12000000 {
+		compatible = "samsung,exynos5250-dwusb3";
+		clocks = <&clock 286>;
+		clock-names = "usbdrd30";
+		#address-cells = <1>;
+		#size-cells = <1>;
+		ranges;
+
+		dwc3 {
+			compatible = "synopsys,dwc3";
+			reg = <0x12000000 0x10000>;
+			interrupts = <0 72 0>;
+			usb-phy = <&usb2_phy &usb3_phy>;
+		};
+	};
-- 
1.7.6.5

