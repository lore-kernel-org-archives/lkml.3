Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757145AbaEISIb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 14:08:31 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:45648 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752137AbaEISI3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 14:08:29 -0400
From: Kumar Gala <galak@codeaurora.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Kumar Gala <galak@codeaurora.org>, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Andy Gross <agross@codeaurora.org>
Subject: [PATCH] pinctrl: qcom: ipq8064: Fix naming convention
Date: Fri,  9 May 2014 13:08:25 -0500
Message-Id: <1399658905-12415-1-git-send-email-galak@codeaurora.org>
X-Mailer: git-send-email 1.8.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Drop underscore in spdif_groups to match all other groups.

Signed-off-by: Kumar Gala <galak@codeaurora.org>
---
 drivers/pinctrl/pinctrl-ipq8064.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/pinctrl-ipq8064.c b/drivers/pinctrl/pinctrl-ipq8064.c
index 54aba9f..acafea4 100644
--- a/drivers/pinctrl/pinctrl-ipq8064.c
+++ b/drivers/pinctrl/pinctrl-ipq8064.c
@@ -366,7 +366,7 @@ static const char * const sdc1_groups[] = {
 };
 
 static const char * const spdif_groups[] = {
-	"gpio_10", "gpio_48",
+	"gpio10", "gpio48",
 };
 
 static const char * const nand_groups[] = {
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

