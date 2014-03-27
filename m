Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755319AbaC0KnG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 06:43:06 -0400
Received: from andre.telenet-ops.be ([195.130.132.53]:35397 "EHLO
	andre.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754638AbaC0KnE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 06:43:04 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH] sh: pci: Remove duplicate SH4A_PCIEPHYCTLR
Date: Thu, 27 Mar 2014 11:42:58 +0100
Message-Id: <1395916978-14292-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 arch/sh/drivers/pci/pcie-sh7786.h |    3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/sh/drivers/pci/pcie-sh7786.h b/arch/sh/drivers/pci/pcie-sh7786.h
index 1ee054e47eae..4a6ff55f759b 100644
--- a/arch/sh/drivers/pci/pcie-sh7786.h
+++ b/arch/sh/drivers/pci/pcie-sh7786.h
@@ -145,9 +145,6 @@
 /*	PCIERMSGIER	*/
 #define	SH4A_PCIERMSGIER	(0x004040)	/* R/W - 0x0000 0000 32 */
 
-/*	PCIEPHYCTLR	*/
-#define SH4A_PCIEPHYCTLR	(0x010000)	/* R/W - 0x0000 0000 32 */
-
 /*	PCIEPHYADRR	*/
 #define	SH4A_PCIEPHYADRR	(0x010004)	/* R/W - 0x0000 0000 32 */
 #define		BITS_ACK	(24)			// Rev1.171
-- 
1.7.9.5

