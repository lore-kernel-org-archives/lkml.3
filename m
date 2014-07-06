Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751938AbaGFRYm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2014 13:24:42 -0400
Received: from mail-we0-f181.google.com ([74.125.82.181]:64841 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751886AbaGFRYk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2014 13:24:40 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Jingoo Han <jg1.han@samsung.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Rob Clark <robdclark@gmail.com>, David Ung <davidu@nvidia.com>,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] video: fbdev: core: fbmon.c:  Cleaning up useless assignment of function parameter
Date: Sun,  6 Jul 2014 19:25:55 +0200
Message-Id: <1404667555-14675-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove assignment of function parameter, that has no effect outside the function

This was found using a static code analysis program called cppcheck

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/video/fbdev/core/fbmon.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/video/fbdev/core/fbmon.c b/drivers/video/fbdev/core/fbmon.c
index 5b0e313..71ec1ab 100644
--- a/drivers/video/fbdev/core/fbmon.c
+++ b/drivers/video/fbdev/core/fbmon.c
@@ -1481,7 +1481,6 @@ int fb_parse_edid(unsigned char *edid, struct fb_var_screeninfo *var)
 }
 void fb_edid_to_monspecs(unsigned char *edid, struct fb_monspecs *specs)
 {
-	specs = NULL;
 }
 void fb_edid_add_monspecs(unsigned char *edid, struct fb_monspecs *specs)
 {
-- 
1.7.10.4

