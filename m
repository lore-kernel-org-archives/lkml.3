Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751982Ab3GIBOK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 21:14:10 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:64150 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751245Ab3GIBOG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 21:14:06 -0400
X-AuditID: cbfee68f-b7f436d000000f81-51-51db63d55de2
From: Jingoo Han <jg1.han@samsung.com>
To: "'Arnd Bergmann'" <arnd@arndb.de>
Cc: "'Bjorn Helgaas'" <bhelgaas@google.com>, linux-pci@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Pratyush Anand'" <pratyush.anand@st.com>,
        "'Mohit KUMAR'" <Mohit.KUMAR@st.com>, "'Sean Cross'" <xobs@kosagi.com>,
        "'SRIKANTH TUMKUR SHIVANAND'" <ts.srikanth@samsung.com>,
        linux-kernel@vger.kernel.org, Jingoo Han <jg1.han@samsung.com>
References: <000201ce7959$bf0fb150$3d2f13f0$@samsung.com>
 <201307051245.52149.arnd@arndb.de>
In-reply-to: <201307051245.52149.arnd@arndb.de>
Subject: Re: [PATCH] pci: exynos: split into two parts such as Synopsys part
 and Exynos part
Date: Tue, 09 Jul 2013 10:13:56 +0900
Message-id: <000e01ce7c41$95fa2440$c1ee6cc0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQII16kcxw44AVHNORO1PoktmeAs2wIyBqr0mNVBOfA=
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrFIsWRmVeSWpSXmKPExsVy+t8zI92rybcDDaZtkbT4O+kYu8WSpgyL
	l4c0LS4vvMRq0bvgKpvF5V1z2CzOzjvOZjHj/D4mi41TfzFatF9Stmg8+oDVovXJA0YHHo/f
	vyYxeizYVOrxfeF8do++LasYPZ7+2Mvs8XmTXABbFJdNSmpOZllqkb5dAlfGqd7F7AWfnSuu
	vgxqYHxr0sXIySEhYCJx5+U0RghbTOLCvfVsXYxcHEICyxglprybwgZTtKNzI5gtJLCIUeLx
	j0CIol+MEksbrrGCJNgE1CS+fDnMDmKLCChLHH95hwWkiFngD5PE2ikTgBIcQB1xEqf6SkBq
	OAX0JX6dPckCYgsDhSe8eg7WyyKgKrFhwj4wm1fAUmLPj34WCFtQ4sfke2A2s4CWxPqdx5kg
	bHmJzWveMkMcqiCx4+xrRpBVIgJWElP3MkOUiEjse/GOEeQcCYGJHBJN858xQ+wSkPg2+RAL
	SL2EgKzEpgNQYyQlDq64wTKBUWIWks2zkGyehWTzLCQrFjCyrGIUTS1ILihOSi8y1itOzC0u
	zUvXS87P3cQIiff+HYx3D1gfYkwGWj+RWUo0OR+YLvJK4g2NzYwsTE1MjY3MLc1IE1YS51Vr
	sQ4UEkhPLEnNTk0tSC2KLyrNSS0+xMjEwSnVwNi772T44/PKpzu2JF6b8T+mimn9pxdSVtfe
	PGrVLNLV+ynxqFA+8tzNt8+Zt37IsatnF77XwHUgzSWqfcbJosYHdey9sxU+Pdl6eq3Ahm/B
	f7cIOckyT1/8nzVG6GGQ+VzlgoDMLTNvnZRZu+TYTNsdnU92vbh8rGnuocQEFa3EKyZLK/7k
	s0QosRRnJBpqMRcVJwIAodp5aQ0DAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOKsWRmVeSWpSXmKPExsVy+t9jAd2rybcDDba1Clv8nXSM3WJJU4bF
	y0OaFpcXXmK16F1wlc3i8q45bBZn5x1ns5hxfh+Txcapvxgt2i8pWzQefcBq0frkAaMDj8fv
	X5MYPRZsKvX4vnA+u0ffllWMHk9/7GX2+LxJLoAtqoHRJiM1MSW1SCE1Lzk/JTMv3VbJOzje
	Od7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwfoQiWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6
	viFBcD1GBmggYR1jxqnexewFn50rrr4MamB8a9LFyMkhIWAisaNzIxuELSZx4d56MFtIYBGj
	xOMfgV2MXED2L0aJpQ3XWEESbAJqEl++HGYHsUUElCWOv7zDAlLELPCHSWLtlAlACQ6gjjiJ
	U30lIDWcAvoSv86eZAGxhYHCE149B+tlEVCV2DBhH5jNK2ApsedHPwuELSjxY/I9MJtZQEti
	/c7jTBC2vMTmNW+ZIQ5VkNhx9jUjyCoRASuJqXuZIUpEJPa9eMc4gVFoFpJJs5BMmoVk0iwk
	LQsYWVYxiqYWJBcUJ6XnGukVJ+YWl+al6yXn525iBCeTZ9I7GFc1WBxiFOBgVOLh/XD5VqAQ
	a2JZcWXuIUYJDmYlEd4XqrcDhXhTEiurUovy44tKc1KLDzEmAz06kVlKNDkfmOjySuINjU3M
	jCyNzCyMTMzNSRNWEuc92GodKCSQnliSmp2aWpBaBLOFiYNTqoHR7MIKlQ0/1k286+NwwO3K
	bff60KmFKzMWBmu6/tGRnDfpVo6Ga8dLxqb/US6vJzT+W9r2IjvtnFLzvvnbI+wfP1yt8fSG
	0gUrpbA5X9PyDL5f7jLcWDLR4Yj3ucNa73tEH/BPd3A8eHX6pYzfllaNPgGHl18wYuB/wuXy
	8Nrqz0/K2UuXnM7kUWIpzkg01GIuKk4EAF2xYilqAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, July 05, 2013 7:46 PM, Arnd Bergmann wrote:
> On Friday 05 July 2013, Jingoo Han wrote:
> 
> > --- /dev/null
> > +++ b/drivers/pci/host/pcie-exynos.c
> 
> > +
> > +/* PCIe ELBI registers */
> > +#define PCIE_IRQ_PULSE			0x000
> > +#define IRQ_INTA_ASSERT			(0x1 << 0)
> > +#define IRQ_INTB_ASSERT			(0x1 << 2)
> > +#define IRQ_INTC_ASSERT			(0x1 << 4)
> > +#define IRQ_INTD_ASSERT			(0x1 << 6)
> > +#define PCIE_IRQ_LEVEL			0x004
> > +#define PCIE_IRQ_SPECIAL		0x008
> > +#define PCIE_IRQ_EN_PULSE		0x00c
> > +#define PCIE_IRQ_EN_LEVEL		0x010
> > +#define PCIE_IRQ_EN_SPECIAL		0x014
> > +#define PCIE_PWR_RESET			0x018
> > +#define PCIE_CORE_RESET			0x01c
> > +#define PCIE_CORE_RESET_ENABLE		(0x1 << 0)
> > +#define PCIE_STICKY_RESET		0x020
> > +#define PCIE_NONSTICKY_RESET		0x024
> > +#define PCIE_APP_INIT_RESET		0x028
> > +#define PCIE_APP_LTSSM_ENABLE		0x02c
> > +#define PCIE_ELBI_RDLH_LINKUP		0x064
> > +#define PCIE_ELBI_LTSSM_ENABLE		0x1
> > +#define PCIE_ELBI_SLV_AWMISC		0x11c
> > +#define PCIE_ELBI_SLV_ARMISC		0x120
> > +#define PCIE_ELBI_SLV_DBI_ENABLE	(0x1 << 21)
> > +
> > +/* PCIe Purple registers */
> > +#define PCIE_PHY_GLOBAL_RESET		0x000
> > +#define PCIE_PHY_COMMON_RESET		0x004
> > +#define PCIE_PHY_CMN_REG		0x008
> > +#define PCIE_PHY_MAC_RESET		0x00c
> > +#define PCIE_PHY_PLL_LOCKED		0x010
> > +#define PCIE_PHY_TRSVREG_RESET		0x020
> > +#define PCIE_PHY_TRSV_RESET		0x024
> > +
> > +/* PCIe PHY registers */
> > +#define PCIE_PHY_IMPEDANCE		0x004
> > +#define PCIE_PHY_PLL_DIV_0		0x008
> > +#define PCIE_PHY_PLL_BIAS		0x00c
> > +#define PCIE_PHY_DCC_FEEDBACK		0x014
> > +#define PCIE_PHY_PLL_DIV_1		0x05c
> > +#define PCIE_PHY_TRSV0_EMP_LVL		0x084
> > +#define PCIE_PHY_TRSV0_DRV_LVL		0x088
> > +#define PCIE_PHY_TRSV0_RXCDR		0x0ac
> > +#define PCIE_PHY_TRSV0_LVCC		0x0dc
> > +#define PCIE_PHY_TRSV1_EMP_LVL		0x144
> > +#define PCIE_PHY_TRSV1_RXCDR		0x16c
> > +#define PCIE_PHY_TRSV1_LVCC		0x19c
> > +#define PCIE_PHY_TRSV2_EMP_LVL		0x204
> > +#define PCIE_PHY_TRSV2_RXCDR		0x22c
> > +#define PCIE_PHY_TRSV2_LVCC		0x25c
> > +#define PCIE_PHY_TRSV3_EMP_LVL		0x2c4
> > +#define PCIE_PHY_TRSV3_RXCDR		0x2ec
> > +#define PCIE_PHY_TRSV3_LVCC		0x31c
> 
> Are you sure these are all exynos specific? Maybe they are licensed
> from someone else?

Samsung specific.

I asked our hardware engineer, and he confirmed it.


> 
> > +
> > +	pp->dbi_base = devm_ioremap(&pdev->dev, pp->cfg.start,
> > +				resource_size(&pp->cfg));
> > +	if (!pp->dbi_base) {
> > +		dev_err(&pdev->dev, "error with ioremap\n");
> > +		return -ENOMEM;
> > +	}
> > +
> > +	pp->root_bus_nr = -1;
> > +	pp->ops = &exynos_pcie_host_ops;
> > +
> > +	spin_lock_init(&pp->conf_lock);
> > +	dw_pcie_host_init(pp);
> > +	pp->va_cfg0_base = devm_ioremap(&pdev->dev, pp->cfg0_base,
> > +					pp->config.cfg0_size);
> > +	if (!pp->va_cfg0_base) {
> > +		dev_err(pp->dev, "error with ioremap in function\n");
> > +		return -ENOMEM;
> > +	}
> > +	pp->va_cfg1_base = devm_ioremap(&pdev->dev, pp->cfg1_base,
> > +					pp->config.cfg1_size);
> > +	if (!pp->va_cfg1_base) {
> > +		dev_err(pp->dev, "error with ioremap\n");
> > +		return -ENOMEM;
> > +	}
> 
> I think the configuration space handling should go into the
> dw_pcie_host_init function, as that part would be needed by all drivers.

OK.
I will move it to dw_pcie_host_init().


> 
> > +static int __init exynos_pcie_probe(struct platform_device *pdev)
> > +{
> > +	struct pcie_port *pp;
> > +	struct device_node *np = pdev->dev.of_node;
> > +	struct of_pci_range range;
> > +	struct of_pci_range_parser parser;
> > +	int ret;
> > +
> > +	pp = devm_kzalloc(&pdev->dev, sizeof(*pp), GFP_KERNEL);
> > +	if (!pp) {
> > +		dev_err(&pdev->dev, "no memory for pcie port\n");
> > +		return -ENOMEM;
> > +	}
> > +
> > +	pp->dev = &pdev->dev;
> > +
> > +	if (of_pci_range_parser_init(&parser, np)) {
> > +		dev_err(&pdev->dev, "missing ranges property\n");
> > +		return -EINVAL;
> > +	}
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
> 
> Same for these: it would be better to split up the probe function here
> and move all of the above into the common code.

OK.
I will move it to dw_pcie_host_init().

> 
> > +	pp->reset_gpio = of_get_named_gpio(np, "reset-gpio", 0);
> 
> I assume the reset logic would need to remain exynos specific
> 
> > +	pp->clk = devm_clk_get(&pdev->dev, "pcie");
> > +	if (IS_ERR(pp->clk)) {
> > +		dev_err(&pdev->dev, "Failed to get pcie rc clock\n");
> > +		return PTR_ERR(pp->clk);
> > +	}
> > +	ret = clk_prepare_enable(pp->clk);
> > +	if (ret)
> > +		return ret;
> > +
> > +	pp->bus_clk = devm_clk_get(&pdev->dev, "pcie_bus");
> > +	if (IS_ERR(pp->bus_clk)) {
> > +		dev_err(&pdev->dev, "Failed to get pcie bus clock\n");
> > +		ret = PTR_ERR(pp->bus_clk);
> > +		goto fail_clk;
> > +	}
> > +	ret = clk_prepare_enable(pp->bus_clk);
> > +	if (ret)
> > +		goto fail_clk;
> 
> For the clocks, I think we can keep them in the common code, but
> make them optional, i.e. do not fail the probe function if the clocks
> don't exist, i.e. you get -ENOENT from devm_clk_get. We should however
> still fail here if devm_clk_get returns a different error.
> 
> I also noticed an existing bug in your code here: if the clock controller
> is not yet initialized, devm_clk_get() will return -EPROBE_DEFER,
> which is broken in combination with platform_driver_probe. In order
> to fix that, just change the code to use platform_driver_register
> so it has the option to retry the probe after the clock controller
> is initialized.
> That should be a separate patch.

If I should do it, I will send a separate patch.

> 
> > +static int exynos_pcie_abort(unsigned long addr, unsigned int fsr,
> > +			struct pt_regs *regs)
> > +{
> > +	unsigned long pc = instruction_pointer(regs);
> > +	unsigned long instr = *(unsigned long *)pc;
> > +
> > +	WARN_ONCE(1, "pcie abort\n");
> > +
> > +	/*
> > +	 * If the instruction being executed was a read,
> > +	 * make it look like it read all-ones.
> > +	 */
> > +	if ((instr & 0x0c100000) == 0x04100000) {
> > +		int reg = (instr >> 12) & 15;
> > +		unsigned long val;
> > +
> > +		if (instr & 0x00400000)
> > +			val = 255;
> > +		else
> > +			val = -1;
> > +
> > +		regs->uregs[reg] = val;
> > +		regs->ARM_pc += 4;
> > +		return 0;
> > +	}
> > +
> > +	if ((instr & 0x0e100090) == 0x00100090) {
> > +		int reg = (instr >> 12) & 15;
> > +
> > +		regs->uregs[reg] = -1;
> > +		regs->ARM_pc += 4;
> > +		return 0;
> > +	}
> > +
> > +	return 1;
> > +}
> 
> Another observation that is only partially related: the abort handler logic
> is not specific to either exynos nor synopsys. However it is specific
> to ARM and should not be part of a driver that is potentially architecture
> independent. I would recommend moving this to a separate file
> "arm-pci-abort.c" or something like that. I notice that a lot of the other
> ARM PCI implementations have the exact same code but also need to reset
> the abort in the bridge. Can you confirm that a) you don't need to tell
> the root port about the abort and b) the abort handler is actually required
> for exynos? How often do you run into this?

There is no special reason to add it.
I just referenced other ARM PCI drivers.
Also, I have never seen calling this abort function.

Then, I will remove it.

Thank you for your opinion. :)
Your comment is very helpful.

Best regards,
Jingoo Han


