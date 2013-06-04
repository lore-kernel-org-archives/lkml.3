Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757702Ab3FDRFD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 13:05:03 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:48602 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758198Ab3FDRDP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 13:03:15 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 35/75] drm/i915: add more VLV IDs
Date: Tue,  4 Jun 2013 09:55:19 -0700
Message-Id: <1370364959-9475-36-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1370364959-9475-1-git-send-email-kamal@canonical.com>
References: <1370364959-9475-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jesse Barnes <jbarnes@virtuousgeek.org>

commit d7fee5f6faea17b6e702eba90037ab8f716faf8e upstream.

Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/i915/i915_drv.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/i915/i915_drv.c b/drivers/gpu/drm/i915/i915_drv.c
index 79f5fc5..4bc789e 100644
--- a/drivers/gpu/drm/i915/i915_drv.c
+++ b/drivers/gpu/drm/i915/i915_drv.c
@@ -387,6 +387,9 @@ static const struct pci_device_id pciidlist[] = {		/* aka */
 	INTEL_VGA_DEVICE(0x0D16, &intel_haswell_m_info), /* CRW GT2 mobile */
 	INTEL_VGA_DEVICE(0x0D26, &intel_haswell_m_info), /* CRW GT2 mobile */
 	INTEL_VGA_DEVICE(0x0f30, &intel_valleyview_m_info),
+	INTEL_VGA_DEVICE(0x0f31, &intel_valleyview_m_info),
+	INTEL_VGA_DEVICE(0x0f32, &intel_valleyview_m_info),
+	INTEL_VGA_DEVICE(0x0f33, &intel_valleyview_m_info),
 	INTEL_VGA_DEVICE(0x0157, &intel_valleyview_m_info),
 	INTEL_VGA_DEVICE(0x0155, &intel_valleyview_d_info),
 	{0, 0, 0}
-- 
1.8.1.2

