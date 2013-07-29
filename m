Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755344Ab3G2McJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 08:32:09 -0400
Received: from mail-bk0-f49.google.com ([209.85.214.49]:41582 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752912Ab3G2McG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 08:32:06 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/5] ARM: dove: use preprocessor on device tree files
Date: Mon, 29 Jul 2013 14:31:50 +0200
Message-Id: <1375101114-28858-2-git-send-email-sebastian.hesselbarth@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1375101114-28858-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1375101114-28858-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This coverts Dove DT board files to preprocessor includes instead
of dtc includes.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
---
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 arch/arm/boot/dts/dove-cm-a510.dts |    2 +-
 arch/arm/boot/dts/dove-cubox.dts   |    2 +-
 arch/arm/boot/dts/dove-d2plug.dts  |    2 +-
 arch/arm/boot/dts/dove-dove-db.dts |    2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm/boot/dts/dove-cm-a510.dts b/arch/arm/boot/dts/dove-cm-a510.dts
index 61a8062..50c0d69 100644
--- a/arch/arm/boot/dts/dove-cm-a510.dts
+++ b/arch/arm/boot/dts/dove-cm-a510.dts
@@ -1,6 +1,6 @@
 /dts-v1/;
 
-/include/ "dove.dtsi"
+#include "dove.dtsi"
 
 / {
 	model = "Compulab CM-A510";
diff --git a/arch/arm/boot/dts/dove-cubox.dts b/arch/arm/boot/dts/dove-cubox.dts
index 022646e..4af59b6 100644
--- a/arch/arm/boot/dts/dove-cubox.dts
+++ b/arch/arm/boot/dts/dove-cubox.dts
@@ -1,6 +1,6 @@
 /dts-v1/;
 
-/include/ "dove.dtsi"
+#include "dove.dtsi"
 
 / {
 	model = "SolidRun CuBox";
diff --git a/arch/arm/boot/dts/dove-d2plug.dts b/arch/arm/boot/dts/dove-d2plug.dts
index e2222ce..c11d363 100644
--- a/arch/arm/boot/dts/dove-d2plug.dts
+++ b/arch/arm/boot/dts/dove-d2plug.dts
@@ -1,6 +1,6 @@
 /dts-v1/;
 
-/include/ "dove.dtsi"
+#include "dove.dtsi"
 
 / {
 	model = "Globalscale D2Plug";
diff --git a/arch/arm/boot/dts/dove-dove-db.dts b/arch/arm/boot/dts/dove-dove-db.dts
index e5a920b..bb725dc 100644
--- a/arch/arm/boot/dts/dove-dove-db.dts
+++ b/arch/arm/boot/dts/dove-dove-db.dts
@@ -1,6 +1,6 @@
 /dts-v1/;
 
-/include/ "dove.dtsi"
+#include "dove.dtsi"
 
 / {
 	model = "Marvell DB-MV88AP510-BP Development Board";
-- 
1.7.10.4

