Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754094AbaEEAFa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 20:05:30 -0400
Received: from smtprelay0117.hostedemail.com ([216.40.44.117]:52148 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754016AbaEEAFX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 20:05:23 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::,RULES_HIT:41:355:379:541:800:960:973:988:989:1260:1345:1359:1437:1534:1539:1711:1714:1730:1747:1777:1792:2393:2559:2562:3138:3139:3140:3141:3142:3350:3865:3871:3872:5007:6261:10004:10026:10848:11026:11473:11658:11914:12114:12295:12296:12438:12517:12519:12555:13161:13229:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: work92_2ede2cb791217
X-Filterd-Recvd-Size: 1532
From: Joe Perches <joe@perches.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 05/12] cdrom: Remove unnecessary check_for_audio_disc prototype
Date: Sun,  4 May 2014 17:05:06 -0700
Message-Id: <798b31266ebc0bb7f557cc5aaafb1031dc8001fd.1399247745.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <51EDAD79.3050707@kernel.dk>
References: <51EDAD79.3050707@kernel.dk>
In-Reply-To: <cover.1399247745.git.joe@perches.com>
References: <cover.1399247745.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The actual static is defined below it but not used until later.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/cdrom/cdrom.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/cdrom/cdrom.c b/drivers/cdrom/cdrom.c
index 5a38b56..a570e5f 100644
--- a/drivers/cdrom/cdrom.c
+++ b/drivers/cdrom/cdrom.c
@@ -337,8 +337,6 @@ do {							\
 #define CDROM_DEF_TIMEOUT	(7 * HZ)
 
 /* Not-exported routines. */
-static int check_for_audio_disc(struct cdrom_device_info * cdi,
-			 struct cdrom_device_ops * cdo);
 static void sanitize_format(union cdrom_addr *addr, 
 		u_char * curr, u_char requested);
 static int mmc_ioctl(struct cdrom_device_info *cdi, unsigned int cmd,
-- 
1.8.1.2.459.gbcd45b4.dirty

