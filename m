Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932416Ab3FQJp6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 05:45:58 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:12652 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932188Ab3FQJpz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 05:45:55 -0400
X-AuditID: cbfee690-b7f6f6d00000740c-bc-51bedad18828
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
References: <000b01ce6839$0f0455d0$2d0d0170$@samsung.com>
 <13685067.uPzcc2y1CU@wuerfel> <000001ce68d7$ca762200$5f626600$@samsung.com>
 <3539874.V7zkhbMg0b@wuerfel>
In-reply-to: <3539874.V7zkhbMg0b@wuerfel>
Subject: Re: [PATCH V5 1/3] pci: Add PCIe driver for Samsung Exynos
Date: Mon, 17 Jun 2013 18:45:52 +0900
Message-id: <005e01ce6b3f$74e3c940$5eab5bc0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQIepNJd3UbA8CoBBJYQqRm0XD6uiAJeVbZCAWFlwtsBmefWm5huZaIA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrAKsWRmVeSWpSXmKPExsVy+t8zA92Lt/YFGhy/LGbR/H87q8XfScfY
	LZY0ZVgcmP2Q1eLVmY1sFpcXXmK1+H7D1KJ3wVU2i02Pr7FaXN41h83i7LzjbBYzzu9jsljR
	tJXRYvHF5cwWu1cuYbE4NmMJo8XTB01MDoIea+atYfT4/WsSo0fflKtsHk82XWT0WLCp1OPO
	tT1sHpuX1Hucn7GQ0eP7jl6ggi2rGD1+vtTx+LxJLoAnissmJTUnsyy1SN8ugSvjbptDwX2P
	irM7ljI2MD6x6GLk4JAQMJFYOV+gi5ETyBSTuHBvPVsXIxeHkMAyRom5W3pYYWpmbfGBiC9i
	lNh3cikLhPOLUaJx6nNmkG42ATWJL18Os4PYIgLKEsdf3gErYhY4wCox/8Z0FpAE2NgtDUog
	UzkFNCX6D9qDhIUFnCUufFvCBmKzCKhKbFt0FWwmr4ClxIujT9khbEGJH5PvgY1hFtCS2Lyt
	iRXClpfYvOYtM8QHChI7zr5mhLjBTWLX4tXsEDUiEvtevGMEuUdC4AmHxM6eJUwQywQkvk0+
	xALxpazEpgNQcyQlDq64wTKBUWIWktWzkKyehWT1LCQrFjCyrGIUTS1ILihOSi8y0StOzC0u
	zUvXS87P3cQISS0TdjDeO2B9iDEZaP1EZinR5HxgasoriTc0NjOyMDUxNTYytzQjTVhJnFe9
	xTpQSCA9sSQ1OzW1ILUovqg0J7X4ECMTB6dUA6PUs8szYlM0FuXE7myPMbh+uIbj8PrKLWmL
	JNc+5JjIzO5SdSlWPNblgWVPBot6nMW69HrR5eIeLUvqfbO/Oq4+6Of4yUVEVrvyV5XGCV8W
	lkt2p5cmFBmursm8tVdt1orS/fwSrkk92x5a3VBpm/j8xrTTTD4H2JaI2uj9aN316KCxWGNJ
	vxJLcUaioRZzUXEiAJO8yWhDAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupjk+LIzCtJLcpLzFFi42I5/e+xgO7FW/sCDU5d5Ldo/r+d1eLvpGPs
	FkuaMiwOzH7IavHqzEY2i8sLL7FafL9hatG74CqbxabH11gtLu+aw2Zxdt5xNosZ5/cxWaxo
	2sposfjicmaL3SuXsFgcm7GE0eLpgyYmB0GPNfPWMHr8/jWJ0aNvylU2jyebLjJ6LNhU6nHn
	2h42j81L6j3Oz1jI6PF9Ry9QwZZVjB4/X+p4fN4kF8AT1cBok5GamJJapJCal5yfkpmXbqvk
	HRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuWmQP0l5JCWWJOKVAoILG4WEnfDtOE0BA3XQuY
	xghd35AguB4jAzSQsI4x426bQ8F9j4qzO5YyNjA+sehi5OCQEDCRmLXFp4uRE8gUk7hwbz1b
	FyMXh5DAIkaJfSeXskA4vxglGqc+ZwapYhNQk/jy5TA7iC0ioCxx/OUdsCJmgQOsEvNvTGcB
	SQgJLGOU2NKgBLKBU0BTov+gPUhYWMBZ4sK3JWwgNouAqsS2RVfBZvIKWEq8OPqUHcIWlPgx
	+R7YGGYBLYnN25pYIWx5ic1r3jJDXKogsePsa0aIG9wkdi1ezQ5RIyKx78U7xgmMQrOQjJqF
	ZNQsJKNmIWlZwMiyilE0tSC5oDgpPddQrzgxt7g0L10vOT93EyM4dT2T2sG4ssHiEKMAB6MS
	D++G6n2BQqyJZcWVuYcYJTiYlUR4YycChXhTEiurUovy44tKc1KLDzEmA306kVlKNDkfmFbz
	SuINjU3MjCyNzCyMTMzNSRNWEuc90GodKCSQnliSmp2aWpBaBLOFiYNTqoGxKvdR7K2NHdsv
	pbmqnTPoW5FxqHj166lvtZdYLDFtU3nVlWxa8mvrn53nbrWwbAxRtm+rixHcET3jRjdHWEqY
	bNjtGc7uNf33SmZxHTDakVwvx3VOTn7px1fN+6wuzFBUdV5tn7xXKbm3vNeK/1Ho7eXpStzi
	faw3t/TbJ71MOBcwf59MSYMSS3FGoqEWc1FxIgBRXLp6oQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, June 14, 2013 9:54 PM, Arnd Bergmann wrote:
> On Friday 14 June 2013 17:18:46 Jingoo Han wrote:
> > On Thursday, June 13, 2013 11:14 PM, Arnd Bergmann wrote:
> > > On Thursday 13 June 2013 22:22:31 Jingoo Han wrote:
> 
> > > > +struct pcie_port {
> > > > +	struct device		*dev;
> > > > +	u8			controller;
> > > > +	u8			root_bus_nr;
> > > > +	void __iomem		*dbi_base;
> > > > +	void __iomem		*elbi_base;
> > > > +	void __iomem		*phy_base;
> > > > +	void __iomem		*purple_base;
> > > > +	phys_addr_t		cfg0_base;
> > > > +	void __iomem		*va_cfg0_base;
> > > > +	phys_addr_t		cfg1_base;
> > > > +	void __iomem		*va_cfg1_base;
> > > > +	phys_addr_t		io_base;
> > > > +	phys_addr_t		mem_base;
> > > > +	spinlock_t		conf_lock;
> > > > +	struct resource		cfg;
> > > > +	struct resource		io;
> > > > +	struct resource		mem;
> > > > +	struct pcie_port_info	config;
> > > > +	struct clk		*clk;
> > > > +	struct clk		*bus_clk;
> > > > +	int			irq;
> > > > +	int			reset_gpio;
> > > > +};
> > >
> > > You mentioned that you'd use u64 for the resources here but did not.
> >
> > Do you mean the following?
> >
> > +	u64		cfg0_base;
> > +	u64		cfg1_base;
> > +	u64		io_base;
> > +	u64		mem_base;
> 
> Yes, anything you need to program into a 64 bit hardware register.

OK,

> 
> > > > +static void exynos_pcie_prog_viewport_cfg1(struct pcie_port *pp, u32 busdev)
> > > > +{
> > > > +	u32 val;
> > > > +	void __iomem *dbi_base = pp->dbi_base;
> > > > +
> > > > +	/* Program viewport 1 : OUTBOUND : CFG1 */
> > > > +	val = PCIE_ATU_REGION_OUTBOUND | PCIE_ATU_REGION_INDEX1;
> > > > +	writel_rc(pp, val, dbi_base + PCIE_ATU_VIEWPORT);
> > > > +	writel_rc(pp, PCIE_ATU_TYPE_CFG1, dbi_base + PCIE_ATU_CR1);
> > > > +	val = PCIE_ATU_ENABLE;
> > > > +	writel_rc(pp, val, dbi_base + PCIE_ATU_CR2);
> > > > +	writel_rc(pp, (u64)pp->cfg1_base, dbi_base + PCIE_ATU_LOWER_BASE);
> > > > +	writel_rc(pp, 0, dbi_base + PCIE_ATU_UPPER_BASE);
> > > > +	writel_rc(pp, (u64)pp->cfg1_base + pp->config.cfg1_size - 1,
> > > > +			dbi_base + PCIE_ATU_LIMIT);
> > > > +	writel_rc(pp, busdev, dbi_base + PCIE_ATU_LOWER_TARGET);
> > > > +	writel_rc(pp, 0, dbi_base + PCIE_ATU_UPPER_TARGET);
> > > > +}
> > >
> > > And you still don't set up the UPPER halves, which was really the point
> > > of my comment. Same thing for all the other ones.
> >
> > Do you mean the following?
> >
> > +	writel_rc(pp, pp->cfg1_base, dbi_base + PCIE_ATU_LOWER_BASE);
> > +	writel_rc(pp, (pp->cfg1_base >> 32), dbi_base + PCIE_ATU_UPPER_BASE);
> 
> Right. Note that you could achieve the same using phys_addr_t instead of
> u64, but it's more complicated to get that to work for both 32 and 64 bit
> phys_addr_t types, since you cannot shift a 32 bit value by 32 bits in C.

OK,

> 
> > > > +static void exynos_pcie_prog_viewport_mem_inbound(struct pcie_port *pp)
> > > > +{
> > > > +	u32 val;
> > > > +	void __iomem *dbi_base = pp->dbi_base;
> > > > +
> > > > +	/* Program viewport 0 : INBOUND : MEM */
> > > > +	val = PCIE_ATU_REGION_INBOUND | PCIE_ATU_REGION_INDEX0;
> > > > +	writel_rc(pp, val, dbi_base + PCIE_ATU_VIEWPORT);
> > > > +	writel_rc(pp, PCIE_ATU_TYPE_MEM, dbi_base + PCIE_ATU_CR1);
> > > > +	val = PCIE_ATU_ENABLE | PCIE_ATU_BAR_MODE_ENABLE;
> > > > +	writel_rc(pp, val, dbi_base + PCIE_ATU_CR2);
> > > > +	writel_rc(pp, (u64)pp->config.mem_bus_addr,
> > > > +			dbi_base + PCIE_ATU_LOWER_BASE);
> > > > +	writel_rc(pp, 0, dbi_base + PCIE_ATU_UPPER_BASE);
> > > > +	writel_rc(pp, (u64)pp->config.mem_bus_addr + pp->config.mem_size - 1,
> > > > +			dbi_base + PCIE_ATU_LIMIT);
> > > > +	writel_rc(pp, (u64)pp->mem_base, dbi_base + PCIE_ATU_LOWER_TARGET);
> > > > +	writel_rc(pp, 0, dbi_base + PCIE_ATU_UPPER_TARGET);
> > > > +}
> > >
> > > This makes even less sense than before, it seems like now you only
> > > allow DMA between PCI devices but not to main memory.
> >
> > Sorry, I cannot understand it.
> > Could you give me more details?
> > Also, pseudo-code will be very helpful.
> 
> Please look up the documentation about inbound viewport and describe
> in a code comment what it does. I /assume/ that this is how DMA accesses
> from the bus get translated into AXI bus transactions. If so, you have
> to let the window translate addresses from RAM. If it's something else,
> then you should document what it is and how it needs to be set up.

One of our hardware engineer confirmed it.
He said that these inbound functions are unnecessary.
Also, I checked that PCIe works properly without these functions.
So, I will remove these inbound functions.


> 
> > > > +static int exynos_pcie_setup(int nr, struct pci_sys_data *sys)
> > > > +{
> > > > +	struct pcie_port *pp;
> > > > +
> > > > +	pp = sys_to_pcie(sys);
> > > > +
> > > > +	if (!pp)
> > > > +		return 0;
> > > > +
> > > > +	pci_add_resource(&sys->resources, &pp->io);
> > > > +	pci_add_resource(&sys->resources, &pp->mem);
> > >
> > > Now you are missing the offsets. You have to at least pass an offset for one
> > > of the I/O spaces, since they are using the same bus address. The offset must
> > > match the value you pass to pci_ioremap_io.
> > >
> > > For the memory space, you should pass the difference between the physical
> > > base address and the bus address. That address happens to be zero with
> > > you DT setup, but I would advise to also try out some other values in DT,
> > > just to ensure it still works.
> >
> > Um, I cannot understand it, too.
> > Could you give me Psuedo-code?
> > Or, let me know which pcie driver can be the good reference.
> 
> I think most hardware is not as flexible as yours, so they can just hardcode
> a lot of this.
> 
> What you need here is
> 
> static unsigned long global_io_offset = 0;
> if (global_io_offset < SZ_1M && pp->config.io_size > 0) {
> 	sys->io_offset = global_io_offset - pp->config.io_bus_addr; /* normally 0 */
> 	pci_ioremap_io(sys->io_offset, pp->io.start);
> 	global_io_offset += SZ_64K;
> }
> sys->mem_offset = pp->mem.start - pp->config.mem_bus_addr; /* normally 0 */
> 
> sys->io_offset normally increases by 64K for each bus but should always
> be between 0 and 1MB, it is the index into the registers mapped at
> (void __iomem*)PCI_IO_VIRT_BASE.
> 
> It is best practice to map 64KB of I/O space at bus address 0 for each
> domain into PCI_IO_VIRT_BASE, and set up a 1:1 translation between
> memory space bus addresses and CPU physical addresses, as you do
> in your 'ranges' property.
> 
> However, you should be able to use any other bus addresses with the code
> above, except for broken device drivers.

Then, do you mean the following?


static unsigned long global_io_offset = 0;

static int exynos_pcie_setup(int nr, struct pci_sys_data *sys)
{
	struct pcie_port *pp;

	pp = sys_to_pcie(sys);

	if (!pp)
		return 0;

	if (global_io_offset < SZ_1M && pp->config.io_size > 0) {
		sys->io_offset = global_io_offset - pp->config.io_bus_addr; /* normally 0 */
		pci_ioremap_io(sys->io_offset, pp->io.start);
		global_io_offset += SZ_64K;
	}

	sys->mem_offset = pp->mem.start - pp->config.mem_bus_addr; /* normally 0 */

	pci_add_resource_offset(&sys->resources, &pp->io, sys->io_offset);
	pci_add_resource_offset(&sys->resources, &pp->mem, sys->mem_offset);

        return 1;
}

In this case, boot message is as below:

PCI host bridge to bus 0000:00
pci_bus 0000:00: root bus resource [io  0x40001000-0x40010fff]
pci_bus 0000:00: root bus resource [mem 0x40011000-0x5fffffff]
pci_bus 0000:00: No busn resource found for root bus, will use [bus 00-ff]
pci 0000:00:00.0: [144d:a549] type 01 class 0x060400
[.....]
PCI host bridge to bus 0001:00
pci_bus 0001:00: root bus resource [io  0x60001000-0x60010fff] (bus address [0x5fff1000-0x6000
0fff])
pci_bus 0001:00: root bus resource [mem 0x60011000-0x7fffffff]
pci_bus 0001:00: No busn resource found for root bus, will use [bus 00-ff]
pci 0001:00:00.0: [144d:a549] type 01 class 0x060400

> 
> > > > +static int __exit exynos_pcie_remove(struct platform_device *pdev)
> > > > +{
> > > > +	struct pcie_port *pp = platform_get_drvdata(pdev);
> > > > +
> > > > +	clk_disable_unprepare(pp->bus_clk);
> > > > +	clk_disable_unprepare(pp->clk);
> > > > +
> > > > +	return 0;
> > > > +}
> > >
> > > You also don't remove the PCI devices here, as mentioned in an earlier
> > > review.
> >
> > I reviewed Marvell PCIe driver and Tegra PCIe driver; however,
> > I cannot know what you mean.
> >
> > Could let me know which additional functions are needed?
> 
> The mvebu driver does not allow module unload. I haven't looked at the
> tegra driver. If you allow unloading the driver and provide a 'remove'
> callback, that callback needs to clean up the entire bus and remove
> all child devices that were added as well as undo everything the
> probe function did. I think it would be great if you can do that, although
> it might not be easy. The simplest solution would be to not support
> unloading though.

As the mvebu driver uses platform_driver_probe(), the Exynos driver uses
platform_driver_probe(). Thus, I will not provide a 'remove' callback.

Thank you.

Best regards,
Jingoo Han

> 
> 	Arnd

