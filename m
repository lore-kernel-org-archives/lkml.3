Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754295AbaA1Ajt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 19:39:49 -0500
Received: from mail-ea0-f172.google.com ([209.85.215.172]:58418 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753876AbaA1Ajo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 19:39:44 -0500
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 02/21] devicetree: bindings: update MVEBU pinctrl binding documentation
Date: Tue, 28 Jan 2014 01:39:14 +0100
Message-Id: <1390869573-27624-3-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1390869573-27624-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1390674856-4993-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <1390869573-27624-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dove pinctrl binding now requires three different reg properties. This
updates corresponding binding and example accordingly. While at it, also
document reg property as required for the other MVEBU SoC pinctrl nodes.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
---
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Gregory Clement <gregory.clement@free-electrons.com>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: devicetree@vger.kernel.org
Cc: linux-doc@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 .../devicetree/bindings/pinctrl/marvell,armada-370-pinctrl.txt          | 1 +
 Documentation/devicetree/bindings/pinctrl/marvell,armada-xp-pinctrl.txt | 1 +
 Documentation/devicetree/bindings/pinctrl/marvell,dove-pinctrl.txt      | 1 +
 Documentation/devicetree/bindings/pinctrl/marvell,kirkwood-pinctrl.txt  | 1 +
 Documentation/devicetree/bindings/pinctrl/marvell,mvebu-pinctrl.txt     | 2 +-
 5 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/pinctrl/marvell,armada-370-pinctrl.txt b/Documentation/devicetree/bindings/pinctrl/marvell,armada-370-pinctrl.txt
index 01ef408e205f..adda2a8d1d52 100644
--- a/Documentation/devicetree/bindings/pinctrl/marvell,armada-370-pinctrl.txt
+++ b/Documentation/devicetree/bindings/pinctrl/marvell,armada-370-pinctrl.txt
@@ -5,6 +5,7 @@ part and usage.
 
 Required properties:
 - compatible: "marvell,88f6710-pinctrl"
+- reg: register specifier of MPP registers
 
 Available mpp pins/groups and functions:
 Note: brackets (x) are not part of the mpp name for marvell,function and given
diff --git a/Documentation/devicetree/bindings/pinctrl/marvell,armada-xp-pinctrl.txt b/Documentation/devicetree/bindings/pinctrl/marvell,armada-xp-pinctrl.txt
index bfa0a2e5e0cb..373dbccd7ab0 100644
--- a/Documentation/devicetree/bindings/pinctrl/marvell,armada-xp-pinctrl.txt
+++ b/Documentation/devicetree/bindings/pinctrl/marvell,armada-xp-pinctrl.txt
@@ -6,6 +6,7 @@ part and usage.
 Required properties:
 - compatible: "marvell,mv78230-pinctrl", "marvell,mv78260-pinctrl",
               "marvell,mv78460-pinctrl"
+- reg: register specifier of MPP registers
 
 This driver supports all Armada XP variants, i.e. mv78230, mv78260, and mv78460.
 
diff --git a/Documentation/devicetree/bindings/pinctrl/marvell,dove-pinctrl.txt b/Documentation/devicetree/bindings/pinctrl/marvell,dove-pinctrl.txt
index 50ec3512a292..cf52477cc7ee 100644
--- a/Documentation/devicetree/bindings/pinctrl/marvell,dove-pinctrl.txt
+++ b/Documentation/devicetree/bindings/pinctrl/marvell,dove-pinctrl.txt
@@ -6,6 +6,7 @@ part and usage.
 Required properties:
 - compatible: "marvell,dove-pinctrl"
 - clocks: (optional) phandle of pdma clock
+- reg: register specifiers of MPP, MPP4, and PMU MPP registers
 
 Available mpp pins/groups and functions:
 Note: brackets (x) are not part of the mpp name for marvell,function and given
diff --git a/Documentation/devicetree/bindings/pinctrl/marvell,kirkwood-pinctrl.txt b/Documentation/devicetree/bindings/pinctrl/marvell,kirkwood-pinctrl.txt
index 95daf6335c37..730444a9a4de 100644
--- a/Documentation/devicetree/bindings/pinctrl/marvell,kirkwood-pinctrl.txt
+++ b/Documentation/devicetree/bindings/pinctrl/marvell,kirkwood-pinctrl.txt
@@ -8,6 +8,7 @@ Required properties:
               "marvell,88f6190-pinctrl", "marvell,88f6192-pinctrl",
               "marvell,88f6281-pinctrl", "marvell,88f6282-pinctrl"
               "marvell,98dx4122-pinctrl"
+- reg: register specifier of MPP registers
 
 This driver supports all kirkwood variants, i.e. 88f6180, 88f619x, and 88f628x.
 It also support the 88f6281-based variant in the 98dx412x Bobcat SoCs.
diff --git a/Documentation/devicetree/bindings/pinctrl/marvell,mvebu-pinctrl.txt b/Documentation/devicetree/bindings/pinctrl/marvell,mvebu-pinctrl.txt
index 0a26c3aa4e6d..0c09f4eb2af0 100644
--- a/Documentation/devicetree/bindings/pinctrl/marvell,mvebu-pinctrl.txt
+++ b/Documentation/devicetree/bindings/pinctrl/marvell,mvebu-pinctrl.txt
@@ -37,7 +37,7 @@ uart1: serial@12100 {
 
 pinctrl: pinctrl@d0200 {
 	compatible = "marvell,dove-pinctrl";
-	reg = <0xd0200 0x20>;
+	reg = <0xd0200 0x14>, <0xd0440 0x04>, <0xd802c 0x08>;
 
 	pmx_uart1_sw: pmx-uart1-sw {
 		marvell,pins = "mpp_uart1";
-- 
1.8.5.2

