Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754096Ab3LCOE2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 09:04:28 -0500
Received: from mail-pb0-f48.google.com ([209.85.160.48]:41098 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753917Ab3LCOEY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 09:04:24 -0500
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org,
        JC Lafoucriere <jacques-charles.lafoucriere@cea.fr>,
        Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH v3 04/15] staging/lustre: make obd_uuid_equals return bool
Date: Tue,  3 Dec 2013 21:58:42 +0800
Message-Id: <1386079133-6459-5-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1386079133-6459-1-git-send-email-bergwolf@gmail.com>
References: <1386079133-6459-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: JC Lafoucriere <jacques-charles.lafoucriere@cea.fr>

This is only part of the original Lustre tree commit.
Main part of the original commit changes server code and is
unneeded at client side.

Lustre-change: http://review.whamcloud.com/6534
Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-3342
Signed-off-by: JC Lafoucriere <jacques-charles.lafoucriere@cea.fr>
Reviewed-by: Jinshan Xiong <jinshan.xiong@intel.com>
Reviewed-by: Andreas Dilger <andreas.dilger@intel.com>
Reviewed-by: John L. Hammond <john.hammond@intel.com>
Reviewed-by: Oleg Drokin <oleg.drokin@intel.com>
Signed-off-by: Peng Tao <bergwolf@gmail.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 .../lustre/lustre/include/lustre/lustre_user.h     |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/lustre/lustre/include/lustre/lustre_user.h b/drivers/staging/lustre/lustre/include/lustre/lustre_user.h
index ff825d8..631f026 100644
--- a/drivers/staging/lustre/lustre/include/lustre/lustre_user.h
+++ b/drivers/staging/lustre/lustre/include/lustre/lustre_user.h
@@ -428,8 +428,8 @@ struct obd_uuid {
 	char uuid[UUID_MAX];
 };
 
-static inline int obd_uuid_equals(const struct obd_uuid *u1,
-				  const struct obd_uuid *u2)
+static inline bool obd_uuid_equals(const struct obd_uuid *u1,
+				   const struct obd_uuid *u2)
 {
 	return strcmp((char *)u1->uuid, (char *)u2->uuid) == 0;
 }
-- 
1.7.9.5

