Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751910Ab3HTQRl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 12:17:41 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:61007 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751255Ab3HTQRj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 12:17:39 -0400
Subject: [PATCH v3 trivial 6/7] DRM: comment: `gdm_proc_lists' -> `drm_info_lists'
Date: Tue, 20 Aug 2013 16:05:24 -0000
From: Michael Witten <mfwitten@gmail.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: Rob Landley <rob@landley.net>, Randy Dunlap <rdunlap@infradead.org>,
        David Airlie <airlied@linux.ie>, linux-kernel@vger.kernel.org
Message-ID: <027c085f41de46a185246b334f311ea7-mfwitten@gmail.com>
In-Reply-To: <4cd8ab80726c43cf90243970c20f50ef-mfwitten@gmail.com>
References: <4cd8ab80726c43cf90243970c20f50ef-mfwitten@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Date: Thu, 15 Sep 2011 14:43:00 +0000

I assume `gdm_proc_lists' is a vestigial spelling.

Signed-off-by: Michael Witten <mfwitten@gmail.com>
---
 drivers/gpu/drm/drm_proc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/drm_proc.c b/drivers/gpu/drm/drm_proc.c
index d7f2324..dfc6f1f 100644
--- a/drivers/gpu/drm/drm_proc.c
+++ b/drivers/gpu/drm/drm_proc.c
@@ -87,7 +87,7 @@ static const struct file_operations drm_proc_fops = {
  * \return Zero on success, non-zero on failure
  *
  * Create a given set of proc files represented by an array of
- * gdm_proc_lists in the given root directory.
+ * drm_info_lists in the given root directory.
  */
 static int drm_proc_create_files(const struct drm_info_list *files, int count,
 			  struct proc_dir_entry *root, struct drm_minor *minor)
-- 
1.7.11.2.252.gc4a64c8

