Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753091AbaDODLc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 23:11:32 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:49516 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751120AbaDODLL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 23:11:11 -0400
From: Andy Gross <agross@codeaurora.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        Andy Gross <agross@codeaurora.org>
Subject: [PATCH 3/3] ARM: qcom: Select PINCTRL by default for ARCH_QCOM
Date: Mon, 14 Apr 2014 22:10:37 -0500
Message-Id: <1397531437-9104-4-git-send-email-agross@codeaurora.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1397531437-9104-1-git-send-email-agross@codeaurora.org>
References: <1397531437-9104-1-git-send-email-agross@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add missing PINCTRL selection.  This enables selection of pinctrollers for
Qualcomm processors.

Signed-off-by: Andy Gross <agross@codeaurora.org>
---
 arch/arm/mach-qcom/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/mach-qcom/Kconfig b/arch/arm/mach-qcom/Kconfig
index aded06d..2c561c0 100644
--- a/arch/arm/mach-qcom/Kconfig
+++ b/arch/arm/mach-qcom/Kconfig
@@ -5,6 +5,7 @@ config ARCH_QCOM
 	select CLKSRC_OF
 	select GENERIC_CLOCKEVENTS
 	select HAVE_SMP
+	select PINCTRL
 	select QCOM_SCM if SMP
 	help
 	  Support for Qualcomm's devicetree based systems.
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

