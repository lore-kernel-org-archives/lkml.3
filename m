Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752183Ab3GABM2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Jun 2013 21:12:28 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:38906 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751983Ab3GABM0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Jun 2013 21:12:26 -0400
From: Joe Perches <joe@perches.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 02/12] cdrom: Remove unused CHECKAUDIO macro
Date: Sun, 30 Jun 2013 18:11:57 -0700
Message-Id: <b490bfda4273c511e739b587a66d7d1f387b9f19.1372640818.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1372640818.git.joe@perches.com>
References: <cover.1372640818.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's unused, make it disappear.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/cdrom/cdrom.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/cdrom/cdrom.c b/drivers/cdrom/cdrom.c
index 4239a69..3aa51a7 100644
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

