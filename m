Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933903Ab3BSSul (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 13:50:41 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:54179 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933294Ab3BSSug (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 13:50:36 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Deucher <alexander.deucher@amd.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 11/81] drm/radeon: add WAIT_UNTIL to the non-VM safe regs list for cayman/TN
Date: Tue, 19 Feb 2013 15:48:34 -0300
Message-Id: <1361299784-8830-12-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1361299784-8830-1-git-send-email-herton.krzesinski@canonical.com>
References: <1361299784-8830-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 674a16f2b4724880d07389abbb95abf320b924aa upstream.

Newer versions of mesa emit this.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/gpu/drm/radeon/reg_srcs/cayman |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/radeon/reg_srcs/cayman b/drivers/gpu/drm/radeon/reg_srcs/cayman
index 0f656b1..a072fa8 100644
--- a/drivers/gpu/drm/radeon/reg_srcs/cayman
+++ b/drivers/gpu/drm/radeon/reg_srcs/cayman
@@ -1,5 +1,6 @@
 cayman 0x9400
 0x0000802C GRBM_GFX_INDEX
+0x00008040 WAIT_UNTIL
 0x000084FC CP_STRMOUT_CNTL
 0x000085F0 CP_COHER_CNTL
 0x000085F4 CP_COHER_SIZE
-- 
1.7.9.5

