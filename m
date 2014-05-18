Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751829AbaERAYz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2014 20:24:55 -0400
Received: from mail-ee0-f44.google.com ([74.125.83.44]:58384 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751543AbaERAYy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2014 20:24:54 -0400
Date: Sun, 18 May 2014 02:24:50 +0200
From: Robin Schroer <sulamiification@gmail.com>
To: daniel.vetter@ffwll.ch
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org
Subject: [PATCH] drivers/gpu/drm/i915/intel_display: coding style fixes
Message-ID: <20140518002450.GA26570@shodan.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed several switch statements, curly braces, dereference operators
and keywords.

Signed-off-by: Robin Schroer <sulamiification@gmail.com>
---
 drivers/gpu/drm/i915/intel_display.c | 18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index b9256aa..ff21924 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -962,7 +962,7 @@ bool ibx_digital_port_connected(struct drm_i915_private *dev_priv,
 	u32 bit;

 	if (HAS_PCH_IBX(dev_priv->dev)) {
-		switch(port->port) {
+		switch (port->port) {
 		case PORT_B:
 			bit = SDE_PORTB_HOTPLUG;
 			break;
@@ -976,7 +976,7 @@ bool ibx_digital_port_connected(struct drm_i915_private *dev_priv,
 			return true;
 		}
 	} else {
-		switch(port->port) {
+		switch (port->port) {
 		case PORT_B:
 			bit = SDE_PORTB_HOTPLUG_CPT;
 			break;
@@ -3221,9 +3221,8 @@ static void ironlake_fdi_disable(struct drm_crtc *crtc)
 	udelay(100);

 	/* Ironlake workaround, disable clock pointer after downing FDI */
-	if (HAS_PCH_IBX(dev)) {
+	if (HAS_PCH_IBX(dev))
 		I915_WRITE(FDI_RX_CHICKEN(pipe), FDI_RX_PHASE_SYNC_POINTER_OVR);
-	}

 	/* still set train pattern 1 */
 	reg = FDI_TX_CTL(pipe);
@@ -5844,7 +5843,7 @@ static int i9xx_crtc_mode_set(struct drm_crtc *crtc,
 	} else {
 		i9xx_update_pll(intel_crtc,
 				has_reduced_clock ? &reduced_clock : NULL,
-                                num_connectors);
+				num_connectors);
 	}

 skip_dpll:
@@ -6220,8 +6219,7 @@ static void ironlake_init_pch_refclk(struct drm_device *dev)
 			if (intel_panel_use_ssc(dev_priv) && can_ssc) {
 				DRM_DEBUG_KMS("Using SSC on eDP\n");
 				val |= DREF_CPU_SOURCE_OUTPUT_DOWNSPREAD;
-			}
-			else
+			} else
 				val |= DREF_CPU_SOURCE_OUTPUT_NONSPREAD;
 		} else
 			val |= DREF_CPU_SOURCE_OUTPUT_DISABLE;
@@ -8844,7 +8842,7 @@ void intel_prepare_page_flip(struct drm_device *dev, int plane)
 	spin_unlock_irqrestore(&dev->event_lock, flags);
 }

-inline static void intel_mark_page_flip_active(struct intel_crtc *intel_crtc)
+static inline void intel_mark_page_flip_active(struct intel_crtc *intel_crtc)
 {
 	/* Ensure that the work item is consistent when activating it ... */
 	smp_wmb();
@@ -9054,7 +9052,7 @@ static int intel_gen7_queue_flip(struct drm_device *dev,
 	if (ret)
 		goto err;

-	switch(intel_crtc->plane) {
+	switch (intel_crtc->plane) {
 	case PLANE_A:
 		plane_bit = MI_DISPLAY_FLIP_IVB_PLANE_A;
 		break;
@@ -9333,7 +9331,7 @@ static void intel_modeset_commit_output_state(struct drm_device *dev)
 }

 static void
-connected_sink_compute_bpp(struct intel_connector * connector,
+connected_sink_compute_bpp(struct intel_connector *connector,
 			   struct intel_crtc_config *pipe_config)
 {
 	int bpp = pipe_config->pipe_bpp;
--
1.9.0

