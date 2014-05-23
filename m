Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753396AbaEWPO1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 11:14:27 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:36503 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753351AbaEWPOZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 11:14:25 -0400
From: Georgi Djakov <gdjakov@mm-sol.com>
To: linux@arm.linux.org.uk, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, sboyd@codeaurora.org, rvaswani@codeaurora.org,
        davidb@codeaurora.org
Cc: linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Georgi Djakov <gdjakov@mm-sol.com>
Subject: [PATCH v2 4/4] ARM: debug: qcom: add UART addresses to Kconfig help
Date: Fri, 23 May 2014 18:12:32 +0300
Message-Id: <1400857952-6963-5-git-send-email-gdjakov@mm-sol.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1400857952-6963-1-git-send-email-gdjakov@mm-sol.com>
References: <1400857952-6963-1-git-send-email-gdjakov@mm-sol.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add information about the APQ8084 debug UART physical and virtual
addresses in the DEBUG_QCOM_UARTDM Kconfig help section.
Requires: https://lkml.org/lkml/2014/4/14/312

Signed-off-by: Georgi Djakov <gdjakov@mm-sol.com>
---
 arch/arm/Kconfig.debug |    1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/Kconfig.debug b/arch/arm/Kconfig.debug
index 40ee328..e71723d 100644
--- a/arch/arm/Kconfig.debug
+++ b/arch/arm/Kconfig.debug
@@ -376,6 +376,7 @@ choice
 		  their output to the serial port on Qualcomm devices.
 
 		  ARCH      DEBUG_UART_PHYS   DEBUG_UART_BASE
+		  APQ8084   0xf995e000        0xfa75e000
 		  MSM8X60   0x19c40000        0xf0040000
 		  MSM8960   0x16440000        0xf0040000
 		  MSM8974   0xf991e000        0xfa71e000
-- 
1.7.9.5

