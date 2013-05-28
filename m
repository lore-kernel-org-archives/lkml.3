Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759195Ab3E1XFw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 19:05:52 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:57243 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758201Ab3E1XFu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 19:05:50 -0400
X-AuditID: cbfee691-b7fef6d000002d62-c7-51a5384c78df
From: Jonghwan Choi <jhbird.choi@samsung.com>
To: "'Jonghwan Choi'" <jhbird.choi@samsung.com>, linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org, "'Inki Dae'" <inki.dae@samsung.com>,
        "'Kyungmin Park'" <kyungmin.park@samsung.com>
References: 
In-reply-to: 
Subject: [PATCH 3.9-stable]  This patch fixes the issue that drm_vblank_get() is
Date: Wed, 29 May 2013 08:05:48 +0900
Message-id: <000401ce5bf7$e46950c0$ad3bf240$%choi@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4vhL6OHdYi6A9aR4m9yzeDEXJPogAflJswAu8tBWABA4TFIAFsOElwAIhNXzAAnKxWYACLd58QADUgf7AB+cfNsAAATvIgAGq8R4ABU9kCoA==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrGIsWRmVeSWpSXmKPExsVy+t8zY11fi6WBBs/ucVhMuj+BxWJJM7fF
	2aY37BaXd81hs1iw8RGjA6tH35ZVjB6fN8kFMEVx2aSk5mSWpRbp2yVwZXQtkC+YL1nx+vcE
	pgbGpaJdjJwcEgImEs0P5rBD2GISF+6tZ+ti5OIQEljGKHFv3z8WmKI/T1pZIRLTGSUm7JnB
	BJIQEvjLKLF0ogeIzSagK3Fs/RZWEFtEwFvi1JRfzCA2s0COxL+2X0D1HED13BKrm4NAwpwC
	PBLr/nSClQgLBEg8P7gdzGYRUJVoeHeKDcTmFbCT2DH3JCuELSjxY/I9FoiRWhLrdx5ngrDl
	JTavecsMMl5CQF3i0V9dkDNFBBoYJRYfWwJVIyKx78U7RpCEhMAxdokbN36wQCwTkPg2+RAL
	RLOsxKYDzBD/SkocXHGDZQKjxCwkq2chWT0LyepZSFYsYGRZxSiaWpBcUJyUXmSqV5yYW1ya
	l66XnJ+7iREShxN3MN4/YH2IMRlo/URmKdHkfGAc55XEGxqbGVmYmpgaG5lbmpEmrCTOq95i
	HSgkkJ5YkpqdmlqQWhRfVJqTWnyIkYmDU6qB0Tl2zr9rsoyby0qEGEtz+JaU1c4xafdIC87S
	2fWm6snyZ0cyXT22Mb24KnRJoiZ17eHjrW/Pltq+MClfGvuu9Y7sz/1+T/yzNkitn9j/4XF4
	ty2P6ovvgRVvIyW0rkkc+zN94qwvF9dklojKfziwZk7KL7/GTL5JX7LvRK0RZhHOvLzseKG/
	lxJLcUaioRZzUXEiALFiCs3ZAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrMKsWRmVeSWpSXmKPExsVy+t9jQV0fi6WBBl93mlpMuj+BxWJJM7fF
	2aY37BaXd81hs1iw8RGjA6tH35ZVjB6fN8kFMEU1MNpkpCampBYppOYl56dk5qXbKnkHxzvH
	m5oZGOoaWlqYKynkJeam2iq5+AToumXmAG1TUihLzCkFCgUkFhcr6dthmhAa4qZrAdMYoesb
	EgTXY2SABhLWMWZ0LZAvmC9Z8fr3BKYGxqWiXYycHBICJhJ/nrSyQthiEhfurWfrYuTiEBKY
	zigxYc8MJpCEkMBfRomlEz1AbDYBXYlj67eANYgIeEucmvKLGcRmFsiR+Nf2C6ieA6ieW2J1
	cxBImFOAR2Ldn06wEmGBAInnB7eD2SwCqhIN706xgdi8AnYSO+aeZIWwBSV+TL7HAjFSS2L9
	zuNMELa8xOY1b5lBxksIqEs8+qsLcqaIQAOjxOJjS6BqRCT2vXjHOIFRaBaSUbOQjJqFZNQs
	JC0LGFlWMYqmFiQXFCel5xrpFSfmFpfmpesl5+duYgRH+TPpHYyrGiwOMQpwMCrx8AZ8XRIo
	xJpYVlyZe4hRgoNZSYQ3VXBpoBBvSmJlVWpRfnxRaU5q8SHGZKBPJzJLiSbnAxNQXkm8obGJ
	mZGlkZmFkYm5OWnCSuK8B1utA4UE0hNLUrNTUwtSi2C2MHFwSjUw1mqcl+n7/ftp+q2GjD52
	1VDRx4dieisrvU6uuvgidnqxVQ3LpC2OTp2s/vEzdzYs0Jux4XKAE0vL7g1zqv4U3V+S88Tr
	k/xBZf2jC9lDnQIPPOzoetfSyZNvu8P0s6/bV6dA3/XP7m2Y1qkqYXIypSnqVM8cYe0ZJl+u
	npi9gnFNnfHWe2srlViKMxINtZiLihMBLQhCjTYDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch looks like it should be in the 3.9-stable tree, should we apply
it?

------------------

From: "Inki Dae <inki.dae@samsung.com>"

commit 20cd2640a295cab46bcd08f4788984ca236fc148 upstream

The issus occurs when next page flip request is tried
if previous page flip event wasn't completed yet and then
dpms became off.

So this patch make sure that page flip event is completed
before dpms goes to off.

Cc: <stable@vger.kernel.org> # 3.9.x: b6330548: drm.h: Fix DRM compilation
Signed-off-by: Inki Dae <inki.dae@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
---
 drivers/gpu/drm/exynos/exynos_drm_crtc.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/gpu/drm/exynos/exynos_drm_crtc.c
b/drivers/gpu/drm/exynos/exynos_drm_crtc.c
index e8894bc..1847f1d 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_crtc.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_crtc.c
@@ -48,6 +48,8 @@ struct exynos_drm_crtc {
 	unsigned int			pipe;
 	unsigned int			dpms;
 	enum exynos_crtc_mode		mode;
+	wait_queue_head_t		pending_flip_queue;
+	atomic_t			pending_flip;
 };
 
 static void exynos_drm_crtc_dpms(struct drm_crtc *crtc, int mode)
@@ -61,6 +63,13 @@ static void exynos_drm_crtc_dpms(struct drm_crtc *crtc,
int mode)
 		return;
 	}
 
+	if (mode > DRM_MODE_DPMS_ON) {
+		/* wait for the completion of page flip. */
+		wait_event(exynos_crtc->pending_flip_queue,
+				atomic_read(&exynos_crtc->pending_flip) ==
0);
+		drm_vblank_off(crtc->dev, exynos_crtc->pipe);
+	}
+
 	exynos_drm_fn_encoder(crtc, &mode, exynos_drm_encoder_crtc_dpms);
 	exynos_crtc->dpms = mode;
 }
@@ -225,6 +234,7 @@ static int exynos_drm_crtc_page_flip(struct drm_crtc
*crtc,
 		spin_lock_irq(&dev->event_lock);
 		list_add_tail(&event->base.link,
 				&dev_priv->pageflip_event_list);
+		atomic_set(&exynos_crtc->pending_flip, 1);
 		spin_unlock_irq(&dev->event_lock);
 
 		crtc->fb = fb;
@@ -344,6 +354,8 @@ int exynos_drm_crtc_create(struct drm_device *dev,
unsigned int nr)
 
 	exynos_crtc->pipe = nr;
 	exynos_crtc->dpms = DRM_MODE_DPMS_OFF;
+	init_waitqueue_head(&exynos_crtc->pending_flip_queue);
+	atomic_set(&exynos_crtc->pending_flip, 0);
 	exynos_crtc->plane = exynos_plane_init(dev, 1 << nr, true);
 	if (!exynos_crtc->plane) {
 		kfree(exynos_crtc);
@@ -399,6 +411,8 @@ void exynos_drm_crtc_finish_pageflip(struct drm_device
*dev, int crtc)
 	struct exynos_drm_private *dev_priv = dev->dev_private;
 	struct drm_pending_vblank_event *e, *t;
 	struct timeval now;
+	struct drm_crtc *drm_crtc = dev_priv->crtc[crtc];
+	struct exynos_drm_crtc *exynos_crtc = to_exynos_crtc(drm_crtc);
 	unsigned long flags;
 
 	DRM_DEBUG_KMS("%s\n", __FILE__);
@@ -419,6 +433,8 @@ void exynos_drm_crtc_finish_pageflip(struct drm_device
*dev, int crtc)
 		list_move_tail(&e->base.link,
&e->base.file_priv->event_list);
 		wake_up_interruptible(&e->base.file_priv->event_wait);
 		drm_vblank_put(dev, crtc);
+		atomic_set(&exynos_crtc->pending_flip, 0);
+		wake_up(&exynos_crtc->pending_flip_queue);
 	}
 
 	spin_unlock_irqrestore(&dev->event_lock, flags);
-- 
1.7.9.5

