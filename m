Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934493Ab3JPMf2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 08:35:28 -0400
Received: from georges.telenet-ops.be ([195.130.137.68]:36712 "EHLO
	georges.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934279Ab3JPMby (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 08:31:54 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 06/16] m68k/mac: Remove unused hardware profile tags
Date: Wed, 16 Oct 2013 14:31:23 +0200
Message-Id: <1381926693-6392-7-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1381926693-6392-1-git-send-email-geert@linux-m68k.org>
References: <1381926693-6392-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/m68k/include/asm/bootinfo.h |   24 ------------------------
 1 file changed, 24 deletions(-)

diff --git a/arch/m68k/include/asm/bootinfo.h b/arch/m68k/include/asm/bootinfo.h
index ef888d4af4e6..007c95759e6b 100644
--- a/arch/m68k/include/asm/bootinfo.h
+++ b/arch/m68k/include/asm/bootinfo.h
@@ -149,30 +149,6 @@ static inline void save_bootinfo(const struct bi_record *bi) {}
 #define BI_MAC_CPUID		0x800a	/* Mac CPU type (sanity check) */
 #define BI_MAC_ROMBASE		0x800b	/* Mac system ROM base address */
 
-    /*
-     *  Macintosh hardware profile data - unused, see macintosh.h for
-     *  reasonable type values
-     */
-
-#define BI_MAC_VIA1BASE		0x8010	/* Mac VIA1 base address (always present) */
-#define BI_MAC_VIA2BASE		0x8011	/* Mac VIA2 base address (type varies) */
-#define BI_MAC_VIA2TYPE		0x8012	/* Mac VIA2 type (VIA, RBV, OSS) */
-#define BI_MAC_ADBTYPE		0x8013	/* Mac ADB interface type */
-#define BI_MAC_ASCBASE		0x8014	/* Mac Apple Sound Chip base address */
-#define BI_MAC_SCSI5380		0x8015	/* Mac NCR 5380 SCSI (base address, multi) */
-#define BI_MAC_SCSIDMA		0x8016	/* Mac SCSI DMA (base address) */
-#define BI_MAC_SCSI5396		0x8017	/* Mac NCR 53C96 SCSI (base address, multi) */
-#define BI_MAC_IDETYPE		0x8018	/* Mac IDE interface type */
-#define BI_MAC_IDEBASE		0x8019	/* Mac IDE interface base address */
-#define BI_MAC_NUBUS		0x801a	/* Mac Nubus type (none, regular, pseudo) */
-#define BI_MAC_SLOTMASK		0x801b	/* Mac Nubus slots present */
-#define BI_MAC_SCCTYPE		0x801c	/* Mac SCC serial type (normal, IOP) */
-#define BI_MAC_ETHTYPE		0x801d	/* Mac builtin ethernet type (Sonic, MACE */
-#define BI_MAC_ETHBASE		0x801e	/* Mac builtin ethernet base address */
-#define BI_MAC_PMU		0x801f	/* Mac power management / poweroff hardware */
-#define BI_MAC_IOP_SWIM		0x8020	/* Mac SWIM floppy IOP */
-#define BI_MAC_IOP_ADB		0x8021	/* Mac ADB IOP */
-
 
     /*
      *  Apollo-specific tags
-- 
1.7.9.5

