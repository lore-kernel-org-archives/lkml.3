Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751265AbaH3G4c (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2014 02:56:32 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:59401 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751006AbaH3G4b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2014 02:56:31 -0400
From: Janet Liu <jianhua.ljh@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Janet Liu <jianhua.ljh@gmail.com>
Subject: [PATCHv1 2/4] staging:lustre:lnet: lib-md.c delete space before '(' for code style
Date: Sat, 30 Aug 2014 14:56:09 +0800
Message-Id: <1409381769-2311-1-git-send-email-jianhua.ljh@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1409381575-2211-1-git-send-email-jianhua.ljh@gmail.com>
References: <1409381575-2211-1-git-send-email-jianhua.ljh@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Silences the following checkpatch warning:
  WARNING: space prohibited between function name and open parenthesis '('

Signed-off-by: Janet Liu <jianhua.ljh@gmail.com>
---
 drivers/staging/lustre/lnet/lnet/lib-md.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/lustre/lnet/lnet/lib-md.c b/drivers/staging/lustre/lnet/lnet/lib-md.c
index efd1b82..13f4332 100644
--- a/drivers/staging/lustre/lnet/lnet/lib-md.c
+++ b/drivers/staging/lustre/lnet/lnet/lib-md.c
@@ -110,7 +110,7 @@ lnet_md_build(lnet_libmd_t *lmd, lnet_md_t *umd, int unlink)
 
 		lmd->md_niov = niov = umd->length;
 		memcpy(lmd->md_iov.iov, umd->start,
-		       niov * sizeof (lmd->md_iov.iov[0]));
+		       niov * sizeof(lmd->md_iov.iov[0]));
 
 		for (i = 0; i < (int)niov; i++) {
 			/* We take the base address on trust */
@@ -131,7 +131,7 @@ lnet_md_build(lnet_libmd_t *lmd, lnet_md_t *umd, int unlink)
 	} else if ((umd->options & LNET_MD_KIOV) != 0) {
 		lmd->md_niov = niov = umd->length;
 		memcpy(lmd->md_iov.kiov, umd->start,
-		       niov * sizeof (lmd->md_iov.kiov[0]));
+		       niov * sizeof(lmd->md_iov.kiov[0]));
 
 		for (i = 0; i < (int)niov; i++) {
 			/* We take the page pointer on trust */
@@ -266,15 +266,15 @@ int
 LNetMDAttach(lnet_handle_me_t meh, lnet_md_t umd,
 	     lnet_unlink_t unlink, lnet_handle_md_t *handle)
 {
-	LIST_HEAD		(matches);
-	LIST_HEAD		(drops);
+	LIST_HEAD(matches);
+	LIST_HEAD(drops);
 	struct lnet_me		*me;
 	struct lnet_libmd	*md;
 	int			cpt;
 	int			rc;
 
-	LASSERT (the_lnet.ln_init);
-	LASSERT (the_lnet.ln_refcount > 0);
+	LASSERT(the_lnet.ln_init);
+	LASSERT(the_lnet.ln_refcount > 0);
 
 	if (lnet_md_validate(&umd) != 0)
 		return -EINVAL;
@@ -350,8 +350,8 @@ LNetMDBind(lnet_md_t umd, lnet_unlink_t unlink, lnet_handle_md_t *handle)
 	int		cpt;
 	int		rc;
 
-	LASSERT (the_lnet.ln_init);
-	LASSERT (the_lnet.ln_refcount > 0);
+	LASSERT(the_lnet.ln_init);
+	LASSERT(the_lnet.ln_refcount > 0);
 
 	if (lnet_md_validate(&umd) != 0)
 		return -EINVAL;
@@ -419,7 +419,7 @@ EXPORT_SYMBOL(LNetMDBind);
  * \retval -ENOENT If \a mdh does not point to a valid MD object.
  */
 int
-LNetMDUnlink (lnet_handle_md_t mdh)
+LNetMDUnlink(lnet_handle_md_t mdh)
 {
 	lnet_event_t	ev;
 	lnet_libmd_t	*md;
-- 
1.7.9.5

