Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752869AbaHKJXg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 05:23:36 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:50674 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752662AbaHKJXN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 05:23:13 -0400
X-AuditID: cbfee68f-b7fa26d0000039a0-cb-53e88b7e46f3
From: Chanwoo Choi <cw00.choi@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        sw0312.kim@samsung.com, Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCH 2/2] dt-bindings: extcon: Add support for Richtek RT8973A MUIC
 device
Date: Mon, 11 Aug 2014 18:23:03 +0900
Message-id: <1407748983-15539-3-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1407748983-15539-1-git-send-email-cw00.choi@samsung.com>
References: <1407748983-15539-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNLMWRmVeSWpSXmKPExsWyRsSkRLeu+0Wwwffr4hbXvzxntTjb9Ibd
	4vKuOWwWtxtXsFnMmPySzYHVo2/LKkaPz5vkApiiuGxSUnMyy1KL9O0SuDKedjWwF8zjq9jZ
	mdDA2MLTxcjBISFgIvFobkgXIyeQKSZx4d56NhBbSGApo8S+1cwQcROJ5xPusXYxcgHFpzNK
	3Nt8jxnCaWKSWHTmMytIFZuAlsT+FzfAukUEFCQ29z4DizMLlEusPLIPbJKwQLjE1J1fweIs
	AqoSHZ+PM4LYvAKuEl3XrzJCbJOT+LDnETuIzSngJjHt/il2iItcJV5e7ga7QkLgM5vEygmb
	2SAGCUh8m3yIBeIbWYlNB6CulpQ4uOIGywRG4QWMDKsYRVMLkguKk9KLjPWKE3OLS/PS9ZLz
	czcxAgP29L9n/TsY7x6wPsSYDDRuIrOUaHI+MODzSuINjc2MLExNTI2NzC3NSBNWEue9/zAp
	SEggPbEkNTs1tSC1KL6oNCe1+BAjEwenVANj4kyX79v38a+5uK27fJ05k9TmtknzY3+u1jy3
	3OvR5cc2z8ofcNz/ckCEZU3MM85ZVUwrXZhC7VRZOW2SXngFbltQb1SVHer34sG3ibP3Outp
	/L+wXOFZlHPhGh+VU1dq3j7cZ6N2/VZcIYuJo09+yvblqgGeBU2L32xZMnNX9z/Oc6d/W4hK
	KLEUZyQaajEXFScCAPsiYwtuAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuphkeLIzCtJLcpLzFFi42I5/e+xoG5d94tgg+tTBCyuf3nOanG26Q27
	xeVdc9gsbjeuYLOYMfklmwOrR9+WVYwenzfJBTBFNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7
	x5uaGRjqGlpamCsp5CXmptoqufgE6Lpl5gCtU1IoS8wpBQoFJBYXK+nbYZoQGuKmawHTGKHr
	GxIE12NkgAYS1jBmPO1qYC+Yx1exszOhgbGFp4uRk0NCwETi+YR7rBC2mMSFe+vZuhi5OIQE
	pjNK3Nt8jxnCaWKSWHTmM1gVm4CWxP4XN9hAbBEBBYnNvc/A4swC5RIrj+xjBrGFBcIlpu78
	ChZnEVCV6Ph8nBHE5hVwlei6fpURYpucxIc9j9hBbE4BN4lp90+B2UJANS8vd7NOYORdwMiw
	ilE0tSC5oDgpPddQrzgxt7g0L10vOT93EyM4Jp5J7WBc2WBxiFGAg1GJh/fgl+fBQqyJZcWV
	uYcYJTiYlUR4f1q8CBbiTUmsrEotyo8vKs1JLT7EaAp01URmKdHkfGC85pXEGxqbmBlZGpkb
	WhgZmyuJ8x5otQ4UEkhPLEnNTk0tSC2C6WPi4JRqYBTpiLh9k2ENp9Hb5YV/A3m1Js0QWzKz
	2Nj0keryR28n3bwWuGhXSk6C0fRHyo9ctyaU9fFkFX5r073+ZLf1dBsrxTsZ1xpmRoVl/i7b
	7tMto6N2pH/21+96/u9FblxKy+qUKHWLtfA9vnTK+Unez57cn/Rx+eezfEJHLuTXZyhcu6mU
	vX2z9WMlluKMREMt5qLiRACAmFISnwIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add documentation for binding of Richtek RT8973A (Micro USB Switch)
device which is using EXTCON subsystem. The RT8973A device can detect various
external accessories when external accessories is attached or detached.

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 .../devicetree/bindings/extcon/extcon-rt8973a.txt  | 25 ++++++++++++++++++++++
 1 file changed, 25 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/extcon/extcon-rt8973a.txt

diff --git a/Documentation/devicetree/bindings/extcon/extcon-rt8973a.txt b/Documentation/devicetree/bindings/extcon/extcon-rt8973a.txt
new file mode 100644
index 0000000..6dede7d
--- /dev/null
+++ b/Documentation/devicetree/bindings/extcon/extcon-rt8973a.txt
@@ -0,0 +1,25 @@
+
+* Richtek RT8973A - Micro USB Switch device
+
+The Richtek RT8973A is Micro USB Switch with OVP and I2C interface. The RT8973A
+is a USB port accessory detector and switch that is optimized to protect low
+voltage system from abnormal high input voltage (up to 28V) and supports high
+speed USB operation. Also, RT8973A support 'auto-configuration' mode.
+If auto-configuration mode is enabled, RT8973A would control internal h/w patch
+for USB D-/D+ switching.
+
+Required properties:
+- compatible: Should be "richtek,rt8973a-muic"
+- reg: Specifies the I2C slave address of the MUIC block. It should be 0x14
+- interrupt-parent: Specifies the phandle of the interrupt controller to which
+  the interrupts from rt8973a are delivered to.
+- interrupts: Interrupt specifiers for detection interrupt sources.
+
+Example:
+
+	rt8973a@14 {
+		compatible = "richtek,rt8973a-muic";
+		interrupt-parent = <&gpx1>;
+		interrupts = <5 0>;
+		reg = <0x14>;
+	};
-- 
1.8.0

