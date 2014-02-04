Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753924AbaBDItl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 03:49:41 -0500
Received: from mail-pb0-f44.google.com ([209.85.160.44]:50931 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751374AbaBDIth (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 03:49:37 -0500
Message-ID: <1391503770.19947.0.camel@phoenix>
Subject: [PATCH] pinctrl: capri: Make capri_pinctrl_probe static
From: Axel Lin <axel.lin@ingics.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Sherman Yin <syin@broadcom.com>, linux-kernel@vger.kernel.org
Date: Tue, 04 Feb 2014 16:49:30 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/pinctrl/pinctrl-capri.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/pinctrl-capri.c b/drivers/pinctrl/pinctrl-capri.c
index 4669c53..b4aa8e3 100644
--- a/drivers/pinctrl/pinctrl-capri.c
+++ b/drivers/pinctrl/pinctrl-capri.c
@@ -1390,7 +1390,7 @@ static struct pinctrl_desc capri_pinctrl_desc = {
 	.owner = THIS_MODULE,
 };
 
-int __init capri_pinctrl_probe(struct platform_device *pdev)
+static int __init capri_pinctrl_probe(struct platform_device *pdev)
 {
 	struct capri_pinctrl_data *pdata = &capri_pinctrl;
 	struct resource *res;
-- 
1.8.1.2



