Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932157AbaFPQXe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 12:23:34 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:52538 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755080AbaFPQXc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 12:23:32 -0400
From: Anil Belur <askb23@gmail.com>
X-Google-Original-From: Anil Belur
To: andreas.dilger@intel.com, oleg.drokin@intel.com, tao.peng@emc.com,
        gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, hpdd-discuss@ml01.01.org,
        Anil Belur <askb23@gmail.com>
Subject: [PATCH v5 8/8] staging: lustre: lclient: lcommon_cl.c fixing coding style issues
Date: Tue, 17 Jun 2014 02:22:22 +1000
Message-Id: <1402935742-18788-9-git-send-email-askb23@gmail.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1402935742-18788-1-git-send-email-askb23@gmail.com>
References: <1402935742-18788-1-git-send-email-askb23@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anil Belur <askb23@gmail.com>

fixed: WARNING: suspect code indent for conditional statements (32, 32)
Signed-off-by: Anil Belur <askb23@gmail.com>
---
 drivers/staging/lustre/lustre/lclient/lcommon_cl.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/lustre/lustre/lclient/lcommon_cl.c b/drivers/staging/lustre/lustre/lclient/lcommon_cl.c
index 6c5b828..1bf6404 100644
--- a/drivers/staging/lustre/lustre/lclient/lcommon_cl.c
+++ b/drivers/staging/lustre/lustre/lclient/lcommon_cl.c
@@ -868,8 +868,8 @@ int ccc_prep_size(const struct lu_env *env, struct cl_object *obj,
 				loff_t size_index = ((size - 1) >> PAGE_CACHE_SHIFT);
 
 				if ((size == 0 && cur_index != 0) ||
-				    (size_index < cur_index))
-				*exceed = 1;
+						(size_index < cur_index))
+					*exceed = 1;
 			}
 			return result;
 		} else {
-- 
1.9.0

