Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755157Ab3FGJUL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 05:20:11 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:58247 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751471Ab3FGJUC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 05:20:02 -0400
X-AuditID: cbfee68d-b7f096d0000043fc-0f-51b1a5ac217d
From: Jingoo Han <jg1.han@samsung.com>
To: "'Jason Gunthorpe'" <jgunthorpe@obsidianresearch.com>
Cc: "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Bjorn Helgaas'" <bhelgaas@google.com>,
        linux-samsung-soc@vger.kernel.org, linux-pci@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        "'Grant Likely'" <grant.likely@secretlab.ca>,
        "'Andrew Murray'" <andrew.murray@arm.com>,
        "'Thomas Petazzoni'" <thomas.petazzoni@free-electrons.com>,
        "'Thierry Reding'" <thierry.reding@avionic-design.de>,
        "'Surendranath Gurivireddy Balla'" <suren.reddy@samsung.com>,
        "'Siva Reddy Kallam'" <siva.kallam@samsung.com>,
        "'Thomas Abraham'" <thomas.abraham@linaro.org>,
        Jingoo Han <jg1.han@samsung.com>
References: <00c001ce277b$92b26ab0$b8174010$%han@samsung.com>
 <00c501ce277c$30e49dc0$92add940$%han@samsung.com>
 <000001ce3438$b136e1e0$13a4a5a0$%han@samsung.com>
 <20130408165626.GA30824@obsidianresearch.com>
In-reply-to: <20130408165626.GA30824@obsidianresearch.com>
Subject: Re: [PATCH 6/6] ARM: dts: Add pcie controller node for Samsung
 EXYNOS5440 SoC
Date: Fri, 07 Jun 2013 18:19:40 +0900
Message-id: <000c01ce6360$237a7040$6a6f50c0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac40egx1HM7J5jk+Q4qO2deFDw1tRgu5Tw5A
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrNKsWRmVeSWpSXmKPExsVy+t8zfd01SzcGGqzeZmLR/H87q8WSpgyL
	A7Mfslq8OrORzeLywkusFt9vmFr0LrjKZrHp8TVWi8u75rBZnJ13nM1ixvl9TBYrmrYyWiy+
	uJzZYvfKJSwWx2YsYbR4+qCJyUHAY828NYwefVOusnk82XSR0WPBplKPO9f2sHlsXlLvcX7G
	QkaP7zt6gQq2rGL0+PlSx+PzJrkA7igum5TUnMyy1CJ9uwSujMY3LawFx5QrTs14yNzAuF2y
	i5GTQ0LAROLry42sELaYxIV769m6GLk4hASWMUp8/nGCDabo8be77BCJ6YwSm3ctZoJwfjFK
	rNr6F6ydTUBN4suXw+wgtoiAucSEVT/ARjELdLJK9Mz4xAjRcZVRYsb048wgVZwCVhJ7jrWA
	7RAWiJC48vwxE4jNIqAq0dn5E8zmFbCUuHr4DjOELSjxY/I9FhCbWUBLYv3O40wQtrzE5jVv
	mSFuVZDYcfY1I8QVRhK3l75ihKgRkdj34h3YERICNzgkfrUeZIVYJiDxbfIhoKEcQAlZiU0H
	oOZIShxccYNlAqPELCSrZyFZPQvJ6llIVixgZFnFKJpakFxQnJReZKhXnJhbXJqXrpecn7uJ
	EZJQencw3j5gfYgxGWj9RGYp0eR8YELKK4k3NDYzsjA1MTU2Mrc0I01YSZxXrcU6UEggPbEk
	NTs1tSC1KL6oNCe1+BAjEwenVANj0FbLnZVOccG/XdY1ftG47bdnffwjq9TuY18eLq2zrduh
	3Pzdd+XzZqbKdeaB4mfdW8w37TvJGbA6+WFKomi2V/KHi5KnFWR/hjM85Hh+wMmoRfVzsTzf
	XWuOlSs1D0tZb1EptJC5YbiYY2ZhzbVbe8+lNS6IumC+orjalXf5a9Uzvzy3//NSYinOSDTU
	Yi4qTgQAGa2SVz4DAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupgk+LIzCtJLcpLzFFi42I5/e+xoO6apRsDDT4s1LNo/r+d1WJJU4bF
	gdkPWS1endnIZnF54SVWi+83TC16F1xls9j0+BqrxeVdc9gszs47zmYx4/w+JosVTVsZLRZf
	XM5ssXvlEhaLYzOWMFo8fdDE5CDgsWbeGkaPvilX2TyebLrI6LFgU6nHnWt72Dw2L6n3OD9j
	IaPH9x29QAVbVjF6/Hyp4/F5k1wAd1QDo01GamJKapFCal5yfkpmXrqtkndwvHO8qZmBoa6h
	pYW5kkJeYm6qrZKLT4CuW2YO0DdKCmWJOaVAoYDE4mIlfTtME0JD3HQtYBojdH1DguB6jAzQ
	QMI6xozGNy2sBceUK07NeMjcwLhdsouRk0NCwETi8be77BC2mMSFe+vZuhi5OIQEpjNKbN61
	mAnC+cUosWrrX1aQKjYBNYkvXw6DdYgImEtMWPUDrINZoJNVomfGJ0aIjquMEjOmH2cGqeIU
	sJLYc6yFDcQWFoiQuPL8MROIzSKgKtHZ+RPM5hWwlLh6+A4zhC0o8WPyPRYQm1lAS2L9zuNM
	ELa8xOY1b5khblWQ2HH2NSPEFUYSt5e+YoSoEZHY9+Id4wRGoVlIRs1CMmoWklGzkLQsYGRZ
	xSiaWpBcUJyUnmuoV5yYW1yal66XnJ+7iRGcrp5J7WBc2WBxiFGAg1GJh/fnqg2BQqyJZcWV
	uYcYJTiYlUR4X87aGCjEm5JYWZValB9fVJqTWnyIMRno04nMUqLJ+cBUmlcSb2hsYmZkaWRm
	YWRibk6asJI474FW60AhgfTEktTs1NSC1CKYLUwcnFINjNNO7jfe/rypTXI9j4Rq4n2L951X
	fjzIPdD8KzVhMvvbF+k/Uu77eca8Kp5RUfh4rqnQLovFN65x9coGLWx+x254sjp3//Yr56v2
	cSVErHvCceDpxXP/mSZYSl6qOSX6p1D1q8xD5pLlVSdTZsavO9FkskOSQ+v2jHU5V/8cedng
	/Hb3V5GDcpJKLMUZiYZazEXFiQC/abIlmwMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, April 09, 2013 1:56 AM, Jason Gunthorpe wrote:
> On Mon, Apr 08, 2013 at 06:08:53PM +0900, Jingoo Han wrote:
> 
> > I have a question.  Now, I am reviewing the Tegra PCIe, Marvell PCIe
> > patchset.  However, in the case of Exynos PCIe, 'downstream I/O' and
> > 'non-prefetchable memory' are different between PCIe0 and PCIe1.
> > These regions are not shared.
> >
> > PCIe0:
> > 	ranges = <0x00000800 0 0x40000000 0x40000000 0 0x00200000   /* configuration space */
> > 		  0x81000000 0 0	  0x40200000 0 0x00004000   /* downstream I/O */
> > 		  0x82000000 0 0	  0x40204000 0 0x10000000>; /* non-prefetchable memory */
> >
> > PCIe1:
> > 	ranges = <0x00000800 0 0x40000000 0x40000000 0 0x00200000   /* configuration space */
> > 		  0x81000000 0 0	  0x40200000 0 0x00004000   /* downstream I/O */
> > 		  0x82000000 0 0	  0x40204000 0 0x10000000>; /* non-prefetchable memory */
> >
> > PCIe0 uses 0x40000000~0x5fffffff, PCI1 uses 0x60000000~0x7fffffff.
> >
> > How can I handle this? :)
> 
> You need to dig into where this range restriction comes from, and how
> it interacts with the PCI-E root bridge's window registers. Is there
> another set of registers that control this? Is it hardwired into the
> silicon? Do the root port window registers control this?
> 
> I'm looking at functions like exynos_pcie_prog_viewport_mem_outbound
> and wondering if the driver already controls this window.. But it
> looks like there may be some restrictions.
> 
> Marvell also has unshared regions, but the driver arranges for those
> ranges to be setup dynamically based on writes to the bridge's window
> registers from the Linux PCI core, so the region is always in sync
> with what the Linux PCI core is trying to do.
> 
> The desired perfect outcome is to have a single logical 'shared'
> region for memory and I/O - give that region to the PCI core via
> struct resources, then the PCI core tells the driver and HW what
> portion of that region belongs to each root port via a write to the
> root port bridge's window registers. The net result is still
> non-overlapping regions, but the allocation of space between port 0
> and port 1 is performed at run time.
> 
> I don't really know enough about your hardware to give you better
> advice, sorry. The general guidance to try and follow the PCI-E spec
> for a root complex is good, but if the HW can't do it, or it would
> make the driver too complex, then one PCI domain per port will always
> work (this is similar to your original driver, but with domains).
> 
> The main advantage to following the PCI-E specs and allowing for
> dynamic allocation of address space is that it lets you reserve less
> address space for PCI-E, and this in turn gives you more low mem
> address space to use for DRAM.

Hi Jason Gunthorpe,

I implemented 'Single domain' with Exynos PCIe for last two months;
however, it cannot work properly due to the hardware restriction.
Each MEM region is hard-wired.

Thus, I will send Exynos PCIe V3 patch as 'Separate domains'.

Best regards,
Jingoo Han

> 
> > The following is right?
> 
> > +       pcie-controller {
> > 		.....
> > +               ranges = <0x82000000 0 0x40000000 0x40000000 0 0x00200000   /* port 0 registers */
> > +                         0x82000000 0 0x60000000 0x60000000 0 0x00200000   /* port 1 registers */
> > +                         0x81000000 0 0          0x40200000 0 0x00004000   /* port 0 downstream I/O */
> > +                         0x81000000 0 0          0x60200000 0 0x00004000   /* port 1 downstream I/O */
> > +                         0x82000000 0 0x40204000 0x40204000 0 0x10000000>; /* port 0 non-prefetchable
> memory */
> > +                         0x82000000 0 0x40204000 0x60204000 0 0x10000000>; /* port 1 non-prefetchable
> memory */
> 
> 
> > +
> > +               pci@1,0 {
> > +                       device_type = "pci";
> > +                       assigned-addresses = <0x82000800 0 0x40000000 0 0x00200000
> > +                                                 0x81000800 0 0x40200000 0 0x00004000
> > +                                                 0x81000800 0 0x40204000 0 0x10000000>;
> 
> Would be:
> 
>                        ranges = <0x81000800 0 0x40200000  0x81000800 0 0x40200000  0 0x00004000
>                                  0x81000800 0 0x40204000  0x81000800 0 0x40204000  0 0x10000000>;
>                        assigned-addresses = <0x82000800 0 0x40000000  0 0x00200000>;
> 
> Jason

