Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753466AbaFEEWF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 00:22:05 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44404 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753435AbaFEEWC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 00:22:02 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alan Zimmerman <alan.zimm@gmail.com>,
        Jani Nikula <jani.nikula@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Ben Hutchings <ben@decadent.org.uk>,
        Weng Meiling <wengmeiling.weng@huawei.com>
Subject: [PATCH 3.4 175/214] drm/i915: add quirk to invert brightness on Packard Bell NCL20
Date: Wed,  4 Jun 2014 21:18:58 -0700
Message-Id: <20140605041703.087576327@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <20140605041639.638675216@linuxfoundation.org>
References: <20140605041639.638675216@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jani Nikula <jani.nikula@intel.com>

commit 5559ecadad5a73b27f863e92f4b4f369501dce6f upstream.

Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=44156
Reported-by: Alan Zimmerman <alan.zimm@gmail.com>
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
[wml: Backported to 3.4: Adjust context]
Signed-off-by: Weng Meiling <wengmeiling.weng@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/intel_display.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -9252,6 +9252,9 @@ struct intel_quirk intel_quirks[] = {
 	/* Acer/eMachines e725 */
 	{ 0x2a42, 0x1025, 0x0212, quirk_invert_brightness },
 
+	/* Acer/Packard Bell NCL20 */
+	{ 0x2a42, 0x1025, 0x034b, quirk_invert_brightness },
+
 	/* Dell XPS13 HD Sandy Bridge */
 	{ 0x0116, 0x1028, 0x052e, quirk_no_pcm_pwm_enable },
 	/* Dell XPS13 HD and XPS13 FHD Ivy Bridge */


