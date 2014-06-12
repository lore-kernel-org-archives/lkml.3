Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932660AbaFLHOE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 03:14:04 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:45474 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932230AbaFLHOC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 03:14:02 -0400
From: Honggang Li <enjoymindful@gmail.com>
To: gregkh@linuxfoundation.org, oleg.drokin@intel.com, liang.zhen@intel.com,
        a.terekhov@gmail.com, amk@cray.com, devel@driverdev.osuosl.org
Cc: linux-kernel@vger.kernel.org, enjoymindful@gmail.com
Subject: [PATCH 2/2] lustre/osc/osc_dev.c add a blank line after declarations
Date: Thu, 12 Jun 2014 15:13:39 +0800
Message-Id: <1402557219-3784-3-git-send-email-enjoymindful@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1402557219-3784-2-git-send-email-enjoymindful@gmail.com>
References: <1402557219-3784-1-git-send-email-enjoymindful@gmail.com>
 <1402557219-3784-2-git-send-email-enjoymindful@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Honggang Li <enjoymindful@gmail.com>
---
 drivers/staging/lustre/lustre/osc/osc_dev.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/staging/lustre/lustre/osc/osc_dev.c b/drivers/staging/lustre/lustre/osc/osc_dev.c
index 5249e66..048a5a5 100644
--- a/drivers/staging/lustre/lustre/osc/osc_dev.c
+++ b/drivers/staging/lustre/lustre/osc/osc_dev.c
@@ -132,6 +132,7 @@ static void osc_key_fini(const struct lu_context *ctx,
 			 struct lu_context_key *key, void *data)
 {
 	struct osc_thread_info *info = data;
+
 	OBD_SLAB_FREE_PTR(info, osc_thread_kmem);
 }
 
@@ -156,6 +157,7 @@ static void osc_session_fini(const struct lu_context *ctx,
 			     struct lu_context_key *key, void *data)
 {
 	struct osc_session *info = data;
+
 	OBD_SLAB_FREE_PTR(info, osc_session_kmem);
 }
 
-- 
1.8.3.1

