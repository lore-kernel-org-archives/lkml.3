Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753404AbbAQP1P (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2015 10:27:15 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42055 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751922AbbAQP0L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2015 10:26:11 -0500
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: lee.jones@linaro.org
Cc: broonie@kernel.org, cw00.choi@samsung.com, linus.walleij@linaro.org,
        devicetree@vger.kernel.org, alsa-devel@alsa-project.org,
        patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        linux-gpio@vger.kernel.org, rf@opensource.wolfsonmicro.com
Subject: [RESEND PATCH 5/6] extcon: arizona: Add support for WM8280/WM8281
Date: Sat, 17 Jan 2015 15:21:26 +0000
Message-Id: <1421508087-22311-6-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1421508087-22311-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
References: <1421508087-22311-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Richard Fitzgerald <rf@opensource.wolfsonmicro.com>

Signed-off-by: Richard Fitzgerald <rf@opensource.wolfsonmicro.com>
Acked-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
---
 drivers/extcon/extcon-arizona.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/extcon/extcon-arizona.c b/drivers/extcon/extcon-arizona.c
index ba51588..3abe866 100644
--- a/drivers/extcon/extcon-arizona.c
+++ b/drivers/extcon/extcon-arizona.c
@@ -1149,6 +1149,7 @@ static int arizona_extcon_probe(struct platform_device *pdev)
 		}
 		break;
 	case WM5110:
+	case WM8280:
 		switch (arizona->rev) {
 		case 0 ... 2:
 			break;
-- 
1.7.2.5

