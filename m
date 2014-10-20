Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752781AbaJTOxc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 10:53:32 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:54227 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752141AbaJTOxb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 10:53:31 -0400
From: Masanari Iida <standby24x7@gmail.com>
To: airlied@linux.ie, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, rdunlap@infradead.org, corbet@lwn.net,
        trivial@kernel.org
Cc: Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] gpu:drm: Fix typo in Documentation/DocBook/drm.xml
Date: Mon, 20 Oct 2014 23:53:13 +0900
Message-Id: <1413816793-14690-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 2.1.2.451.g98349e5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fix spelling typos found in drm.xml.
It is because the file is generated from comments in
source codes, I have to fix the typos within source files.

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 drivers/gpu/drm/drm_crtc.c             | 2 +-
 drivers/gpu/drm/drm_irq.c              | 4 ++--
 drivers/gpu/drm/drm_modes.c            | 2 +-
 drivers/gpu/drm/drm_prime.c            | 4 ++--
 drivers/gpu/drm/i915/i915_cmd_parser.c | 4 ++--
 drivers/gpu/drm/i915/i915_reg.h        | 2 +-
 drivers/gpu/drm/i915/intel_lrc.c       | 2 +-
 include/drm/drm_dp_mst_helper.h        | 2 +-
 8 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/gpu/drm/drm_crtc.c b/drivers/gpu/drm/drm_crtc.c
index e79c8d3..7f94989 100644
--- a/drivers/gpu/drm/drm_crtc.c
+++ b/drivers/gpu/drm/drm_crtc.c
@@ -3611,7 +3611,7 @@ static struct drm_property *property_create_range(struct drm_device *dev,
  * object with drm_object_attach_property. The returned property object must be
  * freed with drm_property_destroy.
  *
- * Userspace is allowed to set any interger value in the (min, max) range
+ * Userspace is allowed to set any integer value in the (min, max) range
  * inclusive.
  *
  * Returns:
diff --git a/drivers/gpu/drm/drm_irq.c b/drivers/gpu/drm/drm_irq.c
index 5ef03c2..3e6b582 100644
--- a/drivers/gpu/drm/drm_irq.c
+++ b/drivers/gpu/drm/drm_irq.c
@@ -1190,7 +1190,7 @@ EXPORT_SYMBOL(drm_crtc_vblank_off);
  *
  * This functions restores the vblank interrupt state captured with
  * drm_vblank_off() again. Note that calls to drm_vblank_on() and
- * drm_vblank_off() can be unbalanced and so can also be unconditionaly called
+ * drm_vblank_off() can be unbalanced and so can also be unconditionally called
  * in driver load code to reflect the current hardware state of the crtc.
  *
  * This is the legacy version of drm_crtc_vblank_on().
@@ -1237,7 +1237,7 @@ EXPORT_SYMBOL(drm_vblank_on);
  *
  * This functions restores the vblank interrupt state captured with
  * drm_vblank_off() again. Note that calls to drm_vblank_on() and
- * drm_vblank_off() can be unbalanced and so can also be unconditionaly called
+ * drm_vblank_off() can be unbalanced and so can also be unconditionally called
  * in driver load code to reflect the current hardware state of the crtc.
  *
  * This is the native kms version of drm_vblank_on().
diff --git a/drivers/gpu/drm/drm_modes.c b/drivers/gpu/drm/drm_modes.c
index d1b7d20..6d8b941 100644
--- a/drivers/gpu/drm/drm_modes.c
+++ b/drivers/gpu/drm/drm_modes.c
@@ -914,7 +914,7 @@ EXPORT_SYMBOL(drm_mode_equal_no_clocks_no_stereo);
  *
  * This function is a helper which can be used to validate modes against size
  * limitations of the DRM device/connector. If a mode is too big its status
- * memeber is updated with the appropriate validation failure code. The list
+ * member is updated with the appropriate validation failure code. The list
  * itself is not changed.
  */
 void drm_mode_validate_size(struct drm_device *dev,
diff --git a/drivers/gpu/drm/drm_prime.c b/drivers/gpu/drm/drm_prime.c
index 78ca308..6872eca 100644
--- a/drivers/gpu/drm/drm_prime.c
+++ b/drivers/gpu/drm/drm_prime.c
@@ -328,7 +328,7 @@ static const struct dma_buf_ops drm_gem_prime_dmabuf_ops =  {
  */
 
 /**
- * drm_gem_prime_export - helper library implemention of the export callback
+ * drm_gem_prime_export - helper library implementation of the export callback
  * @dev: drm_device to export from
  * @obj: GEM object to export
  * @flags: flags like DRM_CLOEXEC
@@ -483,7 +483,7 @@ out_unlock:
 EXPORT_SYMBOL(drm_gem_prime_handle_to_fd);
 
 /**
- * drm_gem_prime_import - helper library implemention of the import callback
+ * drm_gem_prime_import - helper library implementation of the import callback
  * @dev: drm_device to import into
  * @dma_buf: dma-buf object to import
  *
diff --git a/drivers/gpu/drm/i915/i915_cmd_parser.c b/drivers/gpu/drm/i915/i915_cmd_parser.c
index 593b657..ee60bd4 100644
--- a/drivers/gpu/drm/i915/i915_cmd_parser.c
+++ b/drivers/gpu/drm/i915/i915_cmd_parser.c
@@ -73,7 +73,7 @@
  * those commands required by the parser. This generally works because command
  * opcode ranges have standard command length encodings. So for commands that
  * the parser does not need to check, it can easily skip them. This is
- * implementated via a per-ring length decoding vfunc.
+ * implemented via a per-ring length decoding vfunc.
  *
  * Unfortunately, there are a number of commands that do not follow the standard
  * length encoding for their opcode range, primarily amongst the MI_* commands.
@@ -838,7 +838,7 @@ finish:
  * @ring: the ring in question
  *
  * Only certain platforms require software batch buffer command parsing, and
- * only when enabled via module paramter.
+ * only when enabled via module parameter.
  *
  * Return: true if the ring requires software command parsing
  */
diff --git a/drivers/gpu/drm/i915/i915_reg.h b/drivers/gpu/drm/i915/i915_reg.h
index c01e5f3..0404fe1 100644
--- a/drivers/gpu/drm/i915/i915_reg.h
+++ b/drivers/gpu/drm/i915/i915_reg.h
@@ -672,7 +672,7 @@ enum punit_power_well {
  * need to be accessed during AUX communication,
  *
  * Generally the common lane corresponds to the pipe and
- * the spline (PCS/TX) correponds to the port.
+ * the spline (PCS/TX) corresponds to the port.
  *
  * For dual channel PHY (VLV/CHV):
  *
diff --git a/drivers/gpu/drm/i915/intel_lrc.c b/drivers/gpu/drm/i915/intel_lrc.c
index bafd38b..06b3e85 100644
--- a/drivers/gpu/drm/i915/intel_lrc.c
+++ b/drivers/gpu/drm/i915/intel_lrc.c
@@ -1660,7 +1660,7 @@ static uint32_t get_lr_context_size(struct intel_engine_cs *ring)
  * the creation is a deferred call: it's better to make sure first that we need to use
  * a given ring with the context.
  *
- * Return: non-zero on eror.
+ * Return: non-zero on error.
  */
 int intel_lr_context_deferred_create(struct intel_context *ctx,
 				     struct intel_engine_cs *ring)
diff --git a/include/drm/drm_dp_mst_helper.h b/include/drm/drm_dp_mst_helper.h
index 338fc10..05e85ee 100644
--- a/include/drm/drm_dp_mst_helper.h
+++ b/include/drm/drm_dp_mst_helper.h
@@ -28,7 +28,7 @@
 struct drm_dp_mst_branch;
 
 /**
- * struct drm_dp_vcpi - Virtual Channel Payload Identifer
+ * struct drm_dp_vcpi - Virtual Channel Payload Identifier
  * @vcpi: Virtual channel ID.
  * @pbn: Payload Bandwidth Number for this channel
  * @aligned_pbn: PBN aligned with slot size
-- 
2.1.2.451.g98349e5

