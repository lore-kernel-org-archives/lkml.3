Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752719AbaIYXJO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 19:09:14 -0400
Received: from rgout0404.bt.lon5.cpcloud.co.uk ([65.20.0.217]:64914 "EHLO
	rgout0404.bt.lon5.cpcloud.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751708AbaIYXJM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 19:09:12 -0400
X-CTCH-RefID: str=0001.0A090206.5424A08F.0092,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-Junkmail-Premium-Raw: score=28/50,refid=2.7.2:2014.9.22.181221:17:28.905,ip=31.50.239.172,rules=__HAS_FROM,
 __PHISH_FROM2, __FRAUD_WEBMAIL_FROM, __TO_MALFORMED_2, __TO_NO_NAME,
 __MULTIPLE_RCPTS_CC_X2, __SUBJ_ALPHA_END, __HAS_MSGID, __SANE_MSGID,
 __HAS_X_MAILER, __ANY_URI, __FRAUD_BODY_WEBMAIL, __URI_NO_WWW, __URI_NO_PATH,
 BODYTEXTP_SIZE_3000_LESS, BODY_SIZE_800_899, __MIME_TEXT_ONLY,
 RDNS_GENERIC_POOLED, __URI_NS, SXL_IP_DYNAMIC[172.239.50.31.fur], HTML_00_01,
 HTML_00_10, BODY_SIZE_5000_LESS, RDNS_SUSP_GENERIC, __PHISH_FROM,
 MULTIPLE_RCPTS, __PHISH_SPEAR_STRUCTURE_1, BODY_SIZE_1000_LESS, RDNS_SUSP,
 BODY_SIZE_2000_LESS, __FRAUD_WEBMAIL, BODY_SIZE_7000_LESS
X-CTCH-Spam: Unknown
From: Mike Roocroft <mike.linux@btinternet.com>
To: gregkh@linuxfoundation.org
Cc: swetland@google.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Mike Roocroft <mike.linux@btinternet.com>
Subject: [PATCH 2/2] Staging: android: sw_sync: fixed a coding style issues
Date: Fri, 26 Sep 2014 00:11:56 +0100
Message-Id: <1411686716-2663-1-git-send-email-mike.linux@btinternet.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mike Roocroft <mike.linux@btinternet.com>
---
 drivers/staging/android/sw_sync.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/staging/android/sw_sync.c b/drivers/staging/android/sw_sync.c
index a76db3f..863d4b1 100644
--- a/drivers/staging/android/sw_sync.c
+++ b/drivers/staging/android/sw_sync.c
@@ -97,6 +97,7 @@ static void sw_sync_pt_value_str(struct sync_pt *sync_pt,
 				       char *str, int size)
 {
 	struct sw_sync_pt *pt = (struct sw_sync_pt *)sync_pt;
+
 	snprintf(str, size, "%d", pt->value);
 }
 
@@ -156,6 +157,7 @@ static int sw_sync_open(struct inode *inode, struct file *file)
 static int sw_sync_release(struct inode *inode, struct file *file)
 {
 	struct sw_sync_timeline *obj = file->private_data;
+
 	sync_timeline_destroy(&obj->obj);
 	return 0;
 }
-- 
2.1.0

