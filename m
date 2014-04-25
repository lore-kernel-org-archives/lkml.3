Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932077AbaDYUmL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 16:42:11 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:34450 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755131AbaDYUmG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 16:42:06 -0400
From: Andy Gross <agross@codeaurora.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Andy Gross <agross@codeaurora.org>
Subject: [PATCH] pinctrl: qcom: Correct name for pin 0
Date: Fri, 25 Apr 2014 15:41:55 -0500
Message-Id: <1398458515-15654-1-git-send-email-agross@codeaurora.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix copy/paste error in pinctrl_pin_desc for pin 0.

Signed-off-by: Andy Gross <agross@codeaurora.org>
---
 drivers/pinctrl/pinctrl-ipq8064.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/pinctrl-ipq8064.c b/drivers/pinctrl/pinctrl-ipq8064.c
index 1700b49..54aba9f 100644
--- a/drivers/pinctrl/pinctrl-ipq8064.c
+++ b/drivers/pinctrl/pinctrl-ipq8064.c
@@ -20,7 +20,7 @@
 #include "pinctrl-msm.h"
 
 static const struct pinctrl_pin_desc ipq8064_pins[] = {
-	PINCTRL_PIN(0, "GPIO_1"),
+	PINCTRL_PIN(0, "GPIO_0"),
 	PINCTRL_PIN(1, "GPIO_1"),
 	PINCTRL_PIN(2, "GPIO_2"),
 	PINCTRL_PIN(3, "GPIO_3"),
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

