Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756822Ab3JIJRa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 05:17:30 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:62993 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751424Ab3JIJR1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 05:17:27 -0400
X-AuditID: cbfee68d-b7fe86d0000077a5-7e-52551f251ecc
From: Jingoo Han <jg1.han@samsung.com>
To: "'Kishon Vijay Abraham I'" <kishon@ti.com>
Cc: "'Bjorn Helgaas'" <bhelgaas@google.com>, linux-pci@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Pratyush Anand'" <pratyush.anand@st.com>,
        "'Mohit KUMAR'" <Mohit.KUMAR@st.com>,
        "'Siva Reddy Kallam'" <siva.kallam@samsung.com>,
        "'SRIKANTH TUMKUR SHIVANAND'" <ts.srikanth@samsung.com>,
        "'Arnd Bergmann'" <arnd@arndb.de>, "'Sean Cross'" <xobs@kosagi.com>,
        "'Thierry Reding'" <thierry.reding@gmail.com>,
        "'Thomas Petazzoni'" <thomas.petazzoni@free-electrons.com>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <000401cec4c6$dc415180$94c3f480$%han@samsung.com>
 <52551C6E.1040404@ti.com>
In-reply-to: <52551C6E.1040404@ti.com>
Subject: Re: [PATCH] PCI: designware: Add irq_create_mapping()
Date: Wed, 09 Oct 2013 18:17:24 +0900
Message-id: <003901cec4d0$5d83e650$188bb2f0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Content-language: ko
Thread-index: Ac7EzsnnQGQIkUxoTmaN/6N9rmGS1wAAYnCA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrMKsWRmVeSWpSXmKPExsVy+t8zY11V+dAgg+23WC3+TjrGbrGkKcPi
	5SFNi/lHzrFaXF54idWid8FVNosLT3vYLC7vmsNmcXbecTaLGef3MVlsnPqL0aL9krLFiqat
	jBY/d81jsXj6oInJovHoA1aL1icPGB0EPX7/msTo8WTTRUaPnbPusnss2FTq8X3hfHaPvi2r
	GD2e/tjL7HH8xnYmj8+b5AI4o7hsUlJzMstSi/TtErgyNh77ylzwjrvizgfBBsZznF2MnBwS
	AiYSt289ZYGwxSQu3FvP1sXIxSEksIxRYtLjmUwwRXcObWOGSExnlNhx7xlU1S9GiaUPOthA
	qtgE1CS+fDnMDmKLCOhILDy9nhnEZha4ySJx66UqiC0kECmx7Xkj2DpOoPqWX51gG4QF7CSa
	Nn4Bm8MioCox4/BaRhCbV8BW4tiezewQtqDEj8n3WCBmakms33mcCcKWl9i85i3QLg6gS9Ul
	Hv3VhQiLSOx78Y4R4hwjiQ+zNoA9ICFwhkNi/4c3zBC7BCS+TT7EAtErK7HpADPEw5ISB1fc
	YJnAKDELyeZZSDbPQrJ5FpJ1CxhZVjGKphYkFxQnpRcZ6hUn5haX5qXrJefnbmKEJJDeHYy3
	D1gfYkwGWj+RWUo0OR+YgPJK4g2NzYwsTE1MjY3MLc1IE1YS51VrsQ4UEkhPLEnNTk0tSC2K
	LyrNSS0+xMjEwSnVwKg7T1wpbc/H3ZZyBZXFn1sP3uS+s/BghvhkufXCkx4ej1r5I/LcpSuc
	e2XNdB4cqZ76xHaL2kGG7iSTJg+t45WNG+9v49u4q+zcbqsdm1LLrs0M+Lt+4sK9ntcZRfpT
	GfiPzj+uyTvHfo1Il43Zspn3p3/Y8edj5Pnr1f4xyzW/98nYdAa3tUUrsRRnJBpqMRcVJwIA
	Y7fz0DYDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpgk+LIzCtJLcpLzFFi42I5/e+xoK6KfGiQwfyjkhZ/Jx1jt1jSlGHx
	8pCmxfwj51gtLi+8xGrRu+Aqm8WFpz1sFpd3zWGzODvvOJvFjPP7mCw2Tv3FaNF+SdliRdNW
	Roufu+axWDx90MRk0Xj0AatF65MHjA6CHr9/TWL0eLLpIqPHzll32T0WbCr1+L5wPrtH35ZV
	jB5Pf+xl9jh+YzuTx+dNcgGcUQ2MNhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaGuoaWFuZK
	CnmJuam2Si4+AbpumTlAnygplCXmlAKFAhKLi5X07TBNCA1x07WAaYzQ9Q0JgusxMkADCesY
	MzYe+8pc8I674s4HwQbGc5xdjJwcEgImEncObWOGsMUkLtxbz9bFyMUhJDCdUWLHvWdQzi9G
	iaUPOthAqtgE1CS+fDnMDmKLCOhILDy9HqybWeAmi8Stl6ogtpBApMS2540sIDYnUH3Lr04m
	EFtYwE6iaeMXsDksAqoSMw6vZQSxeQVsJY7t2cwOYQtK/Jh8jwVippbE+p3HmSBseYnNa94C
	7eIAulRd4tFfXYiwiMS+F+8YIc4xkvgwawPzBEahWUgmzUIyaRaSSbOQtC9gZFnFKJpakFxQ
	nJSea6RXnJhbXJqXrpecn7uJEZyenknvYFzVYHGIUYCDUYmH9wF/SJAQa2JZcWXuIUYJDmYl
	Ed71UqFBQrwpiZVVqUX58UWlOanFhxiTgR6dyCwlmpwPTJ15JfGGxiZmRpZGZhZGJubmpAkr
	ifMebLUOFBJITyxJzU5NLUgtgtnCxMEp1cAYM5lDb+W91C3bOiPOvumOuVTt7hMy7fsvFpfJ
	q/Mt/aJtPYTXbzpWHmXUc+xw4e+JYiatfo9P7P9z0M/87qVI83OTVtntYK7eVR0Ybm7+5v7Z
	oGOa3/lTVuo8PP5wW+g678NvbjquvvdywhH7Q/IVp1Y/i3k8t/CaaWeCyK0nkVwJxze82G+4
	SYmlOCPRUIu5qDgRABv0dfOTAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, October 09, 2013 6:06 PM, Kishon Vijay Abraham I wrote:
> On Wednesday 09 October 2013 01:39 PM, Jingoo Han wrote:
> > Without irq_create_mapping(), the correct irq number cannot be
> > provided. In this case, it makes problem such as NULL deference.
> > Thus, irq_create_mapping() should be added for MSI.
> >
> > Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> > Cc: Kishon Vijay Abraham I <kishon@ti.com>
> > ---
> > Tested on Exynos5440.
> >
> >  drivers/pci/host/pcie-designware.c |   10 ++++------
> >  drivers/pci/host/pcie-designware.h |    1 +
> >  2 files changed, 5 insertions(+), 6 deletions(-)
> >
> > diff --git a/drivers/pci/host/pcie-designware.c b/drivers/pci/host/pcie-designware.c
> > index 8963017..e536bb6 100644
> > --- a/drivers/pci/host/pcie-designware.c
> > +++ b/drivers/pci/host/pcie-designware.c
> > @@ -237,6 +237,8 @@ static int assign_irq(int no_irqs, struct msi_desc *desc, int *pos)
> >  		}
> >  	}
> >
> > +	pp->msi_irq_start = irq_create_mapping(pp->irq_domain, 0);
> > +
> 
> I think irq_create_mapping should be done for all the MSI irq lines instead of
> only the first line. So you might have to do for MAX_MSI_IRQS lines.

I tested PCIe LAN card after I replaced 0 with MAX_MSI_IRQS.
However, it makes an error message as below:
But, PCIe LAN card works properly.

WARNING: CPU: 1 PID: 1 at kernel/irq/irqdomain.c:276 irq_domain_associate+0x150/0x1a8()
error: hwirq 0x20 is too large for (null)

Best regards,
Jingoo Han

