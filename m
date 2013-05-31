Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757736Ab3EaW0h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 18:26:37 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:57532 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757441Ab3EaWXG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 18:23:06 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: patches@lists.linaro.org, linux-arm-kernel@lists.infradead.org,
        Arnd Bergmann <arnd@arndb.de>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        linux-media@vger.kernel.org,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: [PATCH 13/15] [media] omap3isp: include linux/mm_types.h
Date: Sat,  1 Jun 2013 00:22:50 +0200
Message-Id: <1370038972-2318779-14-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1370038972-2318779-1-git-send-email-arnd@arndb.de>
References: <1370038972-2318779-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:z1j8t7Cyv9/WwXa4HCgvvXziI9xR6wjpXpa/8teOAnM
 tkHmpuHi0X8Bv8NH+mHDKsyWUQ+Okt1r6P9jd7mbBV1Yj1faa8
 Jn3hAJ2QkE1DDOgFf6btyltixwvKzmowk6DlmfQMzhLtfNNGm1
 0GePD83PGwO7s0w2nyvLdjN+VMzSpyWdoUxGFYcLfERXlsG7xu
 KmdJBZqFdElZEJni8fr4dVcMK4hzTvXTuaF8m1DeJy34QiILrf
 th18Vvd5kraNgHsoQZDcUy38fj+EXUf9lRnQwKfl/5+GFX1zrQ
 8hybcTzrP9ogIE9/YF/09b2E+oYRZkVRTeD1CNajR2yd0Q9thU
 7DGfT+KLe9hr+SCI7t7Fmu96eJV6JImzfyn8mmmwh
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ispqueue.h file uses vm_flags_t, which is defined in
linux/mm_types.h, so we must include that header in order
to build in all configurations.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org
Cc: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/platform/omap3isp/ispqueue.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/platform/omap3isp/ispqueue.h b/drivers/media/platform/omap3isp/ispqueue.h
index 908dfd7..e6e720c 100644
--- a/drivers/media/platform/omap3isp/ispqueue.h
+++ b/drivers/media/platform/omap3isp/ispqueue.h
@@ -31,6 +31,7 @@
 #include <linux/mutex.h>
 #include <linux/videodev2.h>
 #include <linux/wait.h>
+#include <linux/mm_types.h>
 
 struct isp_video_queue;
 struct page;
-- 
1.8.1.2

