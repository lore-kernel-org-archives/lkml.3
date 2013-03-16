Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752181Ab3CPEVh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Mar 2013 00:21:37 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:61261 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750877Ab3CPEVg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Mar 2013 00:21:36 -0400
Message-ID: <1363407672.3898.1.camel@phoenix>
Subject: [PATCH RESEND] gpio: samsung: Add terminating entry for
 exynos_pinctrl_ids
From: Axel Lin <axel.lin@ingics.com>
To: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>
Cc: Kukjin Kim <kgene.kim@samsung.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Tomasz Figa <t.figa@samsung.com>, linux-kernel@vger.kernel.org
Date: Sat, 16 Mar 2013 12:21:12 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The of_device_id table is supposed to be zero-terminated.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
Acked-by: Grant Likely <grant.likely@secretlab.ca>
---
This patch was sent on https://lkml.org/lkml/2012/12/9/135
Re-generate the patch against linux-next and resend.

 drivers/gpio/gpio-samsung.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpio/gpio-samsung.c b/drivers/gpio/gpio-samsung.c
index 99e0fa4..b22ca79 100644
--- a/drivers/gpio/gpio-samsung.c
+++ b/drivers/gpio/gpio-samsung.c
@@ -3030,6 +3030,7 @@ static __init int samsung_gpiolib_init(void)
 		{ .compatible = "samsung,exynos4x12-pinctrl", },
 		{ .compatible = "samsung,exynos5250-pinctrl", },
 		{ .compatible = "samsung,exynos5440-pinctrl", },
+		{ }
 	};
 	for_each_matching_node(pctrl_np, exynos_pinctrl_ids)
 		if (pctrl_np && of_device_is_available(pctrl_np))
-- 
1.7.9.5



