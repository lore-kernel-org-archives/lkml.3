Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161573Ab3LFXsG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 18:48:06 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:48420 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161367Ab3LFXMi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 18:12:38 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Deucher <alexander.deucher@amd.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 043/152] drm/radeon/si: fix define for MC_SEQ_TRAIN_WAKEUP_CNTL
Date: Fri,  6 Dec 2013 15:09:27 -0800
Message-Id: <1386371476-2477-44-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386371476-2477-1-git-send-email-kamal@canonical.com>
References: <1386371476-2477-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.14 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit d5693761b2b4ff530c8af8af9ec55b6eae76e617 upstream.

Typo in the register offset.

Noticed-by: Sylvain BERTRAND <sylware@legeek.net>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/radeon/sid.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/radeon/sid.h b/drivers/gpu/drm/radeon/sid.h
index 4767968..c394695 100644
--- a/drivers/gpu/drm/radeon/sid.h
+++ b/drivers/gpu/drm/radeon/sid.h
@@ -200,7 +200,7 @@
 #define		NOOFGROUPS_SHIFT				12
 #define		NOOFGROUPS_MASK					0x00001000
 
-#define	MC_SEQ_TRAIN_WAKEUP_CNTL			0x2808
+#define	MC_SEQ_TRAIN_WAKEUP_CNTL			0x28e8
 #define		TRAIN_DONE_D0      			(1 << 30)
 #define		TRAIN_DONE_D1      			(1 << 31)
 
-- 
1.8.3.2

