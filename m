Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753893Ab3KDRKR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 12:10:17 -0500
Received: from e06smtp14.uk.ibm.com ([195.75.94.110]:44226 "EHLO
	e06smtp14.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753395Ab3KDRJg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 12:09:36 -0500
From: Frank Haverkamp <haver@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, gregkh@linuxfoundation.org, cody@linux.vnet.ibm.com,
        schwidefsky@de.ibm.com, utz.bacher@de.ibm.com, mmarek@suse.cz,
        rmallon@gmail.com, jsvogt@de.ibm.com, MIJUNG@de.ibm.com,
        cascardo@linux.vnet.ibm.com, michael@ibmra.de,
        haver@linux.vnet.ibm.com
Subject: [PATCH 3/9] GenWQE: Remove obsolete constants
Date: Mon,  4 Nov 2013 18:08:03 +0100
Message-Id: <1383584889-21594-4-git-send-email-haver@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1383584889-21594-1-git-send-email-haver@linux.vnet.ibm.com>
References: <1383584889-21594-1-git-send-email-haver@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13110417-1948-0000-0000-000006C93918
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The removed constants should not be part of the user-space kernel
interface.

Signed-off-by: Frank Haverkamp <haver@linux.vnet.ibm.com>
---
 include/linux/genwqe/genwqe_card.h |   12 ------------
 1 files changed, 0 insertions(+), 12 deletions(-)

diff --git a/include/linux/genwqe/genwqe_card.h b/include/linux/genwqe/genwqe_card.h
index ffed142..aa3f1b9 100644
--- a/include/linux/genwqe/genwqe_card.h
+++ b/include/linux/genwqe/genwqe_card.h
@@ -390,18 +390,6 @@ struct chip_bitstream {
 #define DDCB_ASV_LENGTH			64  /* len of the DDCB ASV array  */
 #define DDCB_FIXUPS			12  /* maximum number of fixups */
 
-/*
- * We might have addresses within the ASIV data. Those need to be
- * replaced by valid DMA addresses to the buffer, sg-list or
- * child-block in the kernel driver handling the request.
- */
-#define GENWQE_DMA_TYPE_MASK		0x18  /* mask off type */
-#define GENWQE_DMA_TYPE_RAW		0x00  /* no DMA addr  */
-#define GENWQE_DMA_TYPE_FLAT		0x08  /* contignous DMA block */
-#define GENWQE_DMA_TYPE_SGLIST		0x10  /* DMA sg-list */
-#define GENWQE_DMA_TYPE_CHILD		0x18  /* DMA child-block */
-#define GENWQE_DMA_WRITEABLE		0x04  /* memory writeable? */
-
 struct genwqe_debug_data {
 	char driver_version[64];
 	uint64_t slu_unitcfg;
-- 
1.7.1

