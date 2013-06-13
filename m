Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757658Ab3FMNS4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 09:18:56 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:64906 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755677Ab3FMNSx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 09:18:53 -0400
X-AuditID: cbfee68f-b7f436d000000f81-3e-51b9c6ba505f
From: Jingoo Han <jg1.han@samsung.com>
To: "'Arnd Bergmann'" <arnd@arndb.de>
Cc: "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Bjorn Helgaas'" <bhelgaas@google.com>,
        linux-samsung-soc@vger.kernel.org, linux-pci@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        "'Grant Likely'" <grant.likely@secretlab.ca>,
        "'Andrew Murray'" <andrew.murray@arm.com>,
        "'Thomas Petazzoni'" <thomas.petazzoni@free-electrons.com>,
        "'Thierry Reding'" <thierry.reding@avionic-design.de>,
        "'Jason Gunthorpe'" <jgunthorpe@obsidianresearch.com>,
        "'Surendranath Gurivireddy Balla'" <suren.reddy@samsung.com>,
        "'Siva Reddy Kallam'" <siva.kallam@samsung.com>,
        "'Thomas Abraham'" <thomas.abraham@linaro.org>,
        Jingoo Han <jg1.han@samsung.com>
References: <003601ce6756$444e8cd0$cceba670$@samsung.com>
 <2061566.hRLrhtBK6z@wuerfel>
In-reply-to: <2061566.hRLrhtBK6z@wuerfel>
Subject: Re: [PATCH V4 1/3] pci: Add PCIe driver for Samsung Exynos
Date: Thu, 13 Jun 2013 22:18:50 +0900
Message-id: <000901ce6838$8b514720$a1f3d560$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQI6zWNfd1qFXQLUfk+Nn7DxoTtzUwCi4CKwmFW87bA=
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCKsWRmVeSWpSXmKPExsVy+t8zI93dx3YGGhx+w2jR/H87q8XfScfY
	LZY0ZVgcmP2Q1eLVmY1sFpcXXmK1+H7D1KJ3wVU2i02Pr7FaXN41h83i7LzjbBYzzu9jsljR
	tJXRYvHF5cwWu1cuYbE4NmMJo8XTB01MDoIea+atYfT4/WsSo0fflKtsHk82XWT0WLCp1OPO
	tT1sHpuX1Hucn7GQ0eP7jl6ggi2rGD1+vtTx+LxJLoAnissmJTUnsyy1SN8ugStj7sFDzAWt
	zhVX1/5hbmB8ZtrFyMkhIWAi8bDjKiuELSZx4d56ti5GLg4hgWWMEq0vzrDDFC3r+8ECkZjO
	KHH76UpWCOcXo8SvdpAWTg42ATWJL18Og3WICChLHH95B6yDWeAAq8T8G9NZQBJCAhESB9pm
	M4LYnAKaEsdW/AaLCws4S1w+9gcsziKgKnHv7HImEJtXwFKi51I3I4QtKPFj8j2wemYBLYn1
	O48zQdjyEpvXvGWGOFVBYsfZ14wQR1hJ9H78C1UvIrHvxTtGkIMkBB5wSFw7dJ4ZYpmAxLfJ
	h4CKOIASshKbDkDNkZQ4uOIGywRGiVlIVs9CsnoWktWzkKxYwMiyilE0tSC5oDgpvchYrzgx
	t7g0L10vOT93EyMkxfTvYLx7wPoQYzLQ+onMUqLJ+cAUlVcSb2hsZmRhamJqbGRuaUaasJI4
	r1qLdaCQQHpiSWp2ampBalF8UWlOavEhRiYOTqkGxrR6tuX5JVVukuGxeQaKrzPYT2u9W6fx
	sKa2R8PQK/+ZvrBcjtCa1/W6G1VZNKdqc23J7FqdP223W9+6CqOX5nfnufYwSifn80wQMf7/
	NmVigWNXYPjyCx1xq1puRSj3nG3Ra3Y/m2faKPswmckiqfXjBG7ZqrSvJxcLXrsfe2ibIxuL
	3gMlluKMREMt5qLiRAChYhRiRwMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprIJsWRmVeSWpSXmKPExsVy+t9jQd1dx3YGGmy6bW7R/H87q8XfScfY
	LZY0ZVgcmP2Q1eLVmY1sFpcXXmK1+H7D1KJ3wVU2i02Pr7FaXN41h83i7LzjbBYzzu9jsljR
	tJXRYvHF5cwWu1cuYbE4NmMJo8XTB01MDoIea+atYfT4/WsSo0fflKtsHk82XWT0WLCp1OPO
	tT1sHpuX1Hucn7GQ0eP7jl6ggi2rGD1+vtTx+LxJLoAnqoHRJiM1MSW1SCE1Lzk/JTMv3VbJ
	OzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwfoLyWFssScUqBQQGJxsZK+HaYJoSFuuhYw
	jRG6viFBcD1GBmggYR1jxtyDh5gLWp0rrq79w9zA+My0i5GTQ0LARGJZ3w8WCFtM4sK99Wxd
	jFwcQgLTGSVuP13JCuH8YpT41Q6S4eRgE1CT+PLlMDuILSKgLHH85R0WkCJmgQOsEvNvTAcb
	JSQQIXGgbTYjiM0poClxbMVvsLiwgLPE5WN/wOIsAqoS984uZwKxeQUsJXoudTNC2IISPybf
	A6tnFtCSWL/zOBOELS+xec1bZohTFSR2nH3NCHGElUTvx79Q9SIS+168Y5zAKDQLyahZSEbN
	QjJqFpKWBYwsqxhFUwuSC4qT0nMN9YoTc4tL89L1kvNzNzGCE9gzqR2MKxssDjEKcDAq8fC+
	aN0RKMSaWFZcmXuIUYKDWUmE9+bUnYFCvCmJlVWpRfnxRaU5qcWHGJOBPp3ILCWanA9Mrnkl
	8YbGJmZGlkZmFkYm5uakCSuJ8x5otQ4UEkhPLEnNTk0tSC2C2cLEwSnVwGhu/ui1sUFX89qk
	1dx8pXp+YfseFH9p28CzWXXRSatzLIaf0iq/5c3h0T+tmiwQJ2HkNO9BA6skm+nrUlfezder
	8vTbRM6V+87ufcKf1yy9Kmj3hSBBjsfJXI/fL/e5rnFs7u1+6RKhX0YLdhSetVqw5OM6F6+f
	sxfLJ+fxSZz2vbxuWu+sOCWW4oxEQy3mouJEAKGtnKikAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, June 12, 2013 8:23 PM, Arnd Bergmann wrote:
> On Wednesday 12 June 2013 19:19:05 Jingoo Han wrote:
> 
> > +
> > +struct pcie_port {
> > +	struct device		*dev;
> > +	u8			controller;
> > +	u8			root_bus_nr;
> > +	void __iomem		*dbi_base;
> > +	void __iomem		*elbi_base;
> > +	void __iomem		*phy_base;
> > +	void __iomem		*purple_base;
> > +	phys_addr_t		cfg0_base;
> > +	void __iomem		*va_cfg0_base;
> > +	phys_addr_t		cfg1_base;
> > +	void __iomem		*va_cfg1_base;
> > +	phys_addr_t		io_base;
> > +	phys_addr_t		mem_base;
> > +	spinlock_t		conf_lock;
> > +	struct resource		cfg;
> > +	struct resource		io;
> > +	struct resource		mem;
> > +	struct pcie_port_info	config;
> > +	struct clk		*clk;
> > +	struct clk		*bus_clk;
> > +	int			irq;
> > +	int			reset_gpio;
> > +};
> 
> This looks much better now.
> 
> > +
> > +/* synopsis specific PCIE configuration registers*/
> > +#define PCIE_PORT_LINK_CONTROL		0x710
> > +#define PORT_LINK_MODE_MASK		(0x3f << 16)
> > +#define PORT_LINK_MODE_4_LANES		(0x7 << 16)
> 
> Do you mean this is a "Synopsys" designware part? In that case it
> should really not be called "exynos-pcie" but "designware-pcie"
> and you should make sure that the driver makes no assumptions about
> the platform. A lot of other platforms also use designware
> parts and should be able to reuse this driver.

Sorry, I don't think so.
Only core block is a "Synopsys" designware part IP block,
other parts are Exynos-specific.
So, it is hard to share with other PCIe IPs using synopsis core.

> 
> > +static void exynos_pcie_prog_viewport_cfg0(struct pcie_port *pp, u32 busdev)
> > +{
> > +	u32 val;
> > +	void __iomem *dbi_base = pp->dbi_base;
> > +
> > +	/* Program viewport 0 : OUTBOUND : CFG0 */
> > +	val = PCIE_ATU_REGION_OUTBOUND | PCIE_ATU_REGION_INDEX0;
> > +	writel_rc(pp, val, dbi_base + PCIE_ATU_VIEWPORT);
> > +	writel_rc(pp, (u32)pp->cfg0_base, dbi_base + PCIE_ATU_LOWER_BASE);
> > +	writel_rc(pp, 0, dbi_base + PCIE_ATU_UPPER_BASE);
> > +	writel_rc(pp, (u32)pp->cfg0_base + pp->config.cfg0_size - 1,
> > +			dbi_base + PCIE_ATU_LIMIT);
> > +	writel_rc(pp, busdev, dbi_base + PCIE_ATU_LOWER_TARGET);
> > +	writel_rc(pp, 0, dbi_base + PCIE_ATU_UPPER_TARGET);
> > +	writel_rc(pp, PCIE_ATU_TYPE_CFG0, dbi_base + PCIE_ATU_CR1);
> > +	val = PCIE_ATU_ENABLE;
> > +	writel_rc(pp, val, dbi_base + PCIE_ATU_CR2);
> > +}
> 
> I think you should not assume that the physical base address is a 32
> bit value. The hardware clearly supports "lower" and "upper" halves
> for the address window, so when resource_size_t is 64 bit, you should
> set the upper half accordingly. Since the hardware is always 64 bit,
> you can use a "u64" type rather than resource_size_t to simplify the
> code here.

OK, I will replace "u32" with "u64".

> 
> > +static void exynos_pcie_prog_viewport_mem_outbound(struct pcie_port *pp)
> > +{
> > +	u32 val;
> > +	void __iomem *dbi_base = pp->dbi_base;
> > +
> > +	/* Program viewport 0 : OUTBOUND : MEM */
> > +	val = PCIE_ATU_REGION_OUTBOUND | PCIE_ATU_REGION_INDEX0;
> > +	writel_rc(pp, val, dbi_base + PCIE_ATU_VIEWPORT);
> > +	writel_rc(pp, PCIE_ATU_TYPE_MEM, dbi_base + PCIE_ATU_CR1);
> > +	val = PCIE_ATU_ENABLE;
> > +	writel_rc(pp, val, dbi_base + PCIE_ATU_CR2);
> > +	writel_rc(pp, (u32)pp->mem_base, dbi_base + PCIE_ATU_LOWER_BASE);
> > +	writel_rc(pp, 0, dbi_base + PCIE_ATU_UPPER_BASE);
> > +	writel_rc(pp, (u32)(pp->mem_base + pp->config.mem_size - 1),
> > +			dbi_base + PCIE_ATU_LIMIT);
> > +	writel_rc(pp, (u32)pp->mem_base, dbi_base + PCIE_ATU_LOWER_TARGET);
> > +	writel_rc(pp, 0, dbi_base + PCIE_ATU_UPPER_TARGET);
> > +}
> 
> You probably should not assume that there is a 1:1 mapping between
> bus addresses and host physical addresses, but rather read both
> values from the DT individually. With the ranges defined as
> 
>        0x82000000 0 0x40210000 0x40210000 0 0x10000000>; /* non-prefetchable memory */
> 
> the second and third cell should go into
> PCIE_ATU_UPPER_TARGET/PCIE_ATU_LOWER_TARGET, while the translated address
> (from the third cell) should go into PCIE_ATU_LOWER_BASE/PCIE_ATU_UPPER_BASE
> 
> The PCIE_ATU_LIMIT seems to correctly get translated from the last
> cell.

OK, I will change it.

> 
> > +static void exynos_pcie_prog_viewport_io_outbound(struct pcie_port *pp)
> > +{
> > +	u32 val;
> > +	void __iomem *dbi_base = pp->dbi_base;
> > +
> > +	/* Program viewport 1 : OUTBOUND : IO */
> > +	val = PCIE_ATU_REGION_OUTBOUND | PCIE_ATU_REGION_INDEX1;
> > +	writel_rc(pp, val, dbi_base + PCIE_ATU_VIEWPORT);
> > +	writel_rc(pp, PCIE_ATU_TYPE_IO, dbi_base + PCIE_ATU_CR1);
> > +	val = PCIE_ATU_ENABLE;
> > +	writel_rc(pp, val, dbi_base + PCIE_ATU_CR2);
> > +	writel_rc(pp, (u32)pp->io_base, dbi_base + PCIE_ATU_LOWER_BASE);
> > +	writel_rc(pp, 0, dbi_base + PCIE_ATU_UPPER_BASE);
> > +	writel_rc(pp, (u32)(pp->io_base + pp->config.io_size - 1),
> > +			dbi_base + PCIE_ATU_LIMIT);
> > +	writel_rc(pp, (u32)pp->io_base, dbi_base + PCIE_ATU_LOWER_TARGET);
> > +	writel_rc(pp, 0, dbi_base + PCIE_ATU_UPPER_TARGET);
> > +}
> 
> You don't actually map the I/O space anywhere into virtual memory.
> I think you need to call pci_ioremap_io with the pp->io_base at
> boot time.

Sorry, when pci_ioremap_io() is used, Exynos5440 hangs.
I don't know how to deal this.

> 
> I think you mixed up the PCIE_ATU_LOWER_TARGET, it should really be 0,
> since all I/O port numbers have to be smaller than IO_SPACE_LIMIT.
>
> The first argument to pci_ioremap_io needs to be unique for each
> domain and you need to use it to calculate the io_offset you
> set in pci_sys_data->io_offset.
> 
> > +static void exynos_pcie_prog_viewport_mem_inbound(struct pcie_port *pp)
> > +{
> > +	u32 val;
> > +	void __iomem *dbi_base = pp->dbi_base;
> > +	struct pcie_port_info *config = &pp->config;
> > +
> > +	/* Program viewport 0 : INBOUND : MEMORY */
> > +	val = PCIE_ATU_REGION_INBOUND | PCIE_ATU_REGION_INDEX0;
> > +	writel_rc(pp, val, dbi_base + PCIE_ATU_VIEWPORT);
> > +	writel_rc(pp, PCIE_ATU_TYPE_MEM, dbi_base + PCIE_ATU_CR1);
> > +	val = PCIE_ATU_ENABLE | PCIE_ATU_BAR_MODE_ENABLE;
> > +	writel_rc(pp, val, dbi_base + PCIE_ATU_CR2);
> > +	writel_rc(pp, 0, dbi_base + PCIE_ATU_LOWER_BASE);
> > +	writel_rc(pp, 0, dbi_base + PCIE_ATU_UPPER_BASE);
> > +	writel_rc(pp, config->in_mem_size - 1, dbi_base + PCIE_ATU_LIMIT);
> > +	writel_rc(pp, 0, dbi_base + PCIE_ATU_LOWER_TARGET);
> > +	writel_rc(pp, 0, dbi_base + PCIE_ATU_UPPER_TARGET);
> > +}
> 
> You hardcode the in_mem_size to 256 MB. Does that mean you only allow
> PCI bus master DMA on the first part of RAM? Shouldn't it get
> computed from the actual location and size of RAM?

I will remove the hard-coded in_mem_size, instead use the size of MEM region.

> 
> > +static void exynos_pcie_prog_viewport_io_inbound(struct pcie_port *pp)
> > +{
> > +	u32 val;
> > +	void __iomem *dbi_base = pp->dbi_base;
> > +	struct pcie_port_info *config = &pp->config;
> > +
> > +	/* Program viewport 1 : INBOUND : IO */
> > +	val = PCIE_ATU_REGION_INBOUND | PCIE_ATU_REGION_INDEX1;
> > +	writel_rc(pp, val, dbi_base + PCIE_ATU_VIEWPORT);
> > +	writel_rc(pp, PCIE_ATU_TYPE_IO, dbi_base + PCIE_ATU_CR1);
> > +	val = PCIE_ATU_ENABLE | PCIE_ATU_BAR_MODE_ENABLE;
> > +	writel_rc(pp, val, dbi_base + PCIE_ATU_CR2);
> > +	writel_rc(pp, 0, dbi_base + PCIE_ATU_LOWER_BASE);
> > +	writel_rc(pp, 0, dbi_base + PCIE_ATU_UPPER_BASE);
> > +	writel_rc(pp, config->in_mem_size - 1, dbi_base + PCIE_ATU_LIMIT);
> > +	writel_rc(pp, 0, dbi_base + PCIE_ATU_LOWER_TARGET);
> > +	writel_rc(pp, 0, dbi_base + PCIE_ATU_UPPER_TARGET);
> > +}
> 
> I don't understand what in inbound I/O access actually means. What
> does this do, is it for PCI target emulation?

I reviewed the manual, and I will fix it.
I will add bus addresses and host physical addresses to
PCIE_ATU_LOWER_BASE/ PCIE_ATU_LOWER_TARGET.

> 
> > +
> > +static int exynos_pcie_setup(int nr, struct pci_sys_data *sys)
> > +{
> > +	struct pcie_port *pp;
> > +
> > +	pp = sys_to_pcie(sys);
> > +
> > +	if (!pp)
> > +		return 0;
> > +
> > +	pci_add_resource_offset(&sys->resources, &pp->io, sys->io_offset);
> > +	pci_add_resource_offset(&sys->resources, &pp->mem, sys->mem_offset);
> > +
> > +	return 1;
> > +}
> 
> You don't actually set up io_offset and mem_offset, right?

OK, I will replace pci_add_resource_offset() with pci_add_resource().


Best regards,
Jingoo Han

> 
> 	Arnd

