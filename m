Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934185AbaFRIZN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 04:25:13 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:45124 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933705AbaFRIZL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 04:25:11 -0400
From: Anil Belur <askb23@gmail.com>
X-Google-Original-From: Anil Belur
To: andreas.dilger@intel.com, oleg.drokin@intel.com,
        gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, hpdd-discuss@ml01.01.org,
        Anil Belur <askb23@gmail.com>
Subject: [PATCH v7 6/8] staging: lustre: lclient: lcommon_cl.c fixing coding style issues
Date: Wed, 18 Jun 2014 18:23:54 +1000
Message-Id: <1403079836-9304-7-git-send-email-askb23@gmail.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1403079836-9304-1-git-send-email-askb23@gmail.com>
References: <1403079836-9304-1-git-send-email-askb23@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anil Belur <askb23@gmail.com>

fixed: ERROR: inline keyword should sit between storage class and type
Signed-off-by: Anil Belur <askb23@gmail.com>
---
 drivers/staging/lustre/lustre/lclient/lcommon_cl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/lustre/lustre/lclient/lcommon_cl.c b/drivers/staging/lustre/lustre/lclient/lcommon_cl.c
index de0ad37e..2f51b76 100644
--- a/drivers/staging/lustre/lustre/lclient/lcommon_cl.c
+++ b/drivers/staging/lustre/lustre/lclient/lcommon_cl.c
@@ -1273,7 +1273,7 @@ struct lov_stripe_md *ccc_inode_lsm_get(struct inode *inode)
 	return lov_lsm_get(cl_i2info(inode)->lli_clob);
 }
 
-void inline ccc_inode_lsm_put(struct inode *inode, struct lov_stripe_md *lsm)
+inline void ccc_inode_lsm_put(struct inode *inode, struct lov_stripe_md *lsm)
 {
 	lov_lsm_put(cl_i2info(inode)->lli_clob, lsm);
 }
-- 
1.9.0

