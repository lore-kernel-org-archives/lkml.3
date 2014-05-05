Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754041AbaEEAFZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 20:05:25 -0400
Received: from smtprelay0237.hostedemail.com ([216.40.44.237]:56078 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753965AbaEEAFT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 20:05:19 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::,RULES_HIT:41:355:379:541:800:960:973:988:989:1260:1345:1359:1437:1534:1539:1711:1714:1730:1747:1777:1792:2194:2199:2393:2559:2562:3138:3139:3140:3141:3142:3351:3865:3866:3870:3871:3872:4250:4321:5007:6261:9592:10004:10026:10848:11026:11658:11914:12043:12438:12517:12519:12555:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: error98_2e3c564cdea10
X-Filterd-Recvd-Size: 1519
From: Joe Perches <joe@perches.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 02/12] cdrom: Remove unused CHECKAUDIO macro
Date: Sun,  4 May 2014 17:05:03 -0700
Message-Id: <24c14c6e8a8887465eae806fcb35816752992eb7.1399247745.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <51EDAD79.3050707@kernel.dk>
References: <51EDAD79.3050707@kernel.dk>
In-Reply-To: <cover.1399247745.git.joe@perches.com>
References: <cover.1399247745.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's unused, make it disappear.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/cdrom/cdrom.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/cdrom/cdrom.c b/drivers/cdrom/cdrom.c
index 3828c92..8eaba53 100644
--- a/drivers/cdrom/cdrom.c
+++ b/drivers/cdrom/cdrom.c
@@ -339,9 +339,6 @@ do {							\
    a lot of places. This macro makes the code more clear. */
 #define CDROM_CAN(type) (cdi->ops->capability & ~cdi->mask & (type))
 
-/* used in the audio ioctls */
-#define CHECKAUDIO if ((ret=check_for_audio_disc(cdi, cdo))) return ret
-
 /*
  * Another popular OS uses 7 seconds as the hard timeout for default
  * commands, so it is a good choice for us as well.
-- 
1.8.1.2.459.gbcd45b4.dirty

