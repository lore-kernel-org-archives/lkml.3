Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752958AbaKDJ4N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 04:56:13 -0500
Received: from down.free-electrons.com ([37.187.137.238]:60840 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752853AbaKDJzd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 04:55:33 -0500
From: Boris Brezillon <boris.brezillon@free-electrons.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-api@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Boris Brezillon <boris.brezillon@free-electrons.com>
Subject: [PATCH 15/15] staging: media: Replace v4l2-mediabus.h inclusion with v4l2-mbus.h
Date: Tue,  4 Nov 2014 10:55:10 +0100
Message-Id: <1415094910-15899-16-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415094910-15899-1-git-send-email-boris.brezillon@free-electrons.com>
References: <1415094910-15899-1-git-send-email-boris.brezillon@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The v4l2-mediabus.h header is now deprecated and should be replaced with
v4l2-mbus.h.

Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
---
 drivers/staging/media/omap4iss/iss_csi2.c  | 2 +-
 drivers/staging/media/omap4iss/iss_video.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/media/omap4iss/iss_csi2.c b/drivers/staging/media/omap4iss/iss_csi2.c
index b72e530..f47e4e5 100644
--- a/drivers/staging/media/omap4iss/iss_csi2.c
+++ b/drivers/staging/media/omap4iss/iss_csi2.c
@@ -13,7 +13,7 @@
 
 #include <linux/delay.h>
 #include <media/v4l2-common.h>
-#include <linux/v4l2-mediabus.h>
+#include <linux/v4l2-mbus.h>
 #include <linux/mm.h>
 
 #include "iss.h"
diff --git a/drivers/staging/media/omap4iss/iss_video.h b/drivers/staging/media/omap4iss/iss_video.h
index cc8146b..a028b51 100644
--- a/drivers/staging/media/omap4iss/iss_video.h
+++ b/drivers/staging/media/omap4iss/iss_video.h
@@ -14,7 +14,7 @@
 #ifndef OMAP4_ISS_VIDEO_H
 #define OMAP4_ISS_VIDEO_H
 
-#include <linux/v4l2-mediabus.h>
+#include <linux/v4l2-mbus.h>
 #include <media/media-entity.h>
 #include <media/v4l2-dev.h>
 #include <media/v4l2-fh.h>
-- 
1.9.1

