Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752601AbaCXIqF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 04:46:05 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:11503 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752531AbaCXIqD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 04:46:03 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 24 Mar 2014 01:42:01 -0700
From: Alexandre Courbot <acourbot@nvidia.com>
To: Ben Skeggs <bskeggs@redhat.com>
CC: Thierry Reding <thierry.reding@gmail.com>, <nouveau@lists.freedesktop.org>,
        <dri-devel@lists.freedesktop.org>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <gnurou@gmail.com>,
        Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH 01/12] drm/nouveau: fix missing newline
Date: Mon, 24 Mar 2014 17:42:23 +0900
Message-ID: <1395650554-31925-2-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1395650554-31925-1-git-send-email-acourbot@nvidia.com>
References: <1395650554-31925-1-git-send-email-acourbot@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a missing newline at the end of a DRM_INFO message.

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
---
 drivers/gpu/drm/nouveau/nouveau_drm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/nouveau/nouveau_drm.c b/drivers/gpu/drm/nouveau/nouveau_drm.c
index b2a674531fba..ef27949057c3 100644
--- a/drivers/gpu/drm/nouveau/nouveau_drm.c
+++ b/drivers/gpu/drm/nouveau/nouveau_drm.c
@@ -322,7 +322,7 @@ nouveau_get_hdmi_dev(struct drm_device *dev)
 	struct pci_dev *pdev = dev->pdev;
 
 	if (!pdev) {
-		DRM_INFO("not a PCI device; no HDMI");
+		DRM_INFO("not a PCI device; no HDMI\n");
 		drm->hdmi_device = NULL;
 		return;
 	}
-- 
1.9.1

