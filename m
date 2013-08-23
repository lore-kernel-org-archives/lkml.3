Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754616Ab3HWGE0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 02:04:26 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:11048 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754423Ab3HWGEX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 02:04:23 -0400
X-AuditID: cbfee68d-b7fe86d0000077a5-71-5216fb65b4f3
From: Jingoo Han <jg1.han@samsung.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-pci@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        Kukjin Kim <kgene.kim@samsung.com>,
        Pratyush Anand <pratyush.anand@st.com>,
        Mohit KUMAR <Mohit.KUMAR@st.com>,
        Siva Reddy Kallam <siva.kallam@samsung.com>,
        "'SRIKANTH TUMKUR SHIVANAND'" <ts.srikanth@samsung.com>,
        Arnd Bergmann <arnd@arndb.de>, "'Sean Cross'" <xobs@kosagi.com>,
        "'Kishon Vijay Abraham I'" <kishon@ti.com>,
        "'Thierry Reding'" <thierry.reding@gmail.com>,
        "'Thomas Petazzoni'" <thomas.petazzoni@free-electrons.com>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH V2] PCI: exynos: add support for MSI
Date: Fri, 23 Aug 2013 15:04:20 +0900
Message-id: <003d01ce9fc6$9c0f1c20$d42d5460$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac6fxpvmRk71lW5yRCWYZX61UeE3DQ==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupmleLIzCtJLcpLzFFi42I5/e+ZgW7qb7Egg4c/JS3+TjrGbrGkKcPi
	5SFNi/lHzrFaXF54idWid8FVNosLT3vYLC7vmsNmcXbecTaLGef3MVlsnPqL0aL9krLFiqat
	jBY/d81jsXj6oInJovHoA1aL1icPGB0EPX7/msTo8WTTRUaPnbPusnss2FTq8X3hfHaPvi2r
	GD2e/tjL7HH8xnYmj8+b5AI4o7hsUlJzMstSi/TtErgyDn8+xFLQFFsx689XxgbGVV5djJwc
	EgImEu939zNC2GISF+6tZ+ti5OIQEljGKHH/3nsmmKIDPx8wQSQWMUo8bbzLDJIQEvjFKLHw
	ZAmIzSagJvHly2F2EFtEQF1i4VGIZmaBSywSSxrFQWxhoEHT519nA7FZBFQlPn39CTaHV8BW
	4uqeZ6wQtqDEj8n3WCB6tSTW7zwONUdeYvOat0D1HEAHqUs8+qsLsUpPYvnBp2wQJSIS+168
	YwS5U0JgLYfEvU99TBC7BCS+TT7EAtErK7HpADPEX5ISB1fcYJnAKDYLyeZZSDbPQrJ5FpIV
	CxhZVjGKphYkFxQnpRcZ6hUn5haX5qXrJefnbmKEJITeHYy3D1gfYkwGWj+RWUo0OR+YUPJK
	4g2NzYwsTE1MjY3MLc1IE1YS51VrsQ4UEkhPLEnNTk0tSC2KLyrNSS0+xMjEwSnVwBhcdtbS
	qmTHw2ucOX8OzE25VX7K7ZBV6JmIkyfa5n39YzVx5x9rxyCuSsvDT8y/LPP1d9qge1ht6fT0
	1FfHjSXXZOysSBLVWvSj+bfdnlV/3Kex3P1qFt11+ZZpfsTawhOHLdZc+zO/NnZ6deaU598s
	dX59/7sunDvi3cJChmN2Rp2LY5cwfdyvxFKckWioxVxUnAgADFxuKh4DAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrBKsWRmVeSWpSXmKPExsVy+t9jAd3U32JBBgv3CVn8nXSM3WJJU4bF
	y0OaFvOPnGO1uLzwEqtF74KrbBYXnvawWVzeNYfN4uy842wWM87vY7LYOPUXo0X7JWWLFU1b
	GS1+7prHYvH0QROTRePRB6wWrU8eMDoIevz+NYnR48mmi4weO2fdZfdYsKnU4/vC+ewefVtW
	MXo8/bGX2eP4je1MHp83yQVwRjUw2mSkJqakFimk5iXnp2TmpdsqeQfHO8ebmhkY6hpaWpgr
	KeQl5qbaKrn4BOi6ZeYAfaKkUJaYUwoUCkgsLlbSt8M0ITTETdcCpjFC1zckCK7HyAANJKxj
	zDj8+RBLQVNsxaw/XxkbGFd5dTFyckgImEgc+PmACcIWk7hwbz1bFyMXh5DAIkaJp413mUES
	QgK/GCUWniwBsdkE1CS+fDnMDmKLCKhLLDz6HqyZWeASi8SSRnEQWxho6PT519lAbBYBVYlP
	X3+CzeEVsJW4uucZK4QtKPFj8j0WiF4tifU7j0PNkZfYvOYtUD0H0EHqEo/+6kKs0pNYfvAp
	G0SJiMS+F+8YJzAKzEIyaRaSSbOQTJqFpGUBI8sqRtHUguSC4qT0XCO94sTc4tK8dL3k/NxN
	jOB080x6B+OqBotDjAIcjEo8vBOcxYKEWBPLiitzDzFKcDArifDarAIK8aYkVlalFuXHF5Xm
	pBYfYkwGenQis5Rocj4wFeaVxBsam5gZWRqZWRiZmJuTJqwkznuw1TpQSCA9sSQ1OzW1ILUI
	ZgsTB6dUA2NTx8Nr/7J8OBfecJooYGz7T0dMfCPTpAv82ULF2hFtoTcfCs30MtyfIs0480dp
	y6djc23dbLav+fSqeWNZ4ikx7zrZ/lVWJkbR0+rNzVsuaj6qednS/f2P0Xyp+2LTXvcqsfOG
	2K9NEWTaPE19WVD283fx+y5/jploMZU3rNn25qGi2NhXNUosxRmJhlrMRcWJAHjdM0J7AwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for Message Signaled Interrupt in the
Exynos PCIe diver using Synopsys designware PCIe core IP.

Signed-off-by: Siva Reddy Kallam <siva.kallam@samsung.com>
Signed-off-by: Srikanth T Shivanand <ts.srikanth@samsung.com>
Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Pratyush Anand <pratyush.anand@st.com>
Cc: Mohit KUMAR <Mohit.KUMAR@st.com>
---
Changes since v1:
- removed unnecessary exynos_pcie_clear_irq_level()
- updated the bindings documentation
- used new msi_chip infrastructure
- removed ARCH_SUPPORTS_MSI
- replaced #ifdef guards with IS_ENABLED(CONFIG_PCI_MSI)

 .../devicetree/bindings/pci/designware-pcie.txt    |    2 +
 arch/arm/boot/dts/exynos5440.dtsi                  |    2 +
 drivers/pci/host/pci-exynos.c                      |   47 ++++
 drivers/pci/host/pcie-designware.c                 |  225 ++++++++++++++++++++
 drivers/pci/host/pcie-designware.h                 |    4 +
 5 files changed, 280 insertions(+)

diff --git a/Documentation/devicetree/bindings/pci/designware-pcie.txt b/Documentation/devicetree/bindings/pci/designware-pcie.txt
index eabcb4b..00bb935 100644
--- a/Documentation/devicetree/bindings/pci/designware-pcie.txt
+++ b/Documentation/devicetree/bindings/pci/designware-pcie.txt
@@ -43,6 +43,7 @@ SoC specific DT Entry:
 		interrupt-map-mask = <0 0 0 0>;
 		interrupt-map = <0x0 0 &gic 53>;
 		num-lanes = <4>;
+		msi-base = <200>;
 	};
 
 	pcie@2a0000 {
@@ -63,6 +64,7 @@ SoC specific DT Entry:
 		interrupt-map-mask = <0 0 0 0>;
 		interrupt-map = <0x0 0 &gic 56>;
 		num-lanes = <4>;
+		msi-base = <232>;
 	};
 
 Board specific DT Entry:
diff --git a/arch/arm/boot/dts/exynos5440.dtsi b/arch/arm/boot/dts/exynos5440.dtsi
index 5d6cf49..17549b9 100644
--- a/arch/arm/boot/dts/exynos5440.dtsi
+++ b/arch/arm/boot/dts/exynos5440.dtsi
@@ -276,6 +276,7 @@
 		interrupt-map-mask = <0 0 0 0>;
 		interrupt-map = <0x0 0 &gic 53>;
 		num-lanes = <4>;
+		msi-base = <200>;
 	};
 
 	pcie@2a0000 {
@@ -296,5 +297,6 @@
 		interrupt-map-mask = <0 0 0 0>;
 		interrupt-map = <0x0 0 &gic 56>;
 		num-lanes = <4>;
+		msi-base = <232>;
 	};
 };
diff --git a/drivers/pci/host/pci-exynos.c b/drivers/pci/host/pci-exynos.c
index 012ca8a..aaead2c 100644
--- a/drivers/pci/host/pci-exynos.c
+++ b/drivers/pci/host/pci-exynos.c
@@ -48,6 +48,7 @@ struct exynos_pcie {
 #define PCIE_IRQ_SPECIAL		0x008
 #define PCIE_IRQ_EN_PULSE		0x00c
 #define PCIE_IRQ_EN_LEVEL		0x010
+#define IRQ_MSI_ENABLE			(0x1 << 2)
 #define PCIE_IRQ_EN_SPECIAL		0x014
 #define PCIE_PWR_RESET			0x018
 #define PCIE_CORE_RESET			0x01c
@@ -320,9 +321,38 @@ static irqreturn_t exynos_pcie_irq_handler(int irq, void *arg)
 	return IRQ_HANDLED;
 }
 
+static irqreturn_t exynos_pcie_msi_irq_handler(int irq, void *arg)
+{
+	struct pcie_port *pp = arg;
+
+	/* handle msi irq */
+	dw_handle_msi_irq(pp);
+
+	return IRQ_HANDLED;
+}
+
+static void exynos_pcie_msi_init(struct pcie_port *pp)
+{
+	u32 val;
+	struct exynos_pcie *exynos_pcie = to_exynos_pcie(pp);
+	void __iomem *elbi_base = exynos_pcie->elbi_base;
+
+	dw_pcie_msi_init(pp);
+
+	/* enable MSI interrupt */
+	val = readl(elbi_base + PCIE_IRQ_EN_LEVEL);
+	val |= IRQ_MSI_ENABLE;
+	writel(val, elbi_base + PCIE_IRQ_EN_LEVEL);
+	return;
+}
+
 static void exynos_pcie_enable_interrupts(struct pcie_port *pp)
 {
 	exynos_pcie_enable_irq_pulse(pp);
+
+	if (IS_ENABLED(CONFIG_PCI_MSI))
+		exynos_pcie_msi_init(pp);
+
 	return;
 }
 
@@ -408,6 +438,23 @@ static int add_pcie_port(struct pcie_port *pp, struct platform_device *pdev)
 		return ret;
 	}
 
+	if (IS_ENABLED(CONFIG_PCI_MSI)) {
+		pp->msi_irq = platform_get_irq(pdev, 0);
+
+		if (!pp->msi_irq) {
+			dev_err(&pdev->dev, "failed to get msi irq\n");
+			return -ENODEV;
+		}
+
+		ret = devm_request_irq(&pdev->dev, pp->msi_irq,
+					exynos_pcie_msi_irq_handler,
+					IRQF_SHARED, "exynos-pcie", pp);
+		if (ret) {
+			dev_err(&pdev->dev, "failed to request msi irq\n");
+			return ret;
+		}
+	}
+
 	pp->root_bus_nr = -1;
 	pp->ops = &exynos_pcie_host_ops;
 
diff --git a/drivers/pci/host/pcie-designware.c b/drivers/pci/host/pcie-designware.c
index 77b0c25..a4fed11 100644
--- a/drivers/pci/host/pcie-designware.c
+++ b/drivers/pci/host/pcie-designware.c
@@ -11,8 +11,10 @@
  * published by the Free Software Foundation.
  */
 
+#include <linux/irq.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/msi.h>
 #include <linux/of_address.h>
 #include <linux/pci.h>
 #include <linux/pci_regs.h>
@@ -62,6 +64,12 @@
 #define PCIE_ATU_FUNC(x)		(((x) & 0x7) << 16)
 #define PCIE_ATU_UPPER_TARGET		0x91C
 
+#define MAX_MSI_IRQS			32
+#define MAX_MSI_CTRLS			8
+
+static unsigned int msi_data;
+static DECLARE_BITMAP(msi_irq_in_use, MAX_MSI_IRQS);
+
 static struct hw_pci dw_pci;
 
 unsigned long global_io_offset;
@@ -144,6 +152,205 @@ int dw_pcie_wr_own_conf(struct pcie_port *pp, int where, int size,
 	return ret;
 }
 
+static struct irq_chip dw_msi_irq_chip = {
+	.name = "PCI-MSI",
+	.irq_enable = unmask_msi_irq,
+	.irq_disable = mask_msi_irq,
+	.irq_mask = mask_msi_irq,
+	.irq_unmask = unmask_msi_irq,
+};
+
+/* MSI int handler */
+void dw_handle_msi_irq(struct pcie_port *pp)
+{
+	unsigned long val;
+	int i, pos;
+
+	for (i = 0; i < MAX_MSI_CTRLS; i++) {
+		dw_pcie_rd_own_conf(pp, PCIE_MSI_INTR0_STATUS + i * 12, 4,
+				(u32 *)&val);
+		if (val) {
+			pos = 0;
+			while ((pos = find_next_bit(&val, 32, pos)) != 32) {
+				generic_handle_irq(pp->msi_irq_start
+					+ (i * 32) + pos);
+				pos++;
+			}
+		}
+		dw_pcie_wr_own_conf(pp, PCIE_MSI_INTR0_STATUS + i * 12, 4, val);
+	}
+}
+
+void dw_pcie_msi_init(struct pcie_port *pp)
+{
+	/* program the msi_data */
+	dw_pcie_wr_own_conf(pp, PCIE_MSI_ADDR_LO, 4,
+			__virt_to_phys((u32)(&msi_data)));
+	dw_pcie_wr_own_conf(pp, PCIE_MSI_ADDR_HI, 4, 0);
+}
+
+static int find_valid_pos0(int msgvec, int pos, int *pos0)
+{
+	int flag = 1;
+
+	do {
+		pos = find_next_zero_bit(msi_irq_in_use,
+				MAX_MSI_IRQS, pos);
+		/*if you have reached to the end then get out from here.*/
+		if (pos == MAX_MSI_IRQS)
+			return -ENOSPC;
+		/*
+		 * Check if this position is at correct offset.nvec is always a
+		 * power of two. pos0 must be nvec bit alligned.
+		 */
+		if (pos % msgvec)
+			pos += msgvec - (pos % msgvec);
+		else
+			flag = 0;
+	} while (flag);
+
+	*pos0 = pos;
+	return 0;
+}
+
+static int assign_irq(int no_irqs, struct msi_desc *desc, int *pos)
+{
+	int res, bit, irq, pos0, pos1, i;
+	u32 val;
+	struct pcie_port *pp = sys_to_pcie(desc->dev->bus->sysdata);
+
+	if (!pp) {
+		BUG();
+		return -EINVAL;
+	}
+
+	pos0 = find_first_zero_bit(msi_irq_in_use,
+			MAX_MSI_IRQS);
+	if (pos0 % no_irqs) {
+		if (find_valid_pos0(no_irqs, pos0, &pos0))
+			goto no_valid_irq;
+	}
+	if (no_irqs > 1) {
+		pos1 = find_next_bit(msi_irq_in_use,
+				MAX_MSI_IRQS, pos0);
+		/* there must be nvec number of consecutive free bits */
+		while ((pos1 - pos0) < no_irqs) {
+			if (find_valid_pos0(no_irqs, pos1, &pos0))
+				goto no_valid_irq;
+			pos1 = find_next_bit(msi_irq_in_use,
+					MAX_MSI_IRQS, pos0);
+		}
+	}
+
+	irq = (pp->msi_irq_start + pos0);
+
+	if ((irq + no_irqs) > (pp->msi_irq_start + MAX_MSI_IRQS-1))
+		goto no_valid_irq;
+
+	i = 0;
+	while (i < no_irqs) {
+		set_bit(pos0 + i, msi_irq_in_use);
+		irq_alloc_descs((irq + i), (irq + i), 1, 0);
+		irq_set_msi_desc(irq + i, desc);
+		irq_set_chip_and_handler(irq + i, &dw_msi_irq_chip,
+					handle_simple_irq);
+		set_irq_flags(irq + i, IRQF_VALID);
+		/*Enable corresponding interrupt in MSI interrupt controller */
+		res = ((pos0 + i) / 32) * 12;
+		bit = (pos0 + i) % 32;
+		dw_pcie_rd_own_conf(pp, PCIE_MSI_INTR0_ENABLE + res, 4, &val);
+		val |= 1 << bit;
+		dw_pcie_wr_own_conf(pp, PCIE_MSI_INTR0_ENABLE + res, 4, val);
+		i++;
+	}
+
+	*pos = pos0;
+	return irq;
+
+no_valid_irq:
+	*pos = pos0;
+	return -ENOSPC;
+}
+
+static void clear_irq(unsigned int irq)
+{
+	int res, bit, val, pos;
+	struct irq_desc *desc;
+	struct msi_desc *msi;
+	struct pcie_port *pp;
+
+	/* get the port structure */
+	desc = irq_to_desc(irq);
+	msi = irq_desc_get_msi_desc(desc);
+	pp = sys_to_pcie(msi->dev->bus->sysdata);
+	if (!pp) {
+		BUG();
+		return;
+	}
+
+	pos = irq - pp->msi_irq_start;
+
+	irq_free_desc(irq);
+
+	clear_bit(pos, msi_irq_in_use);
+
+	/* Disable corresponding interrupt on MSI interrupt controller */
+	res = (pos / 32) * 12;
+	bit = pos % 32;
+	dw_pcie_rd_own_conf(pp, PCIE_MSI_INTR0_ENABLE + res, 4, &val);
+	val &= ~(1 << bit);
+	dw_pcie_wr_own_conf(pp, PCIE_MSI_INTR0_ENABLE + res, 4, val);
+}
+
+static int dw_msi_setup_irq(struct msi_chip *chip, struct pci_dev *pdev,
+			struct msi_desc *desc)
+{
+	int irq, pos, msgvec;
+	u16 msg_ctr;
+	struct msi_msg msg;
+	struct pcie_port *pp = sys_to_pcie(pdev->bus->sysdata);
+
+	if (!pp) {
+		BUG();
+		return -EINVAL;
+	}
+
+	pci_read_config_word(pdev, desc->msi_attrib.pos+PCI_MSI_FLAGS,
+				&msg_ctr);
+	msgvec = (msg_ctr&PCI_MSI_FLAGS_QSIZE) >> 4;
+	if (msgvec == 0)
+		msgvec = (msg_ctr & PCI_MSI_FLAGS_QMASK) >> 1;
+	if (msgvec > 5)
+		msgvec = 0;
+
+	irq = assign_irq((1 << msgvec), desc, &pos);
+	if (irq < 0)
+		return irq;
+
+	msg_ctr &= ~PCI_MSI_FLAGS_QSIZE;
+	msg_ctr |= msgvec << 4;
+	pci_write_config_word(pdev, desc->msi_attrib.pos + PCI_MSI_FLAGS,
+				msg_ctr);
+	desc->msi_attrib.multiple = msgvec;
+
+	msg.address_hi = 0x0;
+	msg.address_lo = __virt_to_phys((u32)(&msi_data));
+	msg.data = pos;
+	write_msi_msg(irq, &msg);
+
+	return 0;
+}
+
+static void dw_msi_teardown_irq(struct msi_chip *chip, unsigned int irq)
+{
+	clear_irq(irq);
+}
+
+static struct msi_chip dw_pcie_msi_chip = {
+	.setup_irq = dw_msi_setup_irq,
+	.teardown_irq = dw_msi_teardown_irq,
+};
+
 int dw_pcie_link_up(struct pcie_port *pp)
 {
 	if (pp->ops->link_up)
@@ -225,6 +432,13 @@ int __init dw_pcie_host_init(struct pcie_port *pp)
 		return -EINVAL;
 	}
 
+	if (IS_ENABLED(CONFIG_PCI_MSI)) {
+		if (of_property_read_u32(np, "msi-base", &pp->msi_irq_start)) {
+			dev_err(pp->dev, "Failed to parse the number of lanes\n");
+			return -EINVAL;
+		}
+	}
+
 	if (pp->ops->host_init)
 		pp->ops->host_init(pp);
 
@@ -509,10 +723,21 @@ int dw_pcie_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
 	return pp->irq;
 }
 
+static void dw_pcie_add_bus(struct pci_bus *bus)
+{
+	if (IS_ENABLED(CONFIG_PCI_MSI)) {
+		struct pcie_port *pp = sys_to_pcie(bus->sysdata);
+
+		dw_pcie_msi_chip.dev = pp->dev;
+		bus->msi = &dw_pcie_msi_chip;
+	}
+}
+
 static struct hw_pci dw_pci = {
 	.setup		= dw_pcie_setup,
 	.scan		= dw_pcie_scan_bus,
 	.map_irq	= dw_pcie_map_irq,
+	.add_bus	= dw_pcie_add_bus,
 };
 
 void dw_pcie_setup_rc(struct pcie_port *pp)
diff --git a/drivers/pci/host/pcie-designware.h b/drivers/pci/host/pcie-designware.h
index 133820f..3c01935 100644
--- a/drivers/pci/host/pcie-designware.h
+++ b/drivers/pci/host/pcie-designware.h
@@ -38,6 +38,8 @@ struct pcie_port {
 	int			irq;
 	u32			lanes;
 	struct pcie_host_ops	*ops;
+	int			msi_irq;
+	int			msi_irq_start;
 };
 
 struct pcie_host_ops {
@@ -57,6 +59,8 @@ int cfg_read(void __iomem *addr, int where, int size, u32 *val);
 int cfg_write(void __iomem *addr, int where, int size, u32 val);
 int dw_pcie_wr_own_conf(struct pcie_port *pp, int where, int size, u32 val);
 int dw_pcie_rd_own_conf(struct pcie_port *pp, int where, int size, u32 *val);
+void dw_handle_msi_irq(struct pcie_port *pp);
+void dw_pcie_msi_init(struct pcie_port *pp);
 int dw_pcie_link_up(struct pcie_port *pp);
 void dw_pcie_setup_rc(struct pcie_port *pp);
 int dw_pcie_host_init(struct pcie_port *pp);
-- 
1.7.10.4


