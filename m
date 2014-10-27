Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752213AbaJ0JtD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 05:49:03 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:29800 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751670AbaJ0JtA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 05:49:00 -0400
X-AuditID: cbfec7f4-b7f6c6d00000120b-12-544e1509d329
From: Andrzej Hajda <a.hajda@samsung.com>
To: dri-devel@lists.freedesktop.org
Cc: Andrzej Hajda <a.hajda@samsung.com>, Inki Dae <inki.dae@samsung.com>,
        Thierry Reding <treding@nvidia.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 3/5] MAINTAINERS: Add entry for S6E8AA0 drm panel driver
Date: Mon, 27 Oct 2014 10:48:28 +0100
Message-id: <1414403310-6316-4-git-send-email-a.hajda@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1414403310-6316-1-git-send-email-a.hajda@samsung.com>
References: <1414403310-6316-1-git-send-email-a.hajda@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMJMWRmVeSWpSXmKPExsVy+t/xq7qcon4hBp/fK1ncWneO1eLK1/ds
	FpPuT2CxuLxrDpvF7d98Dqwe97uPM3n0Nr9j8+jbsorR4/MmuQCWKC6blNSczLLUIn27BK6M
	j1erCiazVezexN3AuIy1i5GTQ0LARGLDvCXMELaYxIV769lAbCGBpYwSV74mdTFyAdl9TBLv
	nx1hB0mwCWhK/N18E6xIREBZ4u/EVYwgRcwCMxkltn65DDZVWMBDYlvrOSCbg4NFQFVi1msD
	kDCvgJPEn/YtLBDL5CROHpsMVs4p4Czxd+p3qMVOEsc/nmOZwMi7gJFhFaNoamlyQXFSeq6h
	XnFibnFpXrpecn7uJkZIwHzZwbj4mNUhRgEORiUe3h3TfEOEWBPLiitzDzFKcDArifA6/gQK
	8aYkVlalFuXHF5XmpBYfYmTi4JRqYGyJulARzv91avKpxP8nF+fJm87yC2PjXB6q17qbp/E1
	r1LIv7335oaGaEb05K19fEur1CJTYG9rWLDVoY2nqydOfBYoHXMgUIHx3s20tBPOH8+I5wUf
	nxpV9jhavnC1kSZzXc6c9a3ntZluy/YyWBebVcW1F65kj93bLrtwwYkLlqZ6aq2/lViKMxIN
	tZiLihMBUSfU/PYBAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
---
 MAINTAINERS | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 6e57cad..2546fca 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3104,6 +3104,13 @@ S:	Supported
 F:	drivers/gpu/drm/panel/panel-ld9040.c
 F:	Documentation/devicetree/bindings/panel/samsung,ld9040.txt
 
+DRM PANEL S6E8AA0 DRIVER
+M:	Andrzej Hajda <a.hajda@samsung.com>
+L:	dri-devel@lists.freedesktop.org
+S:	Supported
+F:	drivers/gpu/drm/panel/panel-s6e8aa0.c
+F:	Documentation/devicetree/bindings/panel/samsung,s6e8aa0.txt
+
 INTEL DRM DRIVERS (excluding Poulsbo, Moorestown and derivative chipsets)
 M:	Daniel Vetter <daniel.vetter@intel.com>
 M:	Jani Nikula <jani.nikula@linux.intel.com>
-- 
1.9.1

