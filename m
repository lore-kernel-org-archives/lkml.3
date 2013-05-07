Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933748Ab3EGECy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 00:02:54 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:23027 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758076Ab3EGD6z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 23:58:55 -0400
X-Authority-Analysis: v=2.0 cv=UY7TuduN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=f4cYkUrvIiYA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=_NzHBThYImoA:10 a=QyXUC8HyAAAA:8 a=e5mUnYsNAAAA:8 a=pGLkceISAAAA:8 a=fC4T7qsy4_4xvlMS5R0A:9 a=dGJ0OcVc7YAA:10 a=MSl-tDqOz04A:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130507035847.069192044@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 06 May 2013 23:57:49 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Alan Zimmerman <alan.zimm@gmail.com>, Jani Nikula <jani.nikula@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [037/126] drm/i915: add quirk to invert brightness on Packard Bell NCL20
References: <20130507035712.909872333@goodmis.org>
Content-Disposition: inline; filename=0037-drm-i915-add-quirk-to-invert-brightness-on-Packard-B.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.3 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Jani Nikula <jani.nikula@intel.com>

[ Upstream commit 5559ecadad5a73b27f863e92f4b4f369501dce6f ]

Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=44156
Reported-by: Alan Zimmerman <alan.zimm@gmail.com>
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/gpu/drm/i915/intel_display.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index b7d47dd..e7ec168 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -7159,6 +7159,9 @@ static struct intel_quirk intel_quirks[] = {
 
 	/* Acer/eMachines e725 */
 	{ 0x2a42, 0x1025, 0x0212, quirk_invert_brightness },
+
+	/* Acer/Packard Bell NCL20 */
+	{ 0x2a42, 0x1025, 0x034b, quirk_invert_brightness },
 };
 
 static void intel_init_quirks(struct drm_device *dev)
-- 
1.7.10.4


