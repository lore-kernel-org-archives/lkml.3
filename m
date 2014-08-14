Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932209AbaHNW73 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 18:59:29 -0400
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:5594 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754530AbaHNW72 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 18:59:28 -0400
From: Bjorn Andersson <bjorn.andersson@sonymobile.com>
To: Linus Walleij <linus.walleij@linaro.org>
CC: Kiran Padwal <kiran.padwal@smartplayin.com>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-msm@vger.kernel.org>
Subject: [PATCH] pinctrl: qcom: apq8064: Correct interrupts in example
Date: Thu, 14 Aug 2014 15:59:21 -0700
Message-ID: <1408057161-6940-1-git-send-email-bjorn.andersson@sonymobile.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The example in the binding document indicates that interrupt 32 is used
for the TLMM summary IRQ. Correct this to reduce the confusion.

Signed-off-by: Bjorn Andersson <bjorn.andersson@sonymobile.com>
---
 .../bindings/pinctrl/qcom,apq8064-pinctrl.txt      |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/pinctrl/qcom,apq8064-pinctrl.txt b/Documentation/devicetree/bindings/pinctrl/qcom,apq8064-pinctrl.txt
index 0211c6d..92fae82 100644
--- a/Documentation/devicetree/bindings/pinctrl/qcom,apq8064-pinctrl.txt
+++ b/Documentation/devicetree/bindings/pinctrl/qcom,apq8064-pinctrl.txt
@@ -62,7 +62,7 @@ Example:
 		#gpio-cells = <2>;
 		interrupt-controller;
 		#interrupt-cells = <2>;
-		interrupts = <0 32 0x4>;
+		interrupts = <0 16 0x4>;
 
 		pinctrl-names = "default";
 		pinctrl-0 = <&gsbi5_uart_default>;
-- 
1.7.9.5

