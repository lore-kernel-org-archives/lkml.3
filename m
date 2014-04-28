Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755202AbaD1Bc0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 21:32:26 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42990 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752718AbaD1B3W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 21:29:22 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Jani Monoses" <jani@ubuntu.com>,
        "Daniel Vetter" <daniel.vetter@ffwll.ch>,
        "Jani Nikula" <jani.nikula@intel.com>
Date: Mon, 28 Apr 2014 02:11:21 +0100
Message-ID: <lsq.1398647481.228359547@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 21/94] drm/i915: inverted brightness quirk for Acer
 Aspire 4736Z
In-Reply-To: <lsq.1398647481.453080089@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.58-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Vetter <daniel.vetter@ffwll.ch>

commit ac4199e0f047546aa40172785e26c82b54bbe811 upstream.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=53881
Cc: Jani Nikula <jani.nikula@intel.com>
Tested-by: Jani Monoses <jani@ubuntu.com>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/i915/intel_display.c | 3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -8946,6 +8946,9 @@ struct intel_quirk intel_quirks[] = {
 	/* Acer/Packard Bell NCL20 */
 	{ 0x2a42, 0x1025, 0x034b, quirk_invert_brightness },
 
+	/* Acer Aspire 4736Z */
+	{ 0x2a42, 0x1025, 0x0260, quirk_invert_brightness },
+
 	/* Dell XPS13 HD Sandy Bridge */
 	{ 0x0116, 0x1028, 0x052e, quirk_no_pcm_pwm_enable },
 	/* Dell XPS13 HD and XPS13 FHD Ivy Bridge */

