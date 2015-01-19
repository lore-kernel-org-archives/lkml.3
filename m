Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752266AbbASXYP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 18:24:15 -0500
Received: from mail-wg0-f43.google.com ([74.125.82.43]:62979 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751552AbbASXYD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 18:24:03 -0500
From: Beniamino Galvani <b.galvani@gmail.com>
To: Carlo Caione <carlo@caione.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Russell King <linux@arm.linux.org.uk>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Jerry Cao <jerry.cao@amlogic.com>,
        Victor Wan <victor.wan@amlogic.com>,
        Beniamino Galvani <b.galvani@gmail.com>
Subject: [PATCH 2/3] of: Define board compatible for MINIX NEO-X8
Date: Tue, 20 Jan 2015 00:22:58 +0100
Message-Id: <1421709779-25691-3-git-send-email-b.galvani@gmail.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1421709779-25691-1-git-send-email-b.galvani@gmail.com>
References: <1421709779-25691-1-git-send-email-b.galvani@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Document the board compatible property for MINIX NEO-X8, a
Meson8-based digital media player. While at it, move the other
existing Meson board compatible to amlogic.txt.

Signed-off-by: Beniamino Galvani <b.galvani@gmail.com>
---
 Documentation/devicetree/bindings/arm/amlogic.txt   | 4 ++++
 Documentation/devicetree/bindings/arm/geniatech.txt | 5 -----
 2 files changed, 4 insertions(+), 5 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/arm/geniatech.txt

diff --git a/Documentation/devicetree/bindings/arm/amlogic.txt b/Documentation/devicetree/bindings/arm/amlogic.txt
index 8fe8150..973884a 100644
--- a/Documentation/devicetree/bindings/arm/amlogic.txt
+++ b/Documentation/devicetree/bindings/arm/amlogic.txt
@@ -8,3 +8,7 @@ Boards with the Amlogic Meson6 SoC shall have the following properties:
 Boards with the Amlogic Meson8 SoC shall have the following properties:
   Required root node property:
     compatible: "amlogic,meson8";
+
+Board compatible values:
+  - "geniatech,atv1200"
+  - "minix,neo-x8"
diff --git a/Documentation/devicetree/bindings/arm/geniatech.txt b/Documentation/devicetree/bindings/arm/geniatech.txt
deleted file mode 100644
index 74ccba4..0000000
--- a/Documentation/devicetree/bindings/arm/geniatech.txt
+++ /dev/null
@@ -1,5 +0,0 @@
-Geniatech platforms device tree bindings
--------------------------------------------
-
-Geniatech ATV1200
-    - compatible = "geniatech,atv1200"
-- 
2.1.4

