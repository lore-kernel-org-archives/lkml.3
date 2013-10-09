Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757093Ab3JIKFi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 06:05:38 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:62369 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753079Ab3JIKFe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 06:05:34 -0400
X-AuditID: cbfee68e-b7f756d000004512-a9-52552a6487b5
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
 <52551C6E.1040404@ti.com> <003901cec4d0$5d83e650$188bb2f0$%han@samsung.com>
 <5255266B.6040809@ti.com>
In-reply-to: <5255266B.6040809@ti.com>
Subject: Re: [PATCH] PCI: designware: Add irq_create_mapping()
Date: Wed, 09 Oct 2013 19:05:24 +0900
Message-id: <000501cec4d7$1233a3f0$369aebd0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac7E1L1l3uG9QP0WQlCEdfLt9V9DOQAAkNqg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrCKsWRmVeSWpSXmKPExsVy+t8zA90UrdAgg4Wf1S3+TjrGbrGkKcPi
	5SFNi/lHzrFaXF54idWid8FVNosLT3vYLC7vmsNmcXbecTaLGef3MVlsnPqL0aL9krLFiqat
	jBY/d81jsXj6oInJovHoA1aL1icPGB0EPX7/msTo8WTTRUaPnbPusnss2FTq8X3hfHaPvi2r
	GD2e/tjL7HH8xnYmj8+b5AI4o7hsUlJzMstSi/TtErgyuve9Yi94K1jR0zaPpYFxJV8XIweH
	hICJxI1mwS5GTiBTTOLCvfVsXYxcHEICyxglti1tYIFImEicODOXESKxiFFi66nDTBDOL0aJ
	zSvnsYNUsQmoSXz5chjMFhHQkVh4ej0ziM0scJNF4tZLVYiG5YwSF54tACviBGrYdmMdI4gt
	LGAn0bTxCxuIzSKgKjH10WSw1bwCthI/jp6DsgUlfky+xwIxVEti87YmVghbXmLzmrfMEO+o
	Szz6qwtxg5HE+YsfmCBKRCT2vXgH9oGEwBkOiY1tU6F2CUh8m3yIBaJXVmLTAWaIjyUlDq64
	wTKBUWIWks2zkGyehWTzLCQrFjCyrGIUTS1ILihOSi8y0itOzC0uzUvXS87P3cQISSF9Oxhv
	HrA+xJgMtH4is5Rocj4wBeWVxBsamxlZmJqYGhuZW5qRJqwkzqvWYh0oJJCeWJKanZpakFoU
	X1Sak1p8iJGJg1OqgVE3JFm/M+Yxl3luxRKnDQXR3dNWyrLu4g2P3X3C2fK7x9SdNXOW/Fpg
	3mSzLEKVqUDQ+4x9jPzV2qNn+Hc5rX2cvujZvkArhS16u5nLJ2zT5D8XYPLz+f+Tc+wq7QQK
	e6ZkA0N80taTP4uelJru+Gxt5+J52I53q9i2Y0YmTVPEIz984WG9rsRSnJFoqMVcVJwIAKET
	PeI3AwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpik+LIzCtJLcpLzFFi42I5/e+xgG6KVmiQwclXihZ/Jx1jt1jSlGHx
	8pCmxfwj51gtLi+8xGrRu+Aqm8WFpz1sFpd3zWGzODvvOJvFjPP7mCw2Tv3FaNF+SdliRdNW
	Roufu+axWDx90MRk0Xj0AatF65MHjA6CHr9/TWL0eLLpIqPHzll32T0WbCr1+L5wPrtH35ZV
	jB5Pf+xl9jh+YzuTx+dNcgGcUQ2MNhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaGuoaWFuZK
	CnmJuam2Si4+AbpumTlAnygplCXmlAKFAhKLi5X07TBNCA1x07WAaYzQ9Q0JgusxMkADCesY
	M7r3vWIveCtY0dM2j6WBcSVfFyMnh4SAicSJM3MZIWwxiQv31rN1MXJxCAksYpTYeuowE4Tz
	i1Fi88p57CBVbAJqEl++HAazRQR0JBaeXs8MYjML3GSRuPVSFaJhOaPEhWcLwIo4gRq23VgH
	tkJYwE6iaeMXNhCbRUBVYuqjySwgNq+ArcSPo+egbEGJH5PvsUAM1ZLYvK2JFcKWl9i85i3Q
	Mg6gU9UlHv3VhbjBSOL8xQ9MECUiEvtevGOcwCg0C8mkWUgmzUIyaRaSlgWMLKsYRVMLkguK
	k9JzjfSKE3OLS/PS9ZLzczcxglPUM+kdjKsaLA4xCnAwKvHwPuAPCRJiTSwrrsw9xCjBwawk
	wrteKjRIiDclsbIqtSg/vqg0J7X4EGMy0KMTmaVEk/OB6TOvJN7Q2MTMyNLIzMLIxNycNGEl
	cd6DrdaBQgLpiSWp2ampBalFMFuYODilGhgFt6y5L3WjKpBR0WtLyBrn3QEsyz4l1NhPk1oc
	+5Jz842LinWTVh3fefcvc00vv9yWQPOXM7coBGz4KSAuXsSRsb1GNexF96fDAjVKPK9q59hO
	MI98nftGwCnGcYOo8KnCsKeJHT8YtnPvOsqwlF1BfEkx47ueOs8fMl1hwfZTWp2fv1554osS
	S3FGoqEWc1FxIgCV/DYblQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, October 09, 2013 6:48 PM, Kishon Vijay Abraham I wrote:
> On Wednesday 09 October 2013 02:47 PM, Jingoo Han wrote:
> > On Wednesday, October 09, 2013 6:06 PM, Kishon Vijay Abraham I wrote:
> >> On Wednesday 09 October 2013 01:39 PM, Jingoo Han wrote:
> >>> Without irq_create_mapping(), the correct irq number cannot be
> >>> provided. In this case, it makes problem such as NULL deference.
> >>> Thus, irq_create_mapping() should be added for MSI.
> >>>
> >>> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> >>> Cc: Kishon Vijay Abraham I <kishon@ti.com>
> >>> ---
> >>> Tested on Exynos5440.
> >>>
> >>>  drivers/pci/host/pcie-designware.c |   10 ++++------
> >>>  drivers/pci/host/pcie-designware.h |    1 +
> >>>  2 files changed, 5 insertions(+), 6 deletions(-)
> >>>
> >>> diff --git a/drivers/pci/host/pcie-designware.c b/drivers/pci/host/pcie-designware.c
> >>> index 8963017..e536bb6 100644
> >>> --- a/drivers/pci/host/pcie-designware.c
> >>> +++ b/drivers/pci/host/pcie-designware.c
> >>> @@ -237,6 +237,8 @@ static int assign_irq(int no_irqs, struct msi_desc *desc, int *pos)
> >>>  		}
> >>>  	}
> >>>
> >>> +	pp->msi_irq_start = irq_create_mapping(pp->irq_domain, 0);
> >>> +
> >>
> >> I think irq_create_mapping should be done for all the MSI irq lines instead of
> >> only the first line. So you might have to do for MAX_MSI_IRQS lines.
> 
> Maybe it should be only till MAX_MSI_IRQS-1?

I am not sure; however, it doesn't look correct.

irq_create_mapping() is defined as below.
According to the comment, irq_create_mapping() maps 'a' hardware interrupt,
not max value of MSI IRQ lines.

./kernel/irq/irqdomain.c
/**
 * irq_create_mapping() - Map a hardware interrupt into linux irq space
 * @domain: domain owning this hardware interrupt or NULL for default domain
 * @hwirq: hardware irq number in that domain space
[.....]
unsigned int irq_create_mapping(struct irq_domain *domain,
                                irq_hw_number_t hwirq)

Also, another value of 'irq' can be selected, because 'pos0' is added.

	pp->msi_irq_start = irq_create_mapping(pp->irq_domain, 0);
	irq = (pp->msi_irq_start + pos0);


Pratyush Anand,
If I am wrong, please let me know. :-)

Best regards,
Jingoo Han

