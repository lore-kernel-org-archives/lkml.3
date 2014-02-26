Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753851AbaBZTCa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 14:02:30 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:52651 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753404AbaBZS7e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 13:59:34 -0500
From: Stephen Boyd <sboyd@codeaurora.org>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH v4 7/8] mfd: pm8921: Loosen Kconfig dependency
Date: Wed, 26 Feb 2014 10:59:25 -0800
Message-Id: <1393441166-32692-8-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.9.0.1.gd5ccf8c
In-Reply-To: <1393441166-32692-1-git-send-email-sboyd@codeaurora.org>
References: <1393441166-32692-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow this driver to be compiled on all ARM builds as it doesn't
rely on anything within arm/mach-msm.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 drivers/mfd/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index be98d88acfb8..42d592a2e392 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -473,7 +473,7 @@ config MFD_PM8XXX
 
 config MFD_PM8921_CORE
 	tristate "Qualcomm PM8921 PMIC chip"
-	depends on (ARCH_MSM || HEXAGON)
+	depends on (ARM || HEXAGON)
 	select IRQ_DOMAIN
 	select MFD_CORE
 	select MFD_PM8XXX
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

