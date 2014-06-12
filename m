Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932622AbaFLHN6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 03:13:58 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:61673 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932371AbaFLHN5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 03:13:57 -0400
From: Honggang Li <enjoymindful@gmail.com>
To: gregkh@linuxfoundation.org, oleg.drokin@intel.com, liang.zhen@intel.com,
        a.terekhov@gmail.com, amk@cray.com, devel@driverdev.osuosl.org
Cc: linux-kernel@vger.kernel.org, enjoymindful@gmail.com
Subject: [PATCH 1/2] lustre/osc/osc_dev.c remove space between sizeof and open parenthesis
Date: Thu, 12 Jun 2014 15:13:38 +0800
Message-Id: <1402557219-3784-2-git-send-email-enjoymindful@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1402557219-3784-1-git-send-email-enjoymindful@gmail.com>
References: <1402557219-3784-1-git-send-email-enjoymindful@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Honggang Li <enjoymindful@gmail.com>
---
 drivers/staging/lustre/lustre/osc/osc_dev.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/lustre/lustre/osc/osc_dev.c b/drivers/staging/lustre/lustre/osc/osc_dev.c
index a7c1ec0..5249e66 100644
--- a/drivers/staging/lustre/lustre/osc/osc_dev.c
+++ b/drivers/staging/lustre/lustre/osc/osc_dev.c
@@ -61,32 +61,32 @@ struct lu_kmem_descr osc_caches[] = {
 	{
 		.ckd_cache = &osc_lock_kmem,
 		.ckd_name  = "osc_lock_kmem",
-		.ckd_size  = sizeof (struct osc_lock)
+		.ckd_size  = sizeof(struct osc_lock)
 	},
 	{
 		.ckd_cache = &osc_object_kmem,
 		.ckd_name  = "osc_object_kmem",
-		.ckd_size  = sizeof (struct osc_object)
+		.ckd_size  = sizeof(struct osc_object)
 	},
 	{
 		.ckd_cache = &osc_thread_kmem,
 		.ckd_name  = "osc_thread_kmem",
-		.ckd_size  = sizeof (struct osc_thread_info)
+		.ckd_size  = sizeof(struct osc_thread_info)
 	},
 	{
 		.ckd_cache = &osc_session_kmem,
 		.ckd_name  = "osc_session_kmem",
-		.ckd_size  = sizeof (struct osc_session)
+		.ckd_size  = sizeof(struct osc_session)
 	},
 	{
 		.ckd_cache = &osc_req_kmem,
 		.ckd_name  = "osc_req_kmem",
-		.ckd_size  = sizeof (struct osc_req)
+		.ckd_size  = sizeof(struct osc_req)
 	},
 	{
 		.ckd_cache = &osc_extent_kmem,
 		.ckd_name  = "osc_extent_kmem",
-		.ckd_size  = sizeof (struct osc_extent)
+		.ckd_size  = sizeof(struct osc_extent)
 	},
 	{
 		.ckd_cache = &osc_quota_kmem,
-- 
1.8.3.1

