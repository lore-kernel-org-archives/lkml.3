Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752440Ab3GABMx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Jun 2013 21:12:53 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:33356 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752165Ab3GABMv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Jun 2013 21:12:51 -0400
From: Joe Perches <joe@perches.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 05/12] cdrom: Remove unnecessary check_for_audio_disc prototype
Date: Sun, 30 Jun 2013 18:12:00 -0700
Message-Id: <e7dfd01c433470081df5eb59b4837fca6a012bec.1372640818.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1372640818.git.joe@perches.com>
References: <cover.1372640818.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The actual static is defined below it but not used until later.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/cdrom/cdrom.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/cdrom/cdrom.c b/drivers/cdrom/cdrom.c
index 72720d7..546b97e 100644
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

