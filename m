Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965271Ab3FTLm4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 07:42:56 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:58319 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965016Ab3FTLmy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 07:42:54 -0400
X-AuditID: cbfec7f5-b7f376d000001ec6-a5-51c2eabc1068
From: Tomasz Figa <t.figa@samsung.com>
To: Jingoo Han <jg1.han@samsung.com>, "'Arnd Bergmann'" <arnd@arndb.de>
Cc: "'Tomasz Figa'" <tomasz.figa@gmail.com>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
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
        "'Thomas Abraham'" <thomas.abraham@linaro.org>
Subject: Re: [PATCH V6 3/3] ARM: dts: Add pcie controller node for Samsung
 EXYNOS5440 SoC
Date: Thu, 20 Jun 2013 13:42:43 +0200
Message-id: <1490597.TZb2cDc7ca@amdc1227>
Organization: Samsung Poland R&D Center
User-Agent: KMail/4.10.3 (Linux/3.8.8-gentoo; KDE/4.10.3; x86_64; ; )
In-reply-to: <00d801ce6da5$fa792d80$ef6b8880$@samsung.com>
References: <00c201ce6d85$83b072a0$8b1157e0$@samsung.com>
 <201306201216.37248.arnd@arndb.de>
 <00d801ce6da5$fa792d80$ef6b8880$@samsung.com>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrKIsWRmVeSWpSXmKPExsVy+t/xy7p7Xh0KNNjwW9yi+f92Vou/k46x
	WyxpyrA4MPshq8WrMxvZLC4vvMRq8f2GqUXvgqtsFpseX2O1uLxrDpvF2XnH2SxmnN/HZLGi
	aSujxeKLy5ktdq9cwmJxbMYSRounD5qYLFbt+sPoIOSxZt4aRo/fvyYxevRNucrm8WTTRUaP
	nbPusnss2FTqcefaHjaPzUvqPc7PWMjo8X1HL1DVllWMHj9f6nh83iQXwBvFZZOSmpNZllqk
	b5fAlTG9+QFjwVHOihXXTrA2MF5l62Lk5JAQMJF4saYbyhaTuHBvPZDNxSEksJRRYvKUU1BO
	F5PExvYX7CBVbAJqEp8bHgElODhEBFwlNq8uAqlhFjjKKnH98AEWkBphgWiJJ4ubmEBsFgFV
	iesXX7CC2LwCmhJbl1wGq+EXUJd4t+0pWI0o0Jz3qw+DxTkFrCSm3j7FArG4j1Fi/8lGRohm
	QYkfk++BFTELyEvs2z+VFcLWkli/8zjTBEbBWUjKZiEpm4WkbAEj8ypG0dTS5ILipPRcI73i
	xNzi0rx0veT83E2MkKj9uoNx6TGrQ4wCHIxKPLwalw8GCrEmlhVX5h5ilOBgVhLhTZ1zKFCI
	NyWxsiq1KD++qDQntfgQIxMHp1QDo1S+h/GDP9tfKF594Jte/92ufrbeaUXX+4zbhFZys1fE
	eTOeeNbid5713BefRo3/O/q3VdWd828U71+dbxVz8ZHVodkJbA2a0xO+f9GPvNCTVLRPbkWa
	WcTShTvObOP4ZW/uKH4jSN5puYr9Ku+Vh8T2uYnenbjA5MDdfakPON7tOl2TfW/OLyWW4oxE
	Qy3mouJEAEtP4eC4AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 20 of June 2013 20:04:47 Jingoo Han wrote:
> On Thursday, June 20, 2013 7:17 PM, Arnd Bergmann wrote:
> > On Thursday 20 June 2013, Jingoo Han wrote:
> > > 2. patch adding label to the pinctrl node (which is a prerequisite)
> > > and
> > > 
> > >     board-specific properties of PCIe nodes.
> > >    
> > >    [PATCH] ARM: dts: Add pcie controller node for exynos5440-ssdk5440
> > > 
> > > arch/arm/boot/dts/exynos5440-ssdk5440.dts
> > > +
> > > +       pcie0@290000 {
> > > +               reset-gpio = <&pin_ctrl 5 0>;
> > > +       };
> > > +
> > > +       pcie1@2a0000 {
> > > +               reset-gpio = <&pin_ctrl 22 0>;
> > > +       };
> > > 
> > > arch/arm/boot/dts/exynos5440.dtsi
> > > -       pinctrl {
> > > +       pin_ctrl: pinctrl {
> > 
> > Note that you don't really have to use a label, you can also refer
> > to the pinctrl node by its full path, which is just "/pinctrl"
> > or "/pinctrl@e0000".

Sure, you can, but this is ugly.

> 
> I see.
> 
> But, I have a question.
> Using phandle has been the usual way to referring to a node.
> Why do you want to do it differently?

Path is translated to a phandle as well.

--
Best regards,
Tomasz

