Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753273AbaFPE3j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 00:29:39 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:48306 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752941AbaFPE3V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 00:29:21 -0400
From: Anil Belur <askb23@gmail.com>
X-Google-Original-From: Anil Belur
To: andreas.dilger@intel.com, oleg.drokin@intel.com,
        gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, hpdd-discuss@ml01.01.org,
        Anil Belur <askb23@gmail.com>
Subject: [PATCH v3 5/7] staging: lustre: lclient: lcommon_cl.c fixing coding style issues
Date: Mon, 16 Jun 2014 14:28:34 +1000
Message-Id: <1402892916-5298-5-git-send-email-askb23@gmail.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1402892916-5298-1-git-send-email-askb23@gmail.com>
References: <1402892916-5298-1-git-send-email-askb23@gmail.com>
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
index f83e6f2..7be0a93 100644
--- a/drivers/staging/lustre/lustre/lclient/lcommon_cl.c
+++ b/drivers/staging/lustre/lustre/lclient/lcommon_cl.c
@@ -267,7 +267,7 @@ int ccc_req_init(const struct lu_env *env, struct cl_device *dev,
  * fails. Access to this environment is serialized by ccc_inode_fini_guard
  * mutex.
  */
-static struct lu_env *ccc_inode_fini_env = NULL;
+static struct lu_env *ccc_inode_fini_env;
 
 /**
  * A mutex serializing calls to slp_inode_fini() under extreme memory
-- 
1.9.0

