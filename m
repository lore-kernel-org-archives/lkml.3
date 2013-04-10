Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937422Ab3DJWrt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 18:47:49 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56307 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937339Ab3DJWrs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 18:47:48 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alan Zimmerman <alan.zimm@gmail.com>,
        Jani Nikula <jani.nikula@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [ 58/64] drm/i915: add quirk to invert brightness on Packard Bell NCL20
Date: Wed, 10 Apr 2013 15:46:55 -0700
Message-Id: <20130410224347.073530739@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130410224333.114387235@linuxfoundation.org>
References: <20130410224333.114387235@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jani Nikula <jani.nikula@intel.com>

commit 5559ecadad5a73b27f863e92f4b4f369501dce6f upstream.

Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=44156
Reported-by: Alan Zimmerman <alan.zimm@gmail.com>
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/intel_display.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -8907,6 +8907,9 @@ static struct intel_quirk intel_quirks[]
 
 	/* Acer/eMachines e725 */
 	{ 0x2a42, 0x1025, 0x0212, quirk_invert_brightness },
+
+	/* Acer/Packard Bell NCL20 */
+	{ 0x2a42, 0x1025, 0x034b, quirk_invert_brightness },
 };
 
 static void intel_init_quirks(struct drm_device *dev)


