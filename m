Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751278AbaKGApk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 19:45:40 -0500
Received: from alexpilon.ca ([69.165.220.233]:57581 "EHLO
	kanataserver.alexpilon.ca" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750926AbaKGApj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 19:45:39 -0500
X-Greylist: delayed 535 seconds by postgrey-1.27 at vger.kernel.org; Thu, 06 Nov 2014 19:45:39 EST
Date: Thu, 6 Nov 2014 19:36:03 -0500
From: Alex Pilon <alp+linux@alexpilon.ca>
To: David Airlie <airlied@linux.ie>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        trivial@kernel.org
Subject: [PATCH] drm: Fix spelling.
Message-ID: <20141107003505.GA3491@alexpilon.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix spelling of 'ioctl'.

Signed-off-by: Alex Pilon <alp+linux@alexpilon.ca>
---
 drivers/gpu/drm/drm_crtc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/drm_crtc.c b/drivers/gpu/drm/drm_crtc.c
index e79c8d3..3d274c1 100644
--- a/drivers/gpu/drm/drm_crtc.c
+++ b/drivers/gpu/drm/drm_crtc.c
@@ -2943,7 +2943,7 @@ EXPORT_SYMBOL(drm_mode_legacy_fb_format);
  * @file_priv: drm file for the ioctl call
  *
  * Add a new FB to the specified CRTC, given a user request. This is the
- * original addfb ioclt which only supported RGB formats.
+ * original addfb ioctl which only supported RGB formats.
  *
  * Called by the user via ioctl.
  *
-- 
2.1.2

