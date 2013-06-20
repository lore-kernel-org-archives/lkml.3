Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757617Ab3FTK6T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 06:58:19 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:45371 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757582Ab3FTK6R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 06:58:17 -0400
X-AuditID: cbfee691-b7fef6d000002d62-35-51c2e0474bf5
From: Jingoo Han <jg1.han@samsung.com>
To: "'Pratyush Anand'" <pratyush.anand@st.com>,
        "'Arnd Bergmann'" <arnd@arndb.de>
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
        "'Mohit KUMAR'" <Mohit.KUMAR@st.com>, Jingoo Han <jg1.han@samsung.com>
References: <003601ce6756$444e8cd0$cceba670$@samsung.com>
 <2061566.hRLrhtBK6z@wuerfel> <000901ce6838$8b514720$a1f3d560$@samsung.com>
 <28355406.ThqqvnG0Yj@wuerfel> <51C2D260.6000303@st.com>
In-reply-to: <51C2D260.6000303@st.com>
Subject: Re: [PATCH V4 1/3] pci: Add PCIe driver for Samsung Exynos
Date: Thu, 20 Jun 2013 19:58:14 +0900
Message-id: <00d701ce6da5$10216ae0$306440a0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQI6zWNfd1qFXQLUfk+Nn7DxoTtzUwCi4CKwAsXgJ3gBi4djwgIvbJkamCyRb/A=
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCKsWRmVeSWpSXmKPExsVy+t8zA133B4cCDb73CVs0/9/OavF30jF2
	iyVNGRYvD2laHJj9kNXi1ZmNbBaXF15itfh+w9Sid8FVNotNj6+xWlzeNYfN4uy842wWM87v
	Y7LYOPUXo0X7JWWLFU1bGS0WX1zObLF75RIWi2MzljBaPH3QxOQg4rFm3hpGj9+/JjF69E25
	yubxZNNFRo8Fm0o97lzbw+axeUm9x/kZCxk9vu/oBSrYsorR4+dLHY+nP/Yye3zeJBfAG8Vl
	k5Kak1mWWqRvl8CVMeVtE1vBYsmKzT8fMjUwrhDpYuTgkBAwkZi4yaqLkRPIFJO4cG89Wxcj
	F4eQwDJGiWNNR5kgEiYSM24sh0osYpTo/fiNFcL5xSgxY/sUVpAqNgE1iS9fDrODTBUR8JWY
	/8MdpIZZ4BmrxJVt/5ghGg4wSnTOOcwM0sAJ1NBwbBqYLSzgLHH52B9GEJtFQFVi1v/pYIN4
	BSwlNs8tBwnzCghK/Jh8jwXEZhbQkli/8zgThC0vsXnNW2aISxUkdpx9DTZGRMBP4ujP32wQ
	NSIS+168YwS5QUKgmVPiytoNzBC7BCS+TT7EAgkKWYlNB6DmSEocXHGDZQKjxCwkq2chWT0L
	yepZSFYsYGRZxSiaWpBcUJyUXmSqV5yYW1yal66XnJ+7iRGSgibuYLx/wPoQYzLQ+onMUqLJ
	+cAUllcSb2hsZmRhamJqbGRuaUaasJI4r3qLdaCQQHpiSWp2ampBalF8UWlOavEhRiYOTqkG
	xnKW0mpfZ9ZzM/ijKncJXC3TbON5pZrUqvtkkd/KGltLPYXQZoeIVDPjwKQJ01NkZx/p/PRR
	r74iJcv59glxmb5Tz/ZpfrpTu/GayznZr6cjP+81Cco7L5bxg+2639WZOz+v+bvzWbiH9Xb7
	Dv+3HB+Znl17fVa57/jsW9lmAhNqLqfVtE1qUGIpzkg01GIuKk4EAPrtrJdXAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrEJsWRmVeSWpSXmKPExsVy+t9jAV33B4cCDfpm8lg0/9/OavF30jF2
	iyVNGRYvD2laHJj9kNXi1ZmNbBaXF15itfh+w9Sid8FVNotNj6+xWlzeNYfN4uy842wWM87v
	Y7LYOPUXo0X7JWWLFU1bGS0WX1zObLF75RIWi2MzljBaPH3QxOQg4rFm3hpGj9+/JjF69E25
	yubxZNNFRo8Fm0o97lzbw+axeUm9x/kZCxk9vu/oBSrYsorR4+dLHY+nP/Yye3zeJBfAG9XA
	aJORmpiSWqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkD9KmSQlli
	TilQKCCxuFhJ3w7ThNAQN10LmMYIXd+QILgeIwM0kLCOMWPK2ya2gsWSFZt/PmRqYFwh0sXI
	ySEhYCIx48ZyNghbTOLCvfVANheHkMAiRonej99YIZxfjBIztk9hBaliE1CT+PLlMHsXIweH
	iICvxPwf7iA1zALPWCWubPvHDNFwgFGic85hZpAGTqCGhmPTwGxhAWeJy8f+MILYLAKqErP+
	TwcbxCtgKbF5bjlImFdAUOLH5HssIDazgJbE+p3HmSBseYnNa94yQ1yqILHj7GuwMSICfhJH
	f/5mg6gRkdj34h3jBEahWUhGzUIyahaSUbOQtCxgZFnFKJpakFxQnJSea6hXnJhbXJqXrpec
	n7uJEZzinkntYFzZYHGIUYCDUYmHV+PywUAh1sSy4srcQ4wSHMxKIrypcw4FCvGmJFZWpRbl
	xxeV5qQWH2JMBnp0IrOUaHI+MP3mlcQbGpuYGVkamVkYmZibkyasJM57oNU6UEggPbEkNTs1
	tSC1CGYLEwenVAMjo9OqVQ/0A8MPvli3MPzlRj3j827fub3VhTRrhJ9oz5itKMfxvll5SYmY
	buz2gBdzZW+us5yzseHAh7rqRa8eTfNxN9BTLxPXsH1sJu+w+2e7yZWUgso5tgFTlC7eeN42
	WWht6za/nItaltNdrP4kSH4PO3v+9oKfEYaxL3+s3ns7MylzluYaJZbijERDLeai4kQAvPJt
	NbUDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, June 20, 2013 6:59 PM, Pratyush Anand wrote:
> On 6/13/2013 7:48 PM, Arnd Bergmann wrote:
> > On Thursday 13 June 2013 22:18:50 Jingoo Han wrote:
> >> >On Wednesday, June 12, 2013 8:23 PM, Arnd Bergmann wrote:
> >>> > >On Wednesday 12 June 2013 19:19:05 Jingoo Han wrote:
> >>>> > > >+
> >>>> > > >+/* synopsis specific PCIE configuration registers*/
> >>>> > > >+#define PCIE_PORT_LINK_CONTROL		0x710
> >>>> > > >+#define PORT_LINK_MODE_MASK		(0x3f << 16)
> >>>> > > >+#define PORT_LINK_MODE_4_LANES		(0x7 << 16)
> >>> > >
> >>> > >Do you mean this is a "Synopsys" designware part? In that case it
> >>> > >should really not be called "exynos-pcie" but "designware-pcie"
> >>> > >and you should make sure that the driver makes no assumptions about
> >>> > >the platform. A lot of other platforms also use designware
> >>> > >parts and should be able to reuse this driver.
> >> >
> >> >Sorry, I don't think so.
> >> >Only core block is a "Synopsys" designware part IP block,
> >> >other parts are Exynos-specific.
> >> >So, it is hard to share with other PCIe IPs using synopsis core.
> > Just call it synopsys anyway and put a comment in to explain this.
> > That should be enough for the next person with a synopsys PCI core
> > to reuse your code and split out the exynos specific parts into a
> > separate file.
> >
> 
> I agree to Arnd that this patch should be split. I had worked in past
> with SPEAr PCIe which also had designware PCIe IP. I see some code which
> will fit both in SPEAr as well as in exynos. Unfortunately, I was not
> able to get SPEAr driver pushed to mainline, as I moved to some other
> project and got heavily occupied.

Oh, I see.

How about this?
At the next PATCH v7, I will change the file name from 'pci-exynos.c'
to 'pci-designware.c', as Arnd mentioned.

Then, when Spear or other platform using designware is submitted,
this 'pci-designware.c' will be split to two separate files such as
'pci-designware.c' and 'pci-exynos.c'.


Best regards,
Jingoo Han

> 
> Last patch is here:
> 
> https://patchwork.kernel.org/patch/1661441/
> 
> Infact, these functions should be common to all arm platforms.
> 
> sys_to_pcie
> cfg_read
> cfg_write
> 
> Following functions should be common to all designware based driver (at
> least they are same in SPEAr)
> 
> exynos_pcie_prog_viewport_cfg0
> exynos_pcie_prog_viewport_cfg1
> exynos_pcie_rd_other_conf
> exynos_pcie_wr_other_conf
> exynos_pcie_setup
> exynos_pcie_valid_config
> exynos_pcie_rd_conf
> exynos_pcie_wd_conf
> exynos_pcie_scan_bus
> exynos_pcie_map_irq
> add_pcie_port (after a bit of generalization)
> exynos_pcie_probe
> exynos_pcie_remove
> 
> 
> 
> Following should be specific to exynos:
> 
> exynos_pcie_rd_own_conf
> exynos_pcie_wr_own_conf
> exynos_pcie_link_up
> exynos_pcie_setup_rc
> exynos_pcie_assert_core_reset
> exynos_pcie_deassert_core_reset
> exynos_pcie_assert_phy_reset
> exynos_pcie_deassert_phy_reset
> exynos_pcie_init_phy
> exynos_pcie_assert_reset
> exynos_pcie_establish_link
> exynos_pcie_host_init
> 
> 
> 
> struct pcie_port_info and struct pcie_port can also be standardized.
> 
> Regards
> Pratyush

