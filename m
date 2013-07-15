Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754421Ab3GOIZi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 04:25:38 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:26547 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754119Ab3GOIZf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 04:25:35 -0400
X-AuditID: cbfee691-b7fef6d000002d62-03-51e3b1ebb86f
From: Jingoo Han <jg1.han@samsung.com>
To: "'Kishon Vijay Abraham I'" <kishon@ti.com>
Cc: "'Bjorn Helgaas'" <bhelgaas@google.com>, linux-pci@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Pratyush Anand'" <pratyush.anand@st.com>,
        "'Mohit KUMAR'" <Mohit.KUMAR@st.com>,
        "'Arnd Bergmann'" <arnd@arndb.de>, "'Sean Cross'" <xobs@kosagi.com>,
        "'SRIKANTH TUMKUR SHIVANAND'" <ts.srikanth@samsung.com>,
        linux-kernel@vger.kernel.org, Jingoo Han <jg1.han@samsung.com>
References: <001201ce7dfa$716b3370$54419a50$@samsung.com>
 <51DFD3F3.9050704@ti.com>
In-reply-to: <51DFD3F3.9050704@ti.com>
Subject: Re: [PATCH V2] pci: exynos: split into two parts such as Synopsys part
 and Exynos part
Date: Mon, 15 Jul 2013 17:25:15 +0900
Message-id: <000601ce8134$d5277b20$7f767160$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQMw1eBP/VKXWuT2/qwqXEWC1QeRsgH66BKvlpDlkSA=
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpjleLIzCtJLcpLzFFi42I5/e+Zse6bjY8DDZpkLf5OOsZusaQpw+Ll
	IU2LywsvsVr0LrjKZnHhaQ+bxeVdc9gszs47zmYx4/w+JouNU38xWrRfUrZoPPqA1aL1yQNG
	B16P378mMXos2FTq8X3hfHaPvi2rGD2e/tjL7HH8xnYmj8+b5ALYo7hsUlJzMstSi/TtErgy
	9nx/w1iwXrHiXkM7SwPjE8kuRk4OCQETif079jNC2GISF+6tZ+ti5OIQEljGKHH3+CFWmKJX
	S28wQSQWMUpc/ziLFcL5xSgx78NasHY2ATWJL18Os4PYIgI6EgtPr2cGKWIWmMsscbivlQUk
	ISQQKtE99wjQKA4OTqCG9puVIGFhgUSJfysfsIHYLAKqElMOLQUr5xWwlDg6vYsVwhaU+DH5
	HlicWUBLYv3O40wQtrzE5jVvmSEuVZDYcfY1I8QNVhITfy6FqhGR2PfiHSPIPRICSzkkHj49
	zAqxTEDi2+RDLCD3SAjISmw6ADVHUuLgihssExglZiFZPQvJ6llIVs9CsmIBI8sqRtHUguSC
	4qT0IlO94sTc4tK8dL3k/NxNjJA0MHEH4/0D1ocYk4HWT2SWEk3OB6aRvJJ4Q2MzIwtTE1Nj
	I3NLM9KElcR51VusA4UE0hNLUrNTUwtSi+KLSnNSiw8xMnFwSjUwBpuu3T77zKZVJy4VVNsl
	MRYvUDP/qxKbU6UQ8n/ueaWrfJWtEzk26ahlmke/+pl7Wu5Re1Lm5/D/Vz/0f9sw/fb/XE/d
	LubUc/NFjBZXvJy0bGvn+qUmN1Z9uPdn29niYk/Nh8oGMf+0JugGXT5+J8s243aGsMTmiX53
	C1VOXHbyO6JfxBampsRSnJFoqMVcVJwIAGwvnaUZAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCKsWRmVeSWpSXmKPExsVy+t9jAd3XGx8HGvQvN7f4O+kYu8WSpgyL
	l4c0LS4vvMRq0bvgKpvFhac9bBaXd81hszg77zibxYzz+5gsNk79xWjRfknZovHoA1aL1icP
	GB14PX7/msTosWBTqcf3hfPZPfq2rGL0ePpjL7PH8RvbmTw+b5ILYI9qYLTJSE1MSS1SSM1L
	zk/JzEu3VfIOjneONzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvMAbpVSaEsMacUKBSQWFyspG+H
	aUJoiJuuBUxjhK5vSBBcj5EBGkhYx5ix5/sbxoL1ihX3GtpZGhifSHYxcnJICJhIvFp6gwnC
	FpO4cG89WxcjF4eQwCJGiesfZ7FCOL8YJeZ9WMsIUsUmoCbx5cthdhBbREBHYuHp9cwgRcwC
	c5klDve1soAkhARCJbrnHgEay8HBCdTQfrMSJCwskCjxb+UDNhCbRUBVYsqhpWDlvAKWEken
	d7FC2IISPybfA4szC2hJrN95nAnClpfYvOYtM8SlChI7zr5mhLjBSmLiz6VQNSIS+168Y5zA
	KDQLyahZSEbNQjJqFpKWBYwsqxhFUwuSC4qT0nON9IoTc4tL89L1kvNzNzGC08wz6R2Mqxos
	DjEKcDAq8fBmqD0OFGJNLCuuzD3EKMHBrCTCu0z5UaAQb0piZVVqUX58UWlOavEhxmSgTycy
	S4km5wNTYF5JvKGxiZmRpZGZhZGJuTlpwkrivAdbrQOFBNITS1KzU1MLUotgtjBxcEo1MDo8
	X9DPlnLshHTAoY3GG6RvpktWthj9aJSruZdRdOfTVbHUO/w1y4K//JL5dlHkpJrUm3q5RUyv
	P+8QfL1h2+I3xxJv3NtwwzB0/027Kcp3sxZLf3TXeLhS/tzFTWLrbB/Prkn+85V7zVExp7tu
	7q9ULj9rvXbapaB376/VBVM+L5BkFHXZtWqVEktxRqKhFnNRcSIAsMExbXcDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, July 12, 2013 7:01 PM, Kishon Vijay Abraham I wrote:
> On Thursday 11 July 2013 11:19 AM, Jingoo Han wrote:
> > Exynos PCIe IP consists of Synopsys specific part and Exynos
> > specific part. Only core block is a Synopsys designware part;
> > other parts are Exynos specific.
> > Also, the Synopsys designware part can be shared with other
> > platforms; thus, it can be split two parts such as Synopsys
> > designware part and Exynos specific part.
> >
> > Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> > Cc: Pratyush Anand <pratyush.anand@st.com>
> > Cc: Mohit KUMAR <Mohit.KUMAR@st.com>
> > ---
> > Changes since v1:
> > - moved the configuration, I/O, memory space handling to dw_pcie_host_init()
> > - removed exynos_pcie_abort()
> > - replaced 'purple_base' with 'block_base'
> > - replaced 'dbi_base' with 'dbi_addr'
> >
> >  drivers/pci/host/Makefile          |    1 +
> >  drivers/pci/host/pcie-designware.c |  963 +++++++++---------------------------
> >  drivers/pci/host/pcie-designware.h |   71 +++
> >  drivers/pci/host/pcie-exynos.c     |  523 ++++++++++++++++++++
> >  4 files changed, 822 insertions(+), 736 deletions(-)
> >  create mode 100644 drivers/pci/host/pcie-designware.h
> >  create mode 100644 drivers/pci/host/pcie-exynos.c
> >

[...]

> > -static void exynos_pcie_setup_rc(struct pcie_port *pp)
> > +void dw_pcie_setup_rc(struct pcie_port *pp)
> >  {
> >  	struct pcie_port_info *config = &pp->config;
> >  	void __iomem *dbi_base = pp->dbi_base;
> > @@ -549,509 +502,47 @@ static void exynos_pcie_setup_rc(struct pcie_port *pp)
> >  	u32 memlimit;
> >
> >  	/* set the number of lines as 4 */
> > -	readl_rc(pp, dbi_base + PCIE_PORT_LINK_CONTROL, &val);
> > +	dw_pcie_readl_rc(pp, dbi_base + PCIE_PORT_LINK_CONTROL, &val);
> >  	val &= ~PORT_LINK_MODE_MASK;
> >  	val |= PORT_LINK_MODE_4_LANES;
> > -	writel_rc(pp, val, dbi_base + PCIE_PORT_LINK_CONTROL);
> > +	dw_pcie_writel_rc(pp, val, dbi_base + PCIE_PORT_LINK_CONTROL);
> 
> I guess here we need to make this configurable. In Jacinto6 this can be either
> single lane or double lane. Maybe we should have a dt property to specify the
> number of lanes?

OK, I will make it configurable.

[...]

> > +struct pcie_port_info {
> > +	u32		cfg0_size;
> > +	u32		cfg1_size;
> > +	u32		io_size;
> > +	u32		mem_size;
> > +	phys_addr_t	io_bus_addr;
> > +	phys_addr_t	mem_bus_addr;
> > +};
> > +
> > +struct pcie_port {
> > +	struct device		*dev;
> > +	u8			controller;
> > +	u8			root_bus_nr;
> > +	void __iomem		*dbi_base;
> > +	void __iomem		*elbi_base;
> > +	void __iomem		*phy_base;
> > +	void __iomem		*block_base;
> > +	u64			cfg0_base;
> > +	void __iomem		*va_cfg0_base;
> > +	u64			cfg1_base;
> > +	void __iomem		*va_cfg1_base;
> > +	u64			io_base;
> > +	u64			mem_base;
> > +	spinlock_t		conf_lock;
> > +	struct resource		cfg;
> > +	struct resource		io;
> > +	struct resource		mem;
> > +	struct pcie_port_info	config;
> > +	struct clk		*clk;
> > +	struct clk		*bus_clk;
> > +	int			irq;
> > +	int			reset_gpio;
> > +	struct dw_pcie_host_ops	*ops;
> > +};
> 
> I think this structure should be split. This has too many of platform specific
> fields. Maybe we should make pcie_port have only fields necessary for core part
> and have some other structure for platform specific part?
> 
> Something like
> struct exynos_pcie {
> 	[...]
> 	void __iomem		*dbi_base;
> 	void __iomem		*elbi_base;
> 	void __iomem		*phy_base;
> 	int			reset_gpio;
> 	struct clk		*clk;
> 	struct clk		*bus_clk;
> 	[...]
> 	struct pcie_port	pp;
> }
> 
> struct pcie_port {
> 	struct device		*dev;
> 	u64			cfg0_base;
> 	void __iomem		*va_cfg0_base;
> 	u64			cfg1_base;
> 	void __iomem		*va_cfg1_base;
> 	u64			io_base;
> 	u64			mem_base;
> 	spinlock_t		conf_lock;
> 	struct resource		cfg;
> 	struct resource		io;
> 	struct resource		mem;
> 	struct pcie_port_info	config;
> 	int			irq;
> 	struct dw_pcie_host_ops	*ops;
> };
> 
> And in ops, you can use container_of to get reference to exynos_pcie (if we
> want to write to exynos pcie registers)

OK, I see.
It looks good. I will use it as you guided.
Thank you for your suggestion. :)

Best regards,
Jingoo Han


