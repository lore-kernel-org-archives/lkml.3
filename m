Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933564Ab3B0AJO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 19:09:14 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:42837 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760371Ab3B0AJJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 19:09:09 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
	<ville.syrjala@linux.intel.com>,
        Dave Airlie <airlied@gmail.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [ 48/86] drm: Fill depth/bits_per_pixel for C8 format
Date: Tue, 26 Feb 2013 16:07:56 -0800
Message-Id: <20130226235917.895841907@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130226235912.881663118@linuxfoundation.org>
References: <20130226235912.881663118@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

commit c51a6bc5f6d328926a9a4a1247c5030faf190a80 upstream.

Set depth/bits_per_pixel to 8 for C8 format.

Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Acked-by: Dave Airlie <airlied@gmail.com>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/drm_crtc.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/drm_crtc.c
+++ b/drivers/gpu/drm/drm_crtc.c
@@ -3409,6 +3409,7 @@ void drm_fb_get_bpp_depth(uint32_t forma
 			  int *bpp)
 {
 	switch (format) {
+	case DRM_FORMAT_C8:
 	case DRM_FORMAT_RGB332:
 	case DRM_FORMAT_BGR233:
 		*depth = 8;


