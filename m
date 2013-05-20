Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755710Ab3ETLX2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 07:23:28 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56002 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755407Ab3ETKwa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 06:52:30 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Deucher <alexander.deucher@amd.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 021/115] drm/radeon: fix typo in si_select_se_sh()
Date: Mon, 20 May 2013 11:50:21 +0100
Message-Id: <1369047116-9378-22-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1369047116-9378-1-git-send-email-luis.henriques@canonical.com>
References: <1369047116-9378-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 79b52d6a7085a3e430c6de450a5847fdbe04159b upstream.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/radeon/si.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/radeon/si.c b/drivers/gpu/drm/radeon/si.c
index bc044f5..c43a544 100644
--- a/drivers/gpu/drm/radeon/si.c
+++ b/drivers/gpu/drm/radeon/si.c
@@ -1374,7 +1374,7 @@ static void si_select_se_sh(struct radeon_device *rdev,
 	u32 data = INSTANCE_BROADCAST_WRITES;
 
 	if ((se_num == 0xffffffff) && (sh_num == 0xffffffff))
-		data = SH_BROADCAST_WRITES | SE_BROADCAST_WRITES;
+		data |= SH_BROADCAST_WRITES | SE_BROADCAST_WRITES;
 	else if (se_num == 0xffffffff)
 		data |= SE_BROADCAST_WRITES | SH_INDEX(sh_num);
 	else if (sh_num == 0xffffffff)
-- 
1.8.1.2

