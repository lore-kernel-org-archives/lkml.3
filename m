Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752097AbaHIRKP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2014 13:10:15 -0400
Received: from [117.192.104.190] ([117.192.104.190]:52258 "EHLO suman"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751815AbaHIRKM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2014 13:10:12 -0400
From: Suman Kumar <suman@inforcecomputing.com>
To: g.liakhovetski@gmx.de
Cc: m.chehab@samsung.com, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, suman@inforcecomputing.com
Subject: [PATCH] staging: soc_camera: soc_camera_platform.c: Fixed a Missing blank line coding style issue
Date: Sat,  9 Aug 2014 22:40:05 +0530
Message-Id: <1407604205-14920-1-git-send-email-suman@inforcecomputing.com>
X-Mailer: git-send-email 1.8.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

    Fixes a coding style issue reported by checkpatch.pl

Signed-off-by: Suman Kumar <suman@inforcecomputing.com>
---
 drivers/media/platform/soc_camera/soc_camera_platform.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/platform/soc_camera/soc_camera_platform.c b/drivers/media/platform/soc_camera/soc_camera_platform.c
index ceaddfb..fe15a80 100644
--- a/drivers/media/platform/soc_camera/soc_camera_platform.c
+++ b/drivers/media/platform/soc_camera/soc_camera_platform.c
@@ -27,12 +27,14 @@ struct soc_camera_platform_priv {
 static struct soc_camera_platform_priv *get_priv(struct platform_device *pdev)
 {
 	struct v4l2_subdev *subdev = platform_get_drvdata(pdev);
+
 	return container_of(subdev, struct soc_camera_platform_priv, subdev);
 }
 
 static int soc_camera_platform_s_stream(struct v4l2_subdev *sd, int enable)
 {
 	struct soc_camera_platform_info *p = v4l2_get_subdevdata(sd);
+
 	return p->set_capture(p, enable);
 }
 
-- 
1.8.2

