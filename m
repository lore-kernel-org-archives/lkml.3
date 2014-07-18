Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422730AbaGRNqW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 09:46:22 -0400
Received: from bband-dyn38.178-41-141.t-com.sk ([178.41.141.38]:17559 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932919AbaGRNL2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 09:11:28 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Alex Deucher <alexander.deucher@amd.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 163/170] drm/radeon: fix typo in golden register setup on evergreen
Date: Fri, 18 Jul 2014 14:12:48 +0200
Message-Id: <b0eefd635680b1995216f3ca409e0ac4dd56f084.1405685481.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
References: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
In-Reply-To: <cover.1405685481.git.jslaby@suse.cz>
References: <cover.1405685481.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alex Deucher <alexander.deucher@amd.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 6abafb78f9881b4891baf74ab4e9f090ae45230e upstream.

Fixes hangs on driver load on some cards.

bug:
https://bugs.freedesktop.org/show_bug.cgi?id=76998

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/gpu/drm/radeon/evergreen.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/radeon/evergreen.c b/drivers/gpu/drm/radeon/evergreen.c
index e1b2470d3443..4564bb1ab837 100644
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
2.0.0

