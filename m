Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754709AbaADHH5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jan 2014 02:07:57 -0500
Received: from mail-pd0-f169.google.com ([209.85.192.169]:57662 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754068AbaADHHj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jan 2014 02:07:39 -0500
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org,
        JC Lafoucriere <jacques-charles.lafoucriere@cea.fr>,
        Henri Doreau <henri.doreau@cea.fr>, Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH v2 7/8] staging/lustre/lustre_user.h: remove obsolete comments
Date: Sat,  4 Jan 2014 15:06:19 +0800
Message-Id: <1388819180-31538-8-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1388819180-31538-7-git-send-email-bergwolf@gmail.com>
References: <1388819180-31538-1-git-send-email-bergwolf@gmail.com>
 <1388819180-31538-2-git-send-email-bergwolf@gmail.com>
 <1388819180-31538-3-git-send-email-bergwolf@gmail.com>
 <1388819180-31538-4-git-send-email-bergwolf@gmail.com>
 <1388819180-31538-5-git-send-email-bergwolf@gmail.com>
 <1388819180-31538-6-git-send-email-bergwolf@gmail.com>
 <1388819180-31538-7-git-send-email-bergwolf@gmail.com>
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
 1 files changed, 0 insertions(+), 6 deletions(-)

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
1.7.7.6

