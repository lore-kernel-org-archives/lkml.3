Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753547AbbAEOtX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 09:49:23 -0500
Received: from mail-wg0-f53.google.com ([74.125.82.53]:63846 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790AbbAEOtW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 09:49:22 -0500
From: Guillaume Vercoutere <gvercoutere@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        gvercoutere@gmail.com
Subject: [PATCH 3/3] staging: android: struct sizeof coding style in logger.c
Date: Mon,  5 Jan 2015 15:25:37 +0100
Message-Id: <1420467937-6435-1-git-send-email-gvercoutere@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace sizeof struct

Signed-off-by: Guillaume Vercoutere <gvercoutere@gmail.com>
---
 drivers/staging/android/logger.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/android/logger.c b/drivers/staging/android/logger.c
index 72b804e..7e0eab2 100644
--- a/drivers/staging/android/logger.c
+++ b/drivers/staging/android/logger.c
@@ -512,7 +512,7 @@ static int logger_open(struct inode *inode, struct file *file)
 	if (file->f_mode & FMODE_READ) {
 		struct logger_reader *reader;
 
-		reader = kmalloc(sizeof(struct logger_reader), GFP_KERNEL);
+		reader = kmalloc(sizeof(*reader), GFP_KERNEL);
 		if (!reader)
 			return -ENOMEM;
 
@@ -710,7 +710,7 @@ static int __init create_log(char *log_name, int size)
 	if (!buffer)
 		return -ENOMEM;
 
-	log = kzalloc(sizeof(struct logger_log), GFP_KERNEL);
+	log = kzalloc(sizeof(*log), GFP_KERNEL);
 	if (!log) {
 		ret = -ENOMEM;
 		goto out_free_buffer;
-- 
1.7.10.4

