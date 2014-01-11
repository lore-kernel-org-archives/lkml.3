Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753254AbaAKLrc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jan 2014 06:47:32 -0500
Received: from mail-pd0-f172.google.com ([209.85.192.172]:64663 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752688AbaAKLra (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jan 2014 06:47:30 -0500
From: Monam Agarwal <monamagarwal123@gmail.com>
To: gregkh@linuxfoundation.org, monamagarwal123@gmail.com,
        andreas.dilger@intel.com, peter.p.waskiewicz.jr@intel.com,
        tao.peng@emc.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] Staging: lustre : Fix trailing statements should be on next line
Date: Sat, 11 Jan 2014 17:17:15 +0530
Message-Id: <1389440835-6962-1-git-send-email-monamagarwal123@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch fixes the following checkpatch.pl error in
lustre/ldlm/ldlm_extent.c
ERROR: trailing statements should be on next line

Signed-off-by: Monam Agarwal <monamagarwal123@gmail.com>
---
 drivers/staging/lustre/lustre/ldlm/ldlm_extent.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/lustre/lustre/ldlm/ldlm_extent.c b/drivers/staging/lustre/lustre/ldlm/ldlm_extent.c
index 374d6e4..8727057 100644
--- a/drivers/staging/lustre/lustre/ldlm/ldlm_extent.c
+++ b/drivers/staging/lustre/lustre/ldlm/ldlm_extent.c
@@ -153,7 +153,8 @@ static inline int lock_mode_to_index(ldlm_mode_t mode)
 
 	LASSERT(mode != 0);
 	LASSERT(IS_PO2(mode));
-	for (index = -1; mode; index++, mode >>= 1);
+	for (index = -1; mode; index++, mode >>= 1)
+		;
 	LASSERT(index < LCK_MODE_NUM);
 	return index;
 }
-- 
1.7.9.5

