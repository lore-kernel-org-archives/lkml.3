Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754825AbaJWAGq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 20:06:46 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:37487 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754028AbaJWAGo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 20:06:44 -0400
From: Masanari Iida <standby24x7@gmail.com>
To: airlied@linux.ie, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Cc: corbet@lwn.net, Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] gpu: drm: Fix warning caused by a parameter description in drm_crtc.c
Date: Thu, 23 Oct 2014 09:06:28 +0900
Message-Id: <1414022788-32224-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 2.1.2.451.g98349e5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fix following error while "make xmldocs"

Warning(.//drivers/gpu/drm/drm_crtc.c:778): Excess function parameter
 'mode' description in 'drm_connector_get_cmdline_mode'

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 drivers/gpu/drm/drm_crtc.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/gpu/drm/drm_crtc.c b/drivers/gpu/drm/drm_crtc.c
index e79c8d3..171f9a5 100644
--- a/drivers/gpu/drm/drm_crtc.c
+++ b/drivers/gpu/drm/drm_crtc.c
@@ -766,7 +766,6 @@ static void drm_mode_remove(struct drm_connector *connector,
 /**
  * drm_connector_get_cmdline_mode - reads the user's cmdline mode
  * @connector: connector to quwery
- * @mode: returned mode
  *
  * The kernel supports per-connector configration of its consoles through
  * use of the video= parameter. This function parses that option and
-- 
2.1.2.451.g98349e5

