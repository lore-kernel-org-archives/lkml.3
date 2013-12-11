Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751445Ab3LKScq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 13:32:46 -0500
Received: from mail-yh0-f52.google.com ([209.85.213.52]:40191 "EHLO
	mail-yh0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751290Ab3LKScm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 13:32:42 -0500
Date: Wed, 11 Dec 2013 11:32:37 -0700
From: Bjorn Helgaas <bhelgaas@google.com>
To: linux-pci@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-tegra@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, Jingoo Han <jg1.han@samsung.com>,
        Shawn Guo <shawn.guo@linaro.org>, Jason Cooper <jason@lakedaemon.net>,
        Thierry Reding <thierry.reding@gmail.com>,
        Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>,
        Valentine Barshak <valentine.barshak@cogentembedded.com>,
        Wei Yongjun <weiyj.lk@gmail.com>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Subject: [PATCH] MAINTAINERS: Add DesignWare, i.MX6, Armada, R-Car PCI host
 maintainers
Message-ID: <20131211183237.GI4699@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If this looks reasonable, I'll merge it via the PCI tree for v3.13.

Bjorn


MAINTAINERS: Add DesignWare, i.MX6, Armada, R-Car PCI host maintainers

Add entries for PCI host controller drivers in drivers/pci/host/.

Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
---
 MAINTAINERS |   31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 8285ed4676b6..826c722d92ba 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6449,16 +6449,47 @@ F:	drivers/pci/
 F:	include/linux/pci*
 F:	arch/x86/pci/
 
+PCI DRIVER FOR DESIGNWARE
+M:	Jingoo Han <jg1.han@samsung.com>
+L:	linux-pci@vger.kernel.org
+S:	Maintained
+F:	drivers/pci/host/*designware*
+
+PCI DRIVER FOR IMX6
+M:	Shawn Guo <shawn.guo@linaro.org>
+L:	linux-pci@vger.kernel.org
+L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
+S:	Maintained
+F:	drivers/pci/host/*imx6*
+
+PCI DRIVER FOR MVEBU (Marvell Armada 370 and Armada XP SOC support)
+M:	Jason Cooper <jason@lakedaemon.net>
+L:	linux-pci@vger.kernel.org
+L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
+S:	Maintained
+F:	drivers/pci/host/*mvebu*
+
 PCI DRIVER FOR NVIDIA TEGRA
 M:	Thierry Reding <thierry.reding@gmail.com>
 L:	linux-tegra@vger.kernel.org
+L:	linux-pci@vger.kernel.org
 S:	Supported
 F:	Documentation/devicetree/bindings/pci/nvidia,tegra20-pcie.txt
 F:	drivers/pci/host/pci-tegra.c
 
+PCI DRIVER FOR RENESAS R-CAR
+M:	Simon Horman <horms@verge.net.au>
+M:	Magnus Damm <magnus.damm@gmail.com>
+L:	linux-pci@vger.kernel.org
+L:	linux-sh@vger.kernel.org
+S:	Maintained
+F:	drivers/pci/host/*rcar*
+
 PCI DRIVER FOR SAMSUNG EXYNOS
 M:	Jingoo Han <jg1.han@samsung.com>
 L:	linux-pci@vger.kernel.org
+L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
+L:	linux-samsung-soc@vger.kernel.org (moderated for non-subscribers)
 S:	Maintained
 F:	drivers/pci/host/pci-exynos.c
 
