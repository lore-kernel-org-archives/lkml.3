Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753395AbaEOKJM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 06:09:12 -0400
Received: from mail-we0-f182.google.com ([74.125.82.182]:42533 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751831AbaEOKJK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 06:09:10 -0400
From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
To: Kumar Gala <galak@codeaurora.org>
Cc: David Brown <davidb@codeaurora.org>, Russell King <linux@arm.linux.org.uk>,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH] ARM: QCOM: Enable ARM_AMBA option for Qcom SOCS.
Date: Thu, 15 May 2014 11:08:55 +0100
Message-Id: <1400148535-30772-1-git-send-email-srinivas.kandagatla@linaro.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As some of the IPs on Qualcomm SOCs are based on ARM PrimeCell IPs.
For example SDCC controller is PrimeCell MCI pl180. Adding this option will
give flexibility to reuse the existing drivers as it is without major
modifications.

Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
---
 arch/arm/mach-qcom/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/mach-qcom/Kconfig b/arch/arm/mach-qcom/Kconfig
index a028be2..5bac591 100644
--- a/arch/arm/mach-qcom/Kconfig
+++ b/arch/arm/mach-qcom/Kconfig
@@ -2,6 +2,7 @@ config ARCH_QCOM
 	bool "Qualcomm Support" if ARCH_MULTI_V7
 	select ARCH_REQUIRE_GPIOLIB
 	select ARM_GIC
+	select ARM_AMBA
 	select CLKSRC_OF
 	select GENERIC_CLOCKEVENTS
 	select HAVE_SMP
-- 
1.9.1

