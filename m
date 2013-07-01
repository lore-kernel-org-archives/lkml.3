Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752508Ab3GABNL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Jun 2013 21:13:11 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:40322 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752443Ab3GABM7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Jun 2013 21:12:59 -0400
From: Joe Perches <joe@perches.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 06/12] cdrom: Remove unnecessary sanitize_format prototype
Date: Sun, 30 Jun 2013 18:12:01 -0700
Message-Id: <b8d7af222ac0ee7cb468cd463542b35e4b4685ab.1372640818.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1372640818.git.joe@perches.com>
References: <cover.1372640818.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's defined below without being called.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/cdrom/cdrom.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/cdrom/cdrom.c b/drivers/cdrom/cdrom.c
index 546b97e..70ef0134 100644
--- a/drivers/cdrom/cdrom.c
+++ b/drivers/cdrom/cdrom.c
@@ -337,8 +337,6 @@ do {							\
 #define CDROM_DEF_TIMEOUT	(7 * HZ)
 
 /* Not-exported routines. */
-static void sanitize_format(union cdrom_addr *addr, 
-		u_char * curr, u_char requested);
 static int mmc_ioctl(struct cdrom_device_info *cdi, unsigned int cmd,
 		     unsigned long arg);
 
-- 
1.8.1.2.459.gbcd45b4.dirty

