Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751299Ab3G0KGQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jul 2013 06:06:16 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:62300 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751188Ab3G0KGP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jul 2013 06:06:15 -0400
From: Kefeng Wang <wangkefeng.wang@huawei.com>
To: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>, <linux-fbdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC: Jingoo Han <jg1.han@samsung.com>, <guohanjun@huawei.com>
Subject: [PATCH] video: remove unused variable dev
Date: Sat, 27 Jul 2013 18:05:13 +0800
Message-ID: <1374919513-15356-1-git-send-email-wangkefeng.wang@huawei.com>
X-Mailer: git-send-email 1.8.3.msysgit.0
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.135.68.221]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Due to commit: e21d2170f [video: remove unnecessary platform_set_drvdata()],
variable dev is unused, so remove it.

Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
---
 drivers/video/vga16fb.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/video/vga16fb.c b/drivers/video/vga16fb.c
index 830ded4..2827333 100644
--- a/drivers/video/vga16fb.c
+++ b/drivers/video/vga16fb.c
@@ -1265,7 +1265,6 @@ static void vga16fb_imageblit(struct fb_info *info, const struct fb_image *image
 
 static void vga16fb_destroy(struct fb_info *info)
 {
-	struct platform_device *dev = container_of(info->device, struct platform_device, dev);
 	iounmap(info->screen_base);
 	fb_dealloc_cmap(&info->cmap);
 	/* XXX unshare VGA regions */
-- 
1.8.2.2


