Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760595Ab3B0A6r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 19:58:47 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:42057 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760292Ab3BZX6A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 18:58:00 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jani Nikula <jani.nikula@intel.com>, Jani Monoses <jani@ubuntu.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [ 090/150] drm/i915: inverted brightness quirk for Acer Aspire 4736Z
Date: Tue, 26 Feb 2013 15:55:47 -0800
Message-Id: <20130226235533.440170436@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130226235523.930663721@linuxfoundation.org>
References: <20130226235523.930663721@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Vetter <daniel.vetter@ffwll.ch>

commit ac4199e0f047546aa40172785e26c82b54bbe811 upstream.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=53881
Cc: Jani Nikula <jani.nikula@intel.com>
Tested-by: Jani Monoses <jani@ubuntu.com>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/intel_display.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -8890,6 +8890,9 @@ static struct intel_quirk intel_quirks[]
 
 	/* Acer Aspire 5734Z must invert backlight brightness */
 	{ 0x2a42, 0x1025, 0x0459, quirk_invert_brightness },
+
+	/* Acer Aspire 4736Z */
+	{ 0x2a42, 0x1025, 0x0260, quirk_invert_brightness },
 };
 
 static void intel_init_quirks(struct drm_device *dev)


