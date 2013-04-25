Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759638Ab3DYVTf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 17:19:35 -0400
Received: from smtp2.macqel.be ([194.78.208.39]:27825 "EHLO smtp2.macqel.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757309Ab3DYVS0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 17:18:26 -0400
From: Philippe De Muyter <phdm@macqel.be>
To: linux-kernel@vger.kernel.org
Cc: Philippe De Muyter <phdm@macqel.be>, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/5] partitions/msdos.c: end-of-line whitespace and semicolon cleanup
Date: Thu, 25 Apr 2013 23:10:25 +0200
Message-Id: <1366924229-21569-2-git-send-email-phdm@macqel.be>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1366924229-21569-1-git-send-email-phdm@macqel.be>
References: <1366924229-21569-1-git-send-email-phdm@macqel.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Philippe De Muyter <phdm@macqel.be>
Cc: Jens Axboe <axboe@kernel.dk>
---
 block/partitions/msdos.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/block/partitions/msdos.c b/block/partitions/msdos.c
index 7681cd2..9bf19e6 100644
--- a/block/partitions/msdos.c
+++ b/block/partitions/msdos.c
@@ -90,7 +90,7 @@ static int aix_magic_present(struct parsed_partitions *state, unsigned char *p)
 		if (d[0] == '_' && d[1] == 'L' && d[2] == 'V' && d[3] == 'M')
 			ret = 1;
 		put_dev_sector(sect);
-	};
+	}
 	return ret;
 }
 
@@ -142,7 +142,7 @@ static void parse_extended(struct parsed_partitions *state,
 			return;
 
 		if (!msdos_magic_present(data + 510))
-			goto done; 
+			goto done;
 
 		p = (struct partition *) (data + 0x1be);
 
@@ -155,7 +155,7 @@ static void parse_extended(struct parsed_partitions *state,
 		 * and OS/2 seems to use all four entries.
 		 */
 
-		/* 
+		/*
 		 * First process the data partition(s)
 		 */
 		for (i=0; i<4; i++, p++) {
@@ -263,7 +263,7 @@ static void parse_solaris_x86(struct parsed_partitions *state,
 }
 
 #if defined(CONFIG_BSD_DISKLABEL)
-/* 
+/*
  * Create devices for BSD partitions listed in a disklabel, under a
  * dos-like partition. See parse_extended() for more information.
  */
@@ -294,7 +294,7 @@ static void parse_bsd(struct parsed_partitions *state,
 
 		if (state->next == state->limit)
 			break;
-		if (p->p_fstype == BSD_FS_UNUSED) 
+		if (p->p_fstype == BSD_FS_UNUSED)
 			continue;
 		bsd_start = le32_to_cpu(p->p_offset);
 		bsd_size = le32_to_cpu(p->p_size);
@@ -441,7 +441,7 @@ static struct {
 	{NEW_SOLARIS_X86_PARTITION, parse_solaris_x86},
 	{0, NULL},
 };
- 
+
 int msdos_partition(struct parsed_partitions *state)
 {
 	sector_t sector_size = bdev_logical_block_size(state->bdev) / 512;
-- 
1.7.1

