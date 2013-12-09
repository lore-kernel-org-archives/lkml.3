Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933872Ab3LIPBQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 10:01:16 -0500
Received: from mail-pa0-f48.google.com ([209.85.220.48]:33154 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933827Ab3LIPAl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 10:00:41 -0500
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org,
        JC Lafoucriere <jacques-charles.lafoucriere@cea.fr>,
        Henri Doreau <henri.doreau@cea.fr>, Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 12/13] staging/lustre/lustre_user.h: remove obsolete comments
Date: Mon,  9 Dec 2013 22:57:04 +0800
Message-Id: <1386601025-422-13-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1386601025-422-1-git-send-email-bergwolf@gmail.com>
References: <1386601025-422-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: JC Lafoucriere <jacques-charles.lafoucriere@cea.fr>

This is only part of the original Lustre commit, main part of which changes
user space code. And now the comments above struct hsm_copy is no more true.

Lustre-change: http://review.whamcloud.com/4737
Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-2062
Signed-off-by: JC Lafoucriere <jacques-charles.lafoucriere@cea.fr>
Signed-off-by: Henri Doreau <henri.doreau@cea.fr>
Reviewed-by: John L. Hammond <john.hammond@intel.com>
Reviewed-by: Andreas Dilger <andreas.dilger@intel.com>
Signed-off-by: Peng Tao <bergwolf@gmail.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 .../lustre/lustre/include/lustre/lustre_user.h     |    6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/staging/lustre/lustre/include/lustre/lustre_user.h b/drivers/staging/lustre/lustre/include/lustre/lustre_user.h
index 6b6c0240..4d3c25f 100644
--- a/drivers/staging/lustre/lustre/include/lustre/lustre_user.h
+++ b/drivers/staging/lustre/lustre/include/lustre/lustre_user.h
@@ -1158,12 +1158,6 @@ struct hsm_progress {
 	__u32			padding;
 };
 
-/**
- * Use by copytool during any hsm request they handled.
- * This structure is initialized by llapi_hsm_copy_start()
- * which is an helper over the ioctl() interface
- * Store Lustre, internal use only, data.
- */
 struct hsm_copy {
 	__u64			hc_data_version;
 	__u16			hc_flags;
-- 
1.7.9.5

