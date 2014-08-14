Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753848AbaHNC4w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 22:56:52 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:40770 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753554AbaHNC4t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 22:56:49 -0400
X-AuditID: cbfee690-b7f526d000003627-6b-53ec256ed393
From: Jingoo Han <jg1.han@samsung.com>
To: "'Suravee Suthikulpanit'" <suravee.suthikulpanit@amd.com>
Cc: marc.zyngier@arm.com, mark.rutland@arm.com, jason@lakedaemon.net,
        pawel.moll@arm.com, Catalin.Marinas@arm.com, Will.Deacon@arm.com,
        tglx@linutronix.de, Harish.Kasiviswanathan@amd.com,
        linux-arm-kernel@lists.infradead.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        devicetree@vger.kernel.org, "'Mark Rutland'" <Mark.Rutland@arm.com>,
        "'Marc Zyngier'" <Marc.Zyngier@arm.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <1407942041-3291-1-git-send-email-suravee.suthikulpanit@amd.com>
 <1407942041-3291-2-git-send-email-suravee.suthikulpanit@amd.com>
In-reply-to: <1407942041-3291-2-git-send-email-suravee.suthikulpanit@amd.com>
Subject: Re: [PATCH 1/2 V4] irqchip: gic: Add supports for ARM GICv2m MSI(-X)
Date: Thu, 14 Aug 2014 11:56:45 +0900
Message-id: <003d01cfb76b$629b43c0$27d1cb40$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac+3B4H06fq5oC8KSUqoYuPCsVIzDAAYIteA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprKKsWRmVeSWpSXmKPExsVy+t8zI9081TfBBjMWilm8X9bDaDH/yDlW
	i+ObbjFaNC65zGJxeeElVotNj6+xWixsWwLk7prDZnF23nE2i793/rFZLL1+kcliwvS1LBYT
	fyxgtNi8aSqzxcuPJ1gc+D1aL/1l81gzbw2jR8OB8ywe786dY/fYvKTeo2/LKkaPz5vkAtij
	uGxSUnMyy1KL9O0SuDL2bFzMXjAhuOL9uglsDYx7HbsYOTkkBEwkWtq/sEHYYhIX7q0Hsrk4
	hASWMUp8f32RBaboX89qqMQiRomGf53MEM5vRol1m6+DtbMJqEl8+XKYHcQWEbCWeL3sMwtI
	EbPAOWaJno8/WCE6+hklVm35BDaXU8BXYsXpf2AdwkD2/oUtYJNYBFQlLn55zApi8wrYSqyZ
	+5gRwhaU+DH5Hlgvs4CWxPqdx5kgbHmJzWveAp3EAXSrusSjv7oQRxhJfHyylRGiRERi34t3
	jCA3SAhs4ZA4O2ElI8QuAYlvkw+xQPTKSmw6wAzxsqTEwRU3WCYwSsxCsnkWks2zkGyehWTF
	AkaWVYyiqQXJBcVJ6UUmesWJucWleel6yfm5mxghSWLCDsZ7B6wPMSYDrZ/ILCWanA9MMnkl
	8YbGZkYWpiamxkbmlmakCSuJ86o9SgoSEkhPLEnNTk0tSC2KLyrNSS0+xMjEwSnVwBi+NqH0
	tfLZVUGre541OofvfbzzxXa+FofIlKiS6hdBe6q7Xh5RCT9fsjC/Z8akXj8Gpwv901VWdTla
	2Hjs65sn9zt5jaeZ+qTX77b5Xo7gmZDDXruqek3ML9dJaR+r3G3P1/b9zlZ4yCK0wGi6scCF
	hCi2Z4eM//6/d7z0XYCt2TJvx3sx25RYijMSDbWYi4oTAcqI6qkoAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCKsWRmVeSWpSXmKPExsVy+t9jAd081TfBBrfe8Fu8X9bDaDH/yDlW
	i+ObbjFaNC65zGJxeeElVotNj6+xWixsWwLk7prDZnF23nE2i793/rFZLL1+kcliwvS1LBYT
	fyxgtNi8aSqzxcuPJ1gc+D1aL/1l81gzbw2jR8OB8ywe786dY/fYvKTeo2/LKkaPz5vkAtij
	GhhtMlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwCdN0yc4AOV1Io
	S8wpBQoFJBYXK+nbYZoQGuKmawHTGKHrGxIE12NkgAYS1jFm7Nm4mL1gQnDF+3UT2BoY9zp2
	MXJySAiYSPzrWc0GYYtJXLi3Hsjm4hASWMQo0fCvkxnC+c0osW7zdbAqNgE1iS9fDrOD2CIC
	1hKvl31mASliFjjHLNHz8QcrREc/o8SqLZ9YQKo4BXwlVpz+B9YhDGTvX9gCNolFQFXi4pfH
	rCA2r4CtxJq5jxkhbEGJH5PvgfUyC2hJrN95nAnClpfYvOYt0EkcQLeqSzz6qwtxhJHExydb
	GSFKRCT2vXjHOIFRaBaSSbOQTJqFZNIsJC0LGFlWMYqmFiQXFCel5xrqFSfmFpfmpesl5+du
	YgSnoGdSOxhXNlgcYhTgYFTi4fWIeh0sxJpYVlyZe4hRgoNZSYRXmflNsBBvSmJlVWpRfnxR
	aU5q8SFGU6BHJzJLiSbnA9NjXkm8obGJmZGlkZmFkYm5uZI474FW60AhgfTEktTs1NSC1CKY
	PiYOTqkGRgOl8+0/7YsmukxTq0ua8++E5716nsLzru8XbY9tjTjOdzdItj5NZcPx1YoPiw5t
	W1YiOeHay0NZx5dvvKvk+S+vZKvgrKV5U27Nr5+1elVTWITR9WqHrieFH8oe+v8OEv6ee0dH
	Nb79R+yk99qBs5afmPWFS/6JUpRahmP/mk0XPmmI3v+wfZUSS3FGoqEWc1FxIgDwtHebVwMA	AA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, August 14, 2014 12:01 AM, Suravee Suthikulpanit wrote:
> 
> From: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
> 
> ARM GICv2m specification extends GICv2 to support MSI(-X) with
> a new set of register frame. This patch introduces support for
> the non-secure GICv2m register frame. Currently, GICV2m is available
> in certain version of GIC-400.
> 
> The patch introduces a new property in ARM gic binding, the v2m subnode.
> It is optional.

Hi Suravee Suthikulpanit,

I added some minor comments.

> 
> Signed-off-by: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
> Cc: Mark Rutland <Mark.Rutland@arm.com>
> Cc: Marc Zyngier <Marc.Zyngier@arm.com>
> Cc: Jason Cooper <jason@lakedaemon.net>
> Cc: Catalin Marinas <Catalin.Marinas@arm.com>
> Cc: Will Deacon <Will.Deacon@arm.com>
> ---
>  Documentation/devicetree/bindings/arm/gic.txt |  32 ++++
>  drivers/irqchip/Kconfig                       |   7 +
>  drivers/irqchip/Makefile                      |   1 +
>  drivers/irqchip/irq-gic-v2m.c                 | 215 ++++++++++++++++++++++++++
>  drivers/irqchip/irq-gic.c                     |  75 +++++----
>  drivers/irqchip/irq-gic.h                     |  48 ++++++
>  6 files changed, 348 insertions(+), 30 deletions(-)
>  create mode 100644 drivers/irqchip/irq-gic-v2m.c
>  create mode 100644 drivers/irqchip/irq-gic.h
> 
> diff --git a/Documentation/devicetree/bindings/arm/gic.txt
> b/Documentation/devicetree/bindings/arm/gic.txt
> index 5573c08..8a64179 100644
> --- a/Documentation/devicetree/bindings/arm/gic.txt
> +++ b/Documentation/devicetree/bindings/arm/gic.txt
> @@ -95,3 +95,35 @@ Example:
>  		      <0x2c006000 0x2000>;
>  		interrupts = <1 9 0xf04>;
>  	};
> +
> +

Please remove the unnecessary line.

> +* GICv2m extension for MSI/MSI-x support (Optional)
> +
> +Certain revision of GIC-400 supports MSI/MSI-x via V2M register frame.
> +This is enabled by specifying v2m sub-node.
> +
> +Required properties:
> +
> +- msi-controller : Identifies the node as an MSI controller.
> +
> +- reg : GICv2m MSI interface register base and size
> +
> +Example:
> +
> +	interrupt-controller@e1101000 {
> +		compatible = "arm,gic-400";
> +		#interrupt-cells = <3>;
> +		#address-cells = <2>;
> +		#size-cells = <2>;
> +		interrupt-controller;
> +		interrupts = <1 8 0xf04>;
> +		ranges = <0 0 0 0xe1100000 0 0x100000>;
> +		reg = <0x0 0xe1110000 0 0x01000>,
> +		      <0x0 0xe112f000 0 0x02000>,
> +		      <0x0 0xe1140000 0 0x10000>,
> +		      <0x0 0xe1160000 0 0x10000>;
> +		v2m {
> +			msi-controller;
> +			reg = <0x0 0x80000 0 0x1000>;
> +		};
> +	};
> diff --git a/drivers/irqchip/Kconfig b/drivers/irqchip/Kconfig
> index 4e230e7..9aa5edc 100644
> --- a/drivers/irqchip/Kconfig
> +++ b/drivers/irqchip/Kconfig
> @@ -7,6 +7,13 @@ config ARM_GIC
>  	select IRQ_DOMAIN
>  	select MULTI_IRQ_HANDLER
> 
> +config ARM_GIC_V2M
> +	bool
> +	select IRQ_DOMAIN
> +	select MULTI_IRQ_HANDLER
> +	depends on ARM_GIC
> +	depends on PCI && PCI_MSI
> +
>  config GIC_NON_BANKED
>  	bool
> 
> diff --git a/drivers/irqchip/Makefile b/drivers/irqchip/Makefile
> index 73052ba..3bda951 100644
> --- a/drivers/irqchip/Makefile
> +++ b/drivers/irqchip/Makefile
> @@ -17,6 +17,7 @@ obj-$(CONFIG_ARCH_SUNXI)		+= irq-sun4i.o
>  obj-$(CONFIG_ARCH_SUNXI)		+= irq-sunxi-nmi.o
>  obj-$(CONFIG_ARCH_SPEAR3XX)		+= spear-shirq.o
>  obj-$(CONFIG_ARM_GIC)			+= irq-gic.o irq-gic-common.o
> +obj-$(CONFIG_ARM_GIC_V2M)		+= irq-gic-v2m.o
>  obj-$(CONFIG_ARM_GIC_V3)		+= irq-gic-v3.o irq-gic-common.o
>  obj-$(CONFIG_ARM_NVIC)			+= irq-nvic.o
>  obj-$(CONFIG_ARM_VIC)			+= irq-vic.o
> diff --git a/drivers/irqchip/irq-gic-v2m.c b/drivers/irqchip/irq-gic-v2m.c
> new file mode 100644
> index 0000000..1ac0ace
> --- /dev/null
> +++ b/drivers/irqchip/irq-gic-v2m.c
> @@ -0,0 +1,215 @@
> +/*
> + * ARM GIC v2m MSI(-X) support
> + * Support for Message Signalelled Interrupts for systems that

s/Signalelled/Signaled

> + * implement ARM Generic Interrupt Controller: GICv2m.
> + *
> + * Copyright (C) 2014 Advanced Micro Devices, Inc.
> + * Authors: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
> + *          Harish Kasiviswanathan <harish.kasiviswanathan@amd.com>
> + *          Brandon Anderson <brandon.anderson@amd.com>
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms of the GNU General Public License version 2 as published
> + * by the Free Software Foundation.
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/platform_device.h>
> +#include <linux/pci.h>
> +#include <linux/irq.h>
> +#include <linux/spinlock.h>
> +#include <linux/slab.h>
> +#include <linux/of_address.h>
> +#include <linux/of_pci.h>
> +#include <linux/bitmap.h>

Please, re-order these headers alphabetically.
It enhances the readability.

> +
> +#include "irqchip.h"
> +#include "irq-gic.h"
> +
> +/*
> +* MSI_TYPER:
> +*     [31:26] Reserved
> +*     [25:16] lowest SPI assigned to MSI
> +*     [15:10] Reserved
> +*     [9:0]   Numer of SPIs assigned to MSI
> +*/
> +#define V2M_MSI_TYPER			0x008
> +#define V2M_MSI_TYPER_BASE_SHIFT	(16)
> +#define V2M_MSI_TYPER_BASE_MASK		(0x3FF)
> +#define V2M_MSI_TYPER_NUM_MASK		(0x3FF)

These braces are unnecessary.
Please remove them as follows.

+#define V2M_MSI_TYPER_BASE_SHIFT	16
+#define V2M_MSI_TYPER_BASE_MASK		0x3FF
+#define V2M_MSI_TYPER_NUM_MASK		0x3FF

> +#define V2M_MSI_SETSPI_NS		0x040
> +#define V2M_MIN_SPI			32
> +#define V2M_MAX_SPI			1019
> +
> +/*
> + * alloc_msi_irq - Allocate MSIs from avaialbe MSI bitmap.

s/avaialbe/available

> + * @data: Pointer to v2m_data
> + * @nvec: Number of interrupts to allocate
> + * @irq: Pointer to the allocated irq
> + *
> + * Allocates interrupts only if the contiguous range of MSIs
> + * with specified nvec are available. Otherwise return the number
> + * of available interrupts. If none are available, then returns -ENOENT.
> + */
> +static int alloc_msi_irq(struct v2m_data *data, int nvec, int *irq)
> +{
> +	int size = data->nr_spis;
> +	int next = size, i = nvec, ret;
> +
> +	/* We should never allocate more than available nr_spis */
> +	if (i >= size)
> +		i = size;
> +
> +	spin_lock(&data->msi_cnt_lock);
> +
> +	for (; i > 0; i--) {
> +		next = bitmap_find_next_zero_area(data->bm,
> +					size, 0, i, 0);
> +		if (next < size)
> +			break;
> +	}
> +
> +	if (i != nvec) {
> +		ret = i ? : -ENOENT;
> +	} else {
> +		bitmap_set(data->bm, next, nvec);
> +		*irq = data->spi_start + next;
> +		ret = 0;
> +	}
> +
> +	spin_unlock(&data->msi_cnt_lock);
> +
> +	return ret;
> +}
> +
> +static void gicv2m_teardown_msi_irq(struct msi_chip *chip, unsigned int irq)
> +{
> +	int pos;
> +	struct v2m_data *data = container_of(chip, struct v2m_data, msi_chip);
> +
> +	spin_lock(&data->msi_cnt_lock);
> +
> +	pos = irq - data->spi_start;
> +	if (pos >= 0 && pos < data->nr_spis)
> +		bitmap_clear(data->bm, pos, 1);
> +
> +	spin_unlock(&data->msi_cnt_lock);
> +}
> +
> +static int gicv2m_setup_msi_irq(struct msi_chip *chip, struct pci_dev *pdev,
> +		      struct msi_desc *desc)
> +{
> +	int avail, irq = 0;
> +	struct msi_msg msg;
> +	phys_addr_t addr;
> +	struct v2m_data *data = container_of(chip, struct v2m_data, msi_chip);
> +
> +	if (!desc) {
> +		dev_err(&pdev->dev,
> +			"GICv2m: MSI setup failed. Invalid msi descriptor\n");
> +		return -EINVAL;
> +	}
> +
> +	avail = alloc_msi_irq(data, 1, &irq);
> +	if (avail != 0) {
> +		dev_err(&pdev->dev,
> +			"GICv2m: MSI setup failed. Cannnot allocate IRQ\n");
> +		return -ENOSPC;
> +	}
> +
> +	irq_set_chip_data(irq, chip);
> +	irq_set_msi_desc(irq, desc);
> +	irq_set_irq_type(irq, IRQ_TYPE_EDGE_RISING);
> +
> +	addr = data->res.start + V2M_MSI_SETSPI_NS;
> +
> +	msg.address_hi = (u32)(addr >> 32);
> +	msg.address_lo = (u32)(addr);
> +	msg.data = irq;
> +	write_msi_msg(irq, &msg);
> +
> +	return 0;
> +}
> +
> +static void gicv2m_mask_irq(struct irq_data *d)
> +{
> +	gic_mask_irq(d);
> +	if (d->msi_desc)
> +		mask_msi_irq(d);
> +}
> +
> +static void gicv2m_unmask_irq(struct irq_data *d)
> +{
> +	gic_unmask_irq(d);
> +	if (d->msi_desc)
> +		unmask_msi_irq(d);
> +}
> +
> +static struct irq_chip gicv2m_chip;
> +
> +#ifdef CONFIG_OF
> +int __init
> +gicv2m_of_init(struct device_node *node, struct gic_chip_data *gic)
> +{
> +	int ret;
> +	unsigned int val;
> +	struct v2m_data *v2m = &gic->v2m_data;
> +
> +	v2m->msi_chip.owner = THIS_MODULE;
> +	v2m->msi_chip.of_node = node;
> +	v2m->msi_chip.setup_irq = gicv2m_setup_msi_irq;
> +	v2m->msi_chip.teardown_irq = gicv2m_teardown_msi_irq;
> +	ret = of_pci_msi_chip_add(&v2m->msi_chip);
> +	if (ret) {
> +		pr_info("GICv2m: Failed to add msi_chip.\n");

You don't need to add "GICv2m:" to all pr_*() functions.
Instead, you can add the following one at the top of the this .c file.

#define pr_fmt(fmt) " GICv2m: " fmt


> +		return ret;
> +	}
> +
> +	if (of_address_to_resource(node, 0, &v2m->res)) {
> +		pr_err("GICv2m: Failed locate GICv2m MSI register frame\n");
> +		return -EINVAL;
> +	}
> +
> +	v2m->base = of_iomap(node, 0);
> +	if (!v2m->base) {
> +		pr_err("GICv2m: Failed to map GIC MSI registers\n");
> +		return -EINVAL;
> +	}
> +
> +	val = readl_relaxed(v2m->base + V2M_MSI_TYPER);
> +	if (!val) {
> +		pr_warn("GICv2m: Failed to read V2M_MSI_TYPER register\n");
> +		return -EINVAL;
> +	}
> +
> +	v2m->spi_start = (val >> V2M_MSI_TYPER_BASE_SHIFT) &
> +				V2M_MSI_TYPER_BASE_MASK;
> +	v2m->nr_spis = val & V2M_MSI_TYPER_NUM_MASK;
> +	if ((v2m->spi_start < V2M_MIN_SPI) || (v2m->nr_spis >= V2M_MAX_SPI)) {
> +			pr_err("GICv2m: Invalid MSI_TYPER (%#x)\n", val);
> +			return -EINVAL;
> +	}
> +
> +	v2m->bm = kzalloc(sizeof(long) * BITS_TO_LONGS(v2m->nr_spis),
> +			  GFP_KERNEL);
> +	if (!v2m->bm) {
> +		pr_err("GICv2m: Failed to allocate MSI bitmap\n");
> +		return -ENOMEM;
> +	}
> +
> +	spin_lock_init(&v2m->msi_cnt_lock);
> +
> +	pr_info("GICv2m: SPI range [%d:%d]\n",
> +		v2m->spi_start, (v2m->spi_start + v2m->nr_spis));
> +
> +	memcpy(&gicv2m_chip, gic->irq_chip, sizeof(struct irq_chip));
> +	gicv2m_chip.name = "GICv2m",
> +	gicv2m_chip.irq_mask = gicv2m_mask_irq;
> +	gicv2m_chip.irq_unmask = gicv2m_unmask_irq;
> +	gic->irq_chip = &gicv2m_chip;
> +
> +	return 0;
> +}
> +
> +#endif /* CONFIG_OF */

[.....]

Best regards,
Jingoo Han


