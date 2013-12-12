Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751812Ab3LLUqS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 15:46:18 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:51533 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751554Ab3LLUqO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 15:46:14 -0500
Date: Thu, 12 Dec 2013 13:46:10 -0700
From: Bjorn Helgaas <bhelgaas@google.com>
To: linux-pci@vger.kernel.org, Richard Zhu <r65037@freescale.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Magnus Damm <magnus.damm@gmail.com>
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
Subject: [PATCH v2] MAINTAINERS: Add DesignWare, i.MX6, Armada, R-Car PCI
 host maintainers
Message-ID: <20131212204610.GK4699@google.com>
References: <20131211183237.GI4699@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131211183237.GI4699@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[+cc Thomas]

On Wed, Dec 11, 2013 at 11:32:37AM -0700, Bjorn Helgaas wrote:
> If this looks reasonable, I'll merge it via the PCI tree for v3.13.

OK, here's another try.  I'm not actually trying to nominate anybody; I
just tried to write down the list we came up with in an earlier discussion [1].

I'd like confirmation from the following people that they approve of being
listed here:

  Richard Zhu (IMX6)
  Thomas Petazzoni (MVEBU)
  Magnus Damm (R-CAR)

I think everybody else listed has already said they approve.

[1] http://lkml.kernel.org/r/CAErSpo5tN==4nSv2u3SUBe_L4VsWn4P7TN+LtrC172Qj1vhtog@mail.gmail.com


MAINTAINERS: Add DesignWare, i.MX6, Armada, R-Car PCI host maintainers

From: Bjorn Helgaas <bhelgaas@google.com>

Add entries for PCI host controller drivers in drivers/pci/host/.

Signed-off-by: Mohit Kumar <mohit.kumar@st.com>		(DesignWare)
Signed-off-by: Pratyush Anand <pratyush.anand@st.com>	(DesignWare)
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Acked-by: Simon Horman <horms+renesas@verge.net.au>	(R-CAR)
Acked-by: Jason Cooper <jason@lakedaemon.net>		(MVEBU)
Acked-by: Jingoo Han <jg1.han@samsung.com>
Acked-by: Thierry Reding <treding@nvidia.com>
---
 MAINTAINERS |   34 ++++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 8285ed4676b6..1c5dc36ec522 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6449,19 +6449,53 @@ F:	drivers/pci/
 F:	include/linux/pci*
 F:	arch/x86/pci/
 
+PCI DRIVER FOR IMX6
+M:	Richard Zhu <r65037@freescale.com>
+M:	Shawn Guo <shawn.guo@linaro.org>
+L:	linux-pci@vger.kernel.org
+L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
+S:	Maintained
+F:	drivers/pci/host/*imx6*
+
+PCI DRIVER FOR MVEBU (Marvell Armada 370 and Armada XP SOC support)
+M:	Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
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
 
+PCI DRIVER FOR SYNOPSIS DESIGNWARE
+M:	Mohit Kumar <mohit.kumar@st.com>
+M:	Jingoo Han <jg1.han@samsung.com>
+L:	linux-pci@vger.kernel.org
+S:	Maintained
+F:	drivers/pci/host/*designware*
+
 PCMCIA SUBSYSTEM
 P:	Linux PCMCIA Team
 L:	linux-pcmcia@lists.infradead.org
