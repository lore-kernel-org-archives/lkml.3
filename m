Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751335AbaH3G5o (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2014 02:57:44 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:62201 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751045AbaH3G5n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2014 02:57:43 -0400
From: Janet Liu <jianhua.ljh@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Janet Liu <jianhua.ljh@gmail.com>
Subject: [PATCHv1 3/4] staging:lustre:lnet: lib-md.c erase C99 // comments
Date: Sat, 30 Aug 2014 14:57:33 +0800
Message-Id: <1409381853-2362-1-git-send-email-jianhua.ljh@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1409381769-2311-1-git-send-email-jianhua.ljh@gmail.com>
References: <1409381769-2311-1-git-send-email-jianhua.ljh@gmail.com>
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
index 13f4332..c858b59 100644
--- a/drivers/staging/lustre/lnet/lnet/lib-md.c
+++ b/drivers/staging/lustre/lnet/lnet/lib-md.c
@@ -125,7 +125,7 @@ lnet_md_build(lnet_libmd_t *lmd, lnet_md_t *umd, int unlink)
 
 		if ((umd->options & LNET_MD_MAX_SIZE) != 0 && /*max size used*/
 		    (umd->max_size < 0 ||
-		     umd->max_size > total_length)) // illegal max_size
+		     umd->max_size > total_length)) /* illegal max_size */
 			return -EINVAL;
 
 	} else if ((umd->options & LNET_MD_KIOV) != 0) {
@@ -146,7 +146,7 @@ lnet_md_build(lnet_libmd_t *lmd, lnet_md_t *umd, int unlink)
 
 		if ((umd->options & LNET_MD_MAX_SIZE) != 0 && /*max size used*/
 		    (umd->max_size < 0 ||
-		     umd->max_size > total_length)) // illegal max_size
+		     umd->max_size > total_length)) /* illegal max_size */
 			return -EINVAL;
 	} else {   /* contiguous */
 		lmd->md_length = umd->length;
@@ -156,7 +156,7 @@ lnet_md_build(lnet_libmd_t *lmd, lnet_md_t *umd, int unlink)
 
 		if ((umd->options & LNET_MD_MAX_SIZE) != 0 && /*max size used*/
 		    (umd->max_size < 0 ||
-		     umd->max_size > (int)umd->length)) // illegal max_size
+		     umd->max_size > (int)umd->length)) /* illegal max_size */
 			return -EINVAL;
 	}
 
-- 
1.7.9.5

