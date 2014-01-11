Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753120AbaAKLpD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jan 2014 06:45:03 -0500
Received: from mail-pb0-f45.google.com ([209.85.160.45]:39871 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753028AbaAKLov (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jan 2014 06:44:51 -0500
From: Monam Agarwal <monamagarwal123@gmail.com>
To: gregkh@linuxfoundation.org, monamagarwal123@gmail.com,
        andreas.dilger@intel.com, peter.p.waskiewicz.jr@intel.com,
        tao.peng@emc.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] Staging: lustre: Removal of Unnecessary white spaces
Date: Sat, 11 Jan 2014 17:11:06 +0530
Message-Id: <1389440466-6895-1-git-send-email-monamagarwal123@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes the following checkpatch.pl warning in
lustre/ldlm/ldlm_extent.c
WARNING: unnecessary whitespace before a quoted newline

Signed-off-by: Monam Agarwal <monamagarwal123@gmail.com>
---
 drivers/staging/lustre/lustre/ldlm/ldlm_extent.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/lustre/lustre/ldlm/ldlm_extent.c b/drivers/staging/lustre/lustre/ldlm/ldlm_extent.c
index ac5d66a..374d6e4 100644
--- a/drivers/staging/lustre/lustre/ldlm/ldlm_extent.c
+++ b/drivers/staging/lustre/lustre/ldlm/ldlm_extent.c
@@ -153,7 +153,7 @@ static inline int lock_mode_to_index(ldlm_mode_t mode)
 
 	LASSERT(mode != 0);
 	LASSERT(IS_PO2(mode));
-	for (index = -1; mode; index++, mode >>= 1) ;
+	for (index = -1; mode; index++, mode >>= 1);
 	LASSERT(index < LCK_MODE_NUM);
 	return index;
 }
-- 
1.7.9.5

