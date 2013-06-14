Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751998Ab3FNIS7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 04:18:59 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:31858 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751442Ab3FNISy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 04:18:54 -0400
X-AuditID: cbfee68f-b7f436d000000f81-b0-51bad1e63b58
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
 <13685067.uPzcc2y1CU@wuerfel>
In-reply-to: <13685067.uPzcc2y1CU@wuerfel>
Subject: Re: [PATCH V5 1/3] pci: Add PCIe driver for Samsung Exynos
Date: Fri, 14 Jun 2013 17:18:46 +0900
Message-id: <000001ce68d7$ca762200$5f626600$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQIepNJd3UbA8CoBBJYQqRm0XD6uiAJeVbZCmIEcKLA=
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrAKsWRmVeSWpSXmKPExsVy+t8zfd1nF3cFGrSsM7Jo/r+d1eLvpGPs
	FkuaMiwOzH7IavHqzEY2i8sLL7FafL9hatG74CqbxabH11gtLu+aw2Zxdt5xNosZ5/cxWaxo
	2sposfjicmaL3SuXsFgcm7GE0eLpgyYmB0GPNfPWMHr8/jWJ0aNvylU2jyebLjJ6LNhU6nHn
	2h42j81L6j3Oz1jI6PF9Ry9QwZZVjB4/X+p4fN4kF8ATxWWTkpqTWZZapG+XwJVxqk264IN5
	RcOeDawNjKt0uhg5OSQETCR2bJnEDGGLSVy4t54NxBYSWMYosbarFKZm/4WTLF2MXEDxRYwS
	33Z/ZoVwfjFKnL97DKybTUBN4suXw+wgtoiAssTxl3fAOpgFDrBKzL8xnQVibKTEhuv3gbo5
	ODgFtCQenTUGCQsLOEtc+LYEbDOLgKrE3AP7webwClhKLJt5HsoWlPgx+R7YGGag1vU7jzNB
	2PISm9e8hfpAQWLH2deMEDdYSTxbu4MNokZEYt+Ld4wQNQ84JBbtcofYJSDxbfIhFpBzJARk
	JTYdgBojKXFwxQ2WCYwSs5BsnoVk8ywkm2ch2bCAkWUVo2hqQXJBcVJ6kbFecWJucWleul5y
	fu4mRkhq6d/BePeA9SHGZKD1E5mlRJPzgakpryTe0NjMyMLUxNTYyNzSjDRhJXFetRbrQCGB
	9MSS1OzU1ILUovii0pzU4kOMTBycUg2MHqln3G3YFu/QX9fSeX9mzOY3ShIri+553OKoCPib
	bVO3i3U377n79i77NpzoP1v+MvjB/fMdxmqNN623zZrr2T9TiOfgpbTpcTM71rIzbFHL2rx5
	mloVC0f1pL9hO8sZzYTy978veh73J/5E1rQUO/tLzA7nNf8qtkZPecfwf+HTZbt6Jdf9UWIp
	zkg01GIuKk4EAK/GwtNDAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupnk+LIzCtJLcpLzFFi42I5/e+xgO6zi7sCDX5v1bZo/r+d1eLvpGPs
	FkuaMiwOzH7IavHqzEY2i8sLL7FafL9hatG74CqbxabH11gtLu+aw2Zxdt5xNosZ5/cxWaxo
	2sposfjicmaL3SuXsFgcm7GE0eLpgyYmB0GPNfPWMHr8/jWJ0aNvylU2jyebLjJ6LNhU6nHn
	2h42j81L6j3Oz1jI6PF9Ry9QwZZVjB4/X+p4fN4kF8AT1cBok5GamJJapJCal5yfkpmXbqvk
	HRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuWmQP0l5JCWWJOKVAoILG4WEnfDtOE0BA3XQuY
	xghd35AguB4jAzSQsI4x41SbdMEH84qGPRtYGxhX6XQxcnJICJhI7L9wkgXCFpO4cG89Wxcj
	F4eQwCJGiW+7P7NCOL8YJc7fPcYMUsUmoCbx5cthdhBbREBZ4vjLOywgRcwCB1gl5t+YDjZK
	SCBSYsP1+0DdHBycAloSj84ag4SFBZwlLnxbwgZiswioSsw9sB9sDq+ApcSymeehbEGJH5Pv
	gY1hBmpdv/M4E4QtL7F5zVtmiEsVJHacfc0IcYOVxLO1O9ggakQk9r14xziBUWgWklGzkIya
	hWTULCQtCxhZVjGKphYkFxQnpeca6hUn5haX5qXrJefnbmIEJ69nUjsYVzZYHGIU4GBU4uFN
	uLAzUIg1say4MvcQowQHs5IIb/hfoBBvSmJlVWpRfnxRaU5q8SHGZKBPJzJLiSbnAxNrXkm8
	obGJmZGlkZmFkYm5OWnCSuK8B1qtA4UE0hNLUrNTUwtSi2C2MHFwSjUwdjxSk+vRcmR/lbax
	a+LHL/snn3HnvNz/SbyUo+TlfdYY4yTHhxJbTY6Uux1cn7hR5q+5XuSNx3NdStRPulYs8bki
	zLFboGLHCycDT8H9m8Ikih1CDp0yWZGaYXvxt9bGrHdcR1p397InHL/B83Sd2mOnq6WcG9nK
	anZ/cjRezVmhV+8cO+OSEktxRqKhFnNRcSIA29U3zKIDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, June 13, 2013 11:14 PM, Arnd Bergmann wrote:
> On Thursday 13 June 2013 22:22:31 Jingoo Han wrote:
> 
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
> You mentioned that you'd use u64 for the resources here but did not.

Do you mean the following?

+	u64		cfg0_base;
+	u64		cfg1_base;
+	u64		io_base;
+	u64		mem_base;


> 
> > +
> > +static void exynos_pcie_prog_viewport_cfg0(struct pcie_port *pp, u32 busdev)
> > +{
> > +	u32 val;
> > +	void __iomem *dbi_base = pp->dbi_base;
> > +
> > +	/* Program viewport 0 : OUTBOUND : CFG0 */
> > +	val = PCIE_ATU_REGION_OUTBOUND | PCIE_ATU_REGION_INDEX0;
> > +	writel_rc(pp, val, dbi_base + PCIE_ATU_VIEWPORT);
> > +	writel_rc(pp, (u64)pp->cfg0_base, dbi_base + PCIE_ATU_LOWER_BASE);
> > +	writel_rc(pp, 0, dbi_base + PCIE_ATU_UPPER_BASE);
> > +	writel_rc(pp, (u64)pp->cfg0_base + pp->config.cfg0_size - 1,
> > +			dbi_base + PCIE_ATU_LIMIT);
> > +	writel_rc(pp, busdev, dbi_base + PCIE_ATU_LOWER_TARGET);
> > +	writel_rc(pp, 0, dbi_base + PCIE_ATU_UPPER_TARGET);
> > +	writel_rc(pp, PCIE_ATU_TYPE_CFG0, dbi_base + PCIE_ATU_CR1);
> > +	val = PCIE_ATU_ENABLE;
> > +	writel_rc(pp, val, dbi_base + PCIE_ATU_CR2);
> > +}
> > +
> > +static void exynos_pcie_prog_viewport_cfg1(struct pcie_port *pp, u32 busdev)
> > +{
> > +	u32 val;
> > +	void __iomem *dbi_base = pp->dbi_base;
> > +
> > +	/* Program viewport 1 : OUTBOUND : CFG1 */
> > +	val = PCIE_ATU_REGION_OUTBOUND | PCIE_ATU_REGION_INDEX1;
> > +	writel_rc(pp, val, dbi_base + PCIE_ATU_VIEWPORT);
> > +	writel_rc(pp, PCIE_ATU_TYPE_CFG1, dbi_base + PCIE_ATU_CR1);
> > +	val = PCIE_ATU_ENABLE;
> > +	writel_rc(pp, val, dbi_base + PCIE_ATU_CR2);
> > +	writel_rc(pp, (u64)pp->cfg1_base, dbi_base + PCIE_ATU_LOWER_BASE);
> > +	writel_rc(pp, 0, dbi_base + PCIE_ATU_UPPER_BASE);
> > +	writel_rc(pp, (u64)pp->cfg1_base + pp->config.cfg1_size - 1,
> > +			dbi_base + PCIE_ATU_LIMIT);
> > +	writel_rc(pp, busdev, dbi_base + PCIE_ATU_LOWER_TARGET);
> > +	writel_rc(pp, 0, dbi_base + PCIE_ATU_UPPER_TARGET);
> > +}
> 
> And you still don't set up the UPPER halves, which was really the point
> of my comment. Same thing for all the other ones.

Do you mean the following?

+	writel_rc(pp, pp->cfg1_base, dbi_base + PCIE_ATU_LOWER_BASE);
+	writel_rc(pp, (pp->cfg1_base >> 32), dbi_base + PCIE_ATU_UPPER_BASE);


> 
> > +static void exynos_pcie_prog_viewport_mem_inbound(struct pcie_port *pp)
> > +{
> > +	u32 val;
> > +	void __iomem *dbi_base = pp->dbi_base;
> > +
> > +	/* Program viewport 0 : INBOUND : MEM */
> > +	val = PCIE_ATU_REGION_INBOUND | PCIE_ATU_REGION_INDEX0;
> > +	writel_rc(pp, val, dbi_base + PCIE_ATU_VIEWPORT);
> > +	writel_rc(pp, PCIE_ATU_TYPE_MEM, dbi_base + PCIE_ATU_CR1);
> > +	val = PCIE_ATU_ENABLE | PCIE_ATU_BAR_MODE_ENABLE;
> > +	writel_rc(pp, val, dbi_base + PCIE_ATU_CR2);
> > +	writel_rc(pp, (u64)pp->config.mem_bus_addr,
> > +			dbi_base + PCIE_ATU_LOWER_BASE);
> > +	writel_rc(pp, 0, dbi_base + PCIE_ATU_UPPER_BASE);
> > +	writel_rc(pp, (u64)pp->config.mem_bus_addr + pp->config.mem_size - 1,
> > +			dbi_base + PCIE_ATU_LIMIT);
> > +	writel_rc(pp, (u64)pp->mem_base, dbi_base + PCIE_ATU_LOWER_TARGET);
> > +	writel_rc(pp, 0, dbi_base + PCIE_ATU_UPPER_TARGET);
> > +}
> 
> This makes even less sense than before, it seems like now you only
> allow DMA between PCI devices but not to main memory.

Sorry, I cannot understand it.
Could you give me more details?
Also, pseudo-code will be very helpful.


> 
> > +static void exynos_pcie_prog_viewport_io_inbound(struct pcie_port *pp)
> > +{
> > +	u32 val;
> > +	void __iomem *dbi_base = pp->dbi_base;
> > +
> > +	/* Program viewport 1 : INBOUND : IO */
> > +	val = PCIE_ATU_REGION_INBOUND | PCIE_ATU_REGION_INDEX1;
> > +	writel_rc(pp, val, dbi_base + PCIE_ATU_VIEWPORT);
> > +	writel_rc(pp, PCIE_ATU_TYPE_IO, dbi_base + PCIE_ATU_CR1);
> > +	val = PCIE_ATU_ENABLE | PCIE_ATU_BAR_MODE_ENABLE;
> > +	writel_rc(pp, val, dbi_base + PCIE_ATU_CR2);
> > +	writel_rc(pp, (u64)pp->config.io_bus_addr,
> > +			dbi_base + PCIE_ATU_LOWER_BASE);
> > +	writel_rc(pp, 0, dbi_base + PCIE_ATU_UPPER_BASE);
> > +	writel_rc(pp, (u64)pp->config.io_bus_addr + pp->config.io_size - 1,
> > +			dbi_base + PCIE_ATU_LIMIT);
> > +	writel_rc(pp, (u64)pp->io_base, dbi_base + PCIE_ATU_LOWER_TARGET);
> > +	writel_rc(pp, 0, dbi_base + PCIE_ATU_UPPER_TARGET);
> > +}
> 
> Can you please explain what the inbound window is as I asked you?
> I still don't see why you would need to set it up like this.

Sorry, I was guided to use this inbound from hardware engineer.
without this inbound, Exynos5440 PCIe cannot work at booting.


Surendranath Gurivireddy Balla, Siva Reddy,
Would you explain what the inbound window is?


> 
> > +static int exynos_pcie_setup(int nr, struct pci_sys_data *sys)
> > +{
> > +	struct pcie_port *pp;
> > +
> > +	pp = sys_to_pcie(sys);
> > +
> > +	if (!pp)
> > +		return 0;
> > +
> > +	pci_add_resource(&sys->resources, &pp->io);
> > +	pci_add_resource(&sys->resources, &pp->mem);
> 
> Now you are missing the offsets. You have to at least pass an offset for one
> of the I/O spaces, since they are using the same bus address. The offset must
> match the value you pass to pci_ioremap_io.
> 
> For the memory space, you should pass the difference between the physical
> base address and the bus address. That address happens to be zero with
> you DT setup, but I would advise to also try out some other values in DT,
> just to ensure it still works.

Um, I cannot understand it, too.
Could you give me Psuedo-code?
Or, let me know which pcie driver can be the good reference.


> 
> > +	pp->reset_gpio = of_get_named_gpio(np, "reset-gpio", 0);
> 
> Ok.
> 
> > +
> > +static int __exit exynos_pcie_remove(struct platform_device *pdev)
> > +{
> > +	struct pcie_port *pp = platform_get_drvdata(pdev);
> > +
> > +	clk_disable_unprepare(pp->bus_clk);
> > +	clk_disable_unprepare(pp->clk);
> > +
> > +	return 0;
> > +}
> 
> You also don't remove the PCI devices here, as mentioned in an earlier
> review.

I reviewed Marvell PCIe driver and Tegra PCIe driver; however,
I cannot know what you mean.

Could let me know which additional functions are needed?



> 
> 	Arnd

