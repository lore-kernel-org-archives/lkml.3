Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755658AbaIQPal (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 11:30:41 -0400
Received: from 51-240-103-86.dynamic.dsl.tng.de ([86.103.240.51]:38851 "EHLO
	mbp8.localnet" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755524AbaIQPak (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 11:30:40 -0400
X-Greylist: delayed 501 seconds by postgrey-1.27 at vger.kernel.org; Wed, 17 Sep 2014 11:30:39 EDT
Date: Wed, 17 Sep 2014 17:22:15 +0200
From: Wilfried Klaebe <w-lkml@lebenslange-mailadresse.de>
To: "open list:RADEON DRM DRIVERS" <dri-devel@lists.freedesktop.org>
Cc: Alex Deucher <alexander.deucher@amd.com>,
        Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
        David Airlie <airlied@linux.ie>, LKML <linux-kernel@vger.kernel.org>
Subject: radeon/radeon_bios.c: clean up coding style differences in
 radeon_get_bios()
Message-ID: <20140917152215.GA10535@mbp8.localnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

radeon/radeon_bios.c: clean up coding style differences in radeon_get_bios()

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
