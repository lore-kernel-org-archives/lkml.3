Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753083Ab3CWEHk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Mar 2013 00:07:40 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:30972 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752580Ab3CWEHh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Mar 2013 00:07:37 -0400
X-AuditID: cbfee690-b7f656d0000007e3-24-514d2a86018d
From: Jingoo Han <jg1.han@samsung.com>
To: "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Bjorn Helgaas'" <bhelgaas@google.com>
Cc: linux-samsung-soc@vger.kernel.org, linux-pci@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        "'Grant Likely'" <grant.likely@secretlab.ca>,
        "'Andrew Murray'" <andrew.murray@arm.com>,
        "'Thomas Petazzoni'" <thomas.petazzoni@free-electrons.com>,
        "'Thierry Reding'" <thierry.reding@avionic-design.de>,
        "'Jason Gunthorpe'" <jgunthorpe@obsidianresearch.com>,
        "'Surendranath Gurivireddy Balla'" <suren.reddy@samsung.com>,
        "'Siva Reddy Kallam'" <siva.kallam@samsung.com>,
        "'Thomas Abraham'" <thomas.abraham@linaro.org>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <00c001ce277b$92b26ab0$b8174010$%han@samsung.com>
In-reply-to: <00c001ce277b$92b26ab0$b8174010$%han@samsung.com>
Subject: [PATCH 4/6] pci: Add PCIe driver for Samsung Exynos
Date: Sat, 23 Mar 2013 13:07:34 +0900
Message-id: <00c301ce277b$f2790080$d76b0180$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4ne5IlJNJTIxgLT4K5aVV6JypTrgAAEcKA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrNKsWRmVeSWpSXmKPExsVy+t8zI912Ld9Ag8kfbSya/29ntVjSlGFx
	YPZDVotXZzayWVxeeInV4vsNU4veBVfZLDY9vsZqcXnXHDaLs/OOs1nMOL+PyWJF01ZGi8UX
	lzNb7F65hMXi2IwljBZPHzQxOQh4rJm3htGjb8pVNo8nmy4yeizYVOpx59oeNo/NS+o9zs9Y
	yOjxfUcvUMGWVYweP1/qeHzeJBfAHcVlk5Kak1mWWqRvl8CVsXfjDcaC7QuYKiaumcLYwHju
	LWMXIyeHhICJxLqX31kgbDGJC/fWs3UxcnEICSxjlDg2oReu6OC9R6wQiUWMEo1vpkFV/WKU
	ePv5GTNIFZuAmsSXL4fZQWwRAX+Ja1dbWUCKmAU+s0gsn3wGLCEkYCtx9+RcsAZOATuJx62t
	YLuFBWwkzs7cwwZiswioSjz/cgsszgtU335/GyOELSjxY/I9sDizgJbE+p3HmSBseYnNa94C
	zeQAOlVd4tFfXYgbjCQ2r73KDFEiIrHvxTtGkHskBK5wSJx5+pAZYpeAxLfJh1ggemUlNh1g
	hvhYUuLgihssExglZiHZPAvJ5llINs9CsmIBI8sqRtHUguSC4qT0IhO94sTc4tK8dL3k/NxN
	jJCEMmEH470D1ocYk4HWT2SWEk3OByakvJJ4Q2MzIwtTE1NjI3NLM9KElcR51VusA4UE0hNL
	UrNTUwtSi+KLSnNSiw8xMnFwSjUwOjT0TVM8cl7C1d1vX8FqsSi3N4aryjimfpiXafzyCPsK
	XgcH1q8Mv9OlDp+Texh//5bSuvv+1rPFptbvUfqeoNEYqHDocO6P0BkLM5ZEXzm559mEldbX
	pDLZqt/+lqrZc92PaYaYjeGbIxu+bGeckecY1C+lmHC0vsTu1we9ykdTbuuFKdbdUWIpzkg0
	1GIuKk4EALCktnQ+AwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupgk+LIzCtJLcpLzFFi42I5/e+xgG6blm+gwfM7ShbN/7ezWixpyrA4
	MPshq8WrMxvZLC4vvMRq8f2GqUXvgqtsFpseX2O1uLxrDpvF2XnH2SxmnN/HZLGiaSujxeKL
	y5ktdq9cwmJxbMYSRounD5qYHAQ81sxbw+jRN+Uqm8eTTRcZPRZsKvW4c20Pm8fmJfUe52cs
	ZPT4vqMXqGDLKkaPny91PD5vkgvgjmpgtMlITUxJLVJIzUvOT8nMS7dV8g6Od443NTMw1DW0
	tDBXUshLzE21VXLxCdB1y8wB+kZJoSwxpxQoFJBYXKykb4dpQmiIm64FTGOErm9IEFyPkQEa
	SFjHmLF34w3Ggu0LmComrpnC2MB47i1jFyMnh4SAicTBe49YIWwxiQv31rN1MXJxCAksYpRo
	fDMNyvnFKPH28zNmkCo2ATWJL18Os4PYIgL+EteutrKAFDELfGaRWD75DFhCSMBW4u7JuWAN
	nAJ2Eo9bQYo4OYQFbCTOztzDBmKzCKhKPP9yCyzOC1Tffn8bI4QtKPFj8j2wOLOAlsT6nceZ
	IGx5ic1r3gLN5AA6VV3i0V9diBuMJDavvcoMUSIise/FO8YJjEKzkEyahWTSLCSTZiFpWcDI
	sopRNLUguaA4KT3XUK84Mbe4NC9dLzk/dxMjOF09k9rBuLLB4hCjAAejEg9vQLVPoBBrYllx
	Ze4hRgkOZiUR3nsavoFCvCmJlVWpRfnxRaU5qcWHGJOBHp3ILCWanA9MpXkl8YbGJmZGlkZm
	FkYm5uakCSuJ8x5otQ4UEkhPLEnNTk0tSC2C2cLEwSnVwCj6+ebrqzIm8oeOK65U7t3D/pnl
	0rs40dv3z4UxPrjSNdNSytEnSMI3pSPtQK3r+iadnau1NnDp72BJnyfJqqkr9LObd/0K05Wx
	Ox99Ois3STb9+inpTWe9F18W4Jto5pc0Q407Rlj1FUtgJK/b599m+grab1erKH3zSpj9Xidr
	okHi0pt3zJRYijMSDbWYi4oTAV/KptGbAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Exynos5440 has a PCIe controller which can be used as Root Complex.
This driver supports a PCIe controller as Root Complex mode.

Signed-off-by: Surendranath Gurivireddy Balla <suren.reddy@samsung.com>
Signed-off-by: Siva Reddy Kallam <siva.kallam@samsung.com>
Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 .../devicetree/bindings/pci/exynos-pcie.txt        |   56 +
 drivers/pci/host/Kconfig                           |    5 +
 drivers/pci/host/Makefile                          |    1 +
 drivers/pci/host/pci-exynos.c                      | 1139 ++++++++++++++++++++
 4 files changed, 1201 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/pci/exynos-pcie.txt
 create mode 100644 drivers/pci/host/Makefile
 create mode 100644 drivers/pci/host/pci-exynos.c

diff --git a/Documentation/devicetree/bindings/pci/exynos-pcie.txt b/Documentation/devicetree/bindings/pci/exynos-pcie.txt
new file mode 100644
index 0000000..3eb4a2d
--- /dev/null
+++ b/Documentation/devicetree/bindings/pci/exynos-pcie.txt
@@ -0,0 +1,56 @@
+* Samsung Exynos PCIe interface
+
+Required properties:
+-compatible: should be "samsung,exynos5440-pcie"
+-reg: base addresses and lengths of the pcie conteroller,
+	additional register for the pcie controller,
+	the phy controller,
+	additional register for the phy controller.
+- interrupts: interrupt values for level interrupt,
+	pulse interrupt, special interrupt.
+- device_type, set to "pci"
+- bus-range: PCI bus numbers covered
+- ranges: ranges for the PCI memory and I/O regions
+- reset-gpio: gpio pin number of power good signal
+
+Example:
+
+SoC specific DT Entry:
+
+	pcie0@40000000 {
+		compatible = "samsung,exynos5440-pcie";
+		reg = <0x40000000 0x4000
+			0x290000 0x1000
+			0x270000 0x1000
+			0x271000 0x40>;
+		interrupts = <0 20 0>, <0 21 0>, <0 22 0>;
+		device_type = "pci";
+		bus-range = <0x0 0xf>;
+		ranges = <0x00000800 0 0x40000000 0x40000000 0 0x00200000   /* configuration space */
+			  0x81000000 0 0	  0x40200000 0 0x00004000   /* downstream I/O */
+			  0x82000000 0 0	  0x40204000 0 0x10000000>; /* non-prefetchable memory */
+	};
+
+	pcie1@60000000 {
+		compatible = "samsung,exynos5440-pcie";
+		reg = <0x60000000 0x4000
+			0x2a0000 0x1000
+			0x272000 0x1000
+			0x271040 0x40>;
+		interrupts = <0 23 0>, <0 24 0>, <0 25 0>;
+		device_type = "pci";
+		bus-range = <0x0 0xf>;
+		ranges = <0x00000800 0 0x60000000 0x60000000 0 0x00200000   /* configuration space */
+			  0x81000000 0 0	  0x60200000 0 0x00004000   /* downstream I/O */
+			  0x82000000 0 0	  0x60204000 0 0x10000000>; /* non-prefetchable memory */
+	};
+
+Board specific DT Entry:
+
+	pcie0@40000000 {
+		reset-gpio = <5>;
+	};
+
+	pcie1@60000000 {
+		reset-gpio = <22>;
+	};
diff --git a/drivers/pci/host/Kconfig b/drivers/pci/host/Kconfig
index cc3a1af..31189d9 100644
--- a/drivers/pci/host/Kconfig
+++ b/drivers/pci/host/Kconfig
@@ -1,4 +1,9 @@
 menu "PCI host controller drivers"
 	depends on PCI
 
+config PCI_EXYNOS
+	bool "Samsung Exynos PCIe controller"
+	depends on SOC_EXYNOS5440
+	select PCIEPORTBUS
+
 endmenu
diff --git a/drivers/pci/host/Makefile b/drivers/pci/host/Makefile
new file mode 100644
index 0000000..f1cd2bd
--- /dev/null
+++ b/drivers/pci/host/Makefile
@@ -0,0 +1 @@
+obj-$(CONFIG_PCI_EXYNOS) += pci-exynos.o
diff --git a/drivers/pci/host/pci-exynos.c b/drivers/pci/host/pci-exynos.c
new file mode 100644
index 0000000..0ea5b2f
--- /dev/null
+++ b/drivers/pci/host/pci-exynos.c
@@ -0,0 +1,1139 @@
+/*
+ * PCIe host controller driver for Samsung EXYNOS SoCs
+ *
+ * Copyright (C) 2013 Samsung Electronics Co., Ltd.
+ *		http://www.samsung.com
+ *
+ * Author: Jingoo Han <jg1.han@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/clk.h>
+#include <linux/delay.h>
+#include <linux/gpio.h>
+#include <linux/interrupt.h>
+#include <linux/kernel.h>
+#include <linux/list.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
+#include <linux/of_pci.h>
+#include <linux/pci.h>
+#include <linux/pci_regs.h>
+#include <linux/platform_device.h>
+#include <linux/resource.h>
+#include <linux/signal.h>
+#include <linux/slab.h>
+#include <linux/types.h>
+
+struct pcie_port_info {
+	u32	cfg0_size;
+	u32	cfg1_size;
+	u32	io_size;
+	u32	mem_size;
+	u32	in_mem_size;
+};
+
+struct pcie_port {
+	struct device		*dev;
+	u8			controller;
+	u8			root_bus_nr;
+	void __iomem		*dbi_base;
+	void __iomem		*va_dbi_base;
+	void __iomem		*elbi_base;
+	void __iomem		*va_elbi_base;
+	void __iomem		*base;
+	void __iomem		*phy_base;
+	void __iomem		*va_phy_base;
+	void __iomem		*purple_base;
+	void __iomem		*va_purple_base;
+	void __iomem		*cfg0_base;
+	void __iomem		*va_cfg0_base;
+	void __iomem		*cfg1_base;
+	void __iomem		*va_cfg1_base;
+	void __iomem		*io_base;
+	void __iomem		*mem_base;
+	spinlock_t		conf_lock;
+	struct resource		io;
+	struct resource		mem;
+	struct resource		busn;
+	struct pcie_port_info	config;
+	struct list_head	next;
+	struct clk		*clk;
+	int			irq;
+	int			reset_gpio;
+};
+
+/* synopsis specific PCIE configuration registers*/
+#define PCIE_PORT_LINK_CONTROL		0x710
+#define PORT_LINK_MODE_MASK		(0x3f << 16)
+#define PORT_LINK_MODE_4_LANES		(0x7 << 16)
+
+#define PCIE_LINK_WIDTH_SPEED_CONTROL	0x80C
+#define PORT_LOGIC_SPEED_CHANGE		(0x1 << 17)
+#define PORT_LOGIC_LINK_WIDTH_MASK	(0x1ff << 8)
+#define PORT_LOGIC_LINK_WIDTH_4_LANES	(0x7 << 8)
+
+#define PCIE_MSI_ADDR_LO		0x820
+#define PCIE_MSI_ADDR_HI		0x824
+#define PCIE_MSI_INTR0_ENABLE		0x828
+#define PCIE_MSI_INTR0_MASK		0x82C
+#define PCIE_MSI_INTR0_STATUS		0x830
+
+#define PCIE_ATU_VIEWPORT		0x900
+#define PCIE_ATU_REGION_INBOUND		(0x1 << 31)
+#define PCIE_ATU_REGION_OUTBOUND	(0x0 << 31)
+#define PCIE_ATU_REGION_INDEX1		(0x1 << 0)
+#define PCIE_ATU_REGION_INDEX0		(0x0 << 0)
+#define PCIE_ATU_CR1			0x904
+#define PCIE_ATU_TYPE_MEM		(0x0 << 0)
+#define PCIE_ATU_TYPE_IO		(0x2 << 0)
+#define PCIE_ATU_TYPE_CFG0		(0x4 << 0)
+#define PCIE_ATU_TYPE_CFG1		(0x5 << 0)
+#define PCIE_ATU_CR2			0x908
+#define PCIE_ATU_ENABLE			(0x1 << 31)
+#define PCIE_ATU_BAR_MODE_ENABLE	(0x1 << 30)
+#define PCIE_ATU_LOWER_BASE		0x90C
+#define PCIE_ATU_UPPER_BASE		0x910
+#define PCIE_ATU_LIMIT			0x914
+#define PCIE_ATU_LOWER_TARGET		0x918
+#define PCIE_ATU_BUS(x)			((x) & 0xff << 24)
+#define PCIE_ATU_DEV(x)			((x) & 0x1f << 19)
+#define PCIE_ATU_FUNC(x)		((x) & 0x7 << 16)
+#define PCIE_ATU_UPPER_TARGET		0x91C
+
+/* PCIe ELBI registers */
+#define PCIE_IRQ_PULSE			0x000
+#define IRQ_INTA_ASSERT			(0x1 << 0)
+#define IRQ_INTB_ASSERT			(0x1 << 2)
+#define IRQ_INTC_ASSERT			(0x1 << 4)
+#define IRQ_INTD_ASSERT			(0x1 << 6)
+#define PCIE_IRQ_LEVEL			0x004
+#define PCIE_IRQ_SPECIAL		0x008
+#define PCIE_IRQ_EN_PULSE		0x00c
+#define PCIE_IRQ_EN_LEVEL		0x010
+#define PCIE_IRQ_EN_SPECIAL		0x014
+#define PCIE_PWR_RESET			0x018
+#define PCIE_CORE_RESET			0x01c
+#define PCIE_CORE_RESET_ENABLE		(0x1 << 0)
+#define PCIE_STICKY_RESET		0x020
+#define PCIE_NONSTICKY_RESET		0x024
+#define PCIE_APP_INIT_RESET		0x028
+#define PCIE_APP_LTSSM_ENABLE		0x02c
+#define PCIE_ELBI_RDLH_LINKUP		0x064
+#define PCIE_ELBI_LTSSM_ENABLE		0x1
+#define PCIE_ELBI_SLV_AWMISC		0x11c
+#define PCIE_ELBI_SLV_ARMISC		0x120
+#define PCIE_ELBI_SLV_DBI_ENABLE	(0x1 << 21)
+
+/* PCIe Purple registers */
+#define PCIE_PHY_GLOBAL_RESET		0x000
+#define PCIE_PHY_COMMON_RESET		0x004
+#define PCIE_PHY_CMN_REG		0x008
+#define PCIE_PHY_MAC_RESET		0x00c
+#define PCIE_PHY_PLL_LOCKED		0x010
+#define PCIE_PHY_TRSVREG_RESET		0x020
+#define PCIE_PHY_TRSV_RESET		0x024
+
+/* PCIe PHY registers */
+#define PCIE_PHY_RESET			0x004
+#define PCIE_PHY_CTL0			0x008
+#define PCIE_PHY_CTL1			0x05c
+#define PCIE_PHY_PWR0			0x064
+#define PHY_PWR0_ENABLE			(0x1 << 3)
+#define PCIE_PHY_TXCTRL_LEVEL		0x084
+#define PCIE_PHY_TXCTRL_OP		0x088
+#define PCIE_PHY_PWR1			0x0c4
+#define PHY_PWR1_ENABLE			(0x1 << 7)
+#define PCIE_PHY_PWR2			0x184
+#define PHY_PWR2_ENABLE			(0x1 << 7)
+#define PCIE_PHY_PWR3			0x244
+#define PHY_PWR3_ENABLE			(0x1 << 7)
+#define PCIE_PHY_PWR4			0x304
+#define PHY_PWR4_ENABLE			(0x1 << 7)
+
+static struct list_head pcie_port_list;
+static struct hw_pci exynos_pci;
+
+static inline int cfg_read(void *addr, int where, int size, u32 *val)
+{
+	*val = readl(addr);
+
+	if (size == 1)
+		*val = (*val >> (8 * (where & 3))) & 0xff;
+	else if (size == 2)
+		*val = (*val >> (8 * (where & 3))) & 0xffff;
+	else if (size != 4)
+		return PCIBIOS_BAD_REGISTER_NUMBER;
+
+	return PCIBIOS_SUCCESSFUL;
+}
+
+static inline int cfg_write(void *addr, int where, int size, u32 val)
+{
+	if (size == 4)
+		writel(val, addr);
+	else if (size == 2)
+		writew(val, addr + (where & 2));
+	else if (size == 1)
+		writeb(val, addr + (where & 3));
+	else
+		return PCIBIOS_BAD_REGISTER_NUMBER;
+
+	return PCIBIOS_SUCCESSFUL;
+}
+
+static void exynos_pcie_sideband_dbi_w_mode(struct pcie_port *pp, bool on)
+{
+	u32 val;
+
+	if (on) {
+		val = readl(pp->va_elbi_base + PCIE_ELBI_SLV_AWMISC);
+		val |= PCIE_ELBI_SLV_DBI_ENABLE;
+		writel(val, pp->va_elbi_base + PCIE_ELBI_SLV_AWMISC);
+	} else {
+		val = readl(pp->va_elbi_base + PCIE_ELBI_SLV_AWMISC);
+		val &= ~PCIE_ELBI_SLV_DBI_ENABLE;
+		writel(val, pp->va_elbi_base + PCIE_ELBI_SLV_AWMISC);
+	}
+}
+
+static void exynos_pcie_sideband_dbi_r_mode(struct pcie_port *pp, bool on)
+{
+	u32 val;
+
+	if (on) {
+		val = readl(pp->va_elbi_base + PCIE_ELBI_SLV_ARMISC);
+		val |= PCIE_ELBI_SLV_DBI_ENABLE;
+		writel(val, pp->va_elbi_base + PCIE_ELBI_SLV_ARMISC);
+	} else {
+		val = readl(pp->va_elbi_base + PCIE_ELBI_SLV_ARMISC);
+		val &= ~PCIE_ELBI_SLV_DBI_ENABLE;
+		writel(val, pp->va_elbi_base + PCIE_ELBI_SLV_ARMISC);
+	}
+}
+
+static inline void readl_rc(struct pcie_port *pp, void *dbi_base, u32 *val)
+{
+	exynos_pcie_sideband_dbi_r_mode(pp, true);
+	*val = readl(dbi_base);
+	exynos_pcie_sideband_dbi_r_mode(pp, false);
+	return;
+}
+
+static inline void writel_rc(struct pcie_port *pp, u32 val, void *dbi_base)
+{
+	exynos_pcie_sideband_dbi_w_mode(pp, true);
+	writel(val, dbi_base);
+	exynos_pcie_sideband_dbi_w_mode(pp, false);
+	return;
+}
+
+static int exynos_pcie_rd_own_conf(struct pcie_port *pp, int where, int size,
+		u32 *val)
+{
+	int ret;
+
+	exynos_pcie_sideband_dbi_r_mode(pp, true);
+	ret = cfg_read(pp->va_dbi_base + (where & ~0x3), where, size, val);
+	exynos_pcie_sideband_dbi_r_mode(pp, false);
+	return ret;
+}
+
+static int exynos_pcie_wr_own_conf(struct pcie_port *pp, int where, int size,
+		u32 val)
+{
+	int ret;
+
+	exynos_pcie_sideband_dbi_w_mode(pp, true);
+	ret = cfg_write(pp->va_dbi_base + (where & ~0x3), where, size, val);
+	exynos_pcie_sideband_dbi_w_mode(pp, false);
+	return ret;
+}
+
+static void exynos_pcie_prog_viewport_cfg0(struct pcie_port *pp, u32 busdev)
+{
+	u32 val;
+	void __iomem *dbi_base = pp->va_dbi_base;
+
+	/* Program viewport 0 : OUTBOUND : CFG0 */
+	val = PCIE_ATU_REGION_OUTBOUND | PCIE_ATU_REGION_INDEX0;
+	writel_rc(pp, val, dbi_base + PCIE_ATU_VIEWPORT);
+	writel_rc(pp, (u32)pp->cfg0_base, dbi_base + PCIE_ATU_LOWER_BASE);
+	writel_rc(pp, 0, dbi_base + PCIE_ATU_UPPER_BASE);
+	writel_rc(pp, (u32)pp->cfg0_base + pp->config.cfg0_size - 1,
+			dbi_base + PCIE_ATU_LIMIT);
+	writel_rc(pp, busdev, dbi_base + PCIE_ATU_LOWER_TARGET);
+	writel_rc(pp, 0, dbi_base + PCIE_ATU_UPPER_TARGET);
+	writel_rc(pp, PCIE_ATU_TYPE_CFG0, dbi_base + PCIE_ATU_CR1);
+	val = PCIE_ATU_ENABLE;
+	writel_rc(pp, val, dbi_base + PCIE_ATU_CR2);
+}
+
+static void exynos_pcie_prog_viewport_cfg1(struct pcie_port *pp, u32 busdev)
+{
+	u32 val;
+	void __iomem *dbi_base = pp->va_dbi_base;
+
+	/* Program viewport 1 : OUTBOUND : CFG1 */
+	val = PCIE_ATU_REGION_OUTBOUND | PCIE_ATU_REGION_INDEX1;
+	writel_rc(pp, val, dbi_base + PCIE_ATU_VIEWPORT);
+	writel_rc(pp, PCIE_ATU_TYPE_CFG1, dbi_base + PCIE_ATU_CR1);
+	val = PCIE_ATU_ENABLE;
+	writel_rc(pp, val, dbi_base + PCIE_ATU_CR2);
+	writel_rc(pp, (u32)pp->cfg1_base, dbi_base + PCIE_ATU_LOWER_BASE);
+	writel_rc(pp, 0, dbi_base + PCIE_ATU_UPPER_BASE);
+	writel_rc(pp, (u32)pp->cfg1_base + pp->config.cfg1_size - 1,
+			dbi_base + PCIE_ATU_LIMIT);
+	writel_rc(pp, busdev, dbi_base + PCIE_ATU_LOWER_TARGET);
+	writel_rc(pp, 0, dbi_base + PCIE_ATU_UPPER_TARGET);
+}
+
+static void exynos_pcie_prog_viewport_mem_outbound(struct pcie_port *pp)
+{
+	u32 val;
+	void __iomem *dbi_base = pp->va_dbi_base;
+
+	/* Program viewport 0 : OUTBOUND : MEM */
+	val = PCIE_ATU_REGION_OUTBOUND | PCIE_ATU_REGION_INDEX0;
+	writel_rc(pp, val, dbi_base + PCIE_ATU_VIEWPORT);
+	writel_rc(pp, PCIE_ATU_TYPE_MEM, dbi_base + PCIE_ATU_CR1);
+	val = PCIE_ATU_ENABLE;
+	writel_rc(pp, val, dbi_base + PCIE_ATU_CR2);
+	writel_rc(pp, (u32)pp->mem_base, dbi_base + PCIE_ATU_LOWER_BASE);
+	writel_rc(pp, 0, dbi_base + PCIE_ATU_UPPER_BASE);
+	writel_rc(pp, (u32)(pp->mem_base + pp->config.mem_size - 1),
+			dbi_base + PCIE_ATU_LIMIT);
+	writel_rc(pp, (u32)pp->mem_base, dbi_base + PCIE_ATU_LOWER_TARGET);
+	writel_rc(pp, 0, dbi_base + PCIE_ATU_UPPER_TARGET);
+}
+
+static void exynos_pcie_prog_viewport_io_outbound(struct pcie_port *pp)
+{
+	u32 val;
+	void __iomem *dbi_base = pp->va_dbi_base;
+
+	/* Program viewport 1 : OUTBOUND : IO */
+	val = PCIE_ATU_REGION_OUTBOUND | PCIE_ATU_REGION_INDEX1;
+	writel_rc(pp, val, dbi_base + PCIE_ATU_VIEWPORT);
+	writel_rc(pp, PCIE_ATU_TYPE_IO, dbi_base + PCIE_ATU_CR1);
+	val = PCIE_ATU_ENABLE;
+	writel_rc(pp, val, dbi_base + PCIE_ATU_CR2);
+	writel_rc(pp, (u32)pp->io_base, dbi_base + PCIE_ATU_LOWER_BASE);
+	writel_rc(pp, 0, dbi_base + PCIE_ATU_UPPER_BASE);
+	writel_rc(pp, (u32)(pp->io_base + pp->config.io_size - 1),
+			dbi_base + PCIE_ATU_LIMIT);
+	writel_rc(pp, (u32)pp->io_base, dbi_base + PCIE_ATU_LOWER_TARGET);
+	writel_rc(pp, 0, dbi_base + PCIE_ATU_UPPER_TARGET);
+}
+
+static void exynos_pcie_prog_viewport_mem_inbound(struct pcie_port *pp)
+{
+	u32 val;
+	void __iomem *dbi_base = pp->va_dbi_base;
+	struct pcie_port_info *config = &pp->config;
+
+	/* Program viewport 0 : INBOUND : MEMORY */
+	val = PCIE_ATU_REGION_INBOUND | PCIE_ATU_REGION_INDEX0;
+	writel_rc(pp, val, dbi_base + PCIE_ATU_VIEWPORT);
+	writel_rc(pp, PCIE_ATU_TYPE_MEM, dbi_base + PCIE_ATU_CR1);
+	val = PCIE_ATU_ENABLE | PCIE_ATU_BAR_MODE_ENABLE;
+	writel_rc(pp, val, dbi_base + PCIE_ATU_CR2);
+	writel_rc(pp, 0, dbi_base + PCIE_ATU_LOWER_BASE);
+	writel_rc(pp, 0, dbi_base + PCIE_ATU_UPPER_BASE);
+	writel_rc(pp, config->in_mem_size - 1, dbi_base + PCIE_ATU_LIMIT);
+	writel_rc(pp, 0, dbi_base + PCIE_ATU_LOWER_TARGET);
+	writel_rc(pp, 0, dbi_base + PCIE_ATU_UPPER_TARGET);
+}
+
+static void exynos_pcie_prog_viewport_io_inbound(struct pcie_port *pp)
+{
+	u32 val;
+	void __iomem *dbi_base = pp->va_dbi_base;
+	struct pcie_port_info *config = &pp->config;
+
+	/* Program viewport 1 : INBOUND : IO */
+	val = PCIE_ATU_REGION_INBOUND | PCIE_ATU_REGION_INDEX1;
+	writel_rc(pp, val, dbi_base + PCIE_ATU_VIEWPORT);
+	writel_rc(pp, PCIE_ATU_TYPE_IO, dbi_base + PCIE_ATU_CR1);
+	val = PCIE_ATU_ENABLE | PCIE_ATU_BAR_MODE_ENABLE;
+	writel_rc(pp, val, dbi_base + PCIE_ATU_CR2);
+	writel_rc(pp, 0, dbi_base + PCIE_ATU_LOWER_BASE);
+	writel_rc(pp, 0, dbi_base + PCIE_ATU_UPPER_BASE);
+	writel_rc(pp, config->in_mem_size - 1, dbi_base + PCIE_ATU_LIMIT);
+	writel_rc(pp, 0, dbi_base + PCIE_ATU_LOWER_TARGET);
+	writel_rc(pp, 0, dbi_base + PCIE_ATU_UPPER_TARGET);
+}
+
+static int exynos_pcie_rd_other_conf(struct pcie_port *pp, struct pci_bus *bus,
+		u32 devfn, int where, int size, u32 *val)
+{
+	int ret = PCIBIOS_SUCCESSFUL;
+	u32 address, busdev;
+
+	busdev = PCIE_ATU_BUS(bus->number) | PCIE_ATU_DEV(PCI_SLOT(devfn)) |
+		 PCIE_ATU_FUNC(PCI_FUNC(devfn));
+	address = where & ~0x3;
+
+	if (bus->parent->number == pp->root_bus_nr) {
+		exynos_pcie_prog_viewport_cfg0(pp, busdev);
+		ret = cfg_read(pp->va_cfg0_base + address, where, size, val);
+		exynos_pcie_prog_viewport_mem_outbound(pp);
+	} else {
+		exynos_pcie_prog_viewport_cfg1(pp, busdev);
+		ret = cfg_read(pp->va_cfg1_base + address, where, size, val);
+		exynos_pcie_prog_viewport_io_outbound(pp);
+	}
+
+	return ret;
+}
+
+static int exynos_pcie_wr_other_conf(struct pcie_port *pp, struct pci_bus *bus,
+		u32 devfn, int where, int size, u32 val)
+{
+	int ret = PCIBIOS_SUCCESSFUL;
+	u32 address, busdev;
+
+	busdev = PCIE_ATU_BUS(bus->number) | PCIE_ATU_DEV(PCI_SLOT(devfn)) |
+		 PCIE_ATU_FUNC(PCI_FUNC(devfn));
+	address = where & ~0x3;
+
+	if (bus->parent->number == pp->root_bus_nr) {
+		exynos_pcie_prog_viewport_cfg0(pp, busdev);
+		ret = cfg_write(pp->va_cfg0_base + address, where, size, val);
+		exynos_pcie_prog_viewport_mem_outbound(pp);
+	} else {
+		exynos_pcie_prog_viewport_cfg1(pp, busdev);
+		ret = cfg_write(pp->va_cfg1_base + address, where, size, val);
+		exynos_pcie_prog_viewport_io_outbound(pp);
+	}
+
+	return ret;
+}
+
+static struct pcie_port *controller_to_port(int controller)
+{
+	struct pcie_port *pp;
+
+	if (controller >= exynos_pci.nr_controllers)
+		return NULL;
+
+	list_for_each_entry(pp, &pcie_port_list, next) {
+		if (pp->controller == controller)
+			return pp;
+	}
+	return NULL;
+}
+
+static struct pcie_port *bus_to_port(int bus)
+{
+	int i;
+	int rbus;
+	struct pcie_port *pp;
+
+	for (i = exynos_pci.nr_controllers - 1 ; i >= 0; i--) {
+		pp = controller_to_port(i);
+		rbus = pp->root_bus_nr;
+		if (rbus != -1 && rbus <= bus)
+			break;
+	}
+
+	return i >= 0 ? pp : NULL;
+}
+
+static int __init exynos_pcie_setup(int nr, struct pci_sys_data *sys)
+{
+	struct pcie_port *pp;
+
+	pp = controller_to_port(nr);
+
+	if (!pp)
+		return 0;
+
+	pci_add_resource_offset(&sys->resources, &pp->io, sys->io_offset);
+	pci_add_resource_offset(&sys->resources, &pp->mem, sys->mem_offset);
+	pci_add_resource(&sys->resources, &pp->busn);
+
+	return 1;
+}
+
+static int exynos_pcie_link_up(struct pcie_port *pp)
+{
+	u32 val = readl(pp->va_elbi_base + PCIE_ELBI_RDLH_LINKUP);
+	if (val == PCIE_ELBI_LTSSM_ENABLE)
+		return 1;
+
+	return 0;
+}
+
+static int exynos_pcie_valid_config(struct pcie_port *pp,
+				struct pci_bus *bus, int dev)
+{
+	/* If there is no link, then there is no device */
+	if (bus->number != pp->root_bus_nr) {
+		if (!exynos_pcie_link_up(pp))
+			return 0;
+	}
+
+	/* access only one slot on each root port */
+	if (bus->number == pp->root_bus_nr && dev > 0)
+		return 0;
+
+	/*
+	 * do not read more than one device on the bus directly attached
+	 * to RC's (Virtual Bridge's) DS side.
+	 */
+	if (bus->primary == pp->root_bus_nr && dev > 0)
+		return 0;
+
+	return 1;
+}
+
+static int exynos_pcie_rd_conf(struct pci_bus *bus, u32 devfn, int where,
+			int size, u32 *val)
+{
+	struct pcie_port *pp = bus_to_port(bus->number);
+	unsigned long flags;
+	int ret;
+
+	if (!pp) {
+		BUG();
+		return -EINVAL;
+	}
+
+	if (exynos_pcie_valid_config(pp, bus, PCI_SLOT(devfn)) == 0) {
+		*val = 0xffffffff;
+		return PCIBIOS_DEVICE_NOT_FOUND;
+	}
+
+	spin_lock_irqsave(&pp->conf_lock, flags);
+	if (bus->number != pp->root_bus_nr)
+		ret = exynos_pcie_rd_other_conf(pp, bus, devfn,
+						where, size, val);
+	else
+		ret = exynos_pcie_rd_own_conf(pp, where, size, val);
+	spin_unlock_irqrestore(&pp->conf_lock, flags);
+
+	return ret;
+}
+
+static int exynos_pcie_wr_conf(struct pci_bus *bus, u32 devfn,
+			int where, int size, u32 val)
+{
+	struct pcie_port *pp = bus_to_port(bus->number);
+	unsigned long flags;
+	int ret;
+
+	if (!pp) {
+		BUG();
+		return -EINVAL;
+	}
+
+	if (exynos_pcie_valid_config(pp, bus, PCI_SLOT(devfn)) == 0)
+		return PCIBIOS_DEVICE_NOT_FOUND;
+
+	spin_lock_irqsave(&pp->conf_lock, flags);
+	if (bus->number != pp->root_bus_nr)
+		ret = exynos_pcie_wr_other_conf(pp, bus, devfn,
+						where, size, val);
+	else
+		ret = exynos_pcie_wr_own_conf(pp, where, size, val);
+	spin_unlock_irqrestore(&pp->conf_lock, flags);
+
+	return ret;
+}
+
+static struct pci_ops exynos_pcie_ops = {
+	.read = exynos_pcie_rd_conf,
+	.write = exynos_pcie_wr_conf,
+};
+
+static struct pci_bus __init *exynos_pcie_scan_bus(int nr,
+					struct pci_sys_data *sys)
+{
+	struct pci_bus *bus;
+	struct pcie_port *pp = controller_to_port(nr);
+
+	if (pp) {
+		pp->root_bus_nr = sys->busnr;
+		bus = pci_scan_root_bus(NULL, sys->busnr, &exynos_pcie_ops,
+					sys, &sys->resources);
+		return bus;
+	} else {
+		bus = NULL;
+		BUG();
+	}
+
+	return bus;
+}
+
+static int exynos_pcie_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
+{
+	struct pcie_port *pp = bus_to_port(dev->bus->number);
+
+	return pp->irq;
+}
+
+static struct hw_pci exynos_pci = {
+	.setup		= exynos_pcie_setup,
+	.scan		= exynos_pcie_scan_bus,
+	.map_irq	= exynos_pcie_map_irq,
+};
+
+static void exynos_pcie_setup_rc(struct pcie_port *pp)
+{
+	struct pcie_port_info *config = &pp->config;
+	void __iomem *dbi_base = pp->va_dbi_base;
+	u32 val;
+	u32 membase;
+	u32 memlimit;
+
+	/* set the number of lines as 4 */
+	readl_rc(pp, dbi_base + PCIE_PORT_LINK_CONTROL, &val);
+	val &= ~PORT_LINK_MODE_MASK;
+	val |= PORT_LINK_MODE_4_LANES;
+	writel_rc(pp, val, dbi_base + PCIE_PORT_LINK_CONTROL);
+
+	/* set link width speed control register */
+	readl_rc(pp, dbi_base + PCIE_LINK_WIDTH_SPEED_CONTROL, &val);
+	val &= ~PORT_LOGIC_LINK_WIDTH_MASK;
+	val |= PORT_LOGIC_LINK_WIDTH_4_LANES;
+	writel_rc(pp, val, dbi_base + PCIE_LINK_WIDTH_SPEED_CONTROL);
+
+	/* setup RC BARs */
+	writel_rc(pp, 0x00000004, dbi_base + PCI_BASE_ADDRESS_0);
+	writel_rc(pp, 0x00000004, dbi_base + PCI_BASE_ADDRESS_1);
+
+	/* setup interrupt pins */
+	readl_rc(pp, dbi_base + PCI_INTERRUPT_LINE, &val);
+	val &= 0xffff00ff;
+	val |= 0x00000100;
+	writel_rc(pp, val, dbi_base + PCI_INTERRUPT_LINE);
+
+	/* setup bus numbers */
+	readl_rc(pp, dbi_base + PCI_PRIMARY_BUS, &val);
+	val &= 0xff000000;
+	val |= 0x00010100;
+	writel_rc(pp, val, dbi_base + PCI_PRIMARY_BUS);
+
+	/* setup memory base, memory limit */
+	membase = ((u32)pp->mem_base & 0xfff00000) >> 16;
+	memlimit = (config->mem_size + (u32)pp->mem_base) & 0xfff00000;
+	val = memlimit | membase;
+	writel_rc(pp, val, dbi_base + PCI_MEMORY_BASE);
+
+	/* setup command register */
+	readl_rc(pp, dbi_base + PCI_COMMAND, &val);
+	val &= 0xffff0000;
+	val |= PCI_COMMAND_IO | PCI_COMMAND_MEMORY |
+		PCI_COMMAND_MASTER | PCI_COMMAND_SERR;
+	writel_rc(pp, val, dbi_base + PCI_COMMAND);
+}
+
+static void exynos_pcie_assert_core_reset(struct pcie_port *pp)
+{
+	u32 val;
+	void __iomem *elbi_base = pp->va_elbi_base;
+
+	val = readl(elbi_base + PCIE_CORE_RESET);
+	val &= ~PCIE_CORE_RESET_ENABLE;
+	writel(val, elbi_base + PCIE_CORE_RESET);
+	writel(0, elbi_base + PCIE_PWR_RESET);
+	writel(0, elbi_base + PCIE_STICKY_RESET);
+	writel(0, elbi_base + PCIE_NONSTICKY_RESET);
+}
+
+static void exynos_pcie_deassert_core_reset(struct pcie_port *pp)
+{
+	u32 val;
+	void __iomem *elbi_base = pp->va_elbi_base;
+	void __iomem *purple_base = pp->va_purple_base;
+
+	val = readl(elbi_base + PCIE_CORE_RESET);
+	val |= PCIE_CORE_RESET_ENABLE;
+	writel(val, elbi_base + PCIE_CORE_RESET);
+	writel(1, elbi_base + PCIE_STICKY_RESET);
+	writel(1, elbi_base + PCIE_NONSTICKY_RESET);
+	writel(1, elbi_base + PCIE_APP_INIT_RESET);
+	writel(0, elbi_base + PCIE_APP_INIT_RESET);
+	writel(1, purple_base + PCIE_PHY_MAC_RESET);
+}
+
+static void exynos_pcie_assert_phy_reset(struct pcie_port *pp)
+{
+	void __iomem *purple_base = pp->va_purple_base;
+
+	writel(0, purple_base + PCIE_PHY_MAC_RESET);
+	writel(1, purple_base + PCIE_PHY_GLOBAL_RESET);
+}
+
+static void exynos_pcie_deassert_phy_reset(struct pcie_port *pp)
+{
+	void __iomem *elbi_base = pp->va_elbi_base;
+	void __iomem *purple_base = pp->va_purple_base;
+
+	writel(0, purple_base + PCIE_PHY_GLOBAL_RESET);
+	writel(1, elbi_base + PCIE_PWR_RESET);
+	writel(0, purple_base + PCIE_PHY_COMMON_RESET);
+	writel(0, purple_base + PCIE_PHY_CMN_REG);
+	writel(0, purple_base + PCIE_PHY_TRSVREG_RESET);
+	writel(0, purple_base + PCIE_PHY_TRSV_RESET);
+}
+
+static void exynos_pcie_init_phy(struct pcie_port *pp)
+{
+	u32 val;
+	void __iomem *phy_base = pp->va_phy_base;
+
+	/* power down PHY */
+	val = readl(phy_base + PCIE_PHY_PWR0);
+	val |= PHY_PWR0_ENABLE;
+	writel(val, phy_base + PCIE_PHY_PWR0);
+
+	val = readl(phy_base + PCIE_PHY_PWR1);
+	val |= PHY_PWR1_ENABLE;
+	writel(val, phy_base + PCIE_PHY_PWR1);
+
+	val = readl(phy_base + PCIE_PHY_PWR2);
+	val |= PHY_PWR2_ENABLE;
+	writel(val, phy_base + PCIE_PHY_PWR2);
+
+	val = readl(phy_base + PCIE_PHY_PWR3);
+	val |= PHY_PWR3_ENABLE;
+	writel(val, phy_base + PCIE_PHY_PWR3);
+
+	val = readl(phy_base + PCIE_PHY_PWR4);
+	val |= PHY_PWR4_ENABLE;
+	writel(val, phy_base + PCIE_PHY_PWR4);
+
+	udelay(50);
+
+	/* power up PHY */
+	val = readl(phy_base + PCIE_PHY_PWR0);
+	val &= ~PHY_PWR0_ENABLE;
+	writel(val, phy_base + PCIE_PHY_PWR0);
+
+	val = readl(phy_base + PCIE_PHY_PWR1);
+	val &= ~PHY_PWR1_ENABLE;
+	writel(val, phy_base + PCIE_PHY_PWR1);
+
+	val = readl(phy_base + PCIE_PHY_PWR2);
+	val &= ~PHY_PWR2_ENABLE;
+	writel(val, phy_base + PCIE_PHY_PWR2);
+
+	val = readl(phy_base + PCIE_PHY_PWR3);
+	val &= ~PHY_PWR3_ENABLE;
+	writel(val, phy_base + PCIE_PHY_PWR3);
+
+	val = readl(phy_base + PCIE_PHY_PWR4);
+	val &= ~PHY_PWR4_ENABLE;
+	writel(val, phy_base + PCIE_PHY_PWR4);
+
+	/* reset PHY */
+	writel(0xd5, phy_base + PCIE_PHY_RESET);
+
+	/* set 50Mhz PHY clock */
+	writel(0x15, phy_base + PCIE_PHY_CTL0);
+	writel(0x12, phy_base + PCIE_PHY_CTL1);
+
+	/* TX Differential output */
+	writel(0x7f, phy_base + PCIE_PHY_TXCTRL_OP);
+
+	/* TX Pre-emphasis Level Control 11 */
+	writel(0x0, phy_base + PCIE_PHY_TXCTRL_LEVEL);
+}
+
+static void exynos_pcie_assert_reset(struct pcie_port *pp)
+{
+	if (pp->reset_gpio >= 0)
+		devm_gpio_request_one(pp->dev, pp->reset_gpio,
+				GPIOF_OUT_INIT_HIGH, "RESET");
+	return;
+}
+
+static int exynos_pcie_establish_link(struct pcie_port *pp)
+{
+	u32 val;
+	int count = 0;
+	void __iomem *elbi_base = pp->va_elbi_base;
+	void __iomem *purple_base = pp->va_purple_base;
+	void __iomem *phy_base = pp->va_phy_base;
+
+	if (exynos_pcie_link_up(pp)) {
+		dev_err(pp->dev, "Link already up\n");
+		return 0;
+	}
+
+	/* assert reset signals */
+	exynos_pcie_assert_core_reset(pp);
+	exynos_pcie_assert_phy_reset(pp);
+
+	/* de-assert phy reset */
+	exynos_pcie_deassert_phy_reset(pp);
+
+	/* initialize phy */
+	exynos_pcie_init_phy(pp);
+
+	/* pulse for common reset */
+	writel(1, purple_base + PCIE_PHY_COMMON_RESET);
+	udelay(500);
+	writel(0, purple_base + PCIE_PHY_COMMON_RESET);
+
+	/* de-assert core reset */
+	exynos_pcie_deassert_core_reset(pp);
+
+	/* setup root complex */
+	exynos_pcie_setup_rc(pp);
+
+	/* assert reset signal */
+	exynos_pcie_assert_reset(pp);
+
+	/* assert LTSSM enable */
+	writel(PCIE_ELBI_LTSSM_ENABLE, elbi_base + PCIE_APP_LTSSM_ENABLE);
+
+	/* check if the link is up or not */
+	while (!exynos_pcie_link_up(pp)) {
+		mdelay(100);
+		count++;
+		if (count == 10) {
+			while (readl(phy_base + PCIE_PHY_PLL_LOCKED) == 0) {
+				val = readl(purple_base + PCIE_PHY_PLL_LOCKED);
+				dev_info(pp->dev, "PLL Locked: 0x%x\n", val);
+			}
+			dev_err(pp->dev, "PCIe Link Fail\n");
+			return -EINVAL;
+		}
+	}
+
+	dev_info(pp->dev, "Link up\n");
+
+	return 0;
+}
+
+static void exynos_pcie_clear_irq_pulse(struct pcie_port *pp)
+{
+	u32 val;
+	void __iomem *elbi_base = pp->va_elbi_base;
+
+	val = readl(elbi_base + PCIE_IRQ_PULSE);
+	writel(val, elbi_base + PCIE_IRQ_PULSE);
+	return;
+}
+
+static void exynos_pcie_enable_irq_pulse(struct pcie_port *pp)
+{
+	u32 val;
+	void __iomem *elbi_base = pp->va_elbi_base;
+
+	/* enable INTX interrupt */
+	val = IRQ_INTA_ASSERT | IRQ_INTB_ASSERT |
+		IRQ_INTC_ASSERT | IRQ_INTD_ASSERT,
+	writel(val, elbi_base + PCIE_IRQ_EN_PULSE);
+	return;
+}
+
+static irqreturn_t exynos_pcie_irq_handler(int irq, void *arg)
+{
+	struct pcie_port *pp = arg;
+
+	exynos_pcie_clear_irq_pulse(pp);
+	return IRQ_HANDLED;
+}
+
+static void exynos_pcie_enable_interrupts(struct pcie_port *pp)
+{
+	exynos_pcie_enable_irq_pulse(pp);
+	return;
+}
+
+static void exynos_pcie_host_init(struct pcie_port *pp)
+{
+	struct pcie_port_info *config = &pp->config;
+	u32 val;
+
+	/* Keep first 64K for IO */
+	pp->cfg0_base = pp->base;
+	pp->cfg1_base = pp->cfg0_base + config->cfg0_size;
+	pp->io_base = pp->cfg1_base + config->cfg1_size;
+	pp->mem_base = pp->io_base + config->io_size;
+
+	/* enable link */
+	exynos_pcie_establish_link(pp);
+
+	/* set view ports for inbound */
+	exynos_pcie_prog_viewport_mem_inbound(pp);
+	exynos_pcie_prog_viewport_io_inbound(pp);
+
+	exynos_pcie_wr_own_conf(pp, PCI_BASE_ADDRESS_0, 4, 0);
+
+	/* program correct class for RC */
+	exynos_pcie_wr_own_conf(pp, PCI_CLASS_DEVICE, 2, PCI_CLASS_BRIDGE_PCI);
+
+	exynos_pcie_rd_own_conf(pp, PCIE_LINK_WIDTH_SPEED_CONTROL, 4, &val);
+	val |= PORT_LOGIC_SPEED_CHANGE;
+	exynos_pcie_wr_own_conf(pp, PCIE_LINK_WIDTH_SPEED_CONTROL, 4, val);
+
+	exynos_pcie_enable_interrupts(pp);
+}
+
+static int add_pcie_port(struct pcie_port *pp, struct platform_device *pdev)
+{
+	struct resource *dbi_base;
+	struct resource *elbi_base;
+	struct resource *phy_base;
+	struct resource *purple_base;
+	int ret;
+
+	dbi_base = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!dbi_base) {
+		dev_err(&pdev->dev, "couldn't get dbi base resource\n");
+		return -EINVAL;
+	}
+	if (!devm_request_mem_region(&pdev->dev, dbi_base->start,
+				resource_size(dbi_base), pdev->name)) {
+		dev_err(&pdev->dev, "dbi base resource is busy\n");
+		return -EBUSY;
+	}
+	pp->dbi_base = (void __iomem *) (unsigned long)dbi_base->start;
+	pp->va_dbi_base = devm_ioremap(&pdev->dev, dbi_base->start,
+			resource_size(dbi_base));
+	if (!pp->va_dbi_base) {
+		dev_err(&pdev->dev, "error with ioremap\n");
+		return -ENOMEM;
+	}
+
+	elbi_base = platform_get_resource(pdev, IORESOURCE_MEM, 1);
+	if (!elbi_base) {
+		dev_err(&pdev->dev, "couldn't get elbi base resource\n");
+		return -EINVAL;
+	}
+	if (!devm_request_mem_region(&pdev->dev, elbi_base->start,
+				resource_size(elbi_base), pdev->name)) {
+		dev_err(&pdev->dev, "elbi base resource is busy\n");
+		return -EBUSY;
+	}
+	pp->elbi_base = (void __iomem *) (unsigned long)elbi_base->start;
+	pp->va_elbi_base = devm_ioremap(&pdev->dev, elbi_base->start,
+			resource_size(elbi_base));
+	if (!pp->va_elbi_base) {
+		dev_err(&pdev->dev, "error with ioremap\n");
+		return -ENOMEM;
+	}
+
+	phy_base = platform_get_resource(pdev, IORESOURCE_MEM, 2);
+	if (!phy_base) {
+		dev_err(&pdev->dev, "couldn't get phy base resource\n");
+		return -EINVAL;
+	}
+	if (!devm_request_mem_region(&pdev->dev, phy_base->start,
+				resource_size(phy_base), pdev->name)) {
+		dev_err(&pdev->dev, "phy base resource is busy\n");
+		return -EBUSY;
+	}
+
+	pp->phy_base = (void __iomem *) (unsigned long)phy_base->start;
+	pp->va_phy_base = devm_ioremap(&pdev->dev, phy_base->start,
+			resource_size(phy_base));
+	if (!pp->va_phy_base) {
+		dev_err(&pdev->dev, "error with ioremap\n");
+		return -ENOMEM;
+	}
+
+	purple_base = platform_get_resource(pdev, IORESOURCE_MEM, 3);
+	if (!purple_base) {
+		dev_err(&pdev->dev, "couldn't get purple base resource\n");
+		return -EINVAL;
+	}
+	if (!devm_request_mem_region(&pdev->dev, purple_base->start,
+				resource_size(purple_base), pdev->name)) {
+		dev_err(&pdev->dev, "purple base resource is busy\n");
+		return -EBUSY;
+	}
+
+	pp->purple_base = (void __iomem *) (unsigned long)purple_base->start;
+	pp->va_purple_base = devm_ioremap(&pdev->dev, purple_base->start,
+			resource_size(purple_base));
+	if (!pp->va_purple_base) {
+		dev_err(&pdev->dev, "error with ioremap\n");
+		return -ENOMEM;
+	}
+
+	pp->irq = platform_get_irq(pdev, 1);
+	if (!pp->irq) {
+		dev_err(&pdev->dev, "failed to get irq\n");
+		return -ENODEV;
+	}
+
+	ret = devm_request_irq(&pdev->dev, pp->irq, exynos_pcie_irq_handler,
+				IRQF_SHARED, "exynos-pcie", pp);
+	if (ret) {
+		dev_err(&pdev->dev, "failed to request irq\n");
+		return ret;
+	}
+
+	pp->base = pp->dbi_base;
+
+	pp->root_bus_nr = -1;
+
+	spin_lock_init(&pp->conf_lock);
+	exynos_pcie_host_init(pp);
+	pp->va_cfg0_base = ioremap((u32)pp->cfg0_base, pp->config.cfg0_size);
+	if (!pp->va_cfg0_base) {
+		dev_err(pp->dev, "error with ioremap in function\n");
+		return -ENOMEM;
+	}
+	pp->va_cfg1_base = ioremap((u32)pp->cfg1_base, pp->config.cfg1_size);
+	if (!pp->va_cfg1_base) {
+		dev_err(pp->dev, "error with ioremap\n");
+		return -ENOMEM;
+	}
+
+	return 0;
+}
+
+static int __init exynos_pcie_probe(struct platform_device *pdev)
+{
+	struct pcie_port *pp;
+	struct device_node *np = pdev->dev.of_node;
+	struct of_pci_range_iter iter;
+	int ret;
+
+	pp = devm_kzalloc(&pdev->dev, sizeof(*pp), GFP_KERNEL);
+	if (!pp) {
+		dev_err(&pdev->dev, "no memory for pcie port\n");
+		return -ENOMEM;
+	}
+
+	pp->dev = &pdev->dev;
+
+	/* Get the I/O and memory ranges from DT */
+	for_each_of_pci_range(&iter, np) {
+		unsigned long restype = iter.flags & IORESOURCE_TYPE_BITS;
+		if (restype == IORESOURCE_IO) {
+			range_iter_fill_resource(iter, np, &pp->io);
+			pp->io.name = "I/O";
+			pp->config.io_size = resource_size(&pp->io);
+		}
+		if (restype == IORESOURCE_MEM) {
+			range_iter_fill_resource(iter, np, &pp->mem);
+			pp->mem.name = "MEM";
+			pp->config.mem_size = resource_size(&pp->mem);
+		}
+		if (restype == 0) {
+			pp->config.cfg0_size = iter.size/2;
+			pp->config.cfg1_size = iter.size/2;
+		}
+	}
+
+	pp->config.in_mem_size = SZ_256M;
+
+	/* Get the bus range */
+	ret = of_pci_parse_bus_range(np, &pp->busn);
+	if (ret) {
+		dev_err(&pdev->dev, "failed to parse bus-range property: %d\n",
+			ret);
+		return ret;
+	}
+
+	ret = of_property_read_u32(np, "reset-gpio", &pp->reset_gpio);
+	if (ret < 0)
+		pp->reset_gpio = -1;
+
+	ret = add_pcie_port(pp, pdev);
+	if (ret < 0)
+		return ret;
+
+	pp->controller = exynos_pci.nr_controllers;
+	exynos_pci.nr_controllers++;
+	list_add_tail(&pp->next, &pcie_port_list);
+
+	return 0;
+}
+
+static int __exit exynos_pcie_remove(struct platform_device *pdev)
+{
+	return 0;
+}
+
+static const struct of_device_id exynos_pcie_of_match[] = {
+	{ .compatible = "samsung,exynos5440-pcie", },
+	{},
+};
+MODULE_DEVICE_TABLE(of, exynos_pcie_of_match);
+
+static struct platform_driver exynos_pcie_driver = {
+	.probe		= exynos_pcie_probe,
+	.remove		= __exit_p(exynos_pcie_remove),
+	.driver = {
+		.name	= "exynos-pcie",
+		.owner	= THIS_MODULE,
+		.of_match_table = of_match_ptr(exynos_pcie_of_match),
+	},
+};
+
+static int exynos_pcie_abort(unsigned long addr, unsigned int fsr,
+			struct pt_regs *regs)
+{
+	unsigned long pc = instruction_pointer(regs);
+	unsigned long instr = *(unsigned long *)pc;
+
+	WARN_ONCE(1, "pcie abort\n");
+
+	/*
+	 * If the instruction being executed was a read,
+	 * make it look like it read all-ones.
+	 */
+	if ((instr & 0x0c100000) == 0x04100000) {
+		int reg = (instr >> 12) & 15;
+		unsigned long val;
+
+		if (instr & 0x00400000)
+			val = 255;
+		else
+			val = -1;
+
+		regs->uregs[reg] = val;
+		regs->ARM_pc += 4;
+		return 0;
+	}
+
+	if ((instr & 0x0e100090) == 0x00100090) {
+		int reg = (instr >> 12) & 15;
+
+		regs->uregs[reg] = -1;
+		regs->ARM_pc += 4;
+		return 0;
+	}
+
+	return 1;
+}
+
+static int __init pcie_init(void)
+{
+	hook_fault_code(16 + 6, exynos_pcie_abort, SIGBUS, 0,
+			"imprecise external abort");
+
+	INIT_LIST_HEAD(&pcie_port_list);
+	platform_driver_probe(&exynos_pcie_driver, exynos_pcie_probe);
+
+	if (exynos_pci.nr_controllers) {
+		pci_common_init(&exynos_pci);
+		pci_assign_unassigned_resources();
+	}
+
+	return 0;
+}
+subsys_initcall(pcie_init);
+
+static void __exit pcie_exit(void)
+{
+	platform_driver_unregister(&exynos_pcie_driver);
+}
+module_exit(pcie_exit);
+
+MODULE_AUTHOR("Jingoo Han <jg1.han@samsung.com>");
+MODULE_DESCRIPTION("Samsung PCIe host controller driver");
+MODULE_LICENSE("GPLv2");
-- 
1.7.2.5


