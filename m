Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751937AbaJPJuR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 05:50:17 -0400
Received: from mail0.toppoint.de ([217.70.197.20]:47876 "EHLO
	mail0.toppoint.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751794AbaJPJuN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 05:50:13 -0400
X-Greylist: delayed 405 seconds by postgrey-1.27 at vger.kernel.org; Thu, 16 Oct 2014 05:50:12 EDT
Date: Thu, 16 Oct 2014 09:37:34 +0000
From: Wilfried Klaebe <w-lkml@lebenslange-mailadresse.de>
To: linux-kernel@vger.kernel.org
Cc: trivial@kernel.org, dri-devel@lists.freedesktop.org,
        Alex Deucher <alexander.deucher@amd.com>,
        Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
        David Airlie <airlied@linux.ie>
Subject: [RESEND] [PATCH] radeon: clean up coding style differences in
 radeon_get_bios()
Message-ID: <20141016093734.GA2563@kaos.lebenslange-mailadresse.de>
Mail-Followup-To: linux-kernel@vger.kernel.org, trivial@kernel.org,
	dri-devel@lists.freedesktop.org,
	Alex Deucher <alexander.deucher@amd.com>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	David Airlie <airlied@linux.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

radeon: clean up coding style differences in radeon_get_bios()

Signed-off-by: Wilfried Klaebe <w-lkml@lebenslange-mailadresse.de>

diff --git a/drivers/gpu/drm/radeon/radeon_bios.c b/drivers/gpu/drm/radeon/radeon_bios.c
index 6a03624..63ccb8f 100644
--- a/drivers/gpu/drm/radeon/radeon_bios.c
+++ b/drivers/gpu/drm/radeon/radeon_bios.c
@@ -658,12 +658,10 @@ bool radeon_get_bios(struct radeon_device *rdev)
 		r = igp_read_bios_from_vram(rdev);
 	if (r == false)
 		r = radeon_read_bios(rdev);
-	if (r == false) {
+	if (r == false)
 		r = radeon_read_disabled_bios(rdev);
-	}
-	if (r == false) {
+	if (r == false)
 		r = radeon_read_platform_bios(rdev);
-	}
 	if (r == false || rdev->bios == NULL) {
 		DRM_ERROR("Unable to locate a BIOS ROM\n");
 		rdev->bios = NULL;
--
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/



