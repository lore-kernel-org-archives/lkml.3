Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751410Ab3GWBOk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 21:14:40 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:37366 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750747Ab3GWBOh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 21:14:37 -0400
X-AuditID: cbfee68e-b7f276d000002279-4b-51edd8fbe328
From: Jingoo Han <jg1.han@samsung.com>
To: "'Kishon Vijay Abraham I'" <kishon@ti.com>,
        "'Pratyush Anand'" <pratyush.anand@st.com>
Cc: "'Bjorn Helgaas'" <bhelgaas@google.com>, linux-pci@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Mohit KUMAR'" <Mohit.KUMAR@st.com>,
        "'Arnd Bergmann'" <arnd@arndb.de>, "'Sean Cross'" <xobs@kosagi.com>,
        "'Thierry Reding'" <thierry.reding@gmail.com>,
        "'SRIKANTH TUMKUR SHIVANAND'" <ts.srikanth@samsung.com>,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        Jingoo Han <jg1.han@samsung.com>
References: <002801ce8376$a807dbf0$f81793d0$@samsung.com>
 <51ED49D6.9050209@ti.com>
In-reply-to: <51ED49D6.9050209@ti.com>
Subject: Re: [PATCH V3] pci: exynos: split into two parts such as Synopsys part
 and Exynos part
Date: Tue, 23 Jul 2013 10:14:34 +0900
Message-id: <000701ce8741$fe47deb0$fad79c10$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQF5ucZjSP0iPtUWKEGMfOteg1KPqQMXV7PgmgJQ5FA=
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprFKsWRmVeSWpSXmKPExsVy+t8zfd3fN94GGqx6w23xd9IxdoslTRkW
	Lw9pWhyY/ZDV4vLCS6wWvQuusllceNrDZnF51xw2i7PzjrNZzDi/j8li49RfjBbtl5Qtfu6a
	x2LRePQBq0XrkweMDvwev39NYvTYOesuu8eCTaUe3xfOZ/c4P2Mho0ffllWMHk9/7GX2OH5j
	O5PH501yAZxRXDYpqTmZZalF+nYJXBmrfx9gK1jsXHG/6SFrA+NE0y5GTg4JAROJf11/GCFs
	MYkL99azdTFycQgJLGOUmLj5KUsXIwdY0YTzIhDxRYwS637PZYdwfjFKNDbuYQXpZhNQk/jy
	5TA7iC0iECHx8sJisCJmgePMEp1vJzOBJIQEQiXWPr0Hto4TqGHLkl0sILawQKLE3NcfmEG2
	sQioSmzs8QIJ8wpYSnSc+ssIYQtK/Jh8D6ycWUBLYv3O40wQtrzE5jVvmSE+UJDYcfY1I8QN
	VhKfnz5jhagRkdj34h0jyD0SAkc4JK4faQdrYBEQkPg2+RDUl7ISmw5AzZGUOLjiBssERolZ
	SFbPQrJ6FpLVs5CsWMDIsopRNLUguaA4Kb3ISK84Mbe4NC9dLzk/dxMjJF307WC8ecD6EGMy
	0PqJzFKiyfnAdJNXEm9obGZkYWpiamxkbmlGmrCSOK9ai3WgkEB6YklqdmpqQWpRfFFpTmrx
	IUYmDk6pBkb165XXT7euPK+xW5vxZKuHYo+2RW5z1cv7kiy5lhwlSS2rDy9/9zrlxNP9/K5p
	kvWbJ3Gd2G59Kt5Lgb3h7mpz6etVqVYc5xfOPTynN7h6OdNFa5ZfU+7d6ZuR/3LR1EOL1zY0
	MGtELWjeVLlI6vuUWVef9xvZff9razRh+eqJ/EW3rVa72PcrsRRnJBpqMRcVJwIAx3y8bi0D	AAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrOKsWRmVeSWpSXmKPExsVy+t9jAd3fN94GGkz9xGLxd9IxdoslTRkW
	Lw9pWhyY/ZDV4vLCS6wWvQuusllceNrDZnF51xw2i7PzjrNZzDi/j8li49RfjBbtl5Qtfu6a
	x2LRePQBq0XrkweMDvwev39NYvTYOesuu8eCTaUe3xfOZ/c4P2Mho0ffllWMHk9/7GX2OH5j
	O5PH501yAZxRDYw2GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4B
	um6ZOUD3KymUJeaUAoUCEouLlfTtME0IDXHTtYBpjND1DQmC6zEyQAMJ6xgzVv8+wFaw2Lni
	ftND1gbGiaZdjBwcEgImEhPOi3QxcgKZYhIX7q1n62Lk4hASWMQose73XHYI5xejRGPjHlaQ
	KjYBNYkvXw6zg9giAhESLy8sBitiFjjOLNH5djITSEJIIFRi7dN7jCA2J1DDliW7WEBsYYFE
	ibmvPzCDbGYRUJXY2OMFEuYVsJToOPWXEcIWlPgx+R5YObOAlsT6nceZIGx5ic1r3jJDXKog
	sePsa0aIG6wkPj99xgpRIyKx78U7xgmMQrOQjJqFZNQsJKNmIWlZwMiyilE0tSC5oDgpPddI
	rzgxt7g0L10vOT93EyM4GT2T3sG4qsHiEKMAB6MSD6+H99tAIdbEsuLK3EOMEhzMSiK8G/WA
	QrwpiZVVqUX58UWlOanFhxiTgR6dyCwlmpwPTJR5JfGGxiZmRpZGZhZGJubmpAkrifMebLUO
	FBJITyxJzU5NLUgtgtnCxMEp1cC4cuqkPcvX1/fff31QScD1Q4hUg6plwI2FMq+so1+dzbr6
	YvmxKzEndyXlBm8rXjx3lYKw4pnCkJ/cJ+aVdE1+NE/XRds09KaHgTAw0Z5tUF4QrlmwfZWr
	zhThE9/eXW6aXnqpocvc4HTimZuK3LV3v37ZvFLoy/7ucx//CJyx/2x27KzZubBaJZbijERD
	Leai4kQAeIeElIoDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, July 23, 2013 12:04 AM, Kishon Vijay Abraham I wrote:
> On Thursday 18 July 2013 10:51 AM, Jingoo Han wrote:
> > Exynos PCIe IP consists of Synopsys specific part and Exynos
> > specific part. Only core block is a Synopsys designware part;
> > other parts are Exynos specific.
> > Also, the Synopsys designware part can be shared with other
> > platforms; thus, it can be split two parts such as Synopsys
> > designware part and Exynos specific part.
> 
> some more queries and comments..

Hi Kishon,
Thank you for your comments. :)

Hi Pratyush Anand,
Please, answer one question mentioned below. :)

> >
> > Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> > Cc: Pratyush Anand <pratyush.anand@st.com>
> > Cc: Mohit KUMAR <Mohit.KUMAR@st.com>
> > ---
> > Changes since v2:
> .
> .
> <snip>
> .
> .
> > +
> > +static struct pcie_host_ops exynos_pcie_host_ops = {
> > +	.readl_rc = exynos_pcie_readl_rc,
> > +	.writel_rc = exynos_pcie_writel_rc,
> > +	.rd_own_conf = exynos_pcie_rd_own_conf,
> > +	.wr_own_conf = exynos_pcie_wr_own_conf,
> > +	.link_up = exynos_pcie_link_up,
> > +	.host_init = exynos_pcie_host_init,
> > +};
> > +
> > +static int add_pcie_port(struct pcie_port *pp, struct platform_device *pdev)
> > +{
> > +	struct exynos_pcie *exynos_pcie = to_exynos_pcie(pp);
> 
> We can move the exynos_pcie specific initialization to probe and leave only
> pcie_port initialization here.

OK, I will move the exynos_pcie specific initialization to probe
as you mentioned.

> > +	struct resource *elbi_base;
> > +	struct resource *phy_base;
> > +	struct resource *block_base;
> > +	int ret;
> > +
> > +	elbi_base = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> > +	if (!elbi_base) {
> > +		dev_err(&pdev->dev, "couldn't get elbi base resource\n");
> > +		return -EINVAL;
> > +	}
> > +	exynos_pcie->elbi_base = devm_ioremap_resource(&pdev->dev, elbi_base);
> > +	if (IS_ERR(exynos_pcie->elbi_base))
> > +		return PTR_ERR(exynos_pcie->elbi_base);
> > +
> > +	phy_base = platform_get_resource(pdev, IORESOURCE_MEM, 1);
> > +	if (!phy_base) {
> > +		dev_err(&pdev->dev, "couldn't get phy base resource\n");
> > +		return -EINVAL;
> > +	}
> > +	exynos_pcie->phy_base = devm_ioremap_resource(&pdev->dev, phy_base);
> > +	if (IS_ERR(exynos_pcie->phy_base))
> > +		return PTR_ERR(exynos_pcie->phy_base);
> > +
> > +	block_base = platform_get_resource(pdev, IORESOURCE_MEM, 2);
> > +	if (!block_base) {
> > +		dev_err(&pdev->dev, "couldn't get block base resource\n");
> > +		return -EINVAL;
> > +	}
> > +	exynos_pcie->block_base = devm_ioremap_resource(&pdev->dev, block_base);
> > +	if (IS_ERR(exynos_pcie->block_base))
> > +		return PTR_ERR(exynos_pcie->block_base);
> 
> So all this till here can be moved to probe.

As above mentioned, I will move it to probe.

> > +
> > +	pp->irq = platform_get_irq(pdev, 1);
> > +	if (!pp->irq) {
> > +		dev_err(&pdev->dev, "failed to get irq\n");
> > +		return -ENODEV;
> > +	}
> > +	ret = devm_request_irq(&pdev->dev, pp->irq, exynos_pcie_irq_handler,
> > +				IRQF_SHARED, "exynos-pcie", pp);
> > +	if (ret) {
> > +		dev_err(&pdev->dev, "failed to request irq\n");
> > +		return ret;
> > +	}
> > +
> > +	pp->root_bus_nr = -1;
> > +	pp->ops = &exynos_pcie_host_ops;
> > +
> > +	spin_lock_init(&pp->conf_lock);
> > +	ret = dw_pcie_host_init(pp);
> > +	if (ret) {
> > +		dev_err(&pdev->dev, "failed to initialize host\n");
> > +		return ret;
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> > +static int __init exynos_pcie_probe(struct platform_device *pdev)
> > +{
> > +	struct exynos_pcie *exynos_pcie;
> > +	struct pcie_port *pp;
> > +	struct device_node *np = pdev->dev.of_node;
> > +	int ret;
> > +
> > +	exynos_pcie = devm_kzalloc(&pdev->dev, sizeof(*exynos_pcie),
> > +				GFP_KERNEL);
> > +	if (!exynos_pcie) {
> > +		dev_err(&pdev->dev, "no memory for exynos pcie\n");
> > +		return -ENOMEM;
> > +	}
> > +
> > +	pp = &exynos_pcie->pp;
> > +
> > +	pp->dev = &pdev->dev;
> > +
> > +	exynos_pcie->reset_gpio = of_get_named_gpio(np, "reset-gpio", 0);
> > +
> > +	exynos_pcie->clk = devm_clk_get(&pdev->dev, "pcie");
> > +	if (IS_ERR(exynos_pcie->clk)) {
> > +		dev_err(&pdev->dev, "Failed to get pcie rc clock\n");
> > +		return PTR_ERR(exynos_pcie->clk);
> > +	}
> > +	ret = clk_prepare_enable(exynos_pcie->clk);
> > +	if (ret)
> > +		return ret;
> > +
> > +	exynos_pcie->bus_clk = devm_clk_get(&pdev->dev, "pcie_bus");
> > +	if (IS_ERR(exynos_pcie->bus_clk)) {
> > +		dev_err(&pdev->dev, "Failed to get pcie bus clock\n");
> > +		ret = PTR_ERR(exynos_pcie->bus_clk);
> > +		goto fail_clk;
> > +	}
> > +	ret = clk_prepare_enable(exynos_pcie->bus_clk);
> > +	if (ret)
> > +		goto fail_clk;
> > +
> > +	ret = add_pcie_port(pp, pdev);
> > +	if (ret < 0)
> > +		goto fail_bus_clk;
> 
> I think we should move all the below code to designware core file. IMO it
> should be common everyone who use designware core.

OK, I will move the below code to dw_pcie_host_init() in pcie-designware.c


> > +
> > +	dw_pci.nr_controllers = 1;
> > +	dw_pci.private_data = (void **)&pp;
> > +
> > +	pci_common_init(&dw_pci);
> > +	pci_assign_unassigned_resources();
> > +#ifdef CONFIG_PCI_DOMAINS
> > +	dw_pci.domain++;
> > +#endif
> > +
> > +	platform_set_drvdata(pdev, exynos_pcie);
> > +	return 0;
> > +
> > +fail_bus_clk:
> > +	clk_disable_unprepare(exynos_pcie->bus_clk);
> > +fail_clk:
> > +	clk_disable_unprepare(exynos_pcie->clk);
> > +	return ret;
> > +}
> > +

[.....]

> > +int dw_pcie_host_init(struct pcie_port *pp)
> > +{
> > +	struct device_node *np = pp->dev->of_node;
> > +	struct of_pci_range range;
> > +	struct of_pci_range_parser parser;
> > +	u32 val;
> > +
> > +	if (of_pci_range_parser_init(&parser, np)) {
> > +		dev_err(pp->dev, "missing ranges property\n");
> > +		return -EINVAL;
> > +	}
> 
> I have some confusion here w.r.t address space :-s

This scheme has been confirmed for last 6 months.
Previous mail threads on Marvell PCIe, Tegra PCIe will be helpful
to catch up this.

> > +
> > +	/* Get the I/O and memory ranges from DT */
> > +	for_each_of_pci_range(&parser, &range) {
> > +		unsigned long restype = range.flags & IORESOURCE_TYPE_BITS;
> > +		if (restype == IORESOURCE_IO) {
> > +			of_pci_range_to_resource(&range, np, &pp->io);
> > +			pp->io.name = "I/O";
> > +			pp->io.start = max_t(resource_size_t,
> > +					     PCIBIOS_MIN_IO,
> > +					     range.pci_addr + global_io_offset);
> > +			pp->io.end = min_t(resource_size_t,
> > +					   IO_SPACE_LIMIT,
> > +					   range.pci_addr + range.size
> > +					   + global_io_offset);
> > +			pp->config.io_size = resource_size(&pp->io);
> > +			pp->config.io_bus_addr = range.pci_addr;
> > +		}
> > +		if (restype == IORESOURCE_MEM) {
> > +			of_pci_range_to_resource(&range, np, &pp->mem);
> > +			pp->mem.name = "MEM";
> > +			pp->config.mem_size = resource_size(&pp->mem);
> > +			pp->config.mem_bus_addr = range.pci_addr;
> > +		}
> > +		if (restype == 0) {
> > +			of_pci_range_to_resource(&range, np, &pp->cfg);
> > +			pp->config.cfg0_size = resource_size(&pp->cfg)/2;
> > +			pp->config.cfg1_size = resource_size(&pp->cfg)/2;
> > +		}
> > +	}
> > +
> > +	pp->dbi_base = devm_ioremap(pp->dev, pp->cfg.start,
> > +				resource_size(&pp->cfg));
> 
> Why is configuraion space divided into two?

Sorry, I don't know the exact reason. :(
Pratyush Anand may know about this.
Pratyush Anand, could you answer the question?

Also, if you find some problems, please let me know.


> Why should it be same as dbi_base?
> AFAIK, jacinto6 has a dedicated configuration/io/memory space that is entirely
> different from dbi_base.

According to the Synopsys designware PCIe datasheet,
in chapter 5.1.1 Register Space Layout,
'Port Logic Registers' are placed between (config space 0x0 + 0x700)
and (config space 0x0 + 0xFFF).
'dbi_base' is used for reading/writing 'Port Logic Registers'.
Exynos are using 'dbi_base' like this. Thus, the base addresses of
both 'dbi_base' and configuration/io/memory space are same.

Just now, I looked at Spear PCIe driver.
However, in the case of Spear, the base address of configuration/io/memory
space is defined as 0x80000000. The base address of 'Port Logic Registers'
is defined as 0xb1000000.
I think that the situation of 'jacinto6' is similar with Spear, right?

Then, I will move pp->dbi_base mapping code from pcie-designware.c
to pci-exynos.c.


Best regards,
Jingoo Han

