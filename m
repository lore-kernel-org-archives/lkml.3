Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753601AbaI3SKe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 14:10:34 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:36294 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753525AbaI3SKb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 14:10:31 -0400
MIME-Version: 1.0
Date: Tue, 30 Sep 2014 19:10:30 +0100
Message-ID: <CABz95_CN0eDwfgpTTBq0QymxtPJBYmBWw0X5K=Xa4rVKddrrzA@mail.gmail.com>
Subject: [PATCH] zram: trivial improvements to the startup message
From: Steven Honeyman <stevenhoneyman@gmail.com>
To: Minchan Kim <minchan@kernel.org>, Nitin Gupta <ngupta@vflare.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Originally I intended to just remove the ellipsis, because it usually
signifies that something is in progress and will take some time to
complete.
The plural "device"/"devices" is just a bonus addition, because it was
in the same line I was editing!

Signed-off-by: Steven Honeyman <stevenhoneyman@gmail.com>
---
 drivers/block/zram/zram_drv.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index d00831c..71e6fe0 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -1018,7 +1018,8 @@ static int __init zram_init(void)
             goto free_devices;
     }

-    pr_info("Created %u device(s) ...\n", num_devices);
+    pr_info("Created %u device%s\n", num_devices,
+                num_devices > 1 ? "s" : "");

     return 0;

-- 
2.1.1
