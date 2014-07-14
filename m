Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754819AbaGNMXg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 08:23:36 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:65089 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754648AbaGNMXb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 08:23:31 -0400
X-AuditID: cbfee68e-b7fb96d000004bfc-7c-53c3cbc0ceaa
From: Jingoo Han <jg1.han@samsung.com>
To: "'Pratyush Anand'" <pratyush.anand@st.com>,
        "'Murali Karicheri'" <m-karicheri2@ti.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "'Russell King'" <linux@arm.linux.org.uk>,
        "'Grant Likely'" <grant.likely@linaro.org>,
        "'Rob Herring'" <robh+dt@kernel.org>,
        "'Mohit KUMAR DCG'" <Mohit.KUMAR@st.com>,
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
References: <1405110995-24676-1-git-send-email-m-karicheri2@ti.com>
 <20140714060334.GB2930@pratyush-vbox>
In-reply-to: <20140714060334.GB2930@pratyush-vbox>
Subject: Re: [PATCH v4 0/6] Add Keystone PCIe controller driver
Date: Mon, 14 Jul 2014 21:23:28 +0900
Message-id: <00bb01cf9f5e$6aac4250$4004c6f0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac+fKaZTr78RYwVOQMO7uBTaEVE32gANGXww
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA5WSa0hTYRjHe885O9ss6TQvvRklzCxceZu3VywtojgQVmQfzC827aDinLY5
	kQqy1CTxLiqMFBWvY6LOzAsz1iy1RqJbmZEpZlrmplgS3sl5vvi1b7/n+T8P//8DDw8XfOS4
	8BJkqYxcJpEKSTvCuD3n7ak39kf45Ez5oK2SAS6qexyP5g0eqNBSw0H6zW6Ahn81A2SuMXHQ
	yGweibQzYxxk7n1GovdVgyT6YrZHBfl6ElmePAKo/tMohtrL1gEqqmghUI7JDc2oHJB1ooJA
	2X2vueedaE2VBtBZmXkkvbFeAmhzQT5GV6mGCHq7vxCjq7VKurlxhaQ7mkS0Vv2UpCfGdDtV
	3UO64Lka0LOrfTg9ON6F0X+0x69TUXZn7zDShDRG7h162y7e0FbPSSlyTf/Rr8wA9Y65gMeD
	lD+crQ7KBfwddIYjk61kLrDjCagGALPfbGGs4A87K/MxVqgFcNwyymGLDQCnpke5timSOglX
	Vvp32ZGKhGUl27tDOPWCA416NW4TBFQizJxbIm3Mp8Tw7cIsaYvhQIXBTku4rU1Q7jAzu51j
	Y3vqHJyZb+OyfAiulk4SNsYpEWztGcRYdoUdGivOXnMKftvyZCOI4XClkcuOOMKXPxeBLQ6k
	KviwzdqCsV4U/FtqINjdY1Crx9mDj8BXTeNEEYCqPc6qPc6qPc6qPRbVgFADJyYlNkUREycX
	eykkSQqlLM4rNjlJC9iXKugGn/UhBhC7Y1+MuzjFJu+8nCw12tcvUIwC/AP8xEHBgf/XFh62
	r52OuSGg4iSpTCLDpDDyaLlSyigMAOPxXTJAaPiieV3sGbQUFiJM+HAvfZ9meX9GFmlt87kr
	W06+EPf7dOtlwfzmV517+M1i00X7kLDgYkfDpcpCN+drK9JhkW6gSR1hHDo4ubZ2v/DAu+8b
	Rz2uRPWU3zLlBLdfPePl7lKumEp1erC5mKmLFHlaTR2NXa69DeT4gnA6re6ExVdIKOIlviJc
	rpD8Ay0UjaxoAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmplk+LIzCtJLcpLzFFi42I5/e+xgO6B04eDDSYv1LL4O+kYu8WSpgyL
	l4c0LfrfLGS1OPBnB6PFuVcrGS0uL7zEanHhaQ+bxabH11gtLu+aw2Zxdt5xNovbl3kt+noP
	sFm8aWtktFh6/SKTxcapvxgtJkxfy2LRfknZ4vEsYYu3d6azWLTuPcLuIOqxZt4aRo+W5h42
	j9+/JjF6XO7rZfKYN+sEi8e/w/1MHgs2lXqsXP6FzWPzCi2PTas62TzuXNsD5C2p9+jbsorR
	4+mPvcwex29sZ/L4vEkuQCCqgdEmIzUxJbVIITUvOT8lMy/dVsk7ON453tTMwFDX0NLCXEkh
	LzE31VbJxSdA1y0zB+h5JYWyxJxSoFBAYnGxkr4dpgmhIW66FjCNEbq+IUFwPUYGaCBhHWPG
	oQ1LWQsmyFc8P1zawLhUpIuRk0NCwERi69xeJghbTOLCvfVsXYxcHEICixglbry5yArh/GaU
	uP/wIjtIFZuAmsSXL4fBbBGBCImpk/6BFTELbGOVOH1gFTNIQkggW6L52Xs2EJtTwEji5Oun
	QDYHh7CAvcTWN74gYRYBVYnm1o2sIDavgK3E45cb2CFsQYkfk++xgNjMAloS63ceZ4Kw5SU2
	r3nLDDJGQkBd4tFfXYgTjCTOzT3NDlEiIrHvxTvGCYxCs5BMmoVk0iwkk2YhaVnAyLKKUTS1
	ILmgOCk911CvODG3uDQvXS85P3cTIzgJPpPawbiyweIQowAHoxIPbwbH4WAh1sSy4srcQ4wS
	HMxKIrynjwKFeFMSK6tSi/Lji0pzUosPMZoCPTqRWUo0OR+YoPNK4g2NTcyMLI3MLIxMzM2V
	xHkPtFoHCgmkJ5akZqemFqQWwfQxcXBKNTDGqrLFWuj23uPi2vP/7Q6XaRtTj/59OrHl207f
	+UsXLV01Udqq+/TPZpH4AM7MDYx/Tz+5+2flWb8/Bx9nt2kl/lacz5OwcGHfR5npLlusV4Ro
	pE9fXOkzjWuDuHLzD8NO8a/Gn59N+setOk1hQbKAw5JaHem5T59+6Oj6dmWe+rGVPc09UvYK
	SizFGYmGWsxFxYkAXfMdS5gDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, July 14, 2014 3:04 PM, Pratyush Anand wrote:
> On Sat, Jul 12, 2014 at 04:36:29AM +0800, Murali Karicheri wrote:
> 
> [...]
> 
> > Murali Karicheri (6):
> >   PCI: designware: add rd[wr]_other_conf API
> >   PCI: designware: refactor MSI code to work with v3.65 dw hardware
> 
> For  above two you can add my reviewed-by:
> 
> >   PCI: designware: refactor host init code to re-use on keystone PCI
> >   PCI: designware: enhance dw core driver to support keystone PCI host
> 
> In stead of using version number and then changing few functions from
> static to global , I would have used same philosophy of adding callbacks
> wherever needed. May be maintainers can give their view, instead of patch
> 3 and 4 I would have gone with something like this, where kc_pcie can be
> passed through pp->plat_data.

I agree with your suggestion. I don't want to use the version number.
The call back would be better.

Best regards,
Jingoo Han

> 
> diff --git a/drivers/pci/host/pcie-designware.c b/drivers/pci/host/pcie-designware.c
> index 905941c..b216192 100644
> --- a/drivers/pci/host/pcie-designware.c
> +++ b/drivers/pci/host/pcie-designware.c
> @@ -490,16 +490,21 @@ int __init dw_pcie_host_init(struct pcie_port *pp)
>         }
> 
>         if (IS_ENABLED(CONFIG_PCI_MSI)) {
> -               pp->irq_domain = irq_domain_add_linear(pp->dev->of_node,
> -                                       MAX_MSI_IRQS, &msi_domain_ops,
> -                                       &dw_pcie_msi_chip);
> -               if (!pp->irq_domain) {
> -                       dev_err(pp->dev, "irq domain init failed\n");
> -                       return -ENXIO;
> -               }
> +               if (!pp->ops->msi_init) {
> +                       pp->irq_domain = irq_domain_add_linear(pp->dev->of_node,
> +                                               MAX_MSI_IRQS, &msi_domain_ops,
> +                                               &dw_pcie_msi_chip);
> +                       if (!pp->irq_domain) {
> +                               dev_err(pp->dev, "irq domain init failed\n");
> +                               return -ENXIO;
> +                       }
> 
> -               for (i = 0; i < MAX_MSI_IRQS; i++)
> -                       irq_create_mapping(pp->irq_domain, i);
> +                       for (i = 0; i < MAX_MSI_IRQS; i++)
> +                               irq_create_mapping(pp->irq_domain, i);
> +               } else {
> +                       pp->ops->msi_init(pp, &msi_domain_ops,
> +                                               &dw_pcie_msi_chip);
> +               }
>         }
> 
>         if (pp->ops->host_init)
> @@ -759,6 +764,9 @@ static struct pci_bus *dw_pcie_scan_bus(int nr, struct pci_sys_data *sys)
>                 BUG();
>         }
> 
> +       if (bus && pp->ops->scan_bus)
> +               bus = pp->ops->scan_bus(pp);
> +
>         return bus;
>  }
> 
> diff --git a/drivers/pci/host/pcie-designware.h b/drivers/pci/host/pcie-designware.h
> index 387f69e..39ce496 100644
> --- a/drivers/pci/host/pcie-designware.h
> +++ b/drivers/pci/host/pcie-designware.h
> @@ -52,6 +52,7 @@ struct pcie_port {
>         struct irq_domain       *irq_domain;
>         unsigned long           msi_data;
>         DECLARE_BITMAP(msi_irq_in_use, MAX_MSI_IRQS);
> +       void                    *plat_data;
>  };
> 
>  struct pcie_host_ops {
> @@ -70,6 +71,9 @@ struct pcie_host_ops {
>         void (*msi_set_irq)(struct pcie_port *pp, int irq);
>         void (*msi_clear_irq)(struct pcie_port *pp, int irq);
>         u32 (*get_msi_data)(struct pcie_port *pp);
> +       struct pci_bus *(*scan_bus)(struct pcie_port *pp);
> +       void (*msi_init) (struct pcie_port *pp, struct irq_domain_ops *ops,
> +                       struct msi_chip *chip);
>  };
> 
>  int dw_pcie_cfg_read(void __iomem *addr, int where, int size, u32 *val);
> 
> 
> ~Pratyush

