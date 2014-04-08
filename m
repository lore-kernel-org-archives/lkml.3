Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756990AbaDHQcw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 12:32:52 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:32922 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756783AbaDHQct (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 12:32:49 -0400
From: Paul McQuade <paulmcquad@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] Staging:keucr:scsiglue.c-no semicolon terminated
Date: Tue,  8 Apr 2014 17:32:45 +0100
Message-Id: <1396974765-30902-1-git-send-email-paulmcquad@gmail.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

WARNING: do {} while (0) macros should not be semicolon terminated

Signed-off-by: Paul McQuade <paulmcquad@gmail.com>
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

