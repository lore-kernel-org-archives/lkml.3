Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751784AbaLRBKa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 20:10:30 -0500
Received: from mga09.intel.com ([134.134.136.24]:42620 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751233AbaLRBK3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 20:10:29 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,597,1413270000"; 
   d="scan'208";a="656017547"
Date: Thu, 18 Dec 2014 09:10:01 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: Rob Clark <robdclark@gmail.com>
Cc: kbuild-all@01.org, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: [PATCH robclark] drm: get_properties() can be static
Message-ID: <20141218011001.GA88947@lkp-sb04>
References: <201412180950.908XRX5k%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201412180950.908XRX5k%fengguang.wu@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: fengguang.wu@intel.com
X-SA-Exim-Scanned: No (on bee); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/gpu/drm/drm_crtc.c:1995:5: sparse: symbol 'get_properties' was not declared. Should it be static?

Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
---
 drm_crtc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/drm_crtc.c b/drivers/gpu/drm/drm_crtc.c
index dcfd64e5..a80a29b 100644
--- a/drivers/gpu/drm/drm_crtc.c
+++ b/drivers/gpu/drm/drm_crtc.c
@@ -1992,7 +1992,7 @@ static struct drm_encoder *drm_connector_get_encoder(struct drm_connector *conne
 }
 
 /* helper for getconnector and getproperties ioctls */
-int get_properties(struct drm_mode_object *obj, uint32_t __user *prop_ptr,
+static int get_properties(struct drm_mode_object *obj, uint32_t __user *prop_ptr,
 		uint64_t __user *prop_values, uint32_t *arg_count_props)
 {
 	int props_count = obj->properties->count;
