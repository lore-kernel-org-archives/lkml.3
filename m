Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753871AbaJAVcN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 17:32:13 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:42677 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751598AbaJAVbj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 17:31:39 -0400
From: Beniamino Galvani <b.galvani@gmail.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Arnd Bergmann <arnd@arndb.de>, Carlo Caione <carlo@caione.org>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Jerry Cao <jerry.cao@amlogic.com>,
        Victor Wan <victor.wan@amlogic.com>,
        Beniamino Galvani <b.galvani@gmail.com>
Subject: [PATCH 6/6] ARM: meson: document meson8 compatible properties
Date: Wed,  1 Oct 2014 23:29:46 +0200
Message-Id: <1412198986-26534-7-git-send-email-b.galvani@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412198986-26534-1-git-send-email-b.galvani@gmail.com>
References: <1412198986-26534-1-git-send-email-b.galvani@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add device tree bindings documentation for Amlogic Meson8 SoCs.

Signed-off-by: Beniamino Galvani <b.galvani@gmail.com>
---
 Documentation/devicetree/bindings/arm/amlogic.txt | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/Documentation/devicetree/bindings/arm/amlogic.txt b/Documentation/devicetree/bindings/arm/amlogic.txt
index 7eece72..8fe8150 100644
--- a/Documentation/devicetree/bindings/arm/amlogic.txt
+++ b/Documentation/devicetree/bindings/arm/amlogic.txt
@@ -2,7 +2,9 @@ Amlogic MesonX device tree bindings
 -------------------------------------------
 
 Boards with the Amlogic Meson6 SoC shall have the following properties:
+  Required root node property:
+    compatible: "amlogic,meson6"
 
-Required root node property:
-
-compatible = "amlogic,meson6";
+Boards with the Amlogic Meson8 SoC shall have the following properties:
+  Required root node property:
+    compatible: "amlogic,meson8";
-- 
1.9.1

