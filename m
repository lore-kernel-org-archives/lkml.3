Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755880AbaFQFsk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 01:48:40 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:35362 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755815AbaFQFsh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 01:48:37 -0400
From: Anil Belur <askb23@gmail.com>
X-Google-Original-From: Anil Belur
To: andreas.dilger@intel.com, oleg.drokin@intel.com,
        gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, hpdd-discuss@ml01.01.org,
        Anil Belur <askb23@gmail.com>
Subject: [PATCH v6 8/8] staging: lustre: lclient: lcommon_cl.c fixing coding style issues
Date: Tue, 17 Jun 2014 15:43:59 +1000
Message-Id: <1402983839-3549-9-git-send-email-askb23@gmail.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1402983839-3549-1-git-send-email-askb23@gmail.com>
References: <1402983839-3549-1-git-send-email-askb23@gmail.com>
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
index e2da397..3b2b995 100644
--- a/drivers/staging/lustre/lustre/lclient/lcommon_cl.c
+++ b/drivers/staging/lustre/lustre/lclient/lcommon_cl.c
@@ -825,8 +825,8 @@ int ccc_prep_size(const struct lu_env *env, struct cl_object *obj,
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

