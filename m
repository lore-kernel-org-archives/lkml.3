Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754504Ab3DVO3j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 10:29:39 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51429 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754438Ab3DVO3g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 10:29:36 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Jani Nikula" <jani.nikula@intel.com>,
        "Alan Zimmerman" <alan.zimm@gmail.com>,
        "Daniel Vetter" <daniel.vetter@ffwll.ch>
Date: Mon, 22 Apr 2013 15:25:59 +0100
Message-ID: <lsq.1366640759.200041168@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [62/75] drm/i915: add quirk to invert brightness on Packard Bell
 NCL20
In-Reply-To: <lsq.1366640759.151900666@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:6834:ff73:7553:7f84
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.44-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Jani Nikula <jani.nikula@intel.com>

commit 5559ecadad5a73b27f863e92f4b4f369501dce6f upstream.

Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=44156
Reported-by: Alan Zimmerman <alan.zimm@gmail.com>
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/i915/intel_display.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -8913,6 +8913,9 @@ struct intel_quirk intel_quirks[] = {
 
 	/* Acer/eMachines e725 */
 	{ 0x2a42, 0x1025, 0x0212, quirk_invert_brightness },
+
+	/* Acer/Packard Bell NCL20 */
+	{ 0x2a42, 0x1025, 0x034b, quirk_invert_brightness },
 };
 
 static void intel_init_quirks(struct drm_device *dev)

