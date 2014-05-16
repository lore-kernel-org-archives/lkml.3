Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752746AbaEPClR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 22:41:17 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:27962 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752262AbaEPClP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 22:41:15 -0400
X-AuditID: cbfee691-b7f3e6d000002ce8-7a-53757ab695df
From: Jingoo Han <jg1.han@samsung.com>
To: "'Murali Karicheri'" <m-karicheri2@ti.com>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        "'Mohit Kumar'" <mohit.kumar@st.com>,
        "'Bjorn Helgaas'" <bhelgaas@google.com>,
        "'Santosh Shilimkar'" <santosh.shilimkar@ti.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Pratyush Anand'" <pratyush.anand@st.com>,
        "'Richard Zhu'" <r65037@freescale.com>,
        "'Kishon Vijay Abraham I'" <kishon@ti.com>,
        "'Marek Vasut'" <marex@denx.de>
References: <1400169692-9677-1-git-send-email-m-karicheri2@ti.com>
 <1400169692-9677-3-git-send-email-m-karicheri2@ti.com>
In-reply-to: <1400169692-9677-3-git-send-email-m-karicheri2@ti.com>
Subject: Re: [PATCH v1 2/5] pci: designware: enhancements to support keystone
 pcie
Date: Fri, 16 May 2014 11:40:53 +0900
Message-id: <006501cf70b0$41dd2240$c59766c0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac9wV29f/qvpILHoQ76G8jLY9j/lygAVr0Wg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupgleLIzCtJLcpLzFFi42I5/e+Zge62qtJgg8+nuSyWNGVYvDykaXF5
	4SVWiwtPe9gsNj2+xmpxedccNouz846zWfT1HmCzeNPWyGixceovRov2S8oWj2cJW7zuW8Ps
	wOsxb9YJFo9/h/uZPBZsKvXYvKTeo2/LKkaPpz/2Mnscv7GdyePzJrkAjigum5TUnMyy1CJ9
	uwSujKWPpAvWJ1ZMXvmNpYFxpW8XIyeHhICJRO/K52wQtpjEhXvrgWwuDiGBZYwSyy7eZIUp
	+vN9IzuILSSwiFHi3b0wiKLfjBJTOx4zgiTYBNQkvnw5DFYkIqAjsex4IxNIEbPAUmaJvu/H
	WCC6qyVOX58IZnMKOEs8WjSPGcQWFgiRuDH7DNggFgFViabbb8HivAK2ErsaT7FB2IISPybf
	A+tlFtCSWL/zOBOELS+xeQ1IPQfQpeoSj/7qQtxgJPHi4RpmiBIRiX0v3jGC3CMhsJBD4kDP
	SnaIXQIS3yYfYoHolZXYdIAZ4mFJiYMrbrBMYJSYhWTzLCSbZyHZPAvJigWMLKsYRVMLkguK
	k9KLTPWKE3OLS/PS9ZLzczcxQlLBxB2M9w9YH2JMBlo/kVlKNDkfmErySuINjc2MLExNTI2N
	zC3NSBNWEudNf5QUJCSQnliSmp2aWpBaFF9UmpNafIiRiYNTqoHxiM/8tx+9mBpNHkzcKTon
	51lc2f2NzWYpWo/umO39d3TlrBlpUQw6J0Or5ghwnc5RauqatPDG3CmZ7rKX831KFuiLCago
	XJCyPn98f+ik17OkbkX+tJ+zukXVgunaouXmj6yPqXxOyZy0dnLo4XnTlwXXpfzY/Twrklny
	5Pod7M+2C31a1/rOSImlOCPRUIu5qDgRALtPQpYbAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKKsWRmVeSWpSXmKPExsVy+t9jAd1tVaXBBt92MFssacqweHlI0+Ly
	wkusFhee9rBZbHp8jdXi8q45bBZn5x1ns+jrPcBm8aatkdFi49RfjBbtl5QtHs8Stnjdt4bZ
	gddj3qwTLB7/DvczeSzYVOqxeUm9R9+WVYweT3/sZfY4fmM7k8fnTXIBHFENjDYZqYkpqUUK
	qXnJ+SmZeem2St7B8c7xpmYGhrqGlhbmSgp5ibmptkouPgG6bpk5QOcqKZQl5pQChQISi4uV
	9O0wTQgNcdO1gGmM0PUNCYLrMTJAAwnrGDOWPpIuWJ9YMXnlN5YGxpW+XYycHBICJhJ/vm9k
	h7DFJC7cW88GYgsJLGKUeHcvrIuRC8j+zSgxteMxI0iCTUBN4suXw2ANIgI6EsuONzKBFDEL
	LGWW6Pt+jAWiu1ri9PWJYDangLPEo0XzmEFsYYEQiRuzz4ANYhFQlWi6/RYszitgK7Gr8RQb
	hC0o8WPyPbBeZgEtifU7jzNB2PISm9eA1HMAXaou8eivLsQNRhIvHq5hhigRkdj34h3jBEah
	WUgmzUIyaRaSSbOQtCxgZFnFKJpakFxQnJSea6RXnJhbXJqXrpecn7uJEZxonknvYFzVYHGI
	UYCDUYmH94JWabAQa2JZcWXuIUYJDmYlEd7TtkAh3pTEyqrUovz4otKc1OJDjMlAj05klhJN
	zgcmwbySeENjEzMjSyMzCyMTc3PShJXEeQ+2WgcKCaQnlqRmp6YWpBbBbGHi4JRqYPR2M7bb
	sjFz9h9GrotKrY4Nkzrnvjv0r9+5Y3Zb33xlsw3hr24+nhyd9uUJ19MYN4lTHJsY6gX4l6Re
	Nw5cVTGx4cSDDX9/Bs/ca2H8u2HBG/1f8Rv6wvc9Ob0sxEPvUOwkx69b5FbfvPY0pcJCXv5d
	bVZRGHeuRExRruylRqvOncz+U1zKVyixFGckGmoxFxUnAgBeQB8veAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, May 16, 2014 1:01 AM, Murali Karicheri wrote:
> 
> keystone pcie hardware is based on designware hw version 3.65.
> There is no support for ATU port and has registers in
> application space to configure inbound/outbound access. Also
> doesn't support PCI PVM option. The MSI IRQ registers available
> in application space is used to mask/unmask/enable the MSI IRQs.
> 
> DW core driver is a set of common functions that are abstracted
> to support DW pci drivers. To allow re-use of these functions for
> keystone pci driver, core driver is to be enhanced.
> 
> Following are done to allow re-use of the functions on keystone pci
> driver.
> 
>  1. Some of the variables in pcie_port struct is folded inside
>     a union that now contains both new DW hw related variables as well
>     as old hardware related variables such as application reg base.
>  2. Added a dw_pcie_common_host_init() function that holds common
>     host initialization code for old and new hw.
>  3. dw_pcie_parse_resource() is used for parsing resource related
>     information from DT bindings.
>  4. dw_pcie_host_init() is called by new DW hw drivers as before.
>     Added dw_old_pcie_host_init() is it's counter part on old dw hw.
>     Both these functions now call dw_pcie_common_host_init().
>  5. Some of the static functions are made global to allow use from
>     dw old pci drivers such as pci-keystone.
> 
> CC: Mohit Kumar <mohit.kumar@st.com>
> CC: Jingoo Han <jg1.han@samsung.com>
> CC: Bjorn Helgaas <bhelgaas@google.com>
> CC: Santosh Shilimkar <santosh.shilimkar@ti.com>
> 
> Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
> ---
>  drivers/pci/host/pcie-designware.c |  101 ++++++++++++++++++++++++------------
>  drivers/pci/host/pcie-designware.h |   42 ++++++++++++---
>  2 files changed, 103 insertions(+), 40 deletions(-)
> 
> diff --git a/drivers/pci/host/pcie-designware.c b/drivers/pci/host/pcie-designware.c
> index c4e3732..9ea8e79 100644
> --- a/drivers/pci/host/pcie-designware.c
> +++ b/drivers/pci/host/pcie-designware.c
> @@ -277,11 +277,15 @@ static int assign_irq(int no_irqs, struct msi_desc *desc, int *pos)
>  		}
>  		set_bit(pos0 + i, pp->msi_irq_in_use);
>  		/*Enable corresponding interrupt in MSI interrupt controller */
> -		res = ((pos0 + i) / 32) * 12;
> -		bit = (pos0 + i) % 32;
> -		dw_pcie_rd_own_conf(pp, PCIE_MSI_INTR0_ENABLE + res, 4, &val);
> -		val |= 1 << bit;
> -		dw_pcie_wr_own_conf(pp, PCIE_MSI_INTR0_ENABLE + res, 4, val);
> +		if (!(pp->version & DW_VERSION_OLD)) {

(+cc Pratyush Anand, Richard Zhu, Kishon Vijay Abraham I, Marek Vasut)

DW_VERSION_OLD?
I don't this name. What is OLD? It is too general.
There should be the proper feature name between your 3.65 version
and other newer versions. This feature name can be defined as DT
property. Also, this code should be selected by DT property.


> +			res = ((pos0 + i) / 32) * 12;
> +			bit = (pos0 + i) % 32;
> +			dw_pcie_rd_own_conf(pp, PCIE_MSI_INTR0_ENABLE + res,
> +						 4, &val);
> +			val |= 1 << bit;
> +			dw_pcie_wr_own_conf(pp, PCIE_MSI_INTR0_ENABLE + res,
> +						 4, val);
> +		}
>  	}
> 
>  	*pos = pos0;
> @@ -349,7 +353,10 @@ static int dw_msi_setup_irq(struct msi_chip *chip, struct pci_dev *pdev,
>  	 */
>  	desc->msi_attrib.multiple = msgvec;
> 
> -	msg.address_lo = virt_to_phys((void *)pp->msi_data);
> +	if (pp->ops->get_msi_data)
> +		msg.address_lo = pp->ops->get_msi_data(pp);
> +	else
> +		msg.address_lo = virt_to_phys((void *)pp->msi_data);
>  	msg.address_hi = 0x0;
>  	msg.data = pos;
>  	write_msi_msg(irq, &msg);
> @@ -389,13 +396,11 @@ static const struct irq_domain_ops msi_domain_ops = {
>  	.map = dw_pcie_msi_map,
>  };
> 
> -int __init dw_pcie_host_init(struct pcie_port *pp)
> +int __init dw_pcie_parse_resource(struct pcie_port *pp)
>  {
>  	struct device_node *np = pp->dev->of_node;
> -	struct of_pci_range range;
>  	struct of_pci_range_parser parser;
> -	u32 val;
> -	int i;
> +	struct of_pci_range range;
> 
>  	if (of_pci_range_parser_init(&parser, np)) {
>  		dev_err(pp->dev, "missing ranges property\n");
> @@ -440,23 +445,17 @@ int __init dw_pcie_host_init(struct pcie_port *pp)
>  			return -ENOMEM;
>  		}
>  	}
> -
> -	pp->cfg0_base = pp->cfg.start;
> -	pp->cfg1_base = pp->cfg.start + pp->config.cfg0_size;
>  	pp->mem_base = pp->mem.start;
> 
> -	pp->va_cfg0_base = devm_ioremap(pp->dev, pp->cfg0_base,
> -					pp->config.cfg0_size);
> -	if (!pp->va_cfg0_base) {
> -		dev_err(pp->dev, "error with ioremap in function\n");
> -		return -ENOMEM;
> -	}
> -	pp->va_cfg1_base = devm_ioremap(pp->dev, pp->cfg1_base,
> -					pp->config.cfg1_size);
> -	if (!pp->va_cfg1_base) {
> -		dev_err(pp->dev, "error with ioremap\n");
> -		return -ENOMEM;
> -	}
> +	return 0;
> +}
> +
> +int __init dw_pcie_common_host_init(struct pcie_port *pp, struct hw_pci *hw,
> +				const struct irq_domain_ops *irq_msi_ops)
> +{
> +	struct device_node *np = pp->dev->of_node;
> +	u32 val;
> +	int i;
> 
>  	if (of_property_read_u32(np, "num-lanes", &pp->lanes)) {
>  		dev_err(pp->dev, "Failed to parse the number of lanes\n");
> @@ -465,7 +464,7 @@ int __init dw_pcie_host_init(struct pcie_port *pp)
> 
>  	if (IS_ENABLED(CONFIG_PCI_MSI)) {
>  		pp->irq_domain = irq_domain_add_linear(pp->dev->of_node,
> -					MAX_MSI_IRQS, &msi_domain_ops,
> +					MAX_MSI_IRQS, irq_msi_ops,
>  					&dw_pcie_msi_chip);
>  		if (!pp->irq_domain) {
>  			dev_err(pp->dev, "irq domain init failed\n");
> @@ -488,10 +487,10 @@ int __init dw_pcie_host_init(struct pcie_port *pp)
>  	val |= PORT_LOGIC_SPEED_CHANGE;
>  	dw_pcie_wr_own_conf(pp, PCIE_LINK_WIDTH_SPEED_CONTROL, 4, val);
> 
> -	dw_pci.nr_controllers = 1;
> -	dw_pci.private_data = (void **)&pp;
> +	hw->nr_controllers = 1;
> +	hw->private_data = (void **)&pp;
> 
> -	pci_common_init_dev(pp->dev, &dw_pci);
> +	pci_common_init_dev(pp->dev, hw);
>  	pci_assign_unassigned_resources();
>  #ifdef CONFIG_PCI_DOMAINS
>  	dw_pci.domain++;
> @@ -500,6 +499,32 @@ int __init dw_pcie_host_init(struct pcie_port *pp)
>  	return 0;
>  }
> 
> +int __init dw_pcie_host_init(struct pcie_port *pp)
> +{
> +	int ret;
> +
> +	ret = dw_pcie_parse_resource(pp);
> +	if (ret)
> +		return ret;
> +
> +	pp->cfg0_base = pp->cfg.start;
> +	pp->cfg1_base = pp->cfg.start + pp->config.cfg0_size;
> +	pp->va_cfg0_base = devm_ioremap(pp->dev, pp->cfg0_base,
> +					pp->config.cfg0_size);
> +	if (!pp->va_cfg0_base) {
> +		dev_err(pp->dev, "error with ioremap in function\n");
> +		return -ENOMEM;
> +	}
> +	pp->va_cfg1_base = devm_ioremap(pp->dev, pp->cfg1_base,
> +					pp->config.cfg1_size);
> +	if (!pp->va_cfg1_base) {
> +		dev_err(pp->dev, "error with ioremap\n");
> +		return -ENOMEM;
> +	}
> +
> +	return dw_pcie_common_host_init(pp, &dw_pci, &msi_domain_ops);
> +}
> +
>  static void dw_pcie_prog_viewport_cfg0(struct pcie_port *pp, u32 busdev)
>  {
>  	/* Program viewport 0 : OUTBOUND : CFG0 */
> @@ -654,7 +679,11 @@ static int dw_pcie_rd_conf(struct pci_bus *bus, u32 devfn, int where,
> 
>  	spin_lock_irqsave(&pp->conf_lock, flags);
>  	if (bus->number != pp->root_bus_nr)
> -		ret = dw_pcie_rd_other_conf(pp, bus, devfn,
> +		if (pp->ops->rd_other_conf)
> +			ret = pp->ops->rd_other_conf(pp, bus, devfn,
> +						where, size, val);
> +		else
> +			ret = dw_pcie_rd_other_conf(pp, bus, devfn,
>  						where, size, val);
>  	else
>  		ret = dw_pcie_rd_own_conf(pp, where, size, val);
> @@ -680,7 +709,11 @@ static int dw_pcie_wr_conf(struct pci_bus *bus, u32 devfn,
> 
>  	spin_lock_irqsave(&pp->conf_lock, flags);
>  	if (bus->number != pp->root_bus_nr)
> -		ret = dw_pcie_wr_other_conf(pp, bus, devfn,
> +		if (pp->ops->wr_other_conf)
> +			ret = pp->ops->wr_other_conf(pp, bus, devfn,
> +						where, size, val);
> +		else
> +			ret = dw_pcie_wr_other_conf(pp, bus, devfn,
>  						where, size, val);
>  	else
>  		ret = dw_pcie_wr_own_conf(pp, where, size, val);
> @@ -694,7 +727,7 @@ static struct pci_ops dw_pcie_ops = {
>  	.write = dw_pcie_wr_conf,
>  };
> 
> -static int dw_pcie_setup(int nr, struct pci_sys_data *sys)
> +int dw_pcie_setup(int nr, struct pci_sys_data *sys)

You removed 'static'; however, this modification is related
to another patch. ([PATCH v1 4/5] pci: dw: add common functions
to support old hw based pci driver)

Please don't mix the modification. So, move this fix to the 4th
patch.

>  {
>  	struct pcie_port *pp;
> 
> @@ -717,7 +750,7 @@ static int dw_pcie_setup(int nr, struct pci_sys_data *sys)
>  	return 1;
>  }
> 
> -static struct pci_bus *dw_pcie_scan_bus(int nr, struct pci_sys_data *sys)
> +struct pci_bus *dw_pcie_scan_bus(int nr, struct pci_sys_data *sys)
>  {
>  	struct pci_bus *bus;
>  	struct pcie_port *pp = sys_to_pcie(sys);
> @@ -746,7 +779,7 @@ static int dw_pcie_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
>  	return irq;
>  }
> 
> -static void dw_pcie_add_bus(struct pci_bus *bus)
> +void dw_pcie_add_bus(struct pci_bus *bus)
>  {
>  	if (IS_ENABLED(CONFIG_PCI_MSI)) {
>  		struct pcie_port *pp = sys_to_pcie(bus->sysdata);
> diff --git a/drivers/pci/host/pcie-designware.h b/drivers/pci/host/pcie-designware.h
> index 3063b35..e97f4d7 100644
> --- a/drivers/pci/host/pcie-designware.h
> +++ b/drivers/pci/host/pcie-designware.h
> @@ -35,21 +35,39 @@ struct pcie_port {
>  	struct device		*dev;
>  	u8			root_bus_nr;
>  	void __iomem		*dbi_base;
> -	u64			cfg0_base;
> -	void __iomem		*va_cfg0_base;
> -	u64			cfg1_base;
> -	void __iomem		*va_cfg1_base;
> +	/*
> +	 * Old DW version implement application register space for
> +	 * MSI and has no ATU view port
> +	 */

ATU can be defined as DT property. It can be selected by
this DT property.

> +#define DW_VERSION_OLD	BIT(0)
> +	u32			version;
> +	union {
> +		/* new dw core specific */
> +		struct {
> +			u64		cfg0_base;
> +			void __iomem	*va_cfg0_base;
> +			u64		cfg1_base;
> +			void __iomem	*va_cfg1_base;
> +			int		msi_irq;
> +		};
> +
> +		/* old dw core specific */
> +		struct  {
> +			struct irq_domain	*legacy_irq_domain;
> +			void __iomem		*va_app_base;
> +			u64			app_base;
> +		};
> +	};
>  	u64			io_base;
>  	u64			mem_base;
>  	spinlock_t		conf_lock;
> -	struct resource		cfg;
>  	struct resource		io;
>  	struct resource		mem;
> +	struct resource		cfg;

Please don't move this variable, without the reason.
Keep in mind that this code is shared with other SoC
drivers. So, without special reason, please don't modify
it.

>  	struct pcie_port_info	config;
>  	int			irq;
>  	u32			lanes;
>  	struct pcie_host_ops	*ops;
> -	int			msi_irq;
>  	struct irq_domain	*irq_domain;
>  	unsigned long		msi_data;
>  	DECLARE_BITMAP(msi_irq_in_use, MAX_MSI_IRQS);
> @@ -62,8 +80,13 @@ struct pcie_host_ops {
>  			u32 val, void __iomem *dbi_base);
>  	int (*rd_own_conf)(struct pcie_port *pp, int where, int size, u32 *val);
>  	int (*wr_own_conf)(struct pcie_port *pp, int where, int size, u32 val);
> +	int (*rd_other_conf)(struct pcie_port *pp, struct pci_bus *bus,
> +			unsigned int devfn, int where, int size, u32 *val);
> +	int (*wr_other_conf)(struct pcie_port *pp, struct pci_bus *bus,
> +			unsigned int devfn, int where, int size, u32 val);
>  	int (*link_up)(struct pcie_port *pp);
>  	void (*host_init)(struct pcie_port *pp);
> +	u32 (*get_msi_data)(struct pcie_port *pp);
>  };
> 
>  int dw_pcie_cfg_read(void __iomem *addr, int where, int size, u32 *val);
> @@ -73,5 +96,12 @@ void dw_pcie_msi_init(struct pcie_port *pp);
>  int dw_pcie_link_up(struct pcie_port *pp);
>  void dw_pcie_setup_rc(struct pcie_port *pp);
>  int dw_pcie_host_init(struct pcie_port *pp);
> +int dw_pcie_setup(int nr, struct pci_sys_data *sys);
> +struct pci_bus *dw_pcie_scan_bus(int nr, struct pci_sys_data *sys);
> +void dw_pcie_add_bus(struct pci_bus *bus);
> +int dw_pcie_parse_resource(struct pcie_port *pp);
> 
> +/* internal to dw core */
> +int dw_pcie_common_host_init(struct pcie_port *pp, struct hw_pci *hw,
> +			const struct irq_domain_ops *irq_ops);
>  #endif /* _PCIE_DESIGNWARE_H */
> --
> 1.7.9.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

