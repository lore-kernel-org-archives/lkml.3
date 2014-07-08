Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754732AbaGHMu5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 08:50:57 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:14138 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754426AbaGHMuy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 08:50:54 -0400
X-AuditID: cbfee690-b7fb56d000003439-66-53bbe92b0b81
From: Jingoo Han <jg1.han@samsung.com>
To: "'Mohit KUMAR DCG'" <Mohit.KUMAR@st.com>,
        "'Kishon Vijay Abraham I'" <kishon@ti.com>
Cc: devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-pci@vger.kernel.org, bhelgaas@google.com,
        linux-kernel@vger.kernel.org, grant.likely@linaro.org,
        "'Jason Gunthorpe'" <jgunthorpe@obsidianresearch.com>,
        "'Marek Vasut'" <marex@denx.de>, "'Arnd Bergmann'" <arnd@arndb.de>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <1403719007-9352-1-git-send-email-kishon@ti.com>
 <1403719007-9352-2-git-send-email-kishon@ti.com>
 <2CC2A0A4A178534D93D5159BF3BCB6619C5F94EFC8@EAPEX1MAIL1.st.com>
In-reply-to: <2CC2A0A4A178534D93D5159BF3BCB6619C5F94EFC8@EAPEX1MAIL1.st.com>
Subject: Re: [PATCH 1/3] PCI: designware: Configuration space should be
 specified in 'reg'
Date: Tue, 08 Jul 2014 21:50:51 +0900
Message-id: <001001cf9aab$3fb008a0$bf1019e0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac+QnvC9I2p6n7FJTmWBZBOX2C+CIwAYzYdQAmo7LnA=
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprIKsWRmVeSWpSXmKPExsVy+t8zA13tl7uDDbZsM7P4O+kYu8WSpgyL
	l4c0LeYfOcdqceDPDkaLywsvsVp8v2FqceFpD5vFwrYlLBaXd81hszg77zibxZu2RkaLjVN/
	MTrwevz+NYnRY96sEyweCzaVety5tofN4/uOXkaPvi2rGD2e/tjL7HH8xnYmj8+b5AI4o7hs
	UlJzMstSi/TtErgyFr7tYSrYoVDRfKSHqYGxW6qLkZNDQsBE4ui9JawQtpjEhXvr2UBsIYFl
	jBLbT4vD1Fyavoeli5ELKL6IUWLLy5vsEM5vRoljs5YwgVSxCahJfPlymB3EFhEIk7j7aDlY
	B7PAQSaJn+1X2CA6NjJKzH6wCqyKU8BHovPcGkYQW1ggRuLHpTnMIDaLgKrEtYdrweK8ArYS
	V270MEPYghI/Jt9jAbGZBbQk1u88zgRhy0tsXvMWqIYD6FZ1iUd/dSGOsJJounybGaJERGLf
	i3eMIDdICGzhkOi9fpIRYpeAxLfJh1ggemUlNh1ghnhZUuLgihssExglZiHZPAvJ5llINs9C
	smIBI8sqRtHUguSC4qT0IhO94sTc4tK8dL3k/NxNjJDkMGEH470D1ocYk4HWT2SWEk3OByaX
	vJJ4Q2MzIwtTE1NjI3NLM9KElcR51R4lBQkJpCeWpGanphakFsUXleakFh9iZOLglGpgLN65
	eWW9zt2CGu2P+5UfLuvL575Xfnpuhln/nMJzigIPZ9ZPveV/uW9tvdGz7yU3P/Jef9+/yGWa
	vNuEQ+GyXo+Vs4w/81doLNroqyV3ccE1Ud6Wdg+/XdMZnihWBvNl77p9O8vlwFu9BZKbFoRe
	vXPA/1WK2tFlwmmL1Asy6g/cedvxIPnibSWW4oxEQy3mouJEACvS9dAkAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrIKsWRmVeSWpSXmKPExsVy+t9jAV3tl7uDDbb+M7D4O+kYu8WSpgyL
	l4c0LeYfOcdqceDPDkaLywsvsVp8v2FqceFpD5vFwrYlLBaXd81hszg77zibxZu2RkaLjVN/
	MTrwevz+NYnRY96sEyweCzaVety5tofN4/uOXkaPvi2rGD2e/tjL7HH8xnYmj8+b5AI4oxoY
	bTJSE1NSixRS85LzUzLz0m2VvIPjneNNzQwMdQ0tLcyVFPISc1NtlVx8AnTdMnOArlZSKEvM
	KQUKBSQWFyvp22GaEBripmsB0xih6xsSBNdjZIAGEtYxZix828NUsEOhovlID1MDY7dUFyMn
	h4SAicSl6XtYIGwxiQv31rN1MXJxCAksYpTY8vImO4Tzm1Hi2KwlTCBVbAJqEl++HGYHsUUE
	wiTuPlrOAlLELHCQSeJn+xWo9o2MErMfrAKr4hTwkeg8t4YRxBYWiJH4cWkOM4jNIqAqce3h
	WrA4r4CtxJUbPcwQtqDEj8n3wG5iFtCSWL/zOBOELS+xec1boBoOoFvVJR791YU4wkqi6fJt
	ZogSEYl9L94xTmAUmoVk0iwkk2YhmTQLScsCRpZVjKKpBckFxUnpuUZ6xYm5xaV56XrJ+bmb
	GMHJ55n0DsZVDRaHGAU4GJV4eFcc3BUsxJpYVlyZe4hRgoNZSYT3y6ndwUK8KYmVValF+fFF
	pTmpxYcYTYEencgsJZqcD0yMeSXxhsYmZkaWRmYWRibm5krivAdbrQOFBNITS1KzU1MLUotg
	+pg4OKUaGOv++eUfdO0Un/1hk9LR73cO5kXsPbZELv6IksynM1cmsasYGL4J2Nu7i3FrtMC9
	2vOVp5q/utb077w1L+04r/fpTrPc8j1Ce/VW5frayS3e1ePcKPWyUiNkkfHkYoUTfRErQicb
	iOX1lb2adXPf8oUfzh29ENrz+eDKG7WZXB//KTJN+LfguL0SS3FGoqEWc1FxIgAsZJXCVAMA	AA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, June 26, 2014 2:56 PM, Mohit KUMAR DCG wrote:
> On Wednesday, June 25, 2014 11:27 PM, Kishon Vijay Abraham I wrote:
> >
> > The configuration address space has so far been specified in *ranges*,
> > however it should be specified in *reg* making it a platform MEM resource.
> > Hence used 'platform_get_resource_*' API to get configuration address
> > space in the designware driver.
> >
> > Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
> > Cc: Bjorn Helgaas <bhelgaas@google.com>
> > Cc: Mohit Kumar <mohit.kumar@st.com>
> > Cc: Jingoo Han <jg1.han@samsung.com>
> > Cc: Marek Vasut <marex@denx.de>
> > Cc: Arnd Bergmann <arnd@arndb.de>
> > Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
> > ---
> >  .../devicetree/bindings/pci/designware-pcie.txt    |    4 ++++
> >  drivers/pci/host/pcie-designware.c                 |   17 +++++++++++++++--
> >  2 files changed, 19 insertions(+), 2 deletions(-)
> >
> > diff --git a/Documentation/devicetree/bindings/pci/designware-pcie.txt
> > b/Documentation/devicetree/bindings/pci/designware-pcie.txt
> > index d0d15ee..ed0d9b9 100644
> > --- a/Documentation/devicetree/bindings/pci/designware-pcie.txt
> > +++ b/Documentation/devicetree/bindings/pci/designware-pcie.txt
> > @@ -2,6 +2,10 @@
> >
> >  Required properties:
> >  - compatible: should contain "snps,dw-pcie" to identify the core.
> > +- reg: Should contain the configuration address space.
> > +- reg-names: Must be "config" for the PCIe configuration space.
> > +    (The old way of getting the configuration address space from "ranges"
> > +    is deprecated and should be avoided.)
> >  - #address-cells: set to <3>
> >  - #size-cells: set to <2>
> >  - device_type: set to "pci"
> > diff --git a/drivers/pci/host/pcie-designware.c b/drivers/pci/host/pcie-
> > designware.c
> > index 1eaf4df..0b7b455 100644
> > --- a/drivers/pci/host/pcie-designware.c
> > +++ b/drivers/pci/host/pcie-designware.c
> > @@ -20,6 +20,7 @@
> >  #include <linux/of_pci.h>
> >  #include <linux/pci.h>
> >  #include <linux/pci_regs.h>
> > +#include <linux/platform_device.h>
> >  #include <linux/types.h>
> >
> >  #include "pcie-designware.h"
> > @@ -396,11 +397,23 @@ static const struct irq_domain_ops
> > msi_domain_ops = {  int __init dw_pcie_host_init(struct pcie_port *pp)  {
> >  	struct device_node *np = pp->dev->of_node;
> > +	struct platform_device *pdev = to_platform_device(pp->dev);
> >  	struct of_pci_range range;
> >  	struct of_pci_range_parser parser;
> > +	struct resource *cfg_res;
> >  	u32 val;
> >  	int i;
> >
> > +	cfg_res = platform_get_resource_byname(pdev,
> > IORESOURCE_MEM, "config");
> > +	if (cfg_res) {
> > +		pp->config.cfg0_size = resource_size(cfg_res)/2;
> > +		pp->config.cfg1_size = resource_size(cfg_res)/2;
> > +		pp->cfg0_base = cfg_res->start;
> > +		pp->cfg1_base = cfg_res->start + pp->config.cfg0_size;
> > +	} else {
> > +		dev_err(pp->dev, "missing *config* reg space\n");
> 
> - so this message will remind other platform to comply and specify configuration space
>  in *reg* property.
> 
> > +	}
> > +
> >  	if (of_pci_range_parser_init(&parser, np)) {
> >  		dev_err(pp->dev, "missing ranges property\n");
> >  		return -EINVAL;
> > @@ -433,6 +446,8 @@ int __init dw_pcie_host_init(struct pcie_port *pp)
> >  			of_pci_range_to_resource(&range, np, &pp->cfg);
> >  			pp->config.cfg0_size = resource_size(&pp->cfg)/2;
> >  			pp->config.cfg1_size = resource_size(&pp->cfg)/2;
> > +			pp->cfg0_base = pp->cfg.start;
> > +			pp->cfg1_base = pp->cfg.start + pp-
> > >config.cfg0_size;
> >  		}
> >  	}
> >
> > @@ -445,8 +460,6 @@ int __init dw_pcie_host_init(struct pcie_port *pp)
> >  		}
> >  	}
> >
> > -	pp->cfg0_base = pp->cfg.start;
> > -	pp->cfg1_base = pp->cfg.start + pp->config.cfg0_size;
> >  	pp->mem_base = pp->mem.start;
> >
> >  	pp->va_cfg0_base = devm_ioremap(pp->dev, pp->cfg0_base,
> 
> Reviewed and Acked-by: Mohit Kumar <mohit.kumar@st.com>

Acked-by: Jingoo Han <jg1.han@samsung.com>

Best regards,
Jingoo Han

> 
> Regards
> Mohit
> 
> > --
> > 1.7.9.5

