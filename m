Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751237AbaHaE4j (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2014 00:56:39 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:61584 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750732AbaHaE4i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2014 00:56:38 -0400
From: Janet Liu <jianhua.ljh@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Janet Liu <jianhua.ljh@gmail.com>
Subject: [PATCHv2 3/4] staging:lustre:lnet: lib-md.c erase C99 // comments
Date: Sun, 31 Aug 2014 12:56:20 +0800
Message-Id: <1409460980-4898-1-git-send-email-jianhua.ljh@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1409460907-4859-1-git-send-email-jianhua.ljh@gmail.com>
References: <1409460907-4859-1-git-send-email-jianhua.ljh@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After changing the comments format, the other error disappears.
So silences two checkpatch errors:
  ERROR: do not use C99 // comments
  ERROR: trailing statements should be on next line

Signed-off-by: Janet Liu <jianhua.ljh@gmail.com>
---
 drivers/staging/lustre/lnet/lnet/lib-md.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/lustre/lnet/lnet/lib-md.c b/drivers/staging/lustre/lnet/lnet/lib-md.c
index ca08703..5b9c93a 100644
--- a/drivers/staging/lustre/lnet/lnet/lib-md.c
+++ b/drivers/staging/lustre/lnet/lnet/lib-md.c
@@ -125,7 +125,7 @@ lnet_md_build(lnet_libmd_t *lmd, lnet_md_t *umd, int unlink)
 
 		if ((umd->options & LNET_MD_MAX_SIZE) != 0 && /* max size used */
 		    (umd->max_size < 0 ||
-		     umd->max_size > total_length)) // illegal max_size
+		     umd->max_size > total_length)) /* illegal max_size */
 			return -EINVAL;
 
 	} else if ((umd->options & LNET_MD_KIOV) != 0) {
@@ -146,7 +146,7 @@ lnet_md_build(lnet_libmd_t *lmd, lnet_md_t *umd, int unlink)
 
 		if ((umd->options & LNET_MD_MAX_SIZE) != 0 && /* max size used */
 		    (umd->max_size < 0 ||
-		     umd->max_size > total_length)) // illegal max_size
+		     umd->max_size > total_length)) /* illegal max_size */
 			return -EINVAL;
 	} else {   /* contiguous */
 		lmd->md_length = umd->length;
@@ -156,7 +156,7 @@ lnet_md_build(lnet_libmd_t *lmd, lnet_md_t *umd, int unlink)
 
 		if ((umd->options & LNET_MD_MAX_SIZE) != 0 && /* max size used */
 		    (umd->max_size < 0 ||
-		     umd->max_size > (int)umd->length)) // illegal max_size
+		     umd->max_size > (int)umd->length)) /* illegal max_size */
 			return -EINVAL;
 	}
 
-- 
1.7.9.5

