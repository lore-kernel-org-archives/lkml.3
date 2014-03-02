Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752081AbaCBMvt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2014 07:51:49 -0500
Received: from mail-pd0-f182.google.com ([209.85.192.182]:40488 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751779AbaCBMvs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2014 07:51:48 -0500
From: Keerthimai Janarthanan <keerthimaipb@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Keerthimai Janarthanan <keerthimaipb@gmail.com>
Subject: [PATCH 2/2] staging :keucr:scsiglue.c : fixed a macros should not be colon terminated issue
Date: Sun,  2 Mar 2014 18:21:16 +0530
Message-Id: <1393764677-4709-1-git-send-email-keerthimaipb@gmail.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fixed a coding style issue.

Signed-off-by: Keerthimai Janarthanan <keerthimaipb@gmail.com>
---
 drivers/staging/keucr/scsiglue.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/keucr/scsiglue.c b/drivers/staging/keucr/scsiglue.c
index ac3d34d..fce19a4 100644
--- a/drivers/staging/keucr/scsiglue.c
+++ b/drivers/staging/keucr/scsiglue.c
@@ -277,7 +277,7 @@ static int show_info(struct seq_file *m, struct Scsi_Host *host)
 	do { \
 		if (us->fflags & value) \
 			SPRINTF(" " #name); \
-	} while (0);
+	} while (0)
 US_DO_ALL_FLAGS
 #undef US_FLAG
 	seq_putc(m, '\n');
-- 
1.8.3.2

