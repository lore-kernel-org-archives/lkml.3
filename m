Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752689AbaDAMCS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 08:02:18 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42339 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752132AbaDALRJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 07:17:09 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Deucher <alexander.deucher@amd.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 054/144] drm/radeon/dpm: fix typo in EVERGREEN_SMC_FIRMWARE_HEADER_softRegisters
Date: Tue,  1 Apr 2014 12:14:18 +0100
Message-Id: <1396350948-29910-55-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1396350948-29910-1-git-send-email-luis.henriques@canonical.com>
References: <1396350948-29910-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 13714323f83ffa5a772fe0d8b74e0fa32ee08819 upstream.

Should be at 0x8 rather than 0.

fixes:
https://bugzilla.kernel.org/show_bug.cgi?id=60523

Noticed by ArtForz on #radeon

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/radeon/evergreen_smc.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/radeon/evergreen_smc.h b/drivers/gpu/drm/radeon/evergreen_smc.h
index 76ada8c..3a03ba3 100644
--- a/drivers/gpu/drm/radeon/evergreen_smc.h
+++ b/drivers/gpu/drm/radeon/evergreen_smc.h
@@ -57,7 +57,7 @@ typedef struct SMC_Evergreen_MCRegisters SMC_Evergreen_MCRegisters;
 
 #define EVERGREEN_SMC_FIRMWARE_HEADER_LOCATION 0x100
 
-#define EVERGREEN_SMC_FIRMWARE_HEADER_softRegisters   0x0
+#define EVERGREEN_SMC_FIRMWARE_HEADER_softRegisters   0x8
 #define EVERGREEN_SMC_FIRMWARE_HEADER_stateTable      0xC
 #define EVERGREEN_SMC_FIRMWARE_HEADER_mcRegisterTable 0x20
 
-- 
1.9.1

