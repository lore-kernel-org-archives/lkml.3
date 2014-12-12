Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031164AbaLLRSi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 12:18:38 -0500
Received: from ns.mm-sol.com ([37.157.136.199]:33800 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031141AbaLLRSe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 12:18:34 -0500
From: Stanimir Varbanov <svarbanov@mm-sol.com>
To: Rob Herring <robh+dt@kernel.org>, Kumar Gala <galak@codeaurora.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Grant Likely <grant.likely@linaro.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-pci@vger.kernel.org, Stanimir Varbanov <svarbanov@mm-sol.com>
Subject: [PATCH 5/5] ARM: qcom: Add Qualcomm APQ8084 SoC
Date: Fri, 12 Dec 2014 19:14:01 +0200
Message-Id: <1418404441-5518-6-git-send-email-svarbanov@mm-sol.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1418404441-5518-1-git-send-email-svarbanov@mm-sol.com>
References: <1418404441-5518-1-git-send-email-svarbanov@mm-sol.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds Snapdragon 805 ARM-based SoC as multiplatform
compatible platform.

Signed-off-by: Stanimir Varbanov <svarbanov@mm-sol.com>
---
 arch/arm/mach-qcom/Kconfig |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-qcom/Kconfig b/arch/arm/mach-qcom/Kconfig
index ee5697b..b8abe7d 100644
--- a/arch/arm/mach-qcom/Kconfig
+++ b/arch/arm/mach-qcom/Kconfig
@@ -23,6 +23,13 @@ config ARCH_MSM8974
 	bool "Enable support for MSM8974"
 	select HAVE_ARM_ARCH_TIMER
 
+config ARCH_APQ8084
+	bool "Enable support for APQ8084"
+	select HAVE_ARM_ARCH_TIMER
+	select PCI
+	select PCI_DOMAINS
+	select PCI_MSI
+
 config QCOM_SCM
 	bool
 
-- 
1.7.0.4

