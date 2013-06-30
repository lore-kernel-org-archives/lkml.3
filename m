Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752098Ab3F3J7d (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Jun 2013 05:59:33 -0400
Received: from jacques.telenet-ops.be ([195.130.132.50]:59522 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751249Ab3F3J7c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Jun 2013 05:59:32 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] m68k/mac: Fix comment about iop_*_present flags setup timing
Date: Sun, 30 Jun 2013 11:59:22 +0200
Message-Id: <1372586362-1206-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/m68k/mac/iop.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/m68k/mac/iop.c b/arch/m68k/mac/iop.c
index 7d8d461..8a4c446 100644
--- a/arch/m68k/mac/iop.c
+++ b/arch/m68k/mac/iop.c
@@ -118,9 +118,9 @@
 
 /*#define DEBUG_IOP*/
 
-/* Set to non-zero if the IOPs are present. Set by iop_init() */
+/* Set to non-zero if the IOPs are present. Set by iop_preinit() */
 
-int iop_scc_present,iop_ism_present;
+int iop_scc_present, iop_ism_present;
 
 /* structure for tracking channel listeners */
 
-- 
1.7.9.5

