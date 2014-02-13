Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752801AbaBMIKh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 03:10:37 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:35789 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751417AbaBMIKe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 03:10:34 -0500
X-AuditID: cbfee68f-b7f156d00000276c-b3-52fc7df69758
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
In-reply-to: <20140206101814.GA4993@e106497-lin.cambridge.arm.com>
Subject: Re: [PATCH] pci: Add support for creating a generic host_bridge from
 device tree
Date: Thu, 13 Feb 2014 17:10:29 +0900
Message-id: <000201cf2893$0f5e3710$2e1aa530$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac8jJMZQcXw+jDDtSgu1a5WFP4+T7AFbBBDg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmplleLIzCtJLcpLzFFi42I5/e+Zge632j9BBj+Pilj8nXSM3WJJU4bF
	+2U9jBbzj5xjtbi88BKrxftDz5gtNj2+BuTumsNmcXbecTaLA0vbWSyef/rEYvHy4wkWBx6P
	j+s/MXqsmbeG0eP3r0mMHgs2lXpsXlLvcfvfY2aPvi2rGD0+b5IL4IjisklJzcksSy3St0vg
	yth1cjNjwXrhiklNEQ2Mh/m7GDk5JARMJN58P8EOYYtJXLi3nq2LkYtDSGAZo0TfzZfMMEUP
	H75igUhMZ5S4ePUvVNUvRol7K8+wgFSxCahJfPlyGGyUiICPxMW3L8GKmAXmMEsc7d7IDNEx
	m0ni8okfrCBVnAJOEjcm3GECsYUFoiUW/D8KNolFQFXi15odYJN4BWwlmk48Z4WwBSV+TL4H
	VMMBNFVdYsqUXJAws4C8xOY1b5lBwhJA4Ud/dUFMEQEjiYtNOhAVIhL7XrxjBLlAQmAhh8SC
	a5NYITYJSHybfIgFolVWYtMBqIclJQ6uuMEygVFiFpK9sxD2zkKydxaSDQsYWVYxiqYWJBcU
	J6UXGesVJ+YWl+al6yXn525ihCSB/h2Mdw9YH2JMBto+kVlKNDkfmETySuINjc2MLExNTI2N
	zC3NSBNWEue9/zApSEggPbEkNTs1tSC1KL6oNCe1+BAjEwenVAOj25ovNTvWT7kSe+Cb8uTv
	sxX0PiTn3dPNObzebsLvndtmde35dztyh+oC6R16qyL9HhbEsqucz/vhnyTMyn36TmXYh/RL
	T6Uff1uXuotdY1PWogfx6ZIrvwTLm9TO/Lcq/rTKyrV5QYd0865xzV4enlb/w4At2SGH+QZj
	kGZ5hei+3hUpa9zeKLEUZyQaajEXFScCAGUsb3gYAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrEKsWRmVeSWpSXmKPExsVy+t9jQd1vtX+CDBat5rf4O+kYu8WSpgyL
	98t6GC3mHznHanF54SVWi/eHnjFbbHp8DcjdNYfN4uy842wWB5a2s1g8//SJxeLlxxMsDjwe
	H9d/YvRYM28No8fvX5MYPRZsKvXYvKTe4/a/x8wefVtWMXp83iQXwBHVwGiTkZqYklqkkJqX
	nJ+SmZduq+QdHO8cb2pmYKhraGlhrqSQl5ibaqvk4hOg65aZA3SskkJZYk4pUCggsbhYSd8O
	04TQEDddC5jGCF3fkCC4HiMDNJCwjjFj18nNjAXrhSsmNUU0MB7m72Lk5JAQMJF4+PAVC4Qt
	JnHh3nq2LkYuDiGB6YwSF6/+hXJ+MUrcW3kGrIpNQE3iy5fD7CC2iICPxMW3L8GKmAXmMEsc
	7d7IDNExm0ni8okfrCBVnAJOEjcm3GECsYUFoiUW/D8KNolFQFXi15odYJN4BWwlmk48Z4Ww
	BSV+TL4HVMMBNFVdYsqUXJAws4C8xOY1b5lBwhJA4Ud/dUFMEQEjiYtNOhAVIhL7XrxjnMAo
	NAvJnFkIc2YhmTMLSccCRpZVjKKpBckFxUnpuUZ6xYm5xaV56XrJ+bmbGMEp5pn0DsZVDRaH
	GAU4GJV4eB8s/h0kxJpYVlyZe4hRgoNZSYRXRuJPkBBvSmJlVWpRfnxRaU5q8SHGZKAvJzJL
	iSbnA9NfXkm8obGJmZGlkZmFkYm5OWnCSuK8B1utA4UE0hNLUrNTUwtSi2C2MHFwSjUwZnRd
	Yt0mzGzAk3bLX+vqO4+o3sazJzfylHutzreYqVnrebXo3YWynUUW3Vm//n/6MfeopOMGt+4l
	VQvaHPpPTZH85qoXkbDq/+PSHkUl2eAvz5XrzDOrnN5mfX67ui7liUfS6f3lPT8yelebn75y
	TvhW9KRD93ccvmFmXmAvePcn98sji7OylFiKMxINtZiLihMBOdZPZXUDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, February 06, 2014 7:18 PM, Liviu Dudau wrote:
> On Wed, Feb 05, 2014 at 10:26:27PM +0000, Tanmay Inamdar wrote:
> > Hello Liviu,
> >
> > I did not get the first email of this particular patch on any of
> > subscribed mailing lists (don't know why), hence replying here.
> 
> Strange, it shows in the MARC and GMANE archive for linux-pci, probably
> a hickup on your receiving side?
> 
> >
> > +struct pci_host_bridge *
> > +pci_host_bridge_of_init(struct device *parent, int busno, struct pci_ops *ops,
> > + void *host_data, struct list_head *resources)
> > +{
> > + struct pci_bus *root_bus;
> > + struct pci_host_bridge *bridge;
> > +
> > + /* first parse the host bridge bus ranges */
> > + if (pci_host_bridge_of_get_ranges(parent->of_node, resources))
> > + return NULL;
> > +
> > + /* then create the root bus */
> > + root_bus = pci_create_root_bus(parent, busno, ops, host_data, resources);
> > + if (!root_bus)
> > + return NULL;
> > +
> > + bridge = to_pci_host_bridge(root_bus->bridge);
> > +
> > + return bridge;
> > +}
> >
> > You are keeping the domain_nr inside pci_host_bridge structure. In
> > above API, domain_nr is required in 'pci_find_bus' function called
> > from 'pci_create_root_bus'. Since the bridge is allocated after
> > creating root bus, 'pci_find_bus' always gets domain_nr as 0. This
> > will cause problem for scanning multiple domains.
> 
> Good catch. I was switching between creating a pci_controller in arch/arm64 and
> adding the needed bits in pci_host_bridge. After internal review I've decided to
> add the domain_nr to pci_host_bridge, but forgot to update the code everywhere.

Hi Liviu Dudau,

One more thing,
I am reviewing and compiling your patch.
Would you consider adding 'struct pci_sys_data' and 'struct hw_pci'?

Currently, 4 PCIe Host drivers (pci-mvebu.c, pci-tegra.c,
pci-rcar-gen2.c, pcie-designware.c) are using 'struct pci_sys_data'
and 'struct hw_pci' in their drivers. Without this, it makes build
errors.

In arm32, 'struct pci_sys_data' and 'struct hw_pci' is defined
in "arch/arm/include/asm/mach/pci.h".

Tanmay Inamdar,
Your 'APM X-Gene PCIe' patch also needs 'struct pci_sys_data' and
'struct hw_pci'. With Liviu Dudau's patch, it will make build
errors. Would you check this?

Thank you.

Best regards,
Jingoo Han

> 
> Thanks for reviewing this, will fix in v2.
> 
> Do you find porting to the new API straight forward?
> 

