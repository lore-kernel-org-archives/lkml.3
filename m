Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753734Ab3HFFd7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 01:33:59 -0400
Received: from g6t0184.atlanta.hp.com ([15.193.32.61]:47553 "EHLO
	g6t0184.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752653Ab3HFFds (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 01:33:48 -0400
From: Davidlohr Bueso <davidlohr@hp.com>
To: Andrew Morton <akpm@linux-foundation.org>, Jens Axboe <axboe@kernel.dk>
Cc: Matt Domsch <Matt_Domsch@dell.com>, Jim Hull <jim.hull@hp.com>,
        Karel Zak <kzak@redhat.com>, Peter Jones <pjones@redhat.com>,
        Chegu Vinod <chegu_vinod@hp.com>,
        Aswin Chandramouleeswaran <aswin@hp.com>, linux-kernel@vger.kernel.org,
        Davidlohr Bueso <davidlohr@hp.com>
Subject: [PATCH 7/8] partitions/efi: delete annoying emacs style comments
Date: Mon,  5 Aug 2013 22:21:15 -0700
Message-Id: <1375766476-4204-8-git-send-email-davidlohr@hp.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1375766476-4204-1-git-send-email-davidlohr@hp.com>
References: <1375766476-4204-1-git-send-email-davidlohr@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I love emacs, but these settings for coding style are
annoying when trying to open the efi.h file. More important,
we already have checkpatch for that.

Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
---
 block/partitions/efi.h | 19 -------------------
 1 file changed, 19 deletions(-)

diff --git a/block/partitions/efi.h b/block/partitions/efi.h
index e9741de..9ab8ee9 100644
--- a/block/partitions/efi.h
+++ b/block/partitions/efi.h
@@ -130,22 +130,3 @@ typedef struct _legacy_mbr {
 extern int efi_partition(struct parsed_partitions *state);
 
 #endif
-
-/*
- * Overrides for Emacs so that we follow Linus's tabbing style.
- * Emacs will notice this stuff at the end of the file and automatically
- * adjust the settings for this buffer only.  This must remain at the end
- * of the file.
- * --------------------------------------------------------------------------
- * Local variables:
- * c-indent-level: 4 
- * c-brace-imaginary-offset: 0
- * c-brace-offset: -4
- * c-argdecl-indent: 4
- * c-label-offset: -4
- * c-continued-statement-offset: 4
- * c-continued-brace-offset: 0
- * indent-tabs-mode: nil
- * tab-width: 8
- * End:
- */
-- 
1.7.11.7

