Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753621Ab3G1NsN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jul 2013 09:48:13 -0400
Received: from mail-ea0-f174.google.com ([209.85.215.174]:33221 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753078Ab3G1NsM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jul 2013 09:48:12 -0400
From: abbasjasim <abbasjasim.aj@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        abbasjasim <abbasjasim.AJ@gmail.com>
Subject: [PATCH] staging: android: logger..c fixed a brace coding style issue
Date: Sun, 28 Jul 2013 16:47:51 +0300
Message-Id: <1375019271-10084-1-git-send-email-abbasjasim.AJ@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fixed a coding style issue.

Signed-off-by: Abbas J. Mohammed <abbasjasim.AJ@gmail.com>
---
 drivers/staging/android/logger.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/android/logger.c b/drivers/staging/android/logger.c
index ffc2d04..3d5180a 100644
--- a/drivers/staging/android/logger.c
+++ b/drivers/staging/android/logger.c
@@ -81,8 +81,9 @@ static inline struct logger_log *file_get_log(struct file *file)
 	if (file->f_mode & FMODE_READ) {
 		struct logger_reader *reader = file->private_data;
 		return reader->log;
-	} else
+	} else {
 		return file->private_data;
+	}
 }
 
 /*
-- 
1.8.1.2

