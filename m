Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753526Ab3JIM3N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 08:29:13 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:51608 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751702Ab3JIM3K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 08:29:10 -0400
X-AuditID: cbfee691-b7f4a6d0000074fc-b9-52554c145558
From: Jingoo Han <jg1.han@samsung.com>
To: "'Pratyush Anand'" <pratyush.anand@st.com>
Cc: "'Kishon Vijay Abraham I'" <kishon@ti.com>,
        "'Bjorn Helgaas'" <bhelgaas@google.com>, linux-pci@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Mohit KUMAR DCG'" <Mohit.KUMAR@st.com>,
        "'Siva Reddy Kallam'" <siva.kallam@samsung.com>,
        "'SRIKANTH TUMKUR SHIVANAND'" <ts.srikanth@samsung.com>,
        "'Arnd Bergmann'" <arnd@arndb.de>, "'Sean Cross'" <xobs@kosagi.com>,
        "'Thierry Reding'" <thierry.reding@gmail.com>,
        "'Thomas Petazzoni'" <thomas.petazzoni@free-electrons.com>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <000401cec4c6$dc415180$94c3f480$%han@samsung.com>
 <52551C6E.1040404@ti.com> <003901cec4d0$5d83e650$188bb2f0$%han@samsung.com>
 <5255266B.6040809@ti.com> <000501cec4d7$1233a3f0$369aebd0$%han@samsung.com>
 <52552F84.2020901@ti.com> <000c01cec4dd$32d92070$988b6150$%han@samsung.com>
 <20131009111333.GC14126@pratyush-vbox>
In-reply-to: <20131009111333.GC14126@pratyush-vbox>
Subject: Re: [PATCH] PCI: designware: Add irq_create_mapping()
Date: Wed, 09 Oct 2013 21:29:07 +0900
Message-id: <000901cec4eb$26377390$72a65ab0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac7E4Kwi43s2711DR/CsZeBAjVF7GgACmKIA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrGKsWRmVeSWpSXmKPExsVy+t8zI10Rn9AggzPLRS3+TjrGbrGkKcPi
	5SFNi/lHzrFaXF54idWid8FVNosLT3vYLC7vmsNmcXbecTaLGef3MVlsnPqL0aL9krLFiqat
	jBY/d81jsXj6oInJovHoA1aL1icPGB0EPX7/msTo8WTTRUaPnbPusnss2FTq8X3hfHaPvi2r
	GD2e/tjL7HH8xnYmj8+b5AI4o7hsUlJzMstSi/TtErgy/q+azVjQZVOxumEfUwPjN60uRk4O
	CQETiSsLHrJA2GISF+6tZ+ti5OIQEljGKHFnzU4WmKIVE16xQCQWMUpsOPKSFcL5xSixZ0kH
	O0gVm4CaxJcvh8FsEQEdieMrljKDFDEL3GeR+HfmIFT7BSaJeV0HmEGqOAWMJaYvmsIEYgsL
	2Ek0bfzCBmKzCKhKzHqyDmwSr4CtxKM/U9kgbEGJH5Pvgd3ELKAlsX7ncSYIW15i85q3QDM5
	gG5Vl3j0VxfiCCOJtVNvMEOUiEjse/GOEeQGCYELHBK9K2cyQ+wSkPg2+RALRK+sxCaI0yQE
	JCUOrrjBMoFRYhaSzbOQbJ6FZPMsJCsWMLKsYhRNLUguKE5KLzLVK07MLS7NS9dLzs/dxAhJ
	IxN3MN4/YH2IMRlo/URmKdHkfGAayiuJNzQ2M7IwNTE1NjK3NCNNWEmcV73FOlBIID2xJDU7
	NbUgtSi+qDQntfgQIxMHp1QDo96qbOa5Uzz0dVcz7bg1W2OOkvmEV4Yanudmz5TM73nl6B/L
	t+bElxxVrbUem6QajkyP/fDQ986na/sEHsqbOag9jffckaS61qVi8XadiHamWj+dZo8Fby06
	EjoNbj7OY4t0rQ1leJex0Yr5xdzNul6di7oUv4eWhdm9nb226vOusrJX4e0ZSizFGYmGWsxF
	xYkAjWQyvjkDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpmk+LIzCtJLcpLzFFi42I5/e+xgK6IT2iQwZYePou/k46xWyxpyrB4
	eUjTYv6Rc6wWlxdeYrXoXXCVzeLC0x42i8u75rBZnJ13nM1ixvl9TBYbp/5itGi/pGyxomkr
	o8XPXfNYLJ4+aGKyaDz6gNWi9ckDRgdBj9+/JjF6PNl0kdFj56y77B4LNpV6fF84n92jb8sq
	Ro+nP/Yyexy/sZ3J4/MmuQDOqAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3Ml
	hbzE3FRbJRefAF23zBygT5QUyhJzSoFCAYnFxUr6dpgmhIa46VrANEbo+oYEwfUYGaCBhHWM
	Gf9XzWYs6LKpWN2wj6mB8ZtWFyMnh4SAicSKCa9YIGwxiQv31rN1MXJxCAksYpTYcOQlK4Tz
	i1Fiz5IOdpAqNgE1iS9fDoPZIgI6EsdXLGUGKWIWuM8i8e/MQRaIjgtMEvO6DjCDVHEKGEtM
	XzSFCcQWFrCTaNr4hQ3EZhFQlZj1ZB3YJF4BW4lHf6ayQdiCEj8m3wO7iVlAS2L9zuNMELa8
	xOY1b4FmcgDdqi7x6K8uxBFGEmun3mCGKBGR2PfiHeMERqFZSCbNQjJpFpJJs5C0LGBkWcUo
	mlqQXFCclJ5rpFecmFtcmpeul5yfu4kRnKSeSe9gXNVgcYhRgINRiYf3AX9IkBBrYllxZe4h
	RgkOZiURXl+L0CAh3pTEyqrUovz4otKc1OJDjMlAj05klhJNzgcm0LySeENjEzMjSyMzCyMT
	c3PShJXEeQ+2WgcKCaQnlqRmp6YWpBbBbGHi4JRqYLTj9npVm8Ri+X/B03LFt7MEM9ccaXXq
	u/OYe/Z168V7e4Q65VU0Dab0fPRpOu8tviaxrUqKb87l5Hk/uQ8VHO2PeerVMO+rWNQl2X+s
	/T9XMajp3g179slix0JGudwUDp6mz0c3a2Y1R8SssTMsadqhZG6/IttBdPblq9cjviXKZuSL
	axvPVmIpzkg01GIuKk4EAFV7S/aWAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, October 09, 2013 8:14 PM, Pratyush Anand wrote:
> On Wed, Oct 09, 2013 at 06:49:15PM +0800, Jingoo Han wrote:
> > On Wednesday, October 09, 2013 7:27 PM, Kishon Vijay Abraham I wrote:
> > > On Wednesday 09 October 2013 03:35 PM, Jingoo Han wrote:
> > > > On Wednesday, October 09, 2013 6:48 PM, Kishon Vijay Abraham I wrote:
> > > >> On Wednesday 09 October 2013 02:47 PM, Jingoo Han wrote:
> > > >>> On Wednesday, October 09, 2013 6:06 PM, Kishon Vijay Abraham I wrote:
> > > >>>> On Wednesday 09 October 2013 01:39 PM, Jingoo Han wrote:
> > > >>>>> Without irq_create_mapping(), the correct irq number cannot be
> > > >>>>> provided. In this case, it makes problem such as NULL deference.
> > > >>>>> Thus, irq_create_mapping() should be added for MSI.
> > > >>>>>
> > > >>>>> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> > > >>>>> Cc: Kishon Vijay Abraham I <kishon@ti.com>
> > > >>>>> ---
> > > >>>>> Tested on Exynos5440.
> > > >>>>>
> > > >>>>>  drivers/pci/host/pcie-designware.c |   10 ++++------
> > > >>>>>  drivers/pci/host/pcie-designware.h |    1 +
> > > >>>>>  2 files changed, 5 insertions(+), 6 deletions(-)
> > > >>>>>
> > > >>>>> diff --git a/drivers/pci/host/pcie-designware.c b/drivers/pci/host/pcie-designware.c
> > > >>>>> index 8963017..e536bb6 100644
> > > >>>>> --- a/drivers/pci/host/pcie-designware.c
> > > >>>>> +++ b/drivers/pci/host/pcie-designware.c
> > > >>>>> @@ -237,6 +237,8 @@ static int assign_irq(int no_irqs, struct msi_desc *desc, int *pos)
> > > >>>>>  		}
> > > >>>>>  	}
> > > >>>>>
> > > >>>>> +	pp->msi_irq_start = irq_create_mapping(pp->irq_domain, 0);
> > > >>>>> +
> > > >>>>
> > > >>>> I think irq_create_mapping should be done for all the MSI irq lines instead of
> > > >>>> only the first line. So you might have to do for MAX_MSI_IRQS lines.
> > > >>
> > > >> Maybe it should be only till MAX_MSI_IRQS-1?
> > >
> > > I meant something like this,
> > >
> > > 	for (i = 0; i < MAX_MSI_IRQS; i++)
> > > 		irq_create_mapping(pp->irq_domain, i);
> > >
> > > That didn't give me any issues though.
> >
> > However, no driver calls irq_create_mapping() like this.
> > For example, Tegra PCI driver gives 'hwirq' as single offset value
> > to irq_create_mapping() without any loop.
> >
> > static int tegra_msi_setup_irq(struct msi_chip *chip, struct pci_dev *pdev,
> >                                struct msi_desc *desc)
> > {
> > 	hwirq = tegra_msi_alloc(msi);
> > 	irq = irq_create_mapping(msi->domain, hwirq);
> >
> > Maybe, the following can be used, it uses 'pos0' as the offset value.
> >
> > 	pp->msi_irq_start = irq_create_mapping(pp->irq_domain, pos0);
> > 	irq = pp->msi_irq_start;
> >
> 
> Documentation/IRQ-domain.txt says that "The irq_create_mapping()
> function must be called *atleast once* before any call to
> irq_find_mapping(), lest the descriptor will not be allocated."
> 
> So for sure current code need to be modified.
> 
> Now, you can create the mapping statically during initialization and
> then use it dynamically whenever needed. In that case what Kishon
> suggested is right,  something like following should work.
> 
>  	for (i = 0; i < MAX_MSI_IRQS; i++)
>  		irq_create_mapping(pp->irq_domain, i);
>         pp->msi_irq_start = irq_find_mapping(pp->irq_domain, 0);
> 
> But, I am not sure that created mapping is continuous. I mean,
> difference between irq returned by
> irq_find_mapping(pp->irq_domain, 0)
> &
> irq_find_mapping(pp->irq_domain, 9)
> is always 9. If that is not the case then, static assignment of
> msi_irq_start will not work. May be you need something as follows:
> 
> diff --git a/drivers/pci/host/pcie-designware.c b/drivers/pci/host/pcie-designware.c
> index 8963017..e6749e8 100644
> --- a/drivers/pci/host/pcie-designware.c
> +++ b/drivers/pci/host/pcie-designware.c
> @@ -157,7 +157,7 @@ static struct irq_chip dw_msi_irq_chip = {
>  void dw_handle_msi_irq(struct pcie_port *pp)
>  {
>         unsigned long val;
> -       int i, pos;
> +       int i, pos, irq;
> 
>         for (i = 0; i < MAX_MSI_CTRLS; i++) {
>                 dw_pcie_rd_own_conf(pp, PCIE_MSI_INTR0_STATUS + i * 12, 4,
> @@ -165,8 +165,9 @@ void dw_handle_msi_irq(struct pcie_port *pp)
>                 if (val) {
>                         pos = 0;
>                         while ((pos = find_next_bit(&val, 32, pos)) != 32) {
> -                               generic_handle_irq(pp->msi_irq_start
> -                                       + (i * 32) + pos);
> +                               irq = irq_find_mapping(pp->irq_domain,
> +                                               i * 32 + pos);
> +                               generic_handle_irq(irq);
>                                 pos++;
>                         }
>                 }
> @@ -237,9 +238,8 @@ static int assign_irq(int no_irqs, struct msi_desc *desc, int *pos)
>                 }
>         }
> 
> -       irq = (pp->msi_irq_start + pos0);
> -
> -       if ((irq + no_irqs) > (pp->msi_irq_start + MAX_MSI_IRQS-1))
> +       irq = irq_find_mapping(pp->irq_domain, pos0);
> +       if (!irq)
>                 goto no_valid_irq;
> 
>         i = 0;
> @@ -270,6 +270,7 @@ static void clear_irq(unsigned int irq)
>         struct irq_desc *desc;
>         struct msi_desc *msi;
>         struct pcie_port *pp;
> +       struct irq_data *data = irq_get_irq_data(irq);
> 
>         /* get the port structure */
>         desc = irq_to_desc(irq);
> @@ -280,7 +281,7 @@ static void clear_irq(unsigned int irq)
>                 return;
>         }
> 
> -       pos = irq - pp->msi_irq_start;
> +       pos = data->hwirq;
> 
>         irq_free_desc(irq);
> 
> @@ -371,6 +372,7 @@ int __init dw_pcie_host_init(struct pcie_port *pp)
>         struct of_pci_range range;
>         struct of_pci_range_parser parser;
>         u32 val;
> +       int i;
> 
>         struct irq_domain *irq_domain;
> 
> @@ -449,7 +451,8 @@ int __init dw_pcie_host_init(struct pcie_port *pp)
>                         return -ENXIO;
>                 }
> 
> -               pp->msi_irq_start = irq_find_mapping(irq_domain, 0);
> +               for (i = 0; i < MAX_MSI_IRQS; i++)
> +                       irq_create_mapping(irq_domain, i);
>         }
> 
>         if (pp->ops->host_init)
> diff --git a/drivers/pci/host/pcie-designware.h b/drivers/pci/host/pcie-designware.h
> index faccbbf..2ad56e4 100644
> --- a/drivers/pci/host/pcie-designware.h
> +++ b/drivers/pci/host/pcie-designware.h
> @@ -47,7 +47,7 @@ struct pcie_port {
>         u32                     lanes;
>         struct pcie_host_ops    *ops;
>         int                     msi_irq;
> -       int                     msi_irq_start;
> +       struct irq_domain       *irq_domain;
>         unsigned long           msi_data;
>         DECLARE_BITMAP(msi_irq_in_use, MAX_MSI_IRQS);
>  };

Hi Pratyush Anand,

Ah, I see.
Thank you for your kind and detailed comment.

Also I tested your patch on Exynos5440 with two Intel e1000e LAN cards.
It works properly with some very trivial modification.

I will send v2 patch as a committer.
Of course, you will be the author of v2 patch.
Thank you.

Kishon,
I would appreciate the opportunity to discuss with you. :-)

Best regards,
Jingoo Han

> 
> Other could be what you are suggesting or Tegra is using. Do no create
> static mapping. Whenever you need a mapping call irq_create_mapping rather
> irq_find_mapping. That should also work, as multiple calling of irq_create_mapping
> will not do anything more than that of irq_find_mapping.

