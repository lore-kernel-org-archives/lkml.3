Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752493AbaB0Mrf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 07:47:35 -0500
Received: from baptiste.telenet-ops.be ([195.130.132.51]:58428 "EHLO
	baptiste.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751798AbaB0Mrd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 07:47:33 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Mark Brown <broonie@linaro.org>
Cc: Laurent Pinchart <Laurent.pinchart@ideasonboard.com>,
        devicetree@vger.kernel.org, linux-spi@vger.kernel.org,
        linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>
Subject: [PATCH] spi: sh-msiof: Remove "renesas,msiof-sh7724" from bindings
Date: Thu, 27 Feb 2014 13:47:17 +0100
Message-Id: <1393505238-11954-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@linux-m68k.org>

It's not implemented in the driver, so it's a bad example.

Signed-off-by: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
---
 Documentation/devicetree/bindings/spi/sh-msiof.txt |    1 -
 1 file changed, 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/spi/sh-msiof.txt b/Documentation/devicetree/bindings/spi/sh-msiof.txt
index 1f0cb33763a1..f24baf3b6cc1 100644
--- a/Documentation/devicetree/bindings/spi/sh-msiof.txt
+++ b/Documentation/devicetree/bindings/spi/sh-msiof.txt
@@ -5,7 +5,6 @@ Required properties:
 			 "renesas,sh-msiof" for SuperH, or
 			 "renesas,sh-mobile-msiof" for SH Mobile series.
 			 Examples with soctypes are:
-			 "renesas,msiof-sh7724" (SH)
 			 "renesas,msiof-r8a7790" (R-Car H2)
 			 "renesas,msiof-r8a7791" (R-Car M2)
 - reg                  : Offset and length of the register set for the device
-- 
1.7.9.5

