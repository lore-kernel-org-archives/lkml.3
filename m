Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756442Ab3I2Tbd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 15:31:33 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59898 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756244Ab3I2TaD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 15:30:03 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [ 40/71] drm/radeon/cik: update gpu_init for an additional berlin gpu
Date: Sun, 29 Sep 2013 12:27:52 -0700
Message-Id: <20130929192646.230990787@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.6.g82e253f.dirty
In-Reply-To: <20130929192643.539596256@linuxfoundation.org>
References: <20130929192643.539596256@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 7c4622d5415038a74964480844de885e7253a0f4 upstream.

Sets the right paramters for the new pci id.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/cik.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/radeon/cik.c
+++ b/drivers/gpu/drm/radeon/cik.c
@@ -1894,7 +1894,8 @@ static void cik_gpu_init(struct radeon_d
 		} else if ((rdev->pdev->device == 0x1309) ||
 			   (rdev->pdev->device == 0x130A) ||
 			   (rdev->pdev->device == 0x130D) ||
-			   (rdev->pdev->device == 0x1313)) {
+			   (rdev->pdev->device == 0x1313) ||
+			   (rdev->pdev->device == 0x131D)) {
 			rdev->config.cik.max_cu_per_sh = 6;
 			rdev->config.cik.max_backends_per_se = 2;
 		} else if ((rdev->pdev->device == 0x1306) ||


