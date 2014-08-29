Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753988AbaH2Ocd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 10:32:33 -0400
Received: from smtp105.ord1c.emailsrvr.com ([108.166.43.105]:38872 "EHLO
	smtp105.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753634AbaH2Ocb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 10:32:31 -0400
X-Sender-Id: pramod.gurav@smartplayin.com
From: Pramod Gurav <pramod.gurav@smartplayin.com>
To: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: Pramod Gurav <pramod.gurav@smartplayin.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Andy Gross <agross@codeaurora.org>
Subject: [PATCH v3 3/4] pinctrl: msm: Add ps_hold function in pinctrl-apq8064 binding documentation
Date: Fri, 29 Aug 2014 20:00:58 +0530
Message-Id: <1409322659-17693-4-git-send-email-pramod.gurav@smartplayin.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1409322659-17693-1-git-send-email-pramod.gurav@smartplayin.com>
References: <1409322659-17693-1-git-send-email-pramod.gurav@smartplayin.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds a function ps_hold (Power Suppy Hold Signal) in pinctrl-ap8064
documentation which was missing. This function is used to reset the targets
with apq8064 soc.

CC: Linus Walleij <linus.walleij@linaro.org>
Acked-by: Bjorn Andersson <bjorn.andersson@sonymobile.com>
CC: "Ivan T. Ivanov" <iivanov@mm-sol.com>
CC: Stephen Boyd <sboyd@codeaurora.org>
CC: Andy Gross <agross@codeaurora.org>

Signed-off-by: Pramod Gurav <pramod.gurav@smartplayin.com>
---
 .../bindings/pinctrl/qcom,apq8064-pinctrl.txt      |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/devicetree/bindings/pinctrl/qcom,apq8064-pinctrl.txt b/Documentation/devicetree/bindings/pinctrl/qcom,apq8064-pinctrl.txt
index 0211c6d..ca5bfa5 100644
--- a/Documentation/devicetree/bindings/pinctrl/qcom,apq8064-pinctrl.txt
+++ b/Documentation/devicetree/bindings/pinctrl/qcom,apq8064-pinctrl.txt
@@ -50,7 +50,7 @@ Valid values for function are:
   gsbi4_cam_i2c, gsbi5, gsbi5_spi_cs1, gsbi5_spi_cs2, gsbi5_spi_cs3, gsbi6,
   gsbi6_spi_cs1, gsbi6_spi_cs2, gsbi6_spi_cs3, gsbi7, gsbi7_spi_cs1,
   gsbi7_spi_cs2, gsbi7_spi_cs3, gsbi_cam_i2c, hdmi, mi2s, riva_bt, riva_fm,
-  riva_wlan, sdc2, sdc4, slimbus, spkr_i2s, tsif1, tsif2, usb2_hsic,
+  riva_wlan, sdc2, sdc4, slimbus, spkr_i2s, tsif1, tsif2, usb2_hsic, ps_hold
 
 Example:
 
-- 
1.7.0.4

