Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753738AbaEHJFW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 05:05:22 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:48463 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752769AbaEHJFR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 05:05:17 -0400
X-AuditID: cbfee691-b7f3e6d000002ce8-6c-536b48c74c01
From: Jingoo Han <jg1.han@samsung.com>
To: "'Arnd Bergmann'" <arnd@arndb.de>,
        "'Kishon Vijay Abraham I'" <kishon@ti.com>
Cc: "'Santosh Shilimkar'" <santosh.shilimkar@ti.com>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org, linux-pci@vger.kernel.org, rogerq@ti.com,
        balajitk@ti.com, "'Bjorn Helgaas'" <bhelgaas@google.com>,
        "'Marek Vasut'" <marex@denx.de>, "'Jingoo Han'" <jg1.han@samsung.com>
References: <1399383244-14556-1-git-send-email-kishon@ti.com>
 <1399383244-14556-7-git-send-email-kishon@ti.com> <4764413.ZAEU5S5p0p@wuerfel>
In-reply-to: <4764413.ZAEU5S5p0p@wuerfel>
Subject: Re: [PATCH 06/17] pci: host: pcie-designware: Use *base-mask* for
 configuring the iATU
Date: Thu, 08 May 2014 18:05:11 +0900
Message-id: <000201cf6a9c$9dd295e0$d977c1a0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac9pM45g6Aw8kLK1TcC/vqVRcMtQqgBZ/Btg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupmleLIzCtJLcpLzFFi42I5/e+Zke5xj+xggxNLzC3+TjrGbjF18nY2
	iyVNGRbzj5xjtbi88BKrxYWnPWwWmx5fY7VY2LaExeLyrjlsFrOX9LNYnJ13nM3iTVsjo0XP
	Iy2L131rmB34PH7/msToMW/WCRaPBZtKPTYvqffo27KK0eP4je1MHp83yQWwR3HZpKTmZJal
	FunbJXBlbGk8w1zwk6ei+95K1gbGzVxdjJwcEgImEus7HjJD2GISF+6tZwOxhQSWMUr0bTaB
	qen9/w4ozgUUn84o8erId3YI5zejRO/trewgVWwCahJfvhwGs0UEfCVOzdrHDFLELPCDSWLG
	htVMEB19jBI3rh5k7WLk4OAU0JTY+8oHpEFYIFHi2NlLYM0sAqoSh1f+ADuDV8BWYsP0Z6wQ
	tqDEj8n3WEBsZgEtifU7jzNB2PISm9e8ZQYZKSGgLvHory7EDUYSTR9/QJWISOx78Y4R5AQJ
	gZUcEq8arjJD7BKQ+Db5EAtEr6zEpgPQkJCUOLjiBssERolZSDbPQrJ5FpLNs5CsWMDIsopR
	NLUguaA4Kb3IVK84Mbe4NC9dLzk/dxMjJCFM3MF4/4D1IcZkoPUTmaVEk/OBCSWvJN7Q2MzI
	wtTE1NjI3NKMNGElcd70R0lBQgLpiSWp2ampBalF8UWlOanFhxiZODilGhjX9em6hrKsfNx1
	fL1rQt6BF3N4nz08n/3MwfW3iP2uRDFZuQvNR+9mGHz/rDqpSMDzwqOn9TMO+jw8t9Nt90uL
	7zITFGddfnmptt6Gy3FBUxdb6eRpatbmctcmtF88ol+4a+6D9JuRVl81jSfdM1t/vnlSoJnb
	jEqNA+YdKXO0p0tM9XjXuEVFiaU4I9FQi7moOBEAEUWYcB4DAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrJKsWRmVeSWpSXmKPExsVy+t9jQd3jHtnBBk17DS3+TjrGbjF18nY2
	iyVNGRbzj5xjtbi88BKrxYWnPWwWmx5fY7VY2LaExeLyrjlsFrOX9LNYnJ13nM3iTVsjo0XP
	Iy2L131rmB34PH7/msToMW/WCRaPBZtKPTYvqffo27KK0eP4je1MHp83yQWwRzUw2mSkJqak
	Fimk5iXnp2TmpdsqeQfHO8ebmhkY6hpaWpgrKeQl5qbaKrn4BOi6ZeYAHaykUJaYUwoUCkgs
	LlbSt8M0ITTETdcCpjFC1zckCK7HyAANJKxjzNjSeIa54CdPRfe9lawNjJu5uhg5OSQETCR6
	/79jg7DFJC7cWw9kc3EICUxnlHh15Ds7hPObUaL39lZ2kCo2ATWJL18Og9kiAr4Sp2btYwYp
	Yhb4wSQxY8NqJoiOPkaJG1cPsnYxcnBwCmhK7H3lA9IgLJAocezsJbBmFgFVicMrf4Ct5hWw
	ldgw/RkrhC0o8WPyPRYQm1lAS2L9zuNMELa8xOY1b5lBRkoIqEs8+qsLcYORRNPHH1AlIhL7
	XrxjnMAoNAvJpFlIJs1CMmkWkpYFjCyrGEVTC5ILipPSc430ihNzi0vz0vWS83M3MYITzjPp
	HYyrGiwOMQpwMCrx8GY4ZwULsSaWFVfmHmKU4GBWEuFNc8wOFuJNSaysSi3Kjy8qzUktPsSY
	DPToRGYp0eR8YDLMK4k3NDYxM7I0MrMwMjE3J01YSZz3YKt1oJBAemJJanZqakFqEcwWJg5O
	qQbGMJ/CUtUps2/Hq65nmTyna6da1+Ib9es9+xnmTCprXtRV1yazMsmPJeWvadHT2YsdZ5iZ
	33CK3t9ifioxwvk90/o/+a9+f5s0P7/NdKGJ0rPOui0r395klj2j2Cm0xrvGJ+J2+vz2O042
	JxcIKT29WD+pvfIhk9SkNU5RRndSJBdYsvEY64kosRRnJBpqMRcVJwIADx6GLnwDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, May 06, 2014 10:59 PM, Arnd Bergmann wrote:
> On Tuesday 06 May 2014 19:03:52 Kishon Vijay Abraham I wrote:
> > In DRA7, the cpu sees 32bit address, but the pcie controller can see only 28bit
> > address. So whenever the cpu issues a read/write request, the 4 most
> > significant bits are used by L3 to determine the target controller.
> > For example, the cpu reserves 0x2000_0000 - 0x2FFF_FFFF for PCIe controller but
> > the PCIe controller will see only (0x000_0000 - 0xFFF_FFF). So for programming
> > the outbound translation window the *base* should be programmed as 0x000_0000.
> > Whenever we try to write to say 0x2000_0000, it will be translated to whatever
> > we have programmed in the translation window with base as 0x000_0000.
> >
> > Cc: Bjorn Helgaas <bhelgaas@google.com>
> > Cc: Marek Vasut <marex@denx.de>
> > Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
> > Acked-by: Jingoo Han <jg1.han@samsung.com>
> > Acked-by: Mohit Kumar <mohit.kumar@st.com>
> 
> Sorry, but NAK.
> 
> We have a standard 'dma-ranges' property to handle this, so use it.
> 
> See the x-gene PCIe driver patches for an example. Please also talk
> to Santosh about it, as he is implementing generic support for
> parsing dma-ranges in platform devices at the moment.

Hi Arnd,

Do you mean the following patch?
http://www.spinics.net/lists/kernel/msg1737725.html

Thank you.

Best regards,
Jingoo Han

> 
> I also suspect you will have to implement swiotlb support to make
> generic PCI devices work behind this bridge. Otherwise you end up
> with random physical addresses passed into DMA registers.


