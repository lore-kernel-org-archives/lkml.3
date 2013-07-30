Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757366Ab3G3Sy7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 14:54:59 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56545 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756860Ab3G3Spe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 14:45:34 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jani Nikula <jani.nikula@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 38/75] drm/i915: inverted brightness quirk for Acer Aspire 4736Z
Date: Tue, 30 Jul 2013 11:44:42 -0700
Message-Id: <1375209919-1768-5-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1375197464-27962-1-git-send-email-kamal@canonical.com>
References: <1375197464-27962-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Vetter <daniel.vetter@ffwll.ch>

commit ac4199e0f047546aa40172785e26c82b54bbe811 upstream.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=53881
Cc: Jani Nikula <jani.nikula@intel.com>
Tested-by: Jani Monoses <jani@ubuntu.com>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/i915/intel_display.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index b17d8a8..d203d77 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -8912,6 +8912,9 @@ static struct intel_quirk intel_quirks[] = {
 
 	/* Acer/Packard Bell NCL20 */
 	{ 0x2a42, 0x1025, 0x034b, quirk_invert_brightness },
+
+	/* Acer Aspire 4736Z */
+	{ 0x2a42, 0x1025, 0x0260, quirk_invert_brightness },
 };
 
 static void intel_init_quirks(struct drm_device *dev)
-- 
1.8.1.2

