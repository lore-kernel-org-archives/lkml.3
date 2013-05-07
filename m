Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756225Ab3EGECw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 00:02:52 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:22102 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760362Ab3EGD64 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 23:58:56 -0400
X-Authority-Analysis: v=2.0 cv=DKcNElxb c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=eFpm0cPEAPsA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=qTRcPV6HCAYA:10 a=QyXUC8HyAAAA:8 a=e5mUnYsNAAAA:8 a=fC4T7qsy4_4xvlMS5R0A:9 a=dGJ0OcVc7YAA:10 a=jTbnE2AvvFoA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130507035846.673817721@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 06 May 2013 23:57:47 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Roland Gruber <post@rolandgruber.de>, Jani Nikula <jani.nikula@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [035/126] drm/i915: add quirk to invert brightness on eMachines G725
References: <20130507035712.909872333@goodmis.org>
Content-Disposition: inline; filename=0035-drm-i915-add-quirk-to-invert-brightness-on-eMachines.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.3 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Jani Nikula <jani.nikula@intel.com>

[ Upstream commit 1ffff60320879830e469e26062c18f75236822ba ]

Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=59628
Reported-by: Roland Gruber <post@rolandgruber.de>
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/gpu/drm/i915/intel_display.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index 379abcb..53c883d 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -7153,6 +7153,9 @@ static struct intel_quirk intel_quirks[] = {
 
 	/* Acer Aspire 5734Z must invert backlight brightness */
 	{ 0x2a42, 0x1025, 0x0459, quirk_invert_brightness },
+
+	/* Acer/eMachines G725 */
+	{ 0x2a42, 0x1025, 0x0210, quirk_invert_brightness },
 };
 
 static void intel_init_quirks(struct drm_device *dev)
-- 
1.7.10.4


