Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755443Ab3FMFeT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 01:34:19 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:60176 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754055Ab3FMFeQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 01:34:16 -0400
X-AuditID: cbfee68e-b7f276d000002279-af-51b959d7ff8e
From: Jingoo Han <jg1.han@samsung.com>
To: "'Arnd Bergmann'" <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org
Cc: "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Bjorn Helgaas'" <bhelgaas@google.com>,
        "'Thomas Petazzoni'" <thomas.petazzoni@free-electrons.com>,
        "'Jason Gunthorpe'" <jgunthorpe@obsidianresearch.com>,
        linux-samsung-soc@vger.kernel.org,
        "'Siva Reddy Kallam'" <siva.kallam@samsung.com>,
        linux-pci@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        "'Thierry Reding'" <thierry.reding@avionic-design.de>,
        linux-kernel@vger.kernel.org,
        "'Grant Likely'" <grant.likely@secretlab.ca>,
        "'Surendranath Gurivireddy Balla'" <suren.reddy@samsung.com>,
        "'Thomas Abraham'" <thomas.abraham@linaro.org>,
        "'Andrew Murray'" <andrew.murray@arm.com>,
        Jingoo Han <jg1.han@samsung.com>
References: <003801ce6756$6578ff80$306afe80$@samsung.com>
 <3532163.SqzZzxO4BR@wuerfel>
In-reply-to: <3532163.SqzZzxO4BR@wuerfel>
Subject: Re: [PATCH V4 3/3] ARM: dts: Add pcie controller node for Samsung
 EXYNOS5440 SoC
Date: Thu, 13 Jun 2013 14:34:14 +0900
Message-id: <003a01ce67f7$a3fc7f60$ebf57e20$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQIB7+Z3pymj9g5Uhopw1ddjvV5kcAIiRn26mLr6ueA=
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMKsWRmVeSWpSXmKPExsVy+t8zA93rkTsDDRZeY7Fo/r+d1eLvpGPs
	FkuaMiwOzH7IavHqzEY2i8sLL7FafL9hatG74CqbxabH11gtLu+aw2Zxdt5xNosZ5/cxWaxo
	2sposfjicmaL3SuXsFgcm7GE0eLpgyYmB0GPNfPWMHr8/jWJ0aNvylU2jyebLjJ6LNhU6nHn
	2h42j81L6j3Oz1jI6PF9Ry9QwZZVjB4/X+p4fN4kF8ATxWWTkpqTWZZapG+XwJVx4/cj5oJL
	YhX/mq+xNDBO5O9i5OSQEDCRuHXhDROELSZx4d56ti5GLg4hgWWMEuvePGSCKTqzro0ZIrGI
	UeLg6SNMEM4vRom9L4+wgFSxCahJfPlymB3EFhHwlDhzcgELSBGzwCxWieNf/oElhAQiJBrv
	tICN5RTQlPi/sZcVxBYWiJaYef4O2CAWAVWJDS8uM4PYvAKWEke6u9khbEGJH5PvgdUwC2hJ
	rN95nAnClpfYvOYtM8SpChI7zr5mhDjCSuJC82N2iBoRiX0v3jFC1DzgkPg7Px9il4DEt8mH
	gGZyAMVlJTYdgBojKXFwxQ2WCYwSs5BsnoVk8ywkm2ch2bCAkWUVo2hqQXJBcVJ6kZFecWJu
	cWleul5yfu4mRkiC6dvBePOA9SHGZKD1E5mlRJPzgQkqryTe0NjMyMLUxNTYyNzSjDRhJXFe
	tRbrQCGB9MSS1OzU1ILUovii0pzU4kOMTBycUg2MVmlie9UCUjp5FTYocfb73E02utJwcvoP
	Tq6Tr5bYp7rlZt8P+n7j/UeX3Y1HeOK+q6n+tnFoX2J79YrLP16HX/zMWkI3J0Wublxe8tDo
	C5tDV3FWn97jrEUXt5d5L8tTYGnban+E9ePHhRJZPM6vqlPTYh8/dJvH4aF96d/Gp627q/YG
	XT6txFKckWioxVxUnAgA3VwSREYDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprIJsWRmVeSWpSXmKPExsVy+t9jAd1rkTsDDQ6ftrZo/r+d1eLvpGPs
	FkuaMiwOzH7IavHqzEY2i8sLL7FafL9hatG74CqbxabH11gtLu+aw2Zxdt5xNosZ5/cxWaxo
	2sposfjicmaL3SuXsFgcm7GE0eLpgyYmB0GPNfPWMHr8/jWJ0aNvylU2jyebLjJ6LNhU6nHn
	2h42j81L6j3Oz1jI6PF9Ry9QwZZVjB4/X+p4fN4kF8AT1cBok5GamJJapJCal5yfkpmXbqvk
	HRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuWmQP0l5JCWWJOKVAoILG4WEnfDtOE0BA3XQuY
	xghd35AguB4jAzSQsI4x48bvR8wFl8Qq/jVfY2lgnMjfxcjJISFgInFmXRszhC0mceHeerYu
	Ri4OIYFFjBIHTx9hgnB+MUrsfXmEBaSKTUBN4suXw+wgtoiAp8SZkwtYQIqYBWaxShz/8g8s
	ISQQIdF4p4UJxOYU0JT4v7GXFcQWFoiWmHn+DtggFgFViQ0vLoOt5hWwlDjS3c0OYQtK/Jh8
	D6yGWUBLYv3O40wQtrzE5jVvoU5VkNhx9jUjxBFWEheaH7ND1IhI7HvxjnECo9AsJKNmIRk1
	C8moWUhaFjCyrGIUTS1ILihOSs810itOzC0uzUvXS87P3cQITmDPpHcwrmqwOMQowMGoxMP7
	8sKOQCHWxLLiytxDjBIczEoivJ6HgEK8KYmVValF+fFFpTmpxYcYk4E+ncgsJZqcD0yueSXx
	hsYmZkaWRmYWRibm5qQJK4nzHmy1DhQSSE8sSc1OTS1ILYLZwsTBKdXAGM4Xu27qTL7Zqs/D
	zVc873vt2rKtmi3mgvebppKJO8Q+9hwtSDwwvfvv5/+KS89u01k1L+PQ+ZJ1vi2PDidYLNmc
	Ebf3i7LEGfMnu8/Fz/SwSpvLGiLqnTUn91OsJI/I+S3z1SvYYzeFNXxX3BR0hkd4wVP1xYUd
	SZevbVZ/7TvD0OmI4oNbV5RYijMSDbWYi4oTAYl12dqkAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, June 12, 2013 7:56 PM, Arnd Bergmann wrote:
> 
> Thanks for the update! A few comments again:
> 
> On Wednesday 12 June 2013 19:20:00 Jingoo Han wrote:
> >
> > diff --git a/arch/arm/boot/dts/exynos5440-ssdk5440.dts b/arch/arm/boot/dts/exynos5440-ssdk5440.dts
> > index d55042b..efe7d39 100644
> > --- a/arch/arm/boot/dts/exynos5440-ssdk5440.dts
> > +++ b/arch/arm/boot/dts/exynos5440-ssdk5440.dts
> > @@ -30,4 +30,12 @@
> >                         clock-frequency = <50000000>;
> >                 };
> >         };
> > +
> > +       pcie0@40000000 {
> > +               reset-gpio = <5>;
> > +       };
> > +
> > +       pcie1@60000000 {
> > +               reset-gpio = <22>;
> > +       };
> >  };
> 
> As mentioned before, please use the gpio binding to pass gpio numbers.

OK, I will use gpio binding.

> 
> > diff --git a/arch/arm/boot/dts/exynos5440.dtsi b/arch/arm/boot/dts/exynos5440.dtsi
> > index f6b1c89..2c15f9d 100644
> > --- a/arch/arm/boot/dts/exynos5440.dtsi
> > +++ b/arch/arm/boot/dts/exynos5440.dtsi
> > @@ -216,4 +216,42 @@
> >                 clock-names = "rtc";
> >                 status = "disabled";
> >         };
> > +
> > +       pcie0@0x290000 {
> > +               compatible = "samsung,exynos5440-pcie";
> > +               reg = <0x290000 0x1000
> > +                       0x270000 0x1000
> > +                       0x271000 0x40>;
> > +               interrupts = <0 20 0>, <0 21 0>, <0 22 0>;
> > +               clocks = <&clock 28>, <&clock 27>;
> > +               clock-names = "pcie", "pcie_bus";
> > +               #address-cells = >;
> > +               #size-cells = <2>;
> > +               device_type = "pci";
> > +               ranges = <0x00000800 0 0x40000000 0x40000000 0 0x00200000   /* configuration space */
> > +                         0x81000000 0 0          0x40200000 0 0x00010000   /* downstream I/O */
> > +                         0x82000000 0 0x40210000 0x40210000 0 0x10000000>; /* non-prefetchable memory */
> 
> I think you did not reply to my question regarding the size of the
> memory space. Does it extend from 0x40210000 to 0x50210000,
> or from 0x40210000 to 0x50000000. You probably meant the latter
> but wrote the former. If not, please add a comment for clarification.

OK, I see.
It extends to 0x60000000. I will modify it.

> 
> > +               #interrupt-cells = <1>;
> > +               interrupt-map-mask = <0 0 0 0>;
> > +               interrupt-map = <0x0 0 &gic 53>;
> > +       };
> 
> So all PCI IntA interrupts are mapped to a single gic interrupt? That
> sounds like a bottleneck when you have a lot of devices on the bus.
> Do you have MSI support?

INTA, INTB, INTC, and INTD are mapped to a single gic interrupt.
Exynos5440 PCIe has MSI support; however, MSI support patch will
be posted later.

> 
> 	Arnd

