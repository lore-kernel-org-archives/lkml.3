Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934165Ab3CTMMn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 08:12:43 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:62614 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933681Ab3CTMKl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 08:10:41 -0400
From: Laurent Navet <laurent.navet@gmail.com>
To: grant.likely@secretlab.ca, linus.walleij@linaro.org
Cc: santosh.shilimkar@ti.com, khilman@ti.com, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, Laurent Navet <laurent.navet@gmail.com>
Subject: [PATCH 05/10] gpio: gpio-pxa.c: fix checkpatch errors
Date: Wed, 20 Mar 2013 13:15:59 +0100
Message-Id: <1363781764-17330-6-git-send-email-laurent.navet@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1363781764-17330-1-git-send-email-laurent.navet@gmail.com>
References: <1363781764-17330-1-git-send-email-laurent.navet@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix :
 gpio/gpio-pxa.c:605: ERROR: space required after that ',' (ctx:VxV)
 gpio/gpio-pxa.c:672: ERROR: space prohibited after that open parenthesis '('

Signed-off-by: Laurent Navet <laurent.navet@gmail.com>
---
 drivers/gpio/gpio-pxa.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpio/gpio-pxa.c b/drivers/gpio/gpio-pxa.c
index 9cc108d..6d01914 100644
--- a/drivers/gpio/gpio-pxa.c
+++ b/drivers/gpio/gpio-pxa.c
@@ -602,7 +602,7 @@ static int pxa_gpio_probe(struct platform_device *pdev)
 	for_each_gpio_chip(gpio, c) {
 		writel_relaxed(0, c->regbase + GFER_OFFSET);
 		writel_relaxed(0, c->regbase + GRER_OFFSET);
-		writel_relaxed(~0,c->regbase + GEDR_OFFSET);
+		writel_relaxed(~0, c->regbase + GEDR_OFFSET);
 		/* unmask GPIO edge detect for AP side */
 		if (gpio_is_mmp_type(gpio_type))
 			writel_relaxed(~0, c->regbase + ED_MASK_OFFSET);
@@ -669,7 +669,7 @@ static void pxa_gpio_resume(void)
 
 	for_each_gpio_chip(gpio, c) {
 		/* restore level with set/clear */
-		writel_relaxed( c->saved_gplr, c->regbase + GPSR_OFFSET);
+		writel_relaxed(c->saved_gplr, c->regbase + GPSR_OFFSET);
 		writel_relaxed(~c->saved_gplr, c->regbase + GPCR_OFFSET);
 
 		writel_relaxed(c->saved_grer, c->regbase + GRER_OFFSET);
-- 
1.7.10.4

