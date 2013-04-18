Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759154Ab3DRJSX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 05:18:23 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40216 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758200Ab3DRJSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 05:18:07 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jani Nikula <jani.nikula@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 44/72] drm/i915: add quirk to invert brightness on eMachines G725
Date: Thu, 18 Apr 2013 10:16:29 +0100
Message-Id: <1366276617-3553-45-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1366276617-3553-1-git-send-email-luis.henriques@canonical.com>
References: <1366276617-3553-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jani Nikula <jani.nikula@intel.com>

commit 1ffff60320879830e469e26062c18f75236822ba upstream.

Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=59628
Reported-by: Roland Gruber <post@rolandgruber.de>
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
[ luis: adjust context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/i915/intel_display.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index 16c6d6b..a0cfeb6 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -6940,6 +6940,9 @@ static struct intel_quirk intel_quirks[] = {
 
 	/* Acer Aspire 4736Z */
 	{ 0x2a42, 0x1025, 0x0260, quirk_invert_brightness },
+
+	/* Acer/eMachines G725 */
+	{ 0x2a42, 0x1025, 0x0210, quirk_invert_brightness },
 };
 
 static void intel_init_quirks(struct drm_device *dev)
-- 
1.8.1.2

