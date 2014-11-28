Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751768AbaK1B16 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 20:27:58 -0500
Received: from mail-oi0-f42.google.com ([209.85.218.42]:33235 "EHLO
	mail-oi0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751324AbaK1B1Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 20:27:16 -0500
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: =?UTF-8?q?S=C3=B6ren=20Brinkmann?= <soren.brinkmann@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Alessandro Rubini <rubini@unipv.it>, Heiko Stuebner <heiko@sntech.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-rockchip@lists.infradead.org, linux-sh@vger.kernel.org,
        "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Beniamino Galvani <b.galvani@gmail.com>
Subject: [PATCH v2 5/7] ARM: zynq: Enable pinctrl
Date: Thu, 27 Nov 2014 17:26:31 -0800
Message-Id: <1417137993-8337-6-git-send-email-soren.brinkmann@xilinx.com>
X-Mailer: git-send-email 2.1.3.1.ge241007
In-Reply-To: <1417137993-8337-1-git-send-email-soren.brinkmann@xilinx.com>
References: <1417137993-8337-1-git-send-email-soren.brinkmann@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Select pinctrl and the Zynq pinctrl driver.

Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
Tested-by: Andreas Färber <afaerber@suse.de>
---
Changes since RFC v2:
 - separate mach-zynq changes in their own patch
---
 arch/arm/mach-zynq/Kconfig | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/mach-zynq/Kconfig b/arch/arm/mach-zynq/Kconfig
index aaa5162c1509..78e5e007f52d 100644
--- a/arch/arm/mach-zynq/Kconfig
+++ b/arch/arm/mach-zynq/Kconfig
@@ -9,6 +9,8 @@ config ARCH_ZYNQ
 	select HAVE_ARM_TWD if SMP
 	select ICST
 	select MFD_SYSCON
+	select PINCTRL
+	select PINCTRL_ZYNQ
 	select SOC_BUS
 	help
 	  Support for Xilinx Zynq ARM Cortex A9 Platform
-- 
2.1.3.1.ge241007

