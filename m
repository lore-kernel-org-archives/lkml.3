Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756962Ab3APP7t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 10:59:49 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:35801 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756979Ab3APP7r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 10:59:47 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Deucher <alexander.deucher@amd.com>, Dave Airlie <airlied@redhat.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 037/222] drm: fix documentation for drm_crtc_set_mode()
Date: Wed, 16 Jan 2013 13:53:57 -0200
Message-Id: <1358351822-7675-38-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 4c9287c6009b37754c42e0ba73a4cc79de92d8f8 upstream.

x and y parameters are offsets, not width/height

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/gpu/drm/drm_crtc_helper.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/drm_crtc_helper.c b/drivers/gpu/drm/drm_crtc_helper.c
index 3252e70..1ea423a 100644
--- a/drivers/gpu/drm/drm_crtc_helper.c
+++ b/drivers/gpu/drm/drm_crtc_helper.c
@@ -328,8 +328,8 @@ drm_crtc_prepare_encoders(struct drm_device *dev)
  * drm_crtc_set_mode - set a mode
  * @crtc: CRTC to program
  * @mode: mode to use
- * @x: width of mode
- * @y: height of mode
+ * @x: horizontal offset into the surface
+ * @y: vertical offset into the surface
  *
  * LOCKING:
  * Caller must hold mode config lock.
-- 
1.7.9.5

