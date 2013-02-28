Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932863Ab3B1Ou3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 09:50:29 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:42453 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932831Ab3B1Ou0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 09:50:26 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Deucher <alexander.deucher@amd.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 111/139] drm/radeon: remove overzealous warning in hdmi handling
Date: Thu, 28 Feb 2013 14:44:21 +0000
Message-Id: <1362062689-2567-112-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
References: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit c944b2abb067130542055666f23409fd5e1afc8e upstream.

hdmi audio works fine.  The warning just confuses users.

fixes:
https://bugzilla.kernel.org/show_bug.cgi?id=44341

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Jerome Glisse <jglisse@redhat.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/radeon/r600_hdmi.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/gpu/drm/radeon/r600_hdmi.c b/drivers/gpu/drm/radeon/r600_hdmi.c
index 82a0a4c..851a477 100644
--- a/drivers/gpu/drm/radeon/r600_hdmi.c
+++ b/drivers/gpu/drm/radeon/r600_hdmi.c
@@ -545,7 +545,6 @@ void r600_hdmi_disable(struct drm_encoder *encoder)
 
 	/* Called for ATOM_ENCODER_MODE_HDMI only */
 	if (!dig || !dig->afmt) {
-		WARN_ON(1);
 		return;
 	}
 	if (!dig->afmt->enabled)
-- 
1.8.1.2

