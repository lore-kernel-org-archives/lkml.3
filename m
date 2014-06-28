Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751787AbaF1Vrc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 17:47:32 -0400
Received: from mail-la0-f41.google.com ([209.85.215.41]:57242 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751389AbaF1Vra (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 17:47:30 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@linaro.org>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Rob Herring <robh+dt@kernel.org>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH] pinctrl: pinctrl-imx27.c:  Cleaning up remove a struct that is unused
Date: Sat, 28 Jun 2014 23:48:40 +0200
Message-Id: <1403992120-8160-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removal of a struct that is never used

This was found using a static code analysis program called cppcheck

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/pinctrl/pinctrl-imx27.c |    6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-imx27.c b/drivers/pinctrl/pinctrl-imx27.c
index 417c992..27ae7ce 100644
--- a/drivers/pinctrl/pinctrl-imx27.c
+++ b/drivers/pinctrl/pinctrl-imx27.c
@@ -440,12 +440,6 @@ static struct of_device_id imx27_pinctrl_of_match[] = {
 	{ /* sentinel */ }
 };
 
-struct imx27_pinctrl_private {
-	int num_gpio_childs;
-	struct platform_device **gpio_dev;
-	struct mxc_gpio_platform_data *gpio_pdata;
-};
-
 static int imx27_pinctrl_probe(struct platform_device *pdev)
 {
 	return imx1_pinctrl_core_probe(pdev, &imx27_pinctrl_info);
-- 
1.7.10.4

