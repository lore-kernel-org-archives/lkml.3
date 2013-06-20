Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965427Ab3FTLgI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 07:36:08 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:11451 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965241Ab3FTLgD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 07:36:03 -0400
X-AuditID: cbfee68f-b7f436d000000f81-3d-51c2e9212356
From: Jingoo Han <jg1.han@samsung.com>
To: "'Pratyush Anand'" <pratyush.anand@st.com>,
        "'Arnd Bergmann'" <arnd@arndb.de>,
        "'Mohit KUMAR'" <Mohit.KUMAR@st.com>
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
References: <003601ce6756$444e8cd0$cceba670$@samsung.com>
 <2061566.hRLrhtBK6z@wuerfel> <000901ce6838$8b514720$a1f3d560$@samsung.com>
 <28355406.ThqqvnG0Yj@wuerfel> <51C2D260.6000303@st.com>
 <00d701ce6da5$10216ae0$306440a0$@samsung.com> <51C2E6E5.1050001@st.com>
In-reply-to: <51C2E6E5.1050001@st.com>
Subject: Re: [PATCH V4 1/3] pci: Add PCIe driver for Samsung Exynos
Date: Thu, 20 Jun 2013 20:36:01 +0900
Message-id: <00d901ce6daa$56ffb6b0$04ff2410$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQI6zWNfd1qFXQLUfk+Nn7DxoTtzUwCi4CKwAsXgJ3gBi4djwgIvbJkaAjJkBM0ClubWPpgGT7Bg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrOKsWRmVeSWpSXmKPExsVy+t8zA13Fl4cCDRpnqVo0/9/OavF30jF2
	iyVNGRYvD2laHJj9kNXi1ZmNbBaXF15itfh+w9Sid8FVNotNj6+xWlzeNYfN4uy842wWM87v
	Y7LYOPUXo0X7JWWLFU1bGS0WX1zObLF75RIWi2MzljBaPH3QxOQg4rFm3hpGj9+/JjF69E25
	yubxZNNFRo8Fm0o97lzbw+axeUm9x/kZCxk9vu/oBSrYsorR4+dLHY+nP/Yye3zeJBfAG8Vl
	k5Kak1mWWqRvl8CVsaaznbWgSb7i9/bt7A2M1yW6GDk5JARMJC48amWEsMUkLtxbz9bFyMUh
	JLCMUaJl91MmmKKuY+egEosYJfbt+Arl/GKUWHhuOitIFZuAmsSXL4fZQWwRgWKJNbMeMYMU
	MQscYJWYf2M6C0RHF5NE65a3YAs5gTquXOoC6xYWcJa4fOwPWJxFQFXi984lYJN4BSwlGtd2
	sEHYghI/Jt9jAbGZBbQk1u88zgRhy0tsXvOWGeJWBYkdZ18zQlwRI3H2ezcrRI2IxL4X7xhB
	jpAQ+M8h8WjHRnaIZQIS3yYfAhrKAZSQldh0AGqOpMTBFTdYJjBKzEKyehaS1bOQrJ6FZMUC
	RpZVjKKpBckFxUnpRcZ6xYm5xaV56XrJ+bmbGCGJqH8H490D1ocYk4HWT2SWEk3OByayvJJ4
	Q2MzIwtTE1NjI3NLM9KElcR51VqsA4UE0hNLUrNTUwtSi+KLSnNSiw8xMnFwSjUwqurob8uv
	6gtYutmiP8N/n9wvFoXu0ndbJktcdlO+4+wiZOEQeK9MOa40IPe6aEr9ubDEaQKFaXtLP8/t
	yUt3q+6csHNrvrPH6S8huss7duketnebyCE46XbTPdOHTY8PT9ArV515ok500/SK6/9mftc4
	5SAeo6iitD57+sMZ//g3VtvMc2ZXYinOSDTUYi4qTgQAOsxklFoDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrCJsWRmVeSWpSXmKPExsVy+t9jAV3Fl4cCDdZ1y1k0/9/OavF30jF2
	iyVNGRYvD2laHJj9kNXi1ZmNbBaXF15itfh+w9Sid8FVNotNj6+xWlzeNYfN4uy842wWM87v
	Y7LYOPUXo0X7JWWLFU1bGS0WX1zObLF75RIWi2MzljBaPH3QxOQg4rFm3hpGj9+/JjF69E25
	yubxZNNFRo8Fm0o97lzbw+axeUm9x/kZCxk9vu/oBSrYsorR4+dLHY+nP/Yye3zeJBfAG9XA
	aJORmpiSWqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkD9KmSQlli
	TilQKCCxuFhJ3w7ThNAQN10LmMYIXd+QILgeIwM0kLCOMWNNZztrQZN8xe/t29kbGK9LdDFy
	ckgImEh0HTvHBmGLSVy4tx7I5uIQEljEKLFvx1co5xejxMJz01lBqtgE1CS+fDnMDmKLCBRL
	rJn1iBmkiFngAKvE/BvTWSA6upgkWre8ZQSp4gTquHKpC6xbWMBZ4vKxP2BxFgFVid87l4BN
	4hWwlGhc28EGYQtK/Jh8jwXEZhbQkli/8zgThC0vsXnNW2aIWxUkdpx9zQhxRYzE2e/drBA1
	IhL7XrxjnMAoNAvJqFlIRs1CMmoWkpYFjCyrGEVTC5ILipPSc430ihNzi0vz0vWS83M3MYLT
	3DPpHYyrGiwOMQpwMCrx8GpcPhgoxJpYVlyZe4hRgoNZSYQ3dc6hQCHelMTKqtSi/Pii0pzU
	4kOMyUCfTmSWEk3OB6bgvJJ4Q2MTMyNLIzMLIxNzc9KElcR5D7ZaBwoJpCeWpGanphakFsFs
	YeLglGpgFHogeb7VwOHE8j8zTmb6NZz6uM9g/vPjh2Jepf1LeGrCqH/3uuGikK2uD7RCPtVV
	Z561fLTF6iqbcFfnWoVexjCrW7eOpzXPjpz1Yl/aMsufJUf4b72NkZl0OdBnzcat0Qv7uA4k
	/BNbcjf5xMGpT9eaXXbnEPjy3+BIgJbE1ed/rn+PdI3PvabEUpyRaKjFXFScCAAQEBG6twMA	AA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, June 20, 2013 8:26 PM, Pratyush Anand wrote:
> On 6/20/2013 4:28 PM, Jingoo Han wrote:
> > On Thursday, June 20, 2013 6:59 PM, Pratyush Anand wrote:
> >> On 6/13/2013 7:48 PM, Arnd Bergmann wrote:
> >>> On Thursday 13 June 2013 22:18:50 Jingoo Han wrote:
> >>>>> On Wednesday, June 12, 2013 8:23 PM, Arnd Bergmann wrote:
> >>>>>>> On Wednesday 12 June 2013 19:19:05 Jingoo Han wrote:
> >>>>>>>>> +
> >>>>>>>>> +/* synopsis specific PCIE configuration registers*/
> >>>>>>>>> +#define PCIE_PORT_LINK_CONTROL		0x710
> >>>>>>>>> +#define PORT_LINK_MODE_MASK		(0x3f << 16)
> >>>>>>>>> +#define PORT_LINK_MODE_4_LANES		(0x7 << 16)
> >>>>>>>
> >>>>>>> Do you mean this is a "Synopsys" designware part? In that case it
> >>>>>>> should really not be called "exynos-pcie" but "designware-pcie"
> >>>>>>> and you should make sure that the driver makes no assumptions about
> >>>>>>> the platform. A lot of other platforms also use designware
> >>>>>>> parts and should be able to reuse this driver.
> >>>>>
> >>>>> Sorry, I don't think so.
> >>>>> Only core block is a "Synopsys" designware part IP block,
> >>>>> other parts are Exynos-specific.
> >>>>> So, it is hard to share with other PCIe IPs using synopsis core.
> >>> Just call it synopsys anyway and put a comment in to explain this.
> >>> That should be enough for the next person with a synopsys PCI core
> >>> to reuse your code and split out the exynos specific parts into a
> >>> separate file.
> >>>
> >>
> >> I agree to Arnd that this patch should be split. I had worked in past
> >> with SPEAr PCIe which also had designware PCIe IP. I see some code which
> >> will fit both in SPEAr as well as in exynos. Unfortunately, I was not
> >> able to get SPEAr driver pushed to mainline, as I moved to some other
> >> project and got heavily occupied.
> >
> > Oh, I see.
> >
> > How about this?
> > At the next PATCH v7, I will change the file name from 'pci-exynos.c'
> > to 'pci-designware.c', as Arnd mentioned.
> >
> > Then, when Spear or other platform using designware is submitted,
> > this 'pci-designware.c' will be split to two separate files such as
> > 'pci-designware.c' and 'pci-exynos.c'.
> >
> 
> For me it's OK. Let it go to mainline as Arnd mentioned.
> Please keep Mohit in mail chain, who might have some bandwidth to
> further add and follow up for SPEAr on top of your patches.

Dear Pratyush Anand,

Thank you for accepting the suggestion. :)
OK, I will keep Mohit in main chain.


Best regards,
Jingoo Han

> 
> Regards
> Pratyush
> 
> >
> > Best regards,
> > Jingoo Han
> >
> >>
> >> Last patch is here:
> >>
> >> https://patchwork.kernel.org/patch/1661441/
> >>
> >> Infact, these functions should be common to all arm platforms.
> >>
> >> sys_to_pcie
> >> cfg_read
> >> cfg_write
> >>
> >> Following functions should be common to all designware based driver (at
> >> least they are same in SPEAr)
> >>
> >> exynos_pcie_prog_viewport_cfg0
> >> exynos_pcie_prog_viewport_cfg1
> >> exynos_pcie_rd_other_conf
> >> exynos_pcie_wr_other_conf
> >> exynos_pcie_setup
> >> exynos_pcie_valid_config
> >> exynos_pcie_rd_conf
> >> exynos_pcie_wd_conf
> >> exynos_pcie_scan_bus
> >> exynos_pcie_map_irq
> >> add_pcie_port (after a bit of generalization)
> >> exynos_pcie_probe
> >> exynos_pcie_remove
> >>
> >>
> >>
> >> Following should be specific to exynos:
> >>
> >> exynos_pcie_rd_own_conf
> >> exynos_pcie_wr_own_conf
> >> exynos_pcie_link_up
> >> exynos_pcie_setup_rc
> >> exynos_pcie_assert_core_reset
> >> exynos_pcie_deassert_core_reset
> >> exynos_pcie_assert_phy_reset
> >> exynos_pcie_deassert_phy_reset
> >> exynos_pcie_init_phy
> >> exynos_pcie_assert_reset
> >> exynos_pcie_establish_link
> >> exynos_pcie_host_init
> >>
> >>
> >>
> >> struct pcie_port_info and struct pcie_port can also be standardized.
> >>
> >> Regards
> >> Pratyush
> >
> > .
> >


