Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755290AbaHVJWS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 05:22:18 -0400
Received: from mail-lb0-f182.google.com ([209.85.217.182]:40949 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750850AbaHVJWR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 05:22:17 -0400
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: [PATCH] sound: pci: ca0132_regs.h: Fix typo in include guard
Date: Fri, 22 Aug 2014 11:22:09 +0200
Message-Id: <1408699329-7218-1-git-send-email-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 sound/pci/hda/ca0132_regs.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/pci/hda/ca0132_regs.h b/sound/pci/hda/ca0132_regs.h
index 07e7609..8371274 100644
--- a/sound/pci/hda/ca0132_regs.h
+++ b/sound/pci/hda/ca0132_regs.h
@@ -20,7 +20,7 @@
  */
 
 #ifndef __CA0132_REGS_H
-#define __CA0312_REGS_H
+#define __CA0132_REGS_H
 
 #define DSP_CHIP_OFFSET                0x100000
 #define DSP_DBGCNTL_MODULE_OFFSET      0xE30
-- 
1.9.2

