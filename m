Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751921Ab3JIFHu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 01:07:50 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:27826 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751195Ab3JIFHq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 01:07:46 -0400
X-AuditID: cbfee68e-b7f756d000004512-4c-5254e4990d65
From: Jingoo Han <jg1.han@samsung.com>
To: "'Kishon Vijay Abraham I'" <kishon@ti.com>
Cc: "'Bjorn Helgaas'" <bhelgaas@google.com>, linux-pci@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Pratyush Anand'" <pratyush.anand@st.com>,
        "'Mohit KUMAR'" <Mohit.KUMAR@st.com>,
        "'Siva Reddy Kallam'" <siva.kallam@samsung.com>,
        "'SRIKANTH TUMKUR SHIVANAND'" <ts.srikanth@samsung.com>,
        "'Arnd Bergmann'" <arnd@arndb.de>, "'Sean Cross'" <xobs@kosagi.com>,
        "'Thierry Reding'" <thierry.reding@gmail.com>,
        "'Thomas Petazzoni'" <thomas.petazzoni@free-electrons.com>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <001a01ceaace$013ec980$03bc5c80$%han@samsung.com>
 <5253A4DA.7090306@ti.com>
In-reply-to: <5253A4DA.7090306@ti.com>
Subject: Re: [PATCH V3] PCI: exynos: add support for MSI
Date: Wed, 09 Oct 2013 14:07:36 +0900
Message-id: <000001cec4ad$78640450$692c0cf0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac7D7u06YLDvVZB6RoeAlYfsjNUtrgAva9Xw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrMKsWRmVeSWpSXmKPExsVy+t8zA92ZT0KCDE7t47H4O+kYu8WSpgyL
	l4c0LeYfOcdqcXnhJVaL3gVX2SwuPO1hs7i8aw6bxdl5x9ksZpzfx2SxceovRov2S8oWK5q2
	Mlr83DWPxeLpgyYmi8ajD1gtWp88YHQQ9Pj9axKjx5NNFxk9ds66y+6xYFOpx/eF89k9+ras
	YvR4+mMvs8fxG9uZPD5vkgvgjOKySUnNySxLLdK3S+DK2Da/mbHgNH/Fx3vODYybeboYOTkk
	BEwkrk68zwxhi0lcuLeerYuRi0NIYBmjxPXZixlhik7eP8UEkVjEKNG/+zILhPOLUWLrnwZ2
	kCo2ATWJL18Og9kiAjoSC0+vBxvLLHCTReLWS1UQW0ggUuLeg6esIDYnUP2Oi7dZQGxhAQuJ
	1rnfmUBsFgFVifebO8FqeAVsJd4cv8EIYQtK/Jh8jwVippbE+p3HmSBseYnNa94C7eIAulRd
	4tFfXYgTjCQ+vFnMDlEiIrHvxTtGkJslBM5wSLzYcI8dYpeAxLfJh1ggemUlNh2AhoSkxMEV
	N1gmMErMQrJ5FpLNs5BsnoVkxQJGllWMoqkFyQXFSelFRnrFibnFpXnpesn5uZsYIQmkbwfj
	zQPWhxiTgdZPZJYSTc4HJqC8knhDYzMjC1MTU2Mjc0sz0oSVxHnVWqwDhQTSE0tSs1NTC1KL
	4otKc1KLDzEycXBKNTD2JD2Ke2/aksZWxv2wp/ujv8bBeLO4b5Z6a7b3si7ruvkrOWGa29Q5
	LKtuLzm5IvlSsOq8C9bNfQHnK2ZtXqX9+euVdwlCTHml+bXRJksXp3/Y7Tn79K2bv13UXSvl
	fCf/LZx42uGPRYNiXdgh9i+tqz1uNt5cv1Qq/+60z08OXfz0ZNrCiFlnlFiKMxINtZiLihMB
	H5c7OTYDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpgk+LIzCtJLcpLzFFi42I5/e+xgO7MJyFBBofWsVn8nXSM3WJJU4bF
	y0OaFvOPnGO1uLzwEqtF74KrbBYXnvawWVzeNYfN4uy842wWM87vY7LYOPUXo0X7JWWLFU1b
	GS1+7prHYvH0QROTRePRB6wWrU8eMDoIevz+NYnR48mmi4weO2fdZfdYsKnU4/vC+ewefVtW
	MXo8/bGX2eP4je1MHp83yQVwRjUw2mSkJqakFimk5iXnp2TmpdsqeQfHO8ebmhkY6hpaWpgr
	KeQl5qbaKrn4BOi6ZeYAfaKkUJaYUwoUCkgsLlbSt8M0ITTETdcCpjFC1zckCK7HyAANJKxj
	zNg2v5mx4DR/xcd7zg2Mm3m6GDk5JARMJE7eP8UEYYtJXLi3nq2LkYtDSGARo0T/7sssEM4v
	RomtfxrYQarYBNQkvnw5DGaLCOhILDy9nhnEZha4ySJx66UqiC0kEClx78FTVhCbE6h+x8Xb
	LCC2sICFROvc72DbWARUJd5v7gSr4RWwlXhz/AYjhC0o8WPyPRaImVoS63ceZ4Kw5SU2r3kL
	tIsD6FJ1iUd/dSFOMJL48GYxO0SJiMS+F+8YJzAKzUIyaRaSSbOQTJqFpGUBI8sqRtHUguSC
	4qT0XEO94sTc4tK8dL3k/NxNjOD09ExqB+PKBotDjAIcjEo8vA/4Q4KEWBPLiitzDzFKcDAr
	ifDmLQQK8aYkVlalFuXHF5XmpBYfYkwGenQis5Rocj4wdeaVxBsam5gZWRqZWRiZmJuTJqwk
	znug1TpQSCA9sSQ1OzW1ILUIZgsTB6dUA+PFBy1XNrJNszD+EnD0w+v585s0HGc+XR6yan95
	D/tlxvO6j+tNrx8sSZldf1aJfUXa73mqguc9bdudu58dT5m54u6sM9Lql/je9EgkzVx/bdG0
	nMpHHWq8LqoXb/3smXOh+G5nVvbtCqawQ0852/f4GO71m1b57eSUW46Lz7zZq/9bisF04WNl
	JZbijERDLeai4kQA/ODP45MDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, October 08, 2013 3:23 PM, Kishon Vijay Abraham I wrote:
> On Friday 06 September 2013 12:24 PM, Jingoo Han wrote:
> > This patch adds support for Message Signaled Interrupt in the
> > Exynos PCIe diver using Synopsys designware PCIe core IP.
> >
> > Signed-off-by: Siva Reddy Kallam <siva.kallam@samsung.com>
> > Signed-off-by: Srikanth T Shivanand <ts.srikanth@samsung.com>
> > Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> > Cc: Pratyush Anand <pratyush.anand@st.com>
> > Cc: Mohit KUMAR <Mohit.KUMAR@st.com>
> > ---

[.....]

> >  int __init dw_pcie_host_init(struct pcie_port *pp)
> >  {
> >  	struct device_node *np = pp->dev->of_node;
> > @@ -157,6 +372,8 @@ int __init dw_pcie_host_init(struct pcie_port *pp)
> >  	struct of_pci_range_parser parser;
> >  	u32 val;
> >
> > +	struct irq_domain *irq_domain;
> > +
> >  	if (of_pci_range_parser_init(&parser, np)) {
> >  		dev_err(pp->dev, "missing ranges property\n");
> >  		return -EINVAL;
> > @@ -223,6 +440,18 @@ int __init dw_pcie_host_init(struct pcie_port *pp)
> >  		return -EINVAL;
> >  	}
> >
> > +	if (IS_ENABLED(CONFIG_PCI_MSI)) {
> > +		irq_domain = irq_domain_add_linear(pp->dev->of_node,
> > +					MAX_MSI_IRQS, &msi_domain_ops,
> > +					&dw_pcie_msi_chip);
> > +		if (!irq_domain) {
> > +			dev_err(pp->dev, "irq domain init failed\n");
> > +			return -ENXIO;
> > +		}
> > +
> > +		pp->msi_irq_start = irq_find_mapping(irq_domain, 0);
> 
> Where is the irq_create_mapping done for this irq domain? Is that not needed?
> Without that I'm not getting the correct irq number.

Oh, you're right.
irq_create_mapping() is necessary!

Without irq_create_mapping(), it makes the ugly NULL deference
when two PCIe controllers are used on Exynos5440.
It is my mistake.

I will add irq_create_mapping() to dw_msi_setup_irq(), as tegra PCIe driver
did. I will send the patch, soon.

I really appreciate your comment. :-)
Thank you.

Best regards,
Jingoo Han

