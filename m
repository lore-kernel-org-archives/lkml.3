Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752101Ab3JTWPO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Oct 2013 18:15:14 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:1500 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751878Ab3JTWPJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Oct 2013 18:15:09 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Sun, 20 Oct 2013 15:15:08 -0700
From: Alexandre Courbot <acourbot@nvidia.com>
To: Linus Walleij <linus.walleij@linaro.org>
CC: <linux-gpio@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <gnurou@gmail.com>, Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH 2/3] gpiolib: devres: add missing headers
Date: Sun, 20 Oct 2013 15:14:58 -0700
Message-ID: <1382307299-22587-3-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.8.4.1
In-Reply-To: <1382307299-22587-1-git-send-email-acourbot@nvidia.com>
References: <1382307299-22587-1-git-send-email-acourbot@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add missing headers for drivers/gpiolib/devres.c.

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
---
 drivers/gpio/devres.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpio/devres.c b/drivers/gpio/devres.c
index fceebdc..307464f 100644
--- a/drivers/gpio/devres.c
+++ b/drivers/gpio/devres.c
@@ -15,7 +15,9 @@
  */
 
 #include <linux/module.h>
+#include <linux/err.h>
 #include <linux/gpio.h>
+#include <linux/gpio/consumer.h>
 #include <linux/device.h>
 #include <linux/gfp.h>
 
-- 
1.8.4.1

