Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753504AbaKZPPL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 10:15:11 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:59498 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753422AbaKZPPE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 10:15:04 -0500
From: Richard Fitzgerald <rf@opensource.wolfsonmicro.com>
To: lee.jones@linaro.org, broonie@kernel.org
Cc: cw00.choi@samsung.com, linus.walleij@linaro.org,
        devicetree@vger.kernel.org, alsa-devel@alsa-project.org,
        patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        linux-gpio@vger.kernel.org, ckeepax@opensource.wolfsonmicro.com
Subject: [PATCH V2 3/6] regulator: arizona-micsupp: Add support for WM8280/WM8281
Date: Wed, 26 Nov 2014 15:13:05 +0000
Message-Id: <1417014788-8311-4-git-send-email-rf@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1417014788-8311-1-git-send-email-rf@opensource.wolfsonmicro.com>
References: <1417014788-8311-1-git-send-email-rf@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Richard Fitzgerald <rf@opensource.wolfsonmicro.com>
---
 drivers/regulator/arizona-micsupp.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/regulator/arizona-micsupp.c b/drivers/regulator/arizona-micsupp.c
index ce9aca5..4ff55e1 100644
--- a/drivers/regulator/arizona-micsupp.c
+++ b/drivers/regulator/arizona-micsupp.c
@@ -245,6 +245,7 @@ static int arizona_micsupp_probe(struct platform_device *pdev)
 	 */
 	switch (arizona->type) {
 	case WM5110:
+	case WM8280:
 		desc = &arizona_micsupp_ext;
 		micsupp->init_data = arizona_micsupp_ext_default;
 		break;
-- 
1.7.2.5

