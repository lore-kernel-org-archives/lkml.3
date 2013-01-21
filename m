Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756873Ab3AUVOK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 16:14:10 -0500
Received: from mail-we0-f178.google.com ([74.125.82.178]:34811 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752074Ab3AUVOI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 16:14:08 -0500
From: Laurent Navet <laurent.navet@gmail.com>
To: linux-pcmcia@lists.infradead.org
Cc: plagnioj@jcrosoft.com, gregkh@linuxfoundation.org, nicolas.ferre@atmel.com,
        wfp5p@virginia.edu, linux-kernel@vger.kernel.org,
        Laurent Navet <laurent.navet@gmail.com>
Subject: [PATCH 3/3] drivers: pcmcia: electra_cf.c fix checkpatch error and warnings
Date: Mon, 21 Jan 2013 22:16:06 +0100
Message-Id: <1358802966-10430-4-git-send-email-laurent.navet@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1358802966-10430-1-git-send-email-laurent.navet@gmail.com>
References: <1358802966-10430-1-git-send-email-laurent.navet@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fix these checkpatch errors and warning:
- ERROR: "foo *           bar" should be "foo *bar"
- WARNING: please, no space before tabs
- WARNING: sizeof *cf should be sizeof(*cf)
- WARNING: space prohibited between function name and open parenthesis '('i

Signed-off-by: Laurent Navet <laurent.navet@gmail.com>
---
 drivers/pcmcia/electra_cf.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/pcmcia/electra_cf.c b/drivers/pcmcia/electra_cf.c
index a007321a..7c5cfa26 100644
--- a/drivers/pcmcia/electra_cf.c
+++ b/drivers/pcmcia/electra_cf.c
@@ -46,14 +46,14 @@ struct electra_cf_socket {
 
 	struct platform_device	*ofdev;
 	unsigned long		mem_phys;
-	void __iomem *		mem_base;
+	void __iomem		*mem_base;
 	unsigned long		mem_size;
-	void __iomem *		io_virt;
+	void __iomem		*io_virt;
 	unsigned int		io_base;
 	unsigned int		io_size;
 	u_int			irq;
 	struct resource		iomem;
-	void __iomem *		gpio_base;
+	void __iomem		*gpio_base;
 	int			gpio_detect;
 	int			gpio_vsense;
 	int			gpio_3v;
@@ -200,7 +200,7 @@ static int electra_cf_probe(struct platform_device *ofdev)
 	if (err)
 		return -EINVAL;
 
-	cf = kzalloc(sizeof *cf, GFP_KERNEL);
+	cf = kzalloc(sizeof(*cf), GFP_KERNEL);
 	if (!cf)
 		return -ENOMEM;
 
@@ -368,5 +368,5 @@ static struct platform_driver electra_cf_driver = {
 module_platform_driver(electra_cf_driver);
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR ("Olof Johansson <olof@lixom.net>");
+MODULE_AUTHOR("Olof Johansson <olof@lixom.net>");
 MODULE_DESCRIPTION("PA Semi Electra CF driver");
-- 
1.7.10.4

