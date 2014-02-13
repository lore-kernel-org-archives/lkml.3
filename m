Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752546AbaBMISo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 03:18:44 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:37919 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751482AbaBMISl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 03:18:41 -0500
X-AuditID: cbfee68d-b7fcd6d00000315b-da-52fc7fdfb2e0
From: Jingoo Han <jg1.han@samsung.com>
To: "'Liviu Dudau'" <Liviu.Dudau@arm.com>,
        "'Tanmay Inamdar'" <tinamdar@apm.com>
Cc: "'Arnd Bergmann'" <arnd@arndb.de>, devicetree@vger.kernel.org,
        "'linaro-kernel'" <linaro-kernel@lists.linaro.org>,
        "'linux-pci'" <linux-pci@vger.kernel.org>,
        "'Will Deacon'" <Will.Deacon@arm.com>,
        "'LKML'" <linux-kernel@vger.kernel.org>,
        "'Catalin Marinas'" <Catalin.Marinas@arm.com>,
        "'Bjorn Helgaas'" <bhelgaas@google.com>,
        "'LAKML'" <linux-arm-kernel@lists.infradead.org>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <1391452428-22917-1-git-send-email-Liviu.Dudau@arm.com>
 <1391452428-22917-2-git-send-email-Liviu.Dudau@arm.com>
 <7398333.9L5KlyFggU@wuerfel>
 <CACoXjckKRQfR3CbC1JpgbhOumED+OqiMh1_Y73-h6q=ByMNanw@mail.gmail.com>
 <20140206101814.GA4993@e106497-lin.cambridge.arm.com>
 <000201cf2893$0f5e3710$2e1aa530$%han@samsung.com>
In-reply-to: <000201cf2893$0f5e3710$2e1aa530$%han@samsung.com>
Subject: Re: [PATCH] pci: Add support for creating a generic host_bridge from
 device tree
Date: Thu, 13 Feb 2014 17:18:39 +0900
Message-id: <000401cf2894$333a3fc0$99aebf40$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac8jJMZQcXw+jDDtSgu1a5WFP4+T7AFbBBDgAADBUmA=
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpnleLIzCtJLcpLzFFi42I5/e+Zke79+j9BBgt+W1n8nXSM3WJJU4bF
	+2U9jBbzj5xjtbi88BKrxftDz5gtNj2+BuTumsNmcXbecTaLA0vbWSyef/rEYvHy4wkWBx6P
	j+s/MXqsmbeG0eP3r0mMHgs2lXpsXlLvcfvfY2aPvi2rGD0+b5IL4IjisklJzcksSy3St0vg
	ymh+fJml4Kt4xbOzexgbGCcIdzFyckgImEjs3jqLGcIWk7hwbz1bFyMXh5DAMkaJr+fns8AU
	HXrbwgqRWMQoMWP6BUYI5xejxJYJHxlBqtgE1CS+fDnMDmKLCPhIXHz7EmwUs8AcZomj3RuZ
	ITrOM0n8mbaaDaSKU8BO4kTrPLBuYYFoiQX/j4LtYxFQlXi89hJYnFfAVuLe/NlMELagxI/J
	94BqOICmqktMmZILEmYWkJfYvOYtM0hYAij86K8uxA1WEg8fvmGCKBGR2PfiHdjREgJLOSRm
	Pr/ICrFKQOLb5EMsEL2yEpsOQINCUuLgihssExglZiFZPAth8Swki2ch2bCAkWUVo2hqQXJB
	cVJ6kaFecWJucWleul5yfu4mRkgi6N3BePuA9SHGZKDtE5mlRJPzgYkkryTe0NjMyMLUxNTY
	yNzSjDRhJXHepIdJQUIC6YklqdmpqQWpRfFFpTmpxYcYmTg4pRoYJ8/xu5Oy/KSK47dkm71r
	JsmL3jwmcOKZHMtv/Yr6rzfPfvS1vr0heZl7ePvhOU+kC/zWXlp//0n5T7ura42C7KPivz/6
	+0yq8h3HQ5Z/eraBCfvyVjDLT9muZPLhs2z96dXcmRG1m7S5OTYLXWyqrQ+aXmzUbO296Udh
	vPDtWaldXQtzvl66oMRSnJFoqMVcVJwIADf80u8aAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCKsWRmVeSWpSXmKPExsVy+t9jAd379X+CDPZeMLX4O+kYu8WSpgyL
	98t6GC3mHznHanF54SVWi/eHnjFbbHp8DcjdNYfN4uy842wWB5a2s1g8//SJxeLlxxMsDjwe
	H9d/YvRYM28No8fvX5MYPRZsKvXYvKTe4/a/x8wefVtWMXp83iQXwBHVwGiTkZqYklqkkJqX
	nJ+SmZduq+QdHO8cb2pmYKhraGlhrqSQl5ibaqvk4hOg65aZA3SskkJZYk4pUCggsbhYSd8O
	04TQEDddC5jGCF3fkCC4HiMDNJCwjjGj+fFlloKv4hXPzu5hbGCcINzFyMkhIWAicehtCyuE
	LSZx4d56ti5GLg4hgUWMEjOmX2CEcH4xSmyZ8JERpIpNQE3iy5fD7CC2iICPxMW3L8E6mAXm
	MEsc7d7IDNFxnkniz7TVbCBVnAJ2Eida54F1CwtESyz4f5QFxGYRUJV4vPYSWJxXwFbi3vzZ
	TBC2oMSPyfeAajiApqpLTJmSCxJmFpCX2LzmLTNIWAIo/OivLsQNVhIPH75hgigRkdj34h3j
	BEahWUgGzUIYNAvJoFlIOhYwsqxiFE0tSC4oTkrPNdQrTswtLs1L10vOz93ECE4zz6R2MK5s
	sDjEKMDBqMTD+2Dx7yAh1sSy4srcQ4wSHMxKIrwyEn+ChHhTEiurUovy44tKc1KLDzEmA705
	kVlKNDkfmALzSuINjU3MjCyNzCyMTMzNSRNWEuc90GodKCSQnliSmp2aWpBaBLOFiYNTqoFR
	c9feVde4DgncuRyld2TLWZ2vR33sej5VX5758Hvv+6ALN5m88gWkfFVOz/Ced+8O3+IwjdSA
	7xderZXxK01dWrfF7KJbQ0nNwmpxiY+Ze0LY1E8zM3A4Pdtctuy4+7evHZ1n9Zau+7Di2I82
	a9c9vnuYYqdwNT6oLPTpCqq/6iY17ejH9fGiSizFGYmGWsxFxYkAdWkG13cDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 

> -----Original Message-----
> From: Jingoo Han [mailto:jg1.han@samsung.com]
> Sent: Thursday, February 13, 2014 5:10 PM
> To: 'Liviu Dudau'; 'Tanmay Inamdar'
> Cc: 'Arnd Bergmann'; devicetree@vger.kernel.org; 'linaro-kernel'; 'linux-pci'; 'Will Deacon'; 'LKML';
> 'Catalin Marinas'; 'Bjorn Helgaas'; 'LAKML'; 'Jingoo Han'
> Subject: Re: [PATCH] pci: Add support for creating a generic host_bridge from device tree
> 
> On Thursday, February 06, 2014 7:18 PM, Liviu Dudau wrote:
> > On Wed, Feb 05, 2014 at 10:26:27PM +0000, Tanmay Inamdar wrote:
> > > Hello Liviu,
> > >
> > > I did not get the first email of this particular patch on any of
> > > subscribed mailing lists (don't know why), hence replying here.
> >
> > Strange, it shows in the MARC and GMANE archive for linux-pci, probably
> > a hickup on your receiving side?
> >
> > >
> > > +struct pci_host_bridge *
> > > +pci_host_bridge_of_init(struct device *parent, int busno, struct pci_ops *ops,
> > > + void *host_data, struct list_head *resources)
> > > +{
> > > + struct pci_bus *root_bus;
> > > + struct pci_host_bridge *bridge;
> > > +
> > > + /* first parse the host bridge bus ranges */
> > > + if (pci_host_bridge_of_get_ranges(parent->of_node, resources))
> > > + return NULL;
> > > +
> > > + /* then create the root bus */
> > > + root_bus = pci_create_root_bus(parent, busno, ops, host_data, resources);
> > > + if (!root_bus)
> > > + return NULL;
> > > +
> > > + bridge = to_pci_host_bridge(root_bus->bridge);
> > > +
> > > + return bridge;
> > > +}
> > >
> > > You are keeping the domain_nr inside pci_host_bridge structure. In
> > > above API, domain_nr is required in 'pci_find_bus' function called
> > > from 'pci_create_root_bus'. Since the bridge is allocated after
> > > creating root bus, 'pci_find_bus' always gets domain_nr as 0. This
> > > will cause problem for scanning multiple domains.
> >
> > Good catch. I was switching between creating a pci_controller in arch/arm64 and
> > adding the needed bits in pci_host_bridge. After internal review I've decided to
> > add the domain_nr to pci_host_bridge, but forgot to update the code everywhere.
> 
> Hi Liviu Dudau,
> 
> One more thing,
> I am reviewing and compiling your patch.
> Would you consider adding 'struct pci_sys_data' and 'struct hw_pci'?
> 
> Currently, 4 PCIe Host drivers (pci-mvebu.c, pci-tegra.c,
> pci-rcar-gen2.c, pcie-designware.c) are using 'struct pci_sys_data'
> and 'struct hw_pci' in their drivers. Without this, it makes build
> errors.
> 
> In arm32, 'struct pci_sys_data' and 'struct hw_pci' is defined
> in "arch/arm/include/asm/mach/pci.h".
> 
> Tanmay Inamdar,
> Your 'APM X-Gene PCIe' patch also needs 'struct pci_sys_data' and
> 'struct hw_pci'. With Liviu Dudau's patch, it will make build
> errors. Would you check this?

I mean the patch '[PATCH] arm64: Add architecture support for PCI'.
With this patch, it makes build errors in PCIe Host drivers such as
pcie-designware.c.

Best regards,
Jingoo Han


