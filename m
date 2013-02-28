Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932750Ab3B1OuR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 09:50:17 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:42422 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932709Ab3B1OuM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 09:50:12 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
	<ville.syrjala@linux.intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 105/139] drm: Fill depth/bits_per_pixel for C8 format
Date: Thu, 28 Feb 2013 14:44:15 +0000
Message-Id: <1362062689-2567-106-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
References: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>

commit c51a6bc5f6d328926a9a4a1247c5030faf190a80 upstream.

Set depth/bits_per_pixel to 8 for C8 format.

Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Acked-by: Dave Airlie <airlied@gmail.com>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/drm_crtc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/drm_crtc.c b/drivers/gpu/drm/drm_crtc.c
index af81f77..2ca9737 100644
--- a/drivers/gpu/drm/drm_crtc.c
+++ b/drivers/gpu/drm/drm_crtc.c
@@ -3633,6 +3633,7 @@ void drm_fb_get_bpp_depth(uint32_t format, unsigned int *depth,
 			  int *bpp)
 {
 	switch (format) {
+	case DRM_FORMAT_C8:
 	case DRM_FORMAT_RGB332:
 	case DRM_FORMAT_BGR233:
 		*depth = 8;
-- 
1.8.1.2

