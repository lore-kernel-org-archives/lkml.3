Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934515AbaGXJx7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 05:53:59 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55187 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934815AbaGXJtL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 05:49:11 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Deucher <alexander.deucher@amd.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 117/128] drm/radeon: fix typo in golden register setup on evergreen
Date: Thu, 24 Jul 2014 10:46:06 +0100
Message-Id: <1406195177-8656-118-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406195177-8656-1-git-send-email-luis.henriques@canonical.com>
References: <1406195177-8656-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.14 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 6abafb78f9881b4891baf74ab4e9f090ae45230e upstream.

Fixes hangs on driver load on some cards.

bug:
https://bugs.freedesktop.org/show_bug.cgi?id=76998

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/radeon/evergreen.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/radeon/evergreen.c b/drivers/gpu/drm/radeon/evergreen.c
index f5eb157f69cd..a34e20921711 100644
--- a/drivers/gpu/drm/radeon/evergreen.c
+++ b/drivers/gpu/drm/radeon/evergreen.c
@@ -183,7 +183,7 @@ static const u32 evergreen_golden_registers[] =
 	0x8c1c, 0xffffffff, 0x00001010,
 	0x28350, 0xffffffff, 0x00000000,
 	0xa008, 0xffffffff, 0x00010000,
-	0x5cc, 0xffffffff, 0x00000001,
+	0x5c4, 0xffffffff, 0x00000001,
 	0x9508, 0xffffffff, 0x00000002,
 	0x913c, 0x0000000f, 0x0000000a
 };
@@ -470,7 +470,7 @@ static const u32 cedar_golden_registers[] =
 	0x8c1c, 0xffffffff, 0x00001010,
 	0x28350, 0xffffffff, 0x00000000,
 	0xa008, 0xffffffff, 0x00010000,
-	0x5cc, 0xffffffff, 0x00000001,
+	0x5c4, 0xffffffff, 0x00000001,
 	0x9508, 0xffffffff, 0x00000002
 };
 
@@ -629,7 +629,7 @@ static const u32 juniper_mgcg_init[] =
 static const u32 supersumo_golden_registers[] =
 {
 	0x5eb4, 0xffffffff, 0x00000002,
-	0x5cc, 0xffffffff, 0x00000001,
+	0x5c4, 0xffffffff, 0x00000001,
 	0x7030, 0xffffffff, 0x00000011,
 	0x7c30, 0xffffffff, 0x00000011,
 	0x6104, 0x01000300, 0x00000000,
@@ -713,7 +713,7 @@ static const u32 sumo_golden_registers[] =
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

