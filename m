Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934490Ab3JPMeu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 08:34:50 -0400
Received: from jacques.telenet-ops.be ([195.130.132.50]:41677 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934307Ab3JPMb4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 08:31:56 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 07/16] m68k/vme: Remove unused mvme_bdid_ptr
Date: Wed, 16 Oct 2013 14:31:24 +0200
Message-Id: <1381926693-6392-8-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1381926693-6392-1-git-send-email-geert@linux-m68k.org>
References: <1381926693-6392-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/m68k/include/asm/mvme16xhw.h |    2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/m68k/include/asm/mvme16xhw.h b/arch/m68k/include/asm/mvme16xhw.h
index 6117f56653d2..87fa84ad252e 100644
--- a/arch/m68k/include/asm/mvme16xhw.h
+++ b/arch/m68k/include/asm/mvme16xhw.h
@@ -7,8 +7,6 @@
 
 /* Note, bytes 12 and 13 are board no in BCD (0162,0166,0167,0177,etc) */
 
-extern long mvme_bdid_ptr;
-
 typedef struct {
 	char	bdid[4];
 	u_char	rev, mth, day, yr;
-- 
1.7.9.5

