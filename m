Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751463AbaDUByj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2014 21:54:39 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:11090 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751415AbaDUByS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2014 21:54:18 -0400
X-AuditID: cbfee68f-b7eff6d000002b70-47-53547a450d7b
From: Jingoo Han <jg1.han@samsung.com>
To: "'Arnd Bergmann'" <arnd@arndb.de>, "'Liviu Dudau'" <Liviu.Dudau@arm.com>
Cc: "'linux-pci'" <linux-pci@vger.kernel.org>,
        "'Bjorn Helgaas'" <bhelgaas@google.com>,
        linux-arm-kernel@lists.infradead.org, linaro-kernel@lists.linaro.org,
        linux-kernel@vger.kernel.org, "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Jason Gunthorpe'" <jgunthorpe@obsidianresearch.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Mohit KUMAR DCG'" <Mohit.KUMAR@st.com>,
        "'Pratyush Anand'" <pratyush.anand@st.com>,
        "'Marek Vasut'" <marex@denx.de>,
        "'Richard Zhu'" <r65037@freescale.com>,
        "'Kishon Vijay Abraham I'" <kishon@ti.com>,
        "'Byungho An'" <bh74.an@samsung.com>
References: <000801cf592e$30b7bff0$92273fd0$%han@samsung.com>
 <000901cf592e$563bc8c0$02b35a40$%han@samsung.com>
 <20140416165724.GG7802@e106497-lin.cambridge.arm.com>
 <16730530.rJ9T0MsYmt@wuerfel>
In-reply-to: <16730530.rJ9T0MsYmt@wuerfel>
Subject: Re: [RFC PATCH 1/2] PCI: designware: Add ARM64 PCI support
Date: Mon, 21 Apr 2014 10:54:12 +0900
Message-id: <000001cf5d04$982a6000$c87f2000$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac9ZoV9F7nOBrq3kQta8LMyyVpoKWwDYDJxg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrEKsWRmVeSWpSXmKPExsVy+t8zQ13XqpBgg+9XNCz+TjrGbnH13DFG
	iyVNGRYvD2laXF54idXi+w1Ti94FV9ksLjztYbN4f+gZs8Wmx9dYLS7vmsNmcXbecTaLA0vb
	WSzetDUyWmyc+ovRov2SssXjWcIOgh5r5q1h9Pj9axKjx7xZJ1g8/h3uZ/JYsKnUY/OSeo/b
	/x4ze3zf0cvo0bdlFaPH0x97mT2O39jO5PF5k1wATxSXTUpqTmZZapG+XQJXRufaz0wFl40r
	VqztZmlgnKzRxcjJISFgItFxZA0jhC0mceHeerYuRi4OIYFljBJXdnSxwhV9nsMIkZjOKDF7
	zRtmCOc3o8S+S0/AqtgE1CS+fDnMDmKLCHhI/HiwnB2kiFlgFYvElA3T2CE6TjJKdPQvZgOp
	4hTQkthxYB0LiC0s4Cxx4nkrE4jNIqAqMfvBObCpvAK2Es/aNjNB2IISPybfA6tnBupdv/M4
	E4QtL7F5zVugkziAblWXePRXF+III4mZS0+zQ5SISOx78Q7sBQmBJxwSy4+cZYbYJSDxbfIh
	FoheWYlNB5ghXpaUOLjiBssERolZSDbPQrJ5FpLNs5CsWMDIsopRNLUguaA4Kb3IWK84Mbe4
	NC9dLzk/dxMjJL3072C8e8D6EGMy0PqJzFKiyfnA9JRXEm9obGZkYWpiamxkbmlGmrCSOO/9
	h0lBQgLpiSWp2ampBalF8UWlOanFhxiZODilGhj3pyyv7KvY1bQ/zG6zcFL1r4PqLtsqJvZl
	LuFPSoqck+LWdTLt66IA829Gzx7O6PFp+L801dmksa4jfd768tsv3pvoPv7Ats3PaO0p1ep3
	dlea7X9IzmXe/32CqXPKxnfb3X2MLwWqbfPTjX2/efehN85Xuwuj3TzfcP6tdmcTSZVhy271
	D1ZiKc5INNRiLipOBACUQ47XRQMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupnk+LIzCtJLcpLzFFi42I5/e+xoK5rVUiwwYIWJYu/k46xW1w9d4zR
	YklThsXLQ5oWlxdeYrX4fsPUonfBVTaLC0972CzeH3rGbLHp8TVWi8u75rBZnJ13nM3iwNJ2
	Fos3bY2MFhun/mK0aL+kbPF4lrCDoMeaeWsYPX7/msToMW/WCRaPf4f7mTwWbCr12Lyk3uP2
	v8fMHt939DJ69G1Zxejx9MdeZo/jN7YzeXzeJBfAE9XAaJORmpiSWqSQmpecn5KZl26r5B0c
	7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkD9JWSQlliTilQKCCxuFhJ3w7ThNAQN10LmMYI
	Xd+QILgeIwM0kLCOMaNz7WemgsvGFSvWdrM0ME7W6GLk5JAQMJHo+DyHEcIWk7hwbz1bFyMX
	h5DAdEaJ2WveMEM4vxkl9l16wgpSxSagJvHly2F2EFtEwEPix4Pl7CBFzAKrWCSmbJjGDtFx
	klGio38xG0gVp4CWxI4D61hAbGEBZ4kTz1uZQGwWAVWJ2Q/OgU3lFbCVeNa2mQnCFpT4Mfke
	WD0zUO/6nceZIGx5ic1r3gKdxAF0q7rEo7+6EEcYScxcepodokREYt+Ld4wTGIVmIZk0C8mk
	WUgmzULSsoCRZRWjaGpBckFxUnquoV5xYm5xaV66XnJ+7iZGcPJ6JrWDcWWDxSFGAQ5GJR7e
	GSUhwUKsiWXFlbmHGCU4mJVEeH+WAYV4UxIrq1KL8uOLSnNSiw8xJgM9OpFZSjQ5H5hY80ri
	DY1NzIwsjcwsjEzMzUkTVhLnPdBqHSgkkJ5YkpqdmlqQWgSzhYmDU6qBUXbmtNpgfUtlpdlm
	cy2r2Iv2PY9/vE2yozSZ76Fm8AchkfcXGASWnTv4/Mr3qwLFp0v/3gvxyPPbGPgp/19CUOnO
	T1n/U9cdcXhk2mZ+7vKRp+1zv+r/2fa+v+rAu4mr5l47p2zDfmz3y5tZ8mb+TekFrSL8eXc5
	tD7Wujy+9Ps5+xSPid+/sCixFGckGmoxFxUnAgCJpEYfogMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, April 17, 2014 3:26 AM, Arnd Bergmann wrote:

(+cc Mohit KUMAR, Pratyush Anand, Marek Vasut, Richard Zhu,
      Kishon Vijay Abraham I, Byungho An)
> 
> On Wednesday 16 April 2014 17:57:24 Liviu Dudau wrote:
> > Jingoo,
> >
> > Thanks for taking a stab at trying to convert a host bridge
> > driver to use the new generic host bridge code.
> >
> > I do however have concerns on the direction you took. You have split
> > your driver in two, depending on whether it was CONFIG_ARM or CONFIG_ARM64,
> > even if (with my series) it should be no reason why the host bridge
> > driver should not work on other architectures as well once they are
> > converted.
> 
> Right.
> 
> > Also, some of the functions that you use have identical names but different
> > signatures depending on what arch you have selected. This is really bad
> > in my books!
> 
> It's only the sys_to_pcie() function, right?
> 
> You can probably simplify that to take a void pointer and have only one line
> difference.

Do you mean the following?
Would you give me more detailed advice?

static inline struct pcie_port *sys_to_pcie(void *sys)
{
	struct pcie_port *pp

#ifdef CONFIG_ARM
	pp = ((struct pci_sys_data *)sys)->private_data;
#else
	pp = (struct pcie_port *)sys;
#endif
	return pp;
}

> 
> > What about creating functions that use my series directly if CONFIG_ARM64 is
> > defined (or any CONFIG_ you want to create for your driver that you select
> > from CONFIG_ARM64) and otherwise implement the CONFIG_ARM version? That
> > way your driver will call only one API without any #ifdef and when arm code
> > gets converted you drop your adaptation functions. Or (better yet), have a
> > stab at converting bios32 (Rob Herring has already provided some hints on
> > how to do it for arch/arm).

To: Liviu Dudau

Sorry, but I will not implement this.
At first, you had to think the compatibility with ARM32 PCIe.
Why do you want other engineers to take this load?

> 
> That would of course be best.
> 
> > To give an example on how things are not going well in your version (not obvious
> > from your patch, but you can see it once you apply it): dw_pcie_host_init()
> > will still carry the handcoded version of DT parsing and that is not guarded
> > against CONFIG_ARM64 being defined, where the parsing will happen again
> > when you call of_create_pci_host_bridge().
> 
> How about making the generic DT parsing code from of_create_pci_host_bridge()
> an exported function that can be called by drivers that don't use
> of_create_pci_host_bridge?

Do you mean that of_create_pci_host_bridge() should be used for both ARM32
and ARM64 cases?

> 
> > Speaking of the handcoded DT parsing of resources: you are using restype == 0
> > as a way of selecting config space, *and then split the range size into two
> > halves*. From what Jason Gunthorpe and Arnd were saying, config ranges in the DT
> > tree should only be used for ECAM space, so no split is allowed.
> >
> > Arnd, are you allowing this non-standard use to creep in the bindings?
> 
> I fear it's too late to change that now. In retrospect we probably shoulnd't
> have defined the binding like that.
> 
> Overall, my impression of the patch is that it should be possible to do
> the same with much fewer #ifdefs by first rearranging the code in one patch
> and then doing another patch on top to add the generic arm64 support.

I will try to reduce #ifdefs as possible.

Best regards,
Jingoo Han

> 
> > > diff --git a/drivers/pci/host/pcie-designware.c b/drivers/pci/host/pcie-designware.c
> > > index 6d23d8c..fac0440 100644
> > > --- a/drivers/pci/host/pcie-designware.c
> > > +++ b/drivers/pci/host/pcie-designware.c
> > > @@ -65,14 +65,27 @@
> > >  #define PCIE_ATU_FUNC(x)		(((x) & 0x7) << 16)
> > >  #define PCIE_ATU_UPPER_TARGET		0x91C
> > >
> > > +#ifdef CONFIG_ARM
> > >  static struct hw_pci dw_pci;
> > > +#endif
> > >
> > >  static unsigned long global_io_offset;
> > >
> > > +#ifdef CONFIG_ARM
> > >  static inline struct pcie_port *sys_to_pcie(struct pci_sys_data *sys)
> > >  {
> > >  	return sys->private_data;
> > >  }
> > > +#endif
> > > +
> > > +#ifdef CONFIG_ARM64
> > > +static inline struct pcie_port *sys_to_pcie(struct pcie_port *pp)
> > > +{
> > > +	return pp;
> > > +}
> > > +
> > > +static struct pci_ops dw_pcie_ops;
> > > +#endif
> > >
> > >  int dw_pcie_cfg_read(void __iomem *addr, int where, int size, u32 *val)
> > >  {
> > > @@ -381,7 +394,9 @@ static int dw_pcie_msi_map(struct irq_domain *domain, unsigned int irq,
> > >  {
> > >  	irq_set_chip_and_handler(irq, &dw_msi_irq_chip, handle_simple_irq);
> > >  	irq_set_chip_data(irq, domain->host_data);
> > > +#ifdef CONFIG_ARM
> > >  	set_irq_flags(irq, IRQF_VALID);
> > > +#endif
> > >
> > >  	return 0;
> > >  }
> > > @@ -397,6 +412,10 @@ int __init dw_pcie_host_init(struct pcie_port *pp)
> > >  	struct of_pci_range_parser parser;
> > >  	u32 val;
> > >  	int i;
> > > +#ifdef CONFIG_ARM64
> > > +	struct pci_host_bridge *bridge;
> > > +	resource_size_t lastbus;
> > > +#endif
> > >
> > >  	if (of_pci_range_parser_init(&parser, np)) {
> > >  		dev_err(pp->dev, "missing ranges property\n");
> > > @@ -489,6 +508,7 @@ int __init dw_pcie_host_init(struct pcie_port *pp)
> > >  	val |= PORT_LOGIC_SPEED_CHANGE;
> > >  	dw_pcie_wr_own_conf(pp, PCIE_LINK_WIDTH_SPEED_CONTROL, 4, val);
> > >
> > > +#ifdef CONFIG_ARM
> > >  	dw_pci.nr_controllers = 1;
> > >  	dw_pci.private_data = (void **)&pp;
> > >
> > > @@ -497,6 +517,16 @@ int __init dw_pcie_host_init(struct pcie_port *pp)
> > >  #ifdef CONFIG_PCI_DOMAINS
> > >  	dw_pci.domain++;
> > >  #endif
> > > +#endif
> > > +
> > > +#ifdef CONFIG_ARM64
> > > +	bridge = of_create_pci_host_bridge(pp->dev, &dw_pcie_ops, pp);
> > > +	if (IS_ERR_OR_NULL(bridge))
> > > +		return PTR_ERR(bridge);
> > > +
> > > +	lastbus = pci_rescan_bus(bridge->bus);
> > > +	pci_bus_update_busn_res_end(bridge->bus, lastbus);
> > > +#endif
> > >
> > >  	return 0;
> > >  }
> > > @@ -695,6 +725,7 @@ static struct pci_ops dw_pcie_ops = {
> > >  	.write = dw_pcie_wr_conf,
> > >  };
> > >
> > > +#ifdef CONFIG_ARM
> > >  static int dw_pcie_setup(int nr, struct pci_sys_data *sys)
> > >  {
> > >  	struct pcie_port *pp;
> > > @@ -758,6 +789,7 @@ static struct hw_pci dw_pci = {
> > >  	.map_irq	= dw_pcie_map_irq,
> > >  	.add_bus	= dw_pcie_add_bus,
> > >  };
> > > +#endif /* CONFIG_ARM */
> > >
> > >  void dw_pcie_setup_rc(struct pcie_port *pp)
> 


