Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932986AbaBUQa0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 11:30:26 -0500
Received: from michel.telenet-ops.be ([195.130.137.88]:57643 "EHLO
	michel.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932526AbaBUQ3Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 11:29:24 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Mark Brown <broonie@kernel.org>
Cc: linux-spi@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>,
        devicetree@vger.kernel.org
Subject: [PATCH 1/4] spi: rspi: List full example compatible properties in bindings
Date: Fri, 21 Feb 2014 17:29:15 +0100
Message-Id: <1393000158-6622-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@linux-m68k.org>

List full example compatible properties with soctypes instead of just the
soctypes, so checkpatch can validate DTSes.

Signed-off-by: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
Cc: devicetree@vger.kernel.org
---
 Documentation/devicetree/bindings/spi/spi-rspi.txt |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/Documentation/devicetree/bindings/spi/spi-rspi.txt b/Documentation/devicetree/bindings/spi/spi-rspi.txt
index 95f9b21d239f..e54924b2aff6 100644
--- a/Documentation/devicetree/bindings/spi/spi-rspi.txt
+++ b/Documentation/devicetree/bindings/spi/spi-rspi.txt
@@ -7,9 +7,11 @@ Required properties:
 		     "renesas,rspi-<soctype>", "renesas,rspi-rz" as fallback.
 		     For Quad Serial Peripheral Interface on R-Car Gen2:
 		     "renesas,qspi-<soctype>", "renesas,qspi" as fallback.
-		     Examples of valid soctypes are "sh7757" (SH),
-		     "r7s72100" (RZ/A1H), "r8a7790" (R-Car H2), and
-		     "r8a7791" (R-Car M2).
+		     Examples with soctypes are:
+		        - "renesas,rspi-sh7757" (SH)
+			- "renesas,rspi-r7s72100" (RZ/A1H)
+			- "renesas,qspi-r8a7790" (R-Car H2)
+			- "renesas,qspi-r8a7791" (R-Car M2)
 - reg              : Address start and address range size of the device
 - interrupts       : A list of interrupt-specifiers, one for each entry in
 		     interrupt-names.
-- 
1.7.9.5

