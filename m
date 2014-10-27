Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752600AbaJ0Jvp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 05:51:45 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:8635 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751711AbaJ0Js5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 05:48:57 -0400
X-AuditID: cbfec7f4-b7f6c6d00000120b-07-544e1508be93
From: Andrzej Hajda <a.hajda@samsung.com>
To: dri-devel@lists.freedesktop.org
Cc: Andrzej Hajda <a.hajda@samsung.com>, Inki Dae <inki.dae@samsung.com>,
        Thierry Reding <treding@nvidia.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 2/5] MAINTAINERS: Add entry for LD9040 drm panel driver
Date: Mon, 27 Oct 2014 10:48:27 +0100
Message-id: <1414403310-6316-3-git-send-email-a.hajda@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1414403310-6316-1-git-send-email-a.hajda@samsung.com>
References: <1414403310-6316-1-git-send-email-a.hajda@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGJMWRmVeSWpSXmKPExsVy+t/xq7ocon4hBtPPcVjcWneO1eLK1/ds
	FpPuT2CxuLxrDpvF7d98Dqwe97uPM3n0Nr9j8+jbsorR4/MmuQCWKC6blNSczLLUIn27BK6M
	VTcuMBb8Y61oXfyXuYFxImsXIweHhICJxJ4GvS5GTiBTTOLCvfVsXYxcHEICSxkl9v9+wgjh
	9DFJvLy4gBWkik1AU+Lv5ptsILaIgLLE34mrwIqYBWYySmz9chmsSFjAXeLpv5PsIDaLgKrE
	jUsnweK8Ak4Sd/csYYFYJydx8thksDingLPE36nfwYYKAdUc/3iOZQIj7wJGhlWMoqmlyQXF
	Sem5hnrFibnFpXnpesn5uZsYIWHzZQfj4mNWhxgFOBiVeHh3TPMNEWJNLCuuzD3EKMHBrCTC
	6/gTKMSbklhZlVqUH19UmpNafIiRiYNTqoFRQFSwny9u42SJq/UW4VtOJvZs1ZnY8XDPs6w7
	vKp166yuZyoWiM3oYN5aYPpxTbXP67zW5Ulm3ZFbJ8o1nz3/TLLGPuSSw6mJd//tOxwbsH1V
	wgMjP25hoYN9frsDK24pxz+6oOzvmHQy8KbRsrWpbg/WaRaJeGjNTkxbuqL1Vc0Sj7YZYSxK
	LMUZiYZazEXFiQDOheke+QEAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
---
 MAINTAINERS | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 476679c..6e57cad 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3097,6 +3097,13 @@ F:	drivers/gpu/drm/panel/
 F:	include/drm/drm_panel.h
 F:	Documentation/devicetree/bindings/panel/
 
+DRM PANEL LD9040 DRIVER
+M:	Andrzej Hajda <a.hajda@samsung.com>
+L:	dri-devel@lists.freedesktop.org
+S:	Supported
+F:	drivers/gpu/drm/panel/panel-ld9040.c
+F:	Documentation/devicetree/bindings/panel/samsung,ld9040.txt
+
 INTEL DRM DRIVERS (excluding Poulsbo, Moorestown and derivative chipsets)
 M:	Daniel Vetter <daniel.vetter@intel.com>
 M:	Jani Nikula <jani.nikula@linux.intel.com>
-- 
1.9.1

