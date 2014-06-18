Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934224AbaFRIZ1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 04:25:27 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:57418 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933705AbaFRIZY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 04:25:24 -0400
From: Anil Belur <askb23@gmail.com>
X-Google-Original-From: Anil Belur
To: andreas.dilger@intel.com, oleg.drokin@intel.com,
        gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, hpdd-discuss@ml01.01.org,
        Anil Belur <askb23@gmail.com>
Subject: [PATCH v7 8/8] staging: lustre: lclient: lcommon_cl.c fixing coding style issues
Date: Wed, 18 Jun 2014 18:23:56 +1000
Message-Id: <1403079836-9304-9-git-send-email-askb23@gmail.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1403079836-9304-1-git-send-email-askb23@gmail.com>
References: <1403079836-9304-1-git-send-email-askb23@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anil Belur <askb23@gmail.com>

fixed: WARNING: suspect code indent for conditional statements (32, 32)
Signed-off-by: Anil Belur <askb23@gmail.com>
---
 drivers/staging/lustre/lustre/lclient/lcommon_cl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/lustre/lustre/lclient/lcommon_cl.c b/drivers/staging/lustre/lustre/lclient/lcommon_cl.c
index b8552ab..08d6fbd 100644
--- a/drivers/staging/lustre/lustre/lclient/lcommon_cl.c
+++ b/drivers/staging/lustre/lustre/lclient/lcommon_cl.c
@@ -826,7 +826,7 @@ int ccc_prep_size(const struct lu_env *env, struct cl_object *obj,
 
 				if ((size == 0 && cur_index != 0) ||
 				    size_index < cur_index)
-				*exceed = 1;
+					*exceed = 1;
 			}
 			return result;
 		} else {
-- 
1.9.0

