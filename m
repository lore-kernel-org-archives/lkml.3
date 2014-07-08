Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755238AbaGHNRm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 09:17:42 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:44183 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754835AbaGHNRX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 09:17:23 -0400
X-AuditID: cbfee68f-b7fef6d000003970-84-53bbef61c9f7
From: Jingoo Han <jg1.han@samsung.com>
To: "'Kishon Vijay Abraham I'" <kishon@ti.com>, mohit.kumar@st.com
Cc: devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-pci@vger.kernel.org, bhelgaas@google.com,
        linux-kernel@vger.kernel.org, grant.likely@linaro.org,
        "'Jason Gunthorpe'" <jgunthorpe@obsidianresearch.com>,
        "'Marek Vasut'" <marex@denx.de>, "'Arnd Bergmann'" <arnd@arndb.de>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <1403719007-9352-1-git-send-email-kishon@ti.com>
 <1403719007-9352-3-git-send-email-kishon@ti.com> <53BBE492.4070904@ti.com>
In-reply-to: <53BBE492.4070904@ti.com>
Subject: Re: [PATCH 2/3] PCI: designware: use untranslated address while
 programming ATU
Date: Tue, 08 Jul 2014 22:17:20 +0900
Message-id: <001201cf9aae$f2e080a0$d8a181e0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac+aqJwIT9x4iy+eRWaKawNyszLuoQABkMyw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupnleLIzCtJLcpLzFFi42I5/e+ZkW7i+93BBkses1n8nXSM3WJJU4bF
	y0OaFvOPnGO1OPBnB6PF5YWXWC2+3zC1uPC0h81iYdsSFovLu+awWZydd5zN4k1bI6PFxqm/
	GB14PX7/msToMW/WCRaPBZtKPe5c28Pm8X1HL6NH35ZVjB5Pf+xl9jh+YzuTx+dNcgGcUVw2
	Kak5mWWpRfp2CVwZXT9PsRT0eVQ0nldqYLxn2cXIySEhYCIxcfViRghbTOLCvfVsILaQwDJG
	iemdZjA1Ex52AtVwAcUXMUo0zDrEAuH8ZpRY1POSCaSKTUBN4suXw+wgtoiAg8TjfUuZQYqY
	BQ4ySfxsv8IG0dEJNPbrD7AdnEAdyw9PB9stLBAlcWrCJWYQm0VAVWLmjmmsIDavgK3EsrO3
	WSBsQYkfk++B2cwCWhLrdx5ngrDlJTaveQvUywF0q7rEo7+6IKaIgJFEx80EiAoRiX0v3oF9
	ICGwlkNi2+uprBCrBCS+TQb5BqRVVmLTAWaIjyUlDq64wTKBUWIWksWzkCyehWTxLCQrFjCy
	rGIUTS1ILihOSi8y1itOzC0uzUvXS87P3cQISQz9OxjvHrA+xJgMtH4is5Rocj4wseSVxBsa
	mxlZmJqYGhuZW5qRJqwkznv/YVKQkEB6YklqdmpqQWpRfFFpTmrxIUYmDk6pBsbc6ufzSuQu
	hbbVLf32wPvYN6Zbn1evzSlJY/uhoaGs9I1dSuvSY8UX7w+nLmOtYY8/rp2XV6r90GYfo+TJ
	/VdmxHA4iCYqdx2zE1ctfaip3bDvS95zxdwG1cX3Ju3vjcr6rt7qr8v3L7FOh6Vu/iaFjjdr
	6yZvZ+EOnX7zcWZVDbua57nYdUosxRmJhlrMRcWJALUFdxEiAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrHKsWRmVeSWpSXmKPExsVy+t9jAd3E97uDDbbnWPyddIzdYklThsXL
	Q5oW84+cY7U48GcHo8XlhZdYLb7fMLW48LSHzWJh2xIWi8u75rBZnJ13nM3iTVsjo8XGqb8Y
	HXg9fv+axOgxb9YJFo8Fm0o97lzbw+bxfUcvo0ffllWMHk9/7GX2OH5jO5PH501yAZxRDYw2
	GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUBHKymUJeaU
	AoUCEouLlfTtME0IDXHTtYBpjND1DQmC6zEyQAMJ6xgzun6eYino86hoPK/UwHjPsouRk0NC
	wERiwsNORghbTOLCvfVsXYxcHEICixglGmYdYoFwfjNKLOp5yQRSxSagJvHly2F2EFtEwEHi
	8b6lzCBFzAIHmSR+tl+Bau9klJj+9QcbSBUnUMfyw9PBdggLREmcmnCJGcRmEVCVmLljGiuI
	zStgK7Hs7G0WCFtQ4sfke2A2s4CWxPqdx5kgbHmJzWveAvVyAN2qLvHory6IKSJgJNFxMwGi
	QkRi34t3jBMYhWYhGTQLyaBZSAbNQtKygJFlFaNoakFyQXFSeq6hXnFibnFpXrpecn7uJkZw
	2nkmtYNxZYPFIUYBDkYlHt4VB3cFC7EmlhVX5h5ilOBgVhLh/XJqd7AQb0piZVVqUX58UWlO
	avEhRlOgPycyS4km5wNTYl5JvKGxiZmRpZGZhZGJubmSOO+BVutAIYH0xJLU7NTUgtQimD4m
	Dk6pBsaSb+sP+m00sI3O1OXavL3tt/Pmdbcnhm55q8PxJbXJ6s2zHQyPdr459EO5KUpcbs7y
	y75sVkp++kWbZY+qN/2tP9937nLNgcVRsaxtE3/8m/erbUvi9ZPrfW6UOE73EZbmLFqpWPpX
	XCiR73bd1yILbbbuVwdZxBX/Nx1dsqs/6OzDZa2dm1mUWIozEg21mIuKEwFSAJm0UQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, July 08, 2014 9:31 PM, Kishon Vijay Abraham I wrote:
> 
> Hi Mohit, Jingoo,
> 
> On Wednesday 25 June 2014 11:26 PM, Kishon Vijay Abraham I wrote:
> > In DRA7, the cpu sees 32bit address, but the pcie controller can see only 28bit
> > address. So whenever the cpu issues a read/write request, the 4 most
> > significant bits are used by L3 to determine the target controller.
> > For example, the cpu reserves 0x2000_0000 - 0x2FFF_FFFF for PCIe controller but
> > the PCIe controller will see only (0x000_0000 - 0xFFF_FFF). So for programming
> > the outbound translation window the *base* should be programmed as 0x000_0000.
> > Whenever we try to write to say 0x2000_0000, it will be translated to whatever
> > we have programmed in the translation window with base as 0x000_0000.
> >
> > This is needed when the dt node is modelled something like below
> > axi {
> > 	compatible = "simple-bus";
> > 	#size-cells = <1>;
> > 	#address-cells = <1>;
> > 	ranges = <0x0        0x20000000 0x10000000 // 28-bit bus
> > 		  0x51000000 0x51000000 0x3000>;
> > 	pcie@51000000 {
> > 		reg = <0x1000 0x2000>, <0x51002000 0x14c>, <0x51000000 0x2000>;
> > 		reg-names = "config", "ti_conf", "rc_dbics";
> > 		#address-cells = <3>;
> > 		#size-cells = <2>;
> > 		ranges = <0x81000000 0 0          0x03000 0 0x00010000
> > 			  0x82000000 0 0x20013000 0x13000 0 0xffed000>;
> > 	};
> > };
> >
> > Here the CPU address for configuration space is 0x20013000 and the controller
> > address for configuration space is 0x13000. The controller address should be
> > used while programming the ATU (in order for translation to happen properly in
> > DRA7xx).
> 
> Are you okay with this patch? Can you give your Reviewed-by/Acked-by?

Sorry, I cannot understand fully what this patch does. :-(
However, I have some questions as below.

1. io_mod_addr
The 'io_mod_addr' variable is not used. Then, how about removing
'io_mod_addr' from this patch?

2. ranges
In the case of Exynos PCIe, there is no limitation such as 28bit for
access. Then, when there is no 'ranges' property in DT file, is there
no side effect? I mean the compatibility with other SoC's PCIe drivers.

3. _addr post fix

How about renaming 'cfg0_mod_addr', 'mem_mod_addr' as below?

 	u64			cfg0_base;
+	u64			cfg0_mod_base;
 	void __iomem		*va_cfg0_base;
 	u64			cfg1_base;
+	u64			cfg1_mod_base;
 	void __iomem		*va_cfg1_base;
 	u64			io_base;
+	u64			io_mod_base;
 	u64			mem_base;
+	u64			mem_mod_base;


Best regards,
Jingoo Han

> 
> Cheers
> Kishon
> >
> > Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
> > Cc: Bjorn Helgaas <bhelgaas@google.com>
> > Cc: Mohit Kumar <mohit.kumar@st.com>
> > Cc: Jingoo Han <jg1.han@samsung.com>
> > Cc: Marek Vasut <marex@denx.de>
> > Cc: Arnd Bergmann <arnd@arndb.de>
> > Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
> > ---
> >  drivers/pci/host/pcie-designware.c |   49 ++++++++++++++++++++++++++++--------
> >  drivers/pci/host/pcie-designware.h |    4 +++
> >  2 files changed, 42 insertions(+), 11 deletions(-)
> >
> > diff --git a/drivers/pci/host/pcie-designware.c b/drivers/pci/host/pcie-designware.c
> > index 0b7b455..11aba6d 100644
> > --- a/drivers/pci/host/pcie-designware.c
> > +++ b/drivers/pci/host/pcie-designware.c
> > @@ -401,8 +401,15 @@ int __init dw_pcie_host_init(struct pcie_port *pp)
> >  	struct of_pci_range range;
> >  	struct of_pci_range_parser parser;
> >  	struct resource *cfg_res;
> > -	u32 val;
> > -	int i;
> > +	u32 val, na, ns;
> > +	const __be32 *addrp;
> > +	int i, index;
> > +
> > +	/* Find the address cell size and the number of cells in order to get
> > +	 * the untranslated address.
> > +	 */
> > +	of_property_read_u32(np, "#address-cells", &na);
> > +	ns = of_n_size_cells(np);
> >
> >  	cfg_res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "config");
> >  	if (cfg_res) {
> > @@ -410,6 +417,12 @@ int __init dw_pcie_host_init(struct pcie_port *pp)
> >  		pp->config.cfg1_size = resource_size(cfg_res)/2;
> >  		pp->cfg0_base = cfg_res->start;
> >  		pp->cfg1_base = cfg_res->start + pp->config.cfg0_size;
> > +
> > +		/* Find the untranslated configuration space address */
> > +		index = of_property_match_string(np, "reg-names", "config");
> > +		addrp = of_get_address(np, index, false, false);
> > +		pp->cfg0_mod_addr = of_read_number(addrp, ns);
> > +		pp->cfg1_mod_addr = pp->cfg0_mod_addr + pp->config.cfg0_size;
> >  	} else {
> >  		dev_err(pp->dev, "missing *config* reg space\n");
> >  	}
> > @@ -435,12 +448,20 @@ int __init dw_pcie_host_init(struct pcie_port *pp)
> >  			pp->config.io_size = resource_size(&pp->io);
> >  			pp->config.io_bus_addr = range.pci_addr;
> >  			pp->io_base = range.cpu_addr;
> > +
> > +			/* Find the untranslated IO space address */
> > +			pp->io_mod_addr = of_read_number(parser.range -
> > +							 parser.np + na, ns);
> >  		}
> >  		if (restype == IORESOURCE_MEM) {
> >  			of_pci_range_to_resource(&range, np, &pp->mem);
> >  			pp->mem.name = "MEM";
> >  			pp->config.mem_size = resource_size(&pp->mem);
> >  			pp->config.mem_bus_addr = range.pci_addr;
> > +
> > +			/* Find the untranslated MEM space address */
> > +			pp->mem_mod_addr = of_read_number(parser.range -
> > +							  parser.np + na, ns);
> >  		}
> >  		if (restype == 0) {
> >  			of_pci_range_to_resource(&range, np, &pp->cfg);
> > @@ -448,6 +469,12 @@ int __init dw_pcie_host_init(struct pcie_port *pp)
> >  			pp->config.cfg1_size = resource_size(&pp->cfg)/2;
> >  			pp->cfg0_base = pp->cfg.start;
> >  			pp->cfg1_base = pp->cfg.start + pp->config.cfg0_size;
> > +
> > +			/* Find the untranslated configuration space address */
> > +			pp->cfg0_mod_addr = of_read_number(parser.range -
> > +							   parser.np + na, ns);
> > +			pp->cfg1_mod_addr = pp->cfg0_mod_addr +
> > +					    pp->config.cfg0_size;
> >  		}
> >  	}
> >
> > @@ -522,9 +549,9 @@ static void dw_pcie_prog_viewport_cfg0(struct pcie_port *pp, u32 busdev)
> >  	/* Program viewport 0 : OUTBOUND : CFG0 */
> >  	dw_pcie_writel_rc(pp, PCIE_ATU_REGION_OUTBOUND | PCIE_ATU_REGION_INDEX0,
> >  			  PCIE_ATU_VIEWPORT);
> > -	dw_pcie_writel_rc(pp, pp->cfg0_base, PCIE_ATU_LOWER_BASE);
> > -	dw_pcie_writel_rc(pp, (pp->cfg0_base >> 32), PCIE_ATU_UPPER_BASE);
> > -	dw_pcie_writel_rc(pp, pp->cfg0_base + pp->config.cfg0_size - 1,
> > +	dw_pcie_writel_rc(pp, pp->cfg0_mod_addr, PCIE_ATU_LOWER_BASE);
> > +	dw_pcie_writel_rc(pp, (pp->cfg0_mod_addr >> 32), PCIE_ATU_UPPER_BASE);
> > +	dw_pcie_writel_rc(pp, pp->cfg0_mod_addr + pp->config.cfg0_size - 1,
> >  			  PCIE_ATU_LIMIT);
> >  	dw_pcie_writel_rc(pp, busdev, PCIE_ATU_LOWER_TARGET);
> >  	dw_pcie_writel_rc(pp, 0, PCIE_ATU_UPPER_TARGET);
> > @@ -538,9 +565,9 @@ static void dw_pcie_prog_viewport_cfg1(struct pcie_port *pp, u32 busdev)
> >  	dw_pcie_writel_rc(pp, PCIE_ATU_REGION_OUTBOUND | PCIE_ATU_REGION_INDEX1,
> >  			  PCIE_ATU_VIEWPORT);
> >  	dw_pcie_writel_rc(pp, PCIE_ATU_TYPE_CFG1, PCIE_ATU_CR1);
> > -	dw_pcie_writel_rc(pp, pp->cfg1_base, PCIE_ATU_LOWER_BASE);
> > -	dw_pcie_writel_rc(pp, (pp->cfg1_base >> 32), PCIE_ATU_UPPER_BASE);
> > -	dw_pcie_writel_rc(pp, pp->cfg1_base + pp->config.cfg1_size - 1,
> > +	dw_pcie_writel_rc(pp, pp->cfg1_mod_addr, PCIE_ATU_LOWER_BASE);
> > +	dw_pcie_writel_rc(pp, (pp->cfg1_mod_addr >> 32), PCIE_ATU_UPPER_BASE);
> > +	dw_pcie_writel_rc(pp, pp->cfg1_mod_addr + pp->config.cfg1_size - 1,
> >  			  PCIE_ATU_LIMIT);
> >  	dw_pcie_writel_rc(pp, busdev, PCIE_ATU_LOWER_TARGET);
> >  	dw_pcie_writel_rc(pp, 0, PCIE_ATU_UPPER_TARGET);
> > @@ -553,9 +580,9 @@ static void dw_pcie_prog_viewport_mem_outbound(struct pcie_port *pp)
> >  	dw_pcie_writel_rc(pp, PCIE_ATU_REGION_OUTBOUND | PCIE_ATU_REGION_INDEX0,
> >  			  PCIE_ATU_VIEWPORT);
> >  	dw_pcie_writel_rc(pp, PCIE_ATU_TYPE_MEM, PCIE_ATU_CR1);
> > -	dw_pcie_writel_rc(pp, pp->mem_base, PCIE_ATU_LOWER_BASE);
> > -	dw_pcie_writel_rc(pp, (pp->mem_base >> 32), PCIE_ATU_UPPER_BASE);
> > -	dw_pcie_writel_rc(pp, pp->mem_base + pp->config.mem_size - 1,
> > +	dw_pcie_writel_rc(pp, pp->mem_mod_addr, PCIE_ATU_LOWER_BASE);
> > +	dw_pcie_writel_rc(pp, (pp->mem_mod_addr >> 32), PCIE_ATU_UPPER_BASE);
> > +	dw_pcie_writel_rc(pp, pp->mem_mod_addr + pp->config.mem_size - 1,
> >  			  PCIE_ATU_LIMIT);
> >  	dw_pcie_writel_rc(pp, pp->config.mem_bus_addr, PCIE_ATU_LOWER_TARGET);
> >  	dw_pcie_writel_rc(pp, upper_32_bits(pp->config.mem_bus_addr),
> > diff --git a/drivers/pci/host/pcie-designware.h b/drivers/pci/host/pcie-designware.h
> > index 77f592f..13828f8 100644
> > --- a/drivers/pci/host/pcie-designware.h
> > +++ b/drivers/pci/host/pcie-designware.h
> > @@ -36,11 +36,15 @@ struct pcie_port {
> >  	u8			root_bus_nr;
> >  	void __iomem		*dbi_base;
> >  	u64			cfg0_base;
> > +	u64			cfg0_mod_addr;
> >  	void __iomem		*va_cfg0_base;
> >  	u64			cfg1_base;
> > +	u64			cfg1_mod_addr;
> >  	void __iomem		*va_cfg1_base;
> >  	u64			io_base;
> > +	u64			io_mod_addr;
> >  	u64			mem_base;
> > +	u64			mem_mod_addr;
> >  	struct resource		cfg;
> >  	struct resource		io;
> >  	struct resource		mem;
> >

