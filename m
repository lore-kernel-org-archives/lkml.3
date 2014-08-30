Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751384AbaH3G7U (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2014 02:59:20 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:44299 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751045AbaH3G7T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2014 02:59:19 -0400
From: Janet Liu <jianhua.ljh@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Janet Liu <jianhua.ljh@gmail.com>
Subject: [PATCHv1 4/4] staging:lustre:lnet lib-md.c erase space before ')' for code style
Date: Sat, 30 Aug 2014 14:59:04 +0800
Message-Id: <1409381944-2430-1-git-send-email-jianhua.ljh@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1409381853-2362-1-git-send-email-jianhua.ljh@gmail.com>
References: <1409381853-2362-1-git-send-email-jianhua.ljh@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Silences the following error:
  ERROR: space prohibited before that close parenthesis ')'

Signed-off-by: Janet Liu <jianhua.ljh@gmail.com>
---
 drivers/staging/lustre/lnet/lnet/lib-md.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/lustre/lnet/lnet/lib-md.c b/drivers/staging/lustre/lnet/lnet/lib-md.c
index c858b59..782b01c 100644
--- a/drivers/staging/lustre/lnet/lnet/lib-md.c
+++ b/drivers/staging/lustre/lnet/lnet/lib-md.c
@@ -136,7 +136,7 @@ lnet_md_build(lnet_libmd_t *lmd, lnet_md_t *umd, int unlink)
 		for (i = 0; i < (int)niov; i++) {
 			/* We take the page pointer on trust */
 			if (lmd->md_iov.kiov[i].kiov_offset +
-			    lmd->md_iov.kiov[i].kiov_len > PAGE_CACHE_SIZE )
+			    lmd->md_iov.kiov[i].kiov_len > PAGE_CACHE_SIZE)
 				return -EINVAL; /* invalid length */
 
 			total_length += lmd->md_iov.kiov[i].kiov_len;
-- 
1.7.9.5

