Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754619AbaGHMRY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 08:17:24 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:17881 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754547AbaGHMRQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 08:17:16 -0400
X-AuditID: cbfee691-b7f2f6d0000040c4-14-53bbe1492c34
From: Jingoo Han <jg1.han@samsung.com>
To: "'Murali Karicheri'" <m-karicheri2@ti.com>,
        "'Mohit KUMAR DCG'" <Mohit.KUMAR@st.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org,
        "'Santosh Shilimkar'" <santosh.shilimkar@ti.com>,
        "'Russell King'" <linux@arm.linux.org.uk>,
        "'Grant Likely'" <grant.likely@linaro.org>,
        "'Rob Herring'" <robh+dt@kernel.org>,
        "'Bjorn Helgaas'" <bhelgaas@google.com>,
        "'Pratyush ANAND'" <pratyush.anand@st.com>,
        "'Richard Zhu'" <r65037@freescale.com>,
        "'Kishon Vijay Abraham I'" <kishon@ti.com>,
        "'Marek Vasut'" <marex@denx.de>, "'Arnd Bergmann'" <arnd@arndb.de>,
        "'Pawel Moll'" <pawel.moll@arm.com>,
        "'Mark Rutland'" <mark.rutland@arm.com>,
        "'Ian Campbell'" <ijc+devicetree@hellion.org.uk>,
        "'Kumar Gala'" <galak@codeaurora.org>,
        "'Randy Dunlap'" <rdunlap@infradead.org>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <1404164720-11066-1-git-send-email-m-karicheri2@ti.com>
 <1404164720-11066-2-git-send-email-m-karicheri2@ti.com>
 <2CC2A0A4A178534D93D5159BF3BCB661A17A3E4282@EAPEX1MAIL1.st.com>
 <53BAD09C.8010505@ti.com>
In-reply-to: <53BAD09C.8010505@ti.com>
Subject: Re: [PATCH v3 1/5] PCI: designware: add rd[wr]_other_conf API
Date: Tue, 08 Jul 2014 21:17:13 +0900
Message-id: <000d01cf9aa6$8cdee420$a69cac60$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac+aBGOvSdcAZMfqSDWYMABQ4aHZPAAoeSTQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA5WSe0iTURjGPfsuTmn05fVkqGFaJGjeO2WF/RMfQZRJBiHonB8q6VybRhSB
	qWWKTp2lMWWpZOqciVNwWcamopblbWDzOpxp5S0tKfFGzs/Af/vvd57zPDzvCy8XsxkmnLjx
	wmRGLOQnuJHWeM/WjI/Xxck3YT5PlgDalHVaohdpceh723H0vKOXQHnz5QTSbmgA6p2tAUhf
	Pkig/ukcEulbSkn0SdFFolE9D0lztSSaf/QAoMrPAxzU8HQNoPziOhxlDh5BU3JbtDBWjKOH
	rR2WaE6qwkIcaJVCBeiM9BySXl+TAVovzeXQCnk3Tm+153HoMnUKXVO1QtKN1Z60WplF0mND
	b0la2qQE9PRqK0Z3GZo59C+1y5X9N6zPxDAJ8bcZ8YlzUdZxy1tKQjTjcmd0TUekAgPMBlZc
	SAVA6XwdYNkB9k/Uk9nAmmtDvQRQtfEY/2cqkw3tfhQDqFv9iLOPdQCn+jY4ZhdJHYUrK+2W
	ZrajwqEprZIwmzDKRMC+/szd+CiAedmyHZfVdqJ4pRYzsy11Aa429WzrXC5OecC+r85mmUed
	harlEpzlA3C1cGKHMcoT1r/u4rDsChtVC5g5Cqlj0LTpxc7gBytqu0nWYgfffVsE5hEgVWIF
	+wsHdnbGKQr+LmzD2awzVGsxduODUFdtwPMBlO9plu9plu9plu+pKAO4EtgzIoFIEh0rDvSW
	8BMlKcJYb0FSohqwZ1WgAUZtcBsQbNcXYE72gqTtsxMmR/r6B/mhwIBAf7+Tp4L+T3Zz5MWa
	oq/aULH8ZOYmw4gYcaQ4JYGRtAEO18opFVg47pNrc02Zw0a/y7qqV9e+RKlkQcbD8g8G98yY
	kSI8Z/bWtDENGTTPwpKD/6TG3Z8TjOsqApotr99T2gnDQ5dE8U7OikNFBfmui7Uzd3njl0MB
	lj75w4MJyvrZnUrwjIxJ0dTontdwPuT0YEspJ/y9RUREZ+jivO+lkU1NhhsuieP7emJiCf8v
	9e1oh2wDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupgk+LIzCtJLcpLzFFi42I5/e+xoK7nw93BBkt/m1v8nXSM3WJJU4bF
	y0OaFvOPnGO16H+zkNXiwJ8djBbnXq1ktLi88BKrxYWnPWwWl3fNYbM4O+84m8Xty7wWfb0H
	2CzetDUyWiy9fpHJYuPUX4wWE6avZbFov6Rs8XiWsMXbO9NZLFr3HmG3eN23htlBzGPNvDWM
	Hi3NPWwev39NYvS43NfL5DFv1gkWj3+H+5k8Fmwq9Vi5/Aubx+YVWh6bVnWyedy5tofNo2/L
	KkaPpz/2Mnscv7GdyePzJrkA/qgGRpuM1MSU1CKF1Lzk/JTMvHRbJe/geOd4UzMDQ11DSwtz
	JYW8xNxUWyUXnwBdt8wcoO+VFMoSc0qBQgGJxcVK+naYJoSGuOlawDRG6PqGBMH1GBmggYR1
	jBkf/61iLXgmV3H710HWBsYbEl2MnBwSAiYSCyZdY4OwxSQu3FsPZHNxCAlMZ5Q4+OMMC4Tz
	m1Hi8fk/TCBVbAJqEl++HGYHsUUEwiQeNS1lBSliFnjEKnH+QjtU+21Gif6uSWBVnEAd07+s
	ZgaxhQXcJH5sOQ0U5+BgEVCVOP9cFiTMK2ArsebjbBYIW1Dix+R7YDazgJbE+p3HmSBseYnN
	a94yg7RKCKhLPPqrC3GDkcSi1SfYIEpEJPa9eMc4gVFoFpJJs5BMmoVk0iwkLQsYWVYxiqYW
	JBcUJ6XnGukVJ+YWl+al6yXn525iBKfCZ9I7GFc1WBxiFOBgVOLhXXFwV7AQa2JZcWXuIUYJ
	DmYlEd4vp3YHC/GmJFZWpRblxxeV5qQWH2I0BfpzIrOUaHI+ME3nlcQbGpuYGVkamVkYmZib
	K4nzHmy1DhQSSE8sSc1OTS1ILYLpY+LglGpgXHbrsN0Pu0af53aM15xU+mYnC/y12hL+9sWM
	/4ekBGeIz4qNOjlZZ43J5k07Vr11+Hbtzt3kTLsXYhUHl6RP4vy/qTevti+sh1V93ZZI/Zui
	5YVzzzjO/nXmxt0nKe2nfXfbizz8uaD82dEqiQWbfPl2+KxPPcbbGRAr7rtvxb49ai9vzyyd
	EqnEUpyRaKjFXFScCADGT5I0mwMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, July 08, 2014 1:54 AM, Murali Karicheri wrote:
> On 07/07/2014 12:11 AM, Mohit KUMAR DCG wrote:
> > On Tuesday, July 01, 2014 3:15 AM, Murali Karicheri wrote:
> >>
> >> v3.65 version of the designware h/w, requires application space registers to
> >> be configured to access the remote EP config space.
> >> To support this, add rd[wr]_other_conf API in the pcie_host_opts
> >>
> >> Signed-off-by: Murali Karicheri<m-karicheri2@ti.com>
> >>
> >> CC: Santosh Shilimkar<santosh.shilimkar@ti.com>
> >> CC: Russell King<linux@arm.linux.org.uk>
> >> CC: Grant Likely<grant.likely@linaro.org>
> >> CC: Rob Herring<robh+dt@kernel.org>
> >> CC: Mohit Kumar<mohit.kumar@st.com>
> >> CC: Jingoo Han<jg1.han@samsung.com>
> >> CC: Bjorn Helgaas<bhelgaas@google.com>
> >> CC: Pratyush Anand<pratyush.anand@st.com>
> >> CC: Richard Zhu<r65037@freescale.com>
> >> CC: Kishon Vijay Abraham I<kishon@ti.com>
> >> CC: Marek Vasut<marex@denx.de>
> >> CC: Arnd Bergmann<arnd@arndb.de>
> >> CC: Pawel Moll<pawel.moll@arm.com>
> >> CC: Mark Rutland<mark.rutland@arm.com>
> >> CC: Ian Campbell<ijc+devicetree@hellion.org.uk>
> >> CC: Kumar Gala<galak@codeaurora.org>
> >> CC: Randy Dunlap<rdunlap@infradead.org>
> >> CC: Grant Likely<grant.likely@linaro.org>
> >> ---
> >>   drivers/pci/host/pcie-designware.c |   12 ++++++++++--
> >>   drivers/pci/host/pcie-designware.h |    4 ++++
> >>   2 files changed, 14 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/drivers/pci/host/pcie-designware.c b/drivers/pci/host/pcie-
> >> designware.c
> >> index 1eaf4df..d8f3af7 100644
> >> --- a/drivers/pci/host/pcie-designware.c
> >> +++ b/drivers/pci/host/pcie-designware.c
> >> @@ -656,7 +656,11 @@ static int dw_pcie_rd_conf(struct pci_bus *bus, u32
> >> devfn, int where,
> >>   	}
> >>
> >>   	if (bus->number != pp->root_bus_nr)
> >> -		ret = dw_pcie_rd_other_conf(pp, bus, devfn,
> >> +		if (pp->ops->rd_other_conf)
> >> +			ret = pp->ops->rd_other_conf(pp, bus, devfn,
> >> +						where, size, val);
> >> +		else
> >> +			ret = dw_pcie_rd_other_conf(pp, bus, devfn,
> >>   						where, size, val);
> >>   	else
> >>   		ret = dw_pcie_rd_own_conf(pp, where, size, val); @@ -
> >> 679,7 +683,11 @@ static int dw_pcie_wr_conf(struct pci_bus *bus, u32
> >> devfn,
> >>   		return PCIBIOS_DEVICE_NOT_FOUND;
> >>
> >>   	if (bus->number != pp->root_bus_nr)
> >> -		ret = dw_pcie_wr_other_conf(pp, bus, devfn,
> >> +		if (pp->ops->wr_other_conf)
> >> +			ret = pp->ops->wr_other_conf(pp, bus, devfn,
> >> +						where, size, val);
> >> +		else
> >> +			ret = dw_pcie_wr_other_conf(pp, bus, devfn,
> >>   						where, size, val);
> >>   	else
> >>   		ret = dw_pcie_wr_own_conf(pp, where, size, val); diff --git
> >> a/drivers/pci/host/pcie-designware.h b/drivers/pci/host/pcie-designware.h
> >> index 77f592f..8121901 100644
> >> --- a/drivers/pci/host/pcie-designware.h
> >> +++ b/drivers/pci/host/pcie-designware.h
> >> @@ -61,6 +61,10 @@ struct pcie_host_ops {
> >>   			u32 val, void __iomem *dbi_base);
> >>   	int (*rd_own_conf)(struct pcie_port *pp, int where, int size, u32
> >> *val);
> >>   	int (*wr_own_conf)(struct pcie_port *pp, int where, int size, u32
> >> val);
> >> +	int (*rd_other_conf)(struct pcie_port *pp, struct pci_bus *bus,
> >> +			unsigned int devfn, int where, int size, u32 *val);
> >> +	int (*wr_other_conf)(struct pcie_port *pp, struct pci_bus *bus,
> >> +			unsigned int devfn, int where, int size, u32 val);
> >>   	int (*link_up)(struct pcie_port *pp);
> >>   	void (*host_init)(struct pcie_port *pp);  };
> >
> > - Now it looks good to me.
> >
> > Acked-by: Mohit Kumar<mohit.kumar@st.com>
> >
> > Regards
> > Mohit
> >> --
> >> 1.7.9.5
> >
> Mohit,
> 
> Thanks.
> 
> Jingoo, could you provide your response or Ack?

Acked-by: Jingoo Han <jg1.han@samsung.com>

Best regards,
Jingoo Han

> 
> Thanks
> Murali
> --

