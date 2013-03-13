Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934181Ab3CMTsZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 15:48:25 -0400
Received: from cpsmtpb-ews08.kpnxchange.com ([213.75.39.13]:54271 "EHLO
	cpsmtpb-ews08.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932236Ab3CMTsY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 15:48:24 -0400
Message-ID: <1363204102.1335.6.camel@x61.thuisdomein>
Subject: [PATCH] drm/omap: change "!CONFIG_FB_OMAP2" to "!FB_OMAP2"
From: Paul Bolle <pebolle@tiscali.nl>
To: David Airlie <airlied@linux.ie>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Date: Wed, 13 Mar 2013 20:48:22 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 13 Mar 2013 19:48:22.0747 (UTC) FILETIME=[B84002B0:01CE2023]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Untested. Perhaps the first test that people with access to the relevant
hardware might do, is to test _before applying this patch_ with FB_OMAP2
set. Perhaps this negative dependency isn't needed at all. Or is it
obvious?

 drivers/gpu/drm/omapdrm/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/omapdrm/Kconfig b/drivers/gpu/drm/omapdrm/Kconfig
index 09f65dc..45875a0 100644
--- a/drivers/gpu/drm/omapdrm/Kconfig
+++ b/drivers/gpu/drm/omapdrm/Kconfig
@@ -1,7 +1,7 @@
 
 config DRM_OMAP
 	tristate "OMAP DRM"
-	depends on DRM && !CONFIG_FB_OMAP2
+	depends on DRM && !FB_OMAP2
 	depends on ARCH_OMAP2PLUS || ARCH_MULTIPLATFORM
 	depends on OMAP2_DSS
 	select DRM_KMS_HELPER
-- 
1.7.11.7

