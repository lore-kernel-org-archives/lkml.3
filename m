Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752582AbaJ0JvW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 05:51:22 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:29800 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752114AbaJ0JtB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 05:49:01 -0400
X-AuditID: cbfec7f5-b7f956d000005ed7-3d-544e150c1abe
From: Andrzej Hajda <a.hajda@samsung.com>
To: dri-devel@lists.freedesktop.org
Cc: Andrzej Hajda <a.hajda@samsung.com>, Inki Dae <inki.dae@samsung.com>,
        Thierry Reding <treding@nvidia.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 5/5] MAINTAINERS: Add entry for Exynos MIPI DPI DRM driver
Date: Mon, 27 Oct 2014 10:48:30 +0100
Message-id: <1414403310-6316-6-git-send-email-a.hajda@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1414403310-6316-1-git-send-email-a.hajda@samsung.com>
References: <1414403310-6316-1-git-send-email-a.hajda@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKJMWRmVeSWpSXmKPExsVy+t/xq7o8on4hBmvbxSxurTvHanHl63s2
	i0n3J7BYXN41h83i9m8+B1aP+93HmTx6m9+xefRtWcXo8XmTXABLFJdNSmpOZllqkb5dAlfG
	17vHWAr+sVScuRfawDiLpYuRk0NCwESi+fU5ZghbTOLCvfVsXYxcHEICSxkl9n/4ww7h9DFJ
	3L45BayKTUBT4u/mm2wgtoiAssTfiasYQYqYBWYySmz9cpkVJCEs4CWx9/xkoBUcHCwCqhJz
	DrmAhHkFnCSur/kEtVlO4uSxyWDlnALOEn+nfgebKQRUc/zjOZYJjLwLGBlWMYqmliYXFCel
	5xrpFSfmFpfmpesl5+duYoQEzdcdjEuPWR1iFOBgVOLhnVDsGyLEmlhWXJl7iFGCg1lJhNfx
	J1CINyWxsiq1KD++qDQntfgQIxMHp1QDo1Xi6sMPvype82Xd43mkZxX/yvsRK2vf+sw69TOw
	sr7L7pzH9x+Zac4zMyYo5Ust0K+dXJRuI2woqJ9v/fiS+eTv7j58S5u2/atbz1LKO/XLm3Ih
	tmtWy3ouqa/dPeGXnsad+UwzzgZ/XPmRpb/HumDS49ZFC/XPJWze73K60qdj0hHNt5pXbymx
	FGckGmoxFxUnAgApyvL7+AEAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
---
 MAINTAINERS | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 256183e..06cdb5a 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3656,6 +3656,12 @@ L:	dri-devel@lists.freedesktop.org
 S:	Supported
 F:	drivers/gpu/drm/exynos/exynos_drm_dsi.c
 
+EXYNOS MIPI DPI DRM DRIVER
+M:	Andrzej Hajda <a.hajda@samsung.com>
+L:	dri-devel@lists.freedesktop.org
+S:	Supported
+F:	drivers/gpu/drm/exynos/exynos_drm_dpi.c
+
 F71805F HARDWARE MONITORING DRIVER
 M:	Jean Delvare <jdelvare@suse.de>
 L:	lm-sensors@lm-sensors.org
-- 
1.9.1

