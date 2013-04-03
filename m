Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762239Ab3DCIq2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 04:46:28 -0400
Received: from mail-ee0-f51.google.com ([74.125.83.51]:49592 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762155Ab3DCIq0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 04:46:26 -0400
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: Felipe Balbi <balbi@ti.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Praveena Nadahally <praveen.nadahally@stericsson.com>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        Fabio Baltieri <fabio.baltieri@linaro.org>
Subject: [PATCH 01/12] usb: musb: ux500_dma: drop references to U5500
Date: Wed,  3 Apr 2013 10:45:02 +0200
Message-Id: <1364978713-19612-2-git-send-email-fabio.baltieri@linaro.org>
X-Mailer: git-send-email 1.8.1.3
In-Reply-To: <1364978713-19612-1-git-send-email-fabio.baltieri@linaro.org>
References: <1364978713-19612-1-git-send-email-fabio.baltieri@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Drop references to deprecated U5500 platform in driver comments.

Acked-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Fabio Baltieri <fabio.baltieri@linaro.org>
---
 drivers/usb/musb/ux500_dma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/musb/ux500_dma.c b/drivers/usb/musb/ux500_dma.c
index f417b7e..3381206 100644
--- a/drivers/usb/musb/ux500_dma.c
+++ b/drivers/usb/musb/ux500_dma.c
@@ -1,7 +1,7 @@
 /*
  * drivers/usb/musb/ux500_dma.c
  *
- * U8500 and U5500 DMA support code
+ * U8500 DMA support code
  *
  * Copyright (C) 2009 STMicroelectronics
  * Copyright (C) 2011 ST-Ericsson SA
-- 
1.8.1.3

