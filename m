Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933127AbaHHUyA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 16:54:00 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41369 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758013AbaHHUxx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 16:53:53 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Deucher <alexander.deucher@amd.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 094/259] drm/radeon: fix typo in golden register setup on evergreen
Date: Fri,  8 Aug 2014 13:38:37 -0700
Message-Id: <1407530482-4483-95-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1407530482-4483-1-git-send-email-kamal@canonical.com>
References: <1407530482-4483-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 6abafb78f9881b4891baf74ab4e9f090ae45230e upstream.

Fixes hangs on driver load on some cards.

bug:
https://bugs.freedesktop.org/show_bug.cgi?id=76998

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/radeon/evergreen.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/radeon/evergreen.c b/drivers/gpu/drm/radeon/evergreen.c
index 4c84deb..47463d8 100644
--- a/drivers/gpu/drm/radeon/evergreen.c
+++ b/drivers/gpu/drm/radeon/evergreen.c
@@ -188,7 +188,7 @@ static const u32 evergreen_golden_registers[] =
 	0x8c1c, 0xffffffff, 0x00001010,
 	0x28350, 0xffffffff, 0x00000000,
 	0xa008, 0xffffffff, 0x00010000,
-	0x5cc, 0xffffffff, 0x00000001,
+	0x5c4, 0xffffffff, 0x00000001,
 	0x9508, 0xffffffff, 0x00000002,
 	0x913c, 0x0000000f, 0x0000000a
 };
@@ -475,7 +475,7 @@ static const u32 cedar_golden_registers[] =
 	0x8c1c, 0xffffffff, 0x00001010,
 	0x28350, 0xffffffff, 0x00000000,
 	0xa008, 0xffffffff, 0x00010000,
-	0x5cc, 0xffffffff, 0x00000001,
+	0x5c4, 0xffffffff, 0x00000001,
 	0x9508, 0xffffffff, 0x00000002
 };
 
@@ -634,7 +634,7 @@ static const u32 juniper_mgcg_init[] =
 static const u32 supersumo_golden_registers[] =
 {
 	0x5eb4, 0xffffffff, 0x00000002,
-	0x5cc, 0xffffffff, 0x00000001,
+	0x5c4, 0xffffffff, 0x00000001,
 	0x7030, 0xffffffff, 0x00000011,
 	0x7c30, 0xffffffff, 0x00000011,
 	0x6104, 0x01000300, 0x00000000,
@@ -718,7 +718,7 @@ static const u32 sumo_golden_registers[] =
 static const u32 wrestler_golden_registers[] =
 {
 	0x5eb4, 0xffffffff, 0x00000002,
-	0x5cc, 0xffffffff, 0x00000001,
+	0x5c4, 0xffffffff, 0x00000001,
 	0x7030, 0xffffffff, 0x00000011,
 	0x7c30, 0xffffffff, 0x00000011,
 	0x6104, 0x01000300, 0x00000000,
-- 
1.9.1

