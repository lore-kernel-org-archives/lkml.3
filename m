Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753608AbaHNARc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 20:17:32 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:33820 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753382AbaHNARJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 20:17:09 -0400
X-AuditID: cbfee690-b7f526d000003627-a5-53ebfff89c81
From: Chanwoo Choi <cw00.choi@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        sw0312.kim@samsung.com, Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCHv2 2/2] dt-bindings: extcon: Add support for Richtek RT8973A
 MUIC device
Date: Thu, 14 Aug 2014 09:16:52 +0900
Message-id: <1407975412-3668-3-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1407975412-3668-1-git-send-email-cw00.choi@samsung.com>
References: <1407975412-3668-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDLMWRmVeSWpSXmKPExsWyRsSkWPfH/9fBBtPPa1pc//Kc1eJs0xt2
	i8u75rBZ3G5cwWYxY/JLNgdWj74tqxg9Pm+SC2CK4rJJSc3JLEst0rdL4Mp42tXAXjCPr2Jn
	Z0IDYwtPFyMnh4SAicTai1+ZIWwxiQv31rN1MXJxCAksZZTYfA3EgSi6/PkuM0RiEaPE7NMt
	LBBOE5PErSlNrCBVbAJaEvtf3ADrEBFQkNjc+wwszixQLrHyyD6wFcICkRJLpi1iBLFZBFQl
	Xjc8BKvnFXCRmHa/FeoMOYkPex6xdzFycHAKuEr0L3AECQsBlfx/+4QVZK+EwGc2icNf1rNC
	zBGQ+Db5EAtIvYSArMSmA1BjJCUOrrjBMoFReAEjwypG0dSC5ILipPQiE73ixNzi0rx0veT8
	3E2MwJA9/e/ZhB2M9w5YH2JMBho3kVlKNDkfGPJ5JfGGxmZGFqYmpsZG5pZmpAkrifOqPUoK
	EhJITyxJzU5NLUgtii8qzUktPsTIxMEp1cDI9b7pfjjnjj9hqxml/85z8HS4tCTgyXnld9Nr
	Hj1eFys6u0igluGFaIi10r7esHVPrFa+sX+3ZJr9pehgjo8G989GbJ5QMFt4UdjjZLe5x84Y
	2v292ax8NPxRifF/4c4b0yKztd+uDz7x92ziK+tam7fWOX/Wix0WfvH7yoabXT+tVqzge3Da
	RImlOCPRUIu5qDgRAAxBh1NvAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupmkeLIzCtJLcpLzFFi42I5/e+xgO6P/6+DDR4eUrK4/uU5q8XZpjfs
	Fpd3zWGzuN24gs1ixuSXbA6sHn1bVjF6fN4kF8AU1cBok5GamJJapJCal5yfkpmXbqvkHRzv
	HG9qZmCoa2hpYa6kkJeYm2qr5OIToOuWmQO0TkmhLDGnFCgUkFhcrKRvh2lCaIibrgVMY4Su
	b0gQXI+RARpIWMOY8bSrgb1gHl/Fzs6EBsYWni5GTg4JAROJy5/vMkPYYhIX7q1n62Lk4hAS
	WMQoMft0CwuE08QkcWtKEytIFZuAlsT+FzfYQGwRAQWJzb3PwOLMAuUSK4/sA5skLBApsWTa
	IkYQm0VAVeJ1w0Owel4BF4lp91uhtslJfNjziL2LkYODU8BVon+BI0hYCKjk/9snrBMYeRcw
	MqxiFE0tSC4oTkrPNdQrTswtLs1L10vOz93ECI6IZ1I7GFc2WBxiFOBgVOLh9Yh6HSzEmlhW
	XJl7iFGCg1lJhNdvN1CINyWxsiq1KD++qDQntfgQoynQUROZpUST84HRmlcSb2hsYmZkaWRu
	aGFkbK4kznug1TpQSCA9sSQ1OzW1ILUIpo+Jg1OqgfGs7t/l7x97SEr58fuxTZuwtv3cLPYj
	4TE7Qv7JWk4J3JhknDY/13/mlM9qGjrt3TL+Jden3X/GeK9B2c6nf/bfj0p8sm+Pr2bpfGp9
	W+f0gbRN7TIb95+49LpMdZs7O0vskWdy1oVz/l7c6yLleX7BOt2TB7Wsmxx36l5ijLgsmH4y
	6C1/o5ESS3FGoqEWc1FxIgBRbY33ngIAAA==
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

