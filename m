Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755048AbaGWB1e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 21:27:34 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:16553 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751692AbaGWB1b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 21:27:31 -0400
X-AuditID: cbfee68f-b7fef6d000003970-15-53cf0f81c281
From: Jingoo Han <jg1.han@samsung.com>
To: "'Murali Karicheri'" <m-karicheri2@ti.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: "'Santosh Shilimkar'" <santosh.shilimkar@ti.com>,
        "'Russell King'" <linux@arm.linux.org.uk>,
        "'Grant Likely'" <grant.likely@linaro.org>,
        "'Rob Herring'" <robh+dt@kernel.org>,
        "'Bjorn Helgaas'" <bhelgaas@google.com>,
        "'Richard Zhu'" <r65037@freescale.com>,
        "'Kishon Vijay Abraham I'" <kishon@ti.com>,
        "'Marek Vasut'" <marex@denx.de>, "'Arnd Bergmann'" <arnd@arndb.de>,
        "'Pawel Moll'" <pawel.moll@arm.com>,
        "'Mark Rutland'" <mark.rutland@arm.com>,
        "'Ian Campbell'" <ijc+devicetree@hellion.org.uk>,
        "'Kumar Gala'" <galak@codeaurora.org>,
        "'Randy Dunlap'" <rdunlap@infradead.org>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <1405961925-27248-1-git-send-email-m-karicheri2@ti.com>
 <1405961925-27248-4-git-send-email-m-karicheri2@ti.com>
In-reply-to: <1405961925-27248-4-git-send-email-m-karicheri2@ti.com>
Subject: Re: [PATCH v7 3/5] PCI: designware: enhance dw_pcie_host_init() to
 support v3.65 DW hardware
Date: Wed, 23 Jul 2014 10:27:28 +0900
Message-id: <003201cfa615$44615ff0$cd241fd0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac+lBVI6UuGp3R+5Rm6OXxFBZmHNyABD8G0Q
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHKsWRmVeSWpSXmKPExsVy+t8zfd1G/vPBBn+e8Vv8nXSM3WJJU4bF
	y0OaFv1vFrJaHPizg9Hi3KuVjBaXF15itbjwtIfNYtPja6wWl3fNYbM4O+84m8Xty7wWfb0H
	2CzetDUyWiy9fpHJYsL0tSwWj2cJW7y9M53FonXvEXaL131rmB1EPNbMW8Po0dLcw+bx+9ck
	Ro/Lfb1MHvNmnWDx+He4n8ljwaZSj5XLv7B5bF6h5bFpVSebx51re4C8JfUefVtWMXocv7Gd
	yePzJrkA/igum5TUnMyy1CJ9uwSujMPL5rMVrNCt6Lq+jqWBcatKFyMHh4SAicTtiZldjJxA
	ppjEhXvr2boYuTiEBJYxSjR9WcsKUzP3gCREfDqjxKuT15ghnN+MEg2Hu1hButkE1CS+fDnM
	DpIQEehllPg4YQfYKGaBuywSm+efZAepEhKolWh8tZYJxOYUcJE419bEDGILC6RLnO56xwhi
	swioSnw/dBzM5hWwlTh4cA4bhC0o8WPyPRYQm1lAS2L9zuNMELa8xOY1b5khTlWXePRXFyQs
	ImAk8XLjPWaIEhGJfS9AxnMBlXRzSix8+JQdYpeAxLfJh1ggemUlNh1ghgSFpMTBFTdYJjBK
	zEKyeRaSzbOQbJ6FZMUCRpZVjKKpBckFxUnpRcZ6xYm5xaV56XrJ+bmbGCFpqX8H490D1ocY
	k4HWT2SWEk3OB6a1vJJ4Q2MzIwtTE1NjI3NLM9KElcR57z9MChISSE8sSc1OTS1ILYovKs1J
	LT7EyMTBKdXA6Bc2q/mRzWYtj+0KKcstrgq0yXQ/ZGHsvx9dtNWP2y+zecrRb6+j9QzCXRTX
	nzOMlD/25or0y5oVXf7/Zq5sWqjToDRp1943DCpds35ceai/ySz7i/OWpFTfnh3+nu0f2m9I
	y7/4cfqF6SauIvYfH6sevpphtkT1evscVVZZn5JbTT0x36wMlViKMxINtZiLihMB7BNoHmED	AAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrHKsWRmVeSWpSXmKPExsVy+t9jQd1G/vPBBk33OS3+TjrGbrGkKcPi
	5SFNi/43C1ktDvzZwWhx7tVKRovLCy+xWlx42sNmsenxNVaLy7vmsFmcnXeczeL2ZV6Lvt4D
	bBZv2hoZLZZev8hkMWH6WhaLx7OELd7emc5i0br3CLvF6741zA4iHmvmrWH0aGnuYfP4/WsS
	o8flvl4mj3mzTrB4/Dvcz+SxYFOpx8rlX9g8Nq/Q8ti0qpPN4861PUDeknqPvi2rGD2O39jO
	5PF5k1wAf1QDo01GamJKapFCal5yfkpmXrqtkndwvHO8qZmBoa6hpYW5kkJeYm6qrZKLT4Cu
	W2YO0M9KCmWJOaVAoYDE4mIlfTtME0JD3HQtYBojdH1DguB6jAzQQMI6xozDy+azFazQrei6
	vo6lgXGrShcjB4eEgInE3AOSXYycQKaYxIV769m6GLk4hASmM0q8OnmNGcL5zSjRcLiLFaSK
	TUBN4suXw+wgCRGBXkaJjxN2gLUwC9xlkdg8/yQ7SJWQQK1E46u1TCA2p4CLxLm2JmYQW1gg
	XeJ01ztGEJtFQFXi+6HjYDavgK3EwYNz2CBsQYkfk++xgNjMAloS63ceZ4Kw5SU2r3nLDHG2
	usSjv7ogYREBI4mXG+8xQ5SISOx78Y5xAqPQLCSTZiGZNAvJpFlIWhYwsqxiFE0tSC4oTkrP
	NdIrTswtLs1L10vOz93ECE57z6R3MK5qsDjEKMDBqMTDW1BzLliINbGsuDL3EKMEB7OSCG90
	K1CINyWxsiq1KD++qDQntfgQoynQoxOZpUST84EpOa8k3tDYxMzI0sjMwsjE3FxJnPdgq3Wg
	kEB6YklqdmpqQWoRTB8TB6dUA6OJTBBj3RztOOscr+J/DV2exl1X1X+IWrA1PZnroBizaC1v
	4xqex5zLiotOfwm09ZK32OUmvqH63gxWFbWFEVctIk4lT9DR5v3+bP6eW3Mf3VnvOUdZNeI/
	uynvpLuWGQZxQmqSU+O0eE+Ju+/a46S/fT5DkO7WJ5lLp4hx9jJPNHpy7N1sayWW4oxEQy3m
	ouJEADLoRdSRAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, July 22, 2014 1:59 AM, Murali Karicheri wrote:
> 
> keystone PCI controller is based on v3.65 designware hardware. This
> version differs from newer versions of the hardware in few functional
> areas discussed below that makes it necessary to change dw_pcie_host_init()
> to support v3.65 based PCI controller.
> 
>  1. No support for ATU port. So any ATU specific resource handling code
>     is to be bypassed for v3.65 h/w.
>  2. MSI controller uses Application space to implement MSI and 32 MSI
>     interrupts are multiplexed over 8 IRQs to the host. Hence the code
>     to process MSI IRQ needs to be different. This patch allows platform
>     driver to provide its own irq_domain_ops ptr to irq_domain_add_linear()
>     through an API callback from the designware core driver.
>  3. MSI interrupt generation requires EP to write to the RC's application
>     register. So enhance the driver to allow setup of inbound access to
>     MSI irq register as a post scan bus API callback.
> 
> Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
> Reviewed-by: Pratyush Anand <pratyush.anand@st.com>
> Acked-by: Mohit KUMAR <mohit.kumar@st.com>
> 
> CC: Santosh Shilimkar <santosh.shilimkar@ti.com>
> CC: Russell King <linux@arm.linux.org.uk>
> CC: Grant Likely <grant.likely@linaro.org>
> CC: Rob Herring <robh+dt@kernel.org>
> CC: Jingoo Han <jg1.han@samsung.com>

Acked-by: Jingoo Han <jg1.han@samsung.com>

Best regards,
Jingoo Han

> CC: Bjorn Helgaas <bhelgaas@google.com>
> CC: Richard Zhu <r65037@freescale.com>
> CC: Kishon Vijay Abraham I <kishon@ti.com>
> CC: Marek Vasut <marex@denx.de>
> CC: Arnd Bergmann <arnd@arndb.de>
> CC: Pawel Moll <pawel.moll@arm.com>
> CC: Mark Rutland <mark.rutland@arm.com>
> CC: Ian Campbell <ijc+devicetree@hellion.org.uk>
> CC: Kumar Gala <galak@codeaurora.org>
> CC: Randy Dunlap <rdunlap@infradead.org>
> CC: Grant Likely <grant.likely@linaro.org>
> ---
>  drivers/pci/host/pcie-designware.c |   54 +++++++++++++++++++++++-------------
>  drivers/pci/host/pcie-designware.h |    2 ++
>  2 files changed, 36 insertions(+), 20 deletions(-)
> 
> diff --git a/drivers/pci/host/pcie-designware.c b/drivers/pci/host/pcie-designware.c
> index 905941c..35bb4af 100644
> --- a/drivers/pci/host/pcie-designware.c
> +++ b/drivers/pci/host/pcie-designware.c
> @@ -420,8 +420,8 @@ int __init dw_pcie_host_init(struct pcie_port *pp)
>  	struct device_node *np = pp->dev->of_node;
>  	struct of_pci_range range;
>  	struct of_pci_range_parser parser;
> +	int i, ret;
>  	u32 val;
> -	int i;
> 
>  	if (of_pci_range_parser_init(&parser, np)) {
>  		dev_err(pp->dev, "missing ranges property\n");
> @@ -467,21 +467,26 @@ int __init dw_pcie_host_init(struct pcie_port *pp)
>  		}
>  	}
> 
> -	pp->cfg0_base = pp->cfg.start;
> -	pp->cfg1_base = pp->cfg.start + pp->config.cfg0_size;
>  	pp->mem_base = pp->mem.start;
> 
> -	pp->va_cfg0_base = devm_ioremap(pp->dev, pp->cfg0_base,
> -					pp->config.cfg0_size);
>  	if (!pp->va_cfg0_base) {
> -		dev_err(pp->dev, "error with ioremap in function\n");
> -		return -ENOMEM;
> +		pp->cfg0_base = pp->cfg.start;
> +		pp->va_cfg0_base = devm_ioremap(pp->dev, pp->cfg0_base,
> +						pp->config.cfg0_size);
> +		if (!pp->va_cfg0_base) {
> +			dev_err(pp->dev, "error with ioremap in function\n");
> +			return -ENOMEM;
> +		}
>  	}
> -	pp->va_cfg1_base = devm_ioremap(pp->dev, pp->cfg1_base,
> -					pp->config.cfg1_size);
> +
>  	if (!pp->va_cfg1_base) {
> -		dev_err(pp->dev, "error with ioremap\n");
> -		return -ENOMEM;
> +		pp->cfg1_base = pp->cfg.start + pp->config.cfg0_size;
> +		pp->va_cfg1_base = devm_ioremap(pp->dev, pp->cfg1_base,
> +						pp->config.cfg1_size);
> +		if (!pp->va_cfg1_base) {
> +			dev_err(pp->dev, "error with ioremap\n");
> +			return -ENOMEM;
> +		}
>  	}
> 
>  	if (of_property_read_u32(np, "num-lanes", &pp->lanes)) {
> @@ -490,16 +495,22 @@ int __init dw_pcie_host_init(struct pcie_port *pp)
>  	}
> 
>  	if (IS_ENABLED(CONFIG_PCI_MSI)) {
> -		pp->irq_domain = irq_domain_add_linear(pp->dev->of_node,
> -					MAX_MSI_IRQS, &msi_domain_ops,
> -					&dw_pcie_msi_chip);
> -		if (!pp->irq_domain) {
> -			dev_err(pp->dev, "irq domain init failed\n");
> -			return -ENXIO;
> -		}
> +		if (!pp->ops->msi_host_init) {
> +			pp->irq_domain = irq_domain_add_linear(pp->dev->of_node,
> +						MAX_MSI_IRQS, &msi_domain_ops,
> +						&dw_pcie_msi_chip);
> +			if (!pp->irq_domain) {
> +				dev_err(pp->dev, "irq domain init failed\n");
> +				return -ENXIO;
> +			}
> 
> -		for (i = 0; i < MAX_MSI_IRQS; i++)
> -			irq_create_mapping(pp->irq_domain, i);
> +			for (i = 0; i < MAX_MSI_IRQS; i++)
> +				irq_create_mapping(pp->irq_domain, i);
> +		} else {
> +			ret = pp->ops->msi_host_init(pp, &dw_pcie_msi_chip);
> +			if (ret < 0)
> +				return ret;
> +		}
>  	}
> 
>  	if (pp->ops->host_init)
> @@ -759,6 +770,9 @@ static struct pci_bus *dw_pcie_scan_bus(int nr, struct pci_sys_data *sys)
>  		BUG();
>  	}
> 
> +	if (bus && pp->ops->scan_bus)
> +		pp->ops->scan_bus(pp);
> +
>  	return bus;
>  }
> 
> diff --git a/drivers/pci/host/pcie-designware.h b/drivers/pci/host/pcie-designware.h
> index 387f69e..080c649 100644
> --- a/drivers/pci/host/pcie-designware.h
> +++ b/drivers/pci/host/pcie-designware.h
> @@ -70,6 +70,8 @@ struct pcie_host_ops {
>  	void (*msi_set_irq)(struct pcie_port *pp, int irq);
>  	void (*msi_clear_irq)(struct pcie_port *pp, int irq);
>  	u32 (*get_msi_data)(struct pcie_port *pp);
> +	void (*scan_bus)(struct pcie_port *pp);
> +	int (*msi_host_init)(struct pcie_port *pp, struct msi_chip *chip);
>  };
> 
>  int dw_pcie_cfg_read(void __iomem *addr, int where, int size, u32 *val);
> --
> 1.7.9.5

