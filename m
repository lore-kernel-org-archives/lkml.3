Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934160AbaFRIZK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 04:25:10 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:52125 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933705AbaFRIZD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 04:25:03 -0400
From: Anil Belur <askb23@gmail.com>
X-Google-Original-From: Anil Belur
To: andreas.dilger@intel.com, oleg.drokin@intel.com,
        gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, hpdd-discuss@ml01.01.org,
        Anil Belur <askb23@gmail.com>
Subject: [PATCH v7 5/8] staging: lustre: lclient: lcommon_cl.c fixing coding style issues
Date: Wed, 18 Jun 2014 18:23:53 +1000
Message-Id: <1403079836-9304-6-git-send-email-askb23@gmail.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1403079836-9304-1-git-send-email-askb23@gmail.com>
References: <1403079836-9304-1-git-send-email-askb23@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anil Belur <askb23@gmail.com>

fixed:  ERROR: do not initialise statics to 0 or NULL
Signed-off-by: Anil Belur <askb23@gmail.com>
---
 drivers/staging/lustre/lustre/lclient/lcommon_cl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/lustre/lustre/lclient/lcommon_cl.c b/drivers/staging/lustre/lustre/lclient/lcommon_cl.c
index 1f39219..de0ad37e 100644
--- a/drivers/staging/lustre/lustre/lclient/lcommon_cl.c
+++ b/drivers/staging/lustre/lustre/lclient/lcommon_cl.c
@@ -266,7 +266,7 @@ int ccc_req_init(const struct lu_env *env, struct cl_device *dev,
  * fails. Access to this environment is serialized by ccc_inode_fini_guard
  * mutex.
  */
-static struct lu_env *ccc_inode_fini_env = NULL;
+static struct lu_env *ccc_inode_fini_env;
 
 /**
  * A mutex serializing calls to slp_inode_fini() under extreme memory
-- 
1.9.0

