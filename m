Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752256AbaCGIhu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 03:37:50 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:46047 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750930AbaCGIhp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 03:37:45 -0500
X-AuditID: cbfee68f-b7f156d00000276c-7d-531985575633
From: Jingoo Han <jg1.han@samsung.com>
To: "'Tanmay Inamdar'" <tinamdar@apm.com>
Cc: linux-pci@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, patches@apm.com, jcm@redhat.com,
        "'Bjorn Helgaas'" <bhelgaas@google.com>,
        "'Arnd Bergmann'" <arnd@arndb.de>,
        "'Jason Gunthorpe'" <jgunthorpe@obsidianresearch.com>,
        "'Grant Likely'" <grant.likely@linaro.org>,
        "'Rob Herring'" <robh+dt@kernel.org>,
        "'Catalin Marinas'" <catalin.marinas@arm.com>,
        "'Rob Landley'" <rob@landley.net>,
        "'Liviu Dudau'" <liviu.dudau@arm.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <1394085963-27553-1-git-send-email-tinamdar@apm.com>
 <1394085963-27553-2-git-send-email-tinamdar@apm.com>
In-reply-to: <1394085963-27553-2-git-send-email-tinamdar@apm.com>
Subject: Re: [PATCH v4 1/4] pci: APM X-Gene PCIe controller driver
Date: Fri, 07 Mar 2014 17:37:42 +0900
Message-id: <005901cf39e0$81ceb960$856c2c20$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac85Ak6x15n2k+c4RZqFLNWGmRMYBAA3JvFg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrIKsWRmVeSWpSXmKPExsVy+t8zA93wVslgg8P3JC3+TjrGbrGkKcPi
	/bIeRov5R86xWhz4s4PRYtLa5cwWlxdeYrX4fsPUYtPja6wWC9uWsFhc3jWHzeLsvONsFgeW
	trNYNJ/5xmax7uV0FovWvUfYLZ5/+sTiIOjxcf0nRo8189Ywevz+NYnRY8GmUo9NqzrZPF6t
	nsnqcefaHjaPzUvqPb7v6GX0eL/vKptH35ZVjB6fN8kF8ERx2aSk5mSWpRbp2yVwZcz/fYGl
	oEeu4t/zvWwNjF0SXYwcHBICJhKP9jN2MXICmWISF+6tZ+ti5OIQEljGKPGu+RITRMJE4sbU
	bnYQW0hgEaPEvGNVEEW/GSVmPd4AVsQmoCbx5cthdpChIgLqErunyIDUMAusZJHonr+FCaK5
	XOLc/O1g2zgFHCVuNkxjBrGFBZwkpq9qZAOxWQRUJfZO2swCYvMK2EpMWnCMEcIWlPgx+R5Y
	nFlAS2L9zuNMELa8xOY1b5khnlGXePRXFyQsImAk0XukGapcRGLfi3eMIPdICDzhkFj0bxkr
	xC4BiW+TD7FA9MpKbDrADPGvpMTBFTdYJgB9h2TzLCSbZyHZPAvJigWMLKsYRVMLkguKk9KL
	jPWKE3OLS/PS9ZLzczcxQpJL/w7GuwesDzEmA62fyCwlmpwPTE55JfGGxmZGFqYmpsZG5pZm
	pAkrifPef5gUJCSQnliSmp2aWpBaFF9UmpNafIiRiYNTqoFx3oe6XRsP31gfxHXg/qmZ5rvC
	9j74Wsg/OUjiSNzsjsa1Pxx2Zoi77TNxVJheps2uJPnnd8jc8EI1bc6uacWlHx00Vhp1c1qH
	PLXaeeff7c7ss+eYNtvISt08uK1H6w6vzee71fH536JWPs1UnnDWZC/Ph8diWhcq/Z7afbdV
	PHrX4/C+aU0/lViKMxINtZiLihMB/0TCckQDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupnk+LIzCtJLcpLzFFi42I5/e+xgG54q2SwQecGYYu/k46xWyxpyrB4
	v6yH0WL+kXOsFgf+7GC0mLR2ObPF5YWXWC2+3zC12PT4GqvFwrYlLBaXd81hszg77zibxYGl
	7SwWzWe+sVmsezmdxaJ17xF2i+efPrE4CHp8XP+J0WPNvDWMHr9/TWL0WLCp1GPTqk42j1er
	Z7J63Lm2h81j85J6j+87ehk93u+7yubRt2UVo8fnTXIBPFENjDYZqYkpqUUKqXnJ+SmZeem2
	St7B8c7xpmYGhrqGlhbmSgp5ibmptkouPgG6bpk5QI8pKZQl5pQChQISi4uV9O0wTQgNcdO1
	gGmM0PUNCYLrMTJAAwnrGDPm/77AUtAjV/Hv+V62BsYuiS5GTg4JAROJG1O72SFsMYkL99az
	gdhCAosYJeYdq+pi5AKyfzNKzHq8gQkkwSagJvHly2GgBg4OEQF1id1TZEBqmAVWskh0z9/C
	BNFcLnFu/nZGEJtTwFHiZsM0ZhBbWMBJYvqqRrAFLAKqEnsnbWYBsXkFbCUmLTjGCGELSvyY
	fA8sziygJbF+53EmCFteYvOat8wgeyWA9j76qwsSFhEwkug90gxVLiKx78U7xgmMQrOQTJqF
	ZNIsJJNmIWlZwMiyilE0tSC5oDgpPddQrzgxt7g0L10vOT93EyM4eT2T2sG4ssHiEKMAB6MS
	D2/HIolgIdbEsuLK3EOMEhzMSiK8Xc2SwUK8KYmVValF+fFFpTmpxYcYk4EencgsJZqcD0ys
	eSXxhsYmZkaWRmYWRibm5qQJK4nzHmi1DhQSSE8sSc1OTS1ILYLZwsTBKdXAWLO2REZt46/7
	9yY6S7O963Ataf9kvcCFQ+/SqfczjspWidTIlEopeqW195xI+hzXFvdabI9tRraNz7kp1k9k
	7NNksvji3OZeMH8maWrPOE/JjOfxceVP3IGRcz5e9SjXvGEmv1XxJqPkr9s2vMHb19llc04r
	Zl8SuLt1zozZZ6P23ni8znCSEktxRqKhFnNRcSIAPEbMaKIDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, March 06, 2014 3:06 PM, Tanmay Inamdar wrote:
> 

Hi Tanmay Inamdar,

I added some minor comments. :-)

> This patch adds the AppliedMicro X-Gene SOC PCIe controller driver.
> X-Gene PCIe controller supports maxmum upto 8 lanes and GEN3 speed.

Would you fix the followings?

s/maxmum/maximum
s/upto/up to

> X-Gene SOC supports maximum 5 PCIe ports.
> 
> Signed-off-by: Tanmay Inamdar <tinamdar@apm.com>
> ---
>  drivers/pci/host/Kconfig     |   10 +
>  drivers/pci/host/Makefile    |    1 +
>  drivers/pci/host/pci-xgene.c |  739 ++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 750 insertions(+)
>  create mode 100644 drivers/pci/host/pci-xgene.c

[.....]

> --- /dev/null
> +++ b/drivers/pci/host/pci-xgene.c

[.....]

> +
> +static int xgene_pcie_parse_map_dma_ranges(struct xgene_pcie_port *port)
> +{
> +	struct device_node *np = port->node;
> +	struct of_pci_range range;
> +	struct of_pci_range_parser parser;
> +	struct device *dev = port->dev;
> +	u8 ib_reg_mask = 0;
> +
> +	if (pci_dma_range_parser_init(&parser, np)) {
> +		dev_err(dev, "missing dma-ranges property\n");
> +		return -EINVAL;
> +	}
> +
> +	/* Get the dma-ranges from DT */
> +	for_each_of_pci_range(&parser, &range) {
> +		u64 end = range.cpu_addr + range.size - 1;
> +		dev_dbg(port->dev, "0x%08x 0x%016llx..0x%016llx -> 0x%016llx\n",
> +			range.flags, range.cpu_addr, end, range.pci_addr);
> +		xgene_pcie_setup_ib_reg(port, &range, &ib_reg_mask);
> +	}
> +	return 0;
> +}
> +
> +static int __init xgene_pcie_probe_bridge(struct platform_device *pdev)

Please, remove '__init' marker in order to fix section mismatch
warning.

> +{
> +	struct device_node *np = of_node_get(pdev->dev.of_node);
> +	struct xgene_pcie_port *port;
> +	struct pci_host_bridge *bridge;
> +	resource_size_t lastbus;
> +	u32 lanes = 0, speed = 0;
> +	u64 cfg_addr = 0;
> +	int ret;
> +
> +	port = devm_kzalloc(&pdev->dev, sizeof(*port), GFP_KERNEL);
> +	if (!port)
> +		return -ENOMEM;
> +	port->node = np;
> +	port->dev = &pdev->dev;
> +
> +	ret = xgene_pcie_map_reg(port, pdev, &cfg_addr);
> +	if (ret)
> +		return ret;
> +
> +	ret = xgene_pcie_init_port(port);
> +	if (ret)
> +		return ret;
> +	xgene_pcie_program_core(port->csr_base);
> +	xgene_pcie_setup_root_complex(port);
> +
> +	bridge = of_create_pci_host_bridge(&pdev->dev, &xgene_pcie_ops, port);
> +	if (IS_ERR_OR_NULL(bridge))
> +		return PTR_ERR(bridge);
> +
> +	ret = xgene_pcie_map_ranges(port, bridge, cfg_addr);
> +	if (ret)
> +		return ret;
> +
> +	ret = xgene_pcie_parse_map_dma_ranges(port);
> +	if (ret)
> +		return ret;
> +
> +	xgene_pcie_poll_linkup(port, &lanes, &speed);
> +	if (!port->link_up)
> +		dev_info(port->dev, "(rc) link down\n");
> +	else
> +		dev_info(port->dev, "(rc) x%d gen-%d link up\n",
> +				lanes, speed + 1);
> +	platform_set_drvdata(pdev, port);
> +	lastbus = pci_rescan_bus(bridge->bus);
> +	pci_bus_update_busn_res_end(bridge->bus, lastbus);
> +	return 0;
> +}
> +
> +static const struct of_device_id xgene_pcie_match_table[] __initconst = {

Please, remove '__initconst' marker in order to fix section mismatch
warning.

> +	{.compatible = "apm,xgene-pcie",},
> +	{},
> +};
> +
> +static struct platform_driver xgene_pcie_driver = {
> +	.driver = {
> +		   .name = "xgene-pcie",
> +		   .owner = THIS_MODULE,
> +		   .of_match_table = of_match_ptr(xgene_pcie_match_table),
> +		  },

Please fix this indent style, as below:

+	},

See you later. :-)

Best regards,
Jingoo Han

> +	.probe = xgene_pcie_probe_bridge,
> +};
> +module_platform_driver(xgene_pcie_driver);
> +
> +MODULE_AUTHOR("Tanmay Inamdar <tinamdar@apm.com>");
> +MODULE_DESCRIPTION("APM X-Gene PCIe driver");
> +MODULE_LICENSE("GPL v2");
> --
> 1.7.9.5

