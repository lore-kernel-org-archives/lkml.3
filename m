Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753372AbaFXWJP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 18:09:15 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:64184 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211AbaFXWJO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 18:09:14 -0400
From: Jerry Stralko <gerb.stralko@gmail.com>
To: greg@kroah.com, linux-kernel@vger.kernel.org
Cc: swetland@google.com, Jerry Stralko <gerb.stralko@gmail.com>
Subject: [PATCH] stagging: android: logger: code cleanup
Date: Tue, 24 Jun 2014 18:09:03 -0400
Message-Id: <1403647743-3955-1-git-send-email-gerb.stralko@gmail.com>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 drivers/staging/android/logger.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/android/logger.c b/drivers/staging/android/logger.c
index 2772e01..9b47e66 100644
--- a/drivers/staging/android/logger.c
+++ b/drivers/staging/android/logger.c
@@ -110,8 +110,8 @@ static inline struct logger_log *file_get_log(struct file *file)
 		struct logger_reader *reader = file->private_data;
 
 		return reader->log;
-	} else
-		return file->private_data;
+	}
+	return file->private_data;
 }
 
 /*
@@ -159,8 +159,7 @@ static size_t get_user_hdr_len(int ver)
 {
 	if (ver < 2)
 		return sizeof(struct user_logger_entry_compat);
-	else
-		return sizeof(struct logger_entry);
+	return sizeof(struct logger_entry);
 }
 
 static ssize_t copy_header_to_user(int ver, struct logger_entry *entry,
-- 
1.9.3

