Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757261Ab3LERgg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 12:36:36 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:38083 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757235Ab3LERge (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 12:36:34 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Deucher <alexander.deucher@amd.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 10/90] drm/radeon/si: fix define for MC_SEQ_TRAIN_WAKEUP_CNTL
Date: Thu,  5 Dec 2013 17:34:52 +0000
Message-Id: <1386264972-5399-11-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386264972-5399-1-git-send-email-luis.henriques@canonical.com>
References: <1386264972-5399-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.27 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit d5693761b2b4ff530c8af8af9ec55b6eae76e617 upstream.

Typo in the register offset.

Noticed-by: Sylvain BERTRAND <sylware@legeek.net>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
[ luis: backported to 3.5: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/radeon/sid.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/radeon/sid.h b/drivers/gpu/drm/radeon/sid.h
index 0a240fa..cc94c77 100644
--- a/drivers/gpu/drm/radeon/sid.h
+++ b/drivers/gpu/drm/radeon/sid.h
@@ -184,7 +184,7 @@
 #define		NOOFGROUPS_SHIFT				12
 #define		NOOFGROUPS_MASK					0x00001000
 
-#define	MC_SEQ_TRAIN_WAKEUP_CNTL			0x2808
+#define	MC_SEQ_TRAIN_WAKEUP_CNTL			0x28e8
 #define		TRAIN_DONE_D0      			(1 << 30)
 #define		TRAIN_DONE_D1      			(1 << 31)
 
-- 
1.8.3.2

