Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757855AbaCRX7Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 19:59:16 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:35765 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751593AbaCRX7N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 19:59:13 -0400
X-AuditID: cbfee691-b7efc6d0000039d3-e2-5328ddce45d1
From: Jingoo Han <jg1.han@samsung.com>
To: "'Tomasz Figa'" <t.figa@samsung.com>,
        "'Cho KyongHo'" <pullip.cho@samsung.com>
Cc: "'Linux ARM Kernel'" <linux-arm-kernel@lists.infradead.org>,
        "'Linux DeviceTree'" <devicetree@vger.kernel.org>,
        "'Linux IOMMU'" <iommu@lists.linux-foundation.org>,
        "'Linux Kernel'" <linux-kernel@vger.kernel.org>,
        "'Linux Samsung SOC'" <linux-samsung-soc@vger.kernel.org>,
        "'Antonios Motakis'" <a.motakis@virtualopensystems.com>,
        "'Grant Grundler'" <grundler@chromium.org>,
        "'Joerg Roedel'" <joro@8bytes.org>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Prathyush'" <prathyush.k@samsung.com>,
        "'Rahul Sharma'" <rahul.sharma@samsung.com>,
        "'Sachin Kamat'" <sachin.kamat@linaro.org>,
        "'Sylwester Nawrocki'" <s.nawrocki@samsung.com>,
        "'Varun Sethi'" <Varun.Sethi@freescale.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <20140314140542.f4ded6c50dbd8a1d937bf354@samsung.com>
 <53230404.6070601@samsung.com>
 <20140318193817.3448387b75e109e814b9c025@samsung.com>
 <5328625B.508@samsung.com>
In-reply-to: <5328625B.508@samsung.com>
Subject: Re: [PATCH v11 10/27] iommu/exynos: use managed device helper functions
Date: Wed, 19 Mar 2014 08:59:09 +0900
Message-id: <001201cf4306$0e16e540$2a44afc0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac9CvWbrFYk6bh8sS7GItB1MnQBo3QASAuqw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrCKsWRmVeSWpSXmKPExsVy+t8zQ91zdzWCDdYfVLa4c/ccq8X8I0Di
	1ZEfTBYL9ltbXF54idWic/YGdoveBVfZLDY9vsZqcXnXHDaLGef3MVlcWLGR3eJf70FGiymL
	DrNaHH7Tzmpx8k8vo8X6Ga9ZLGbeWsPiIOjx5OA8Jo/ZDRdZPP4d7mfyuHNtD5vH5iX1HpNv
	LGf06NuyitHj8yY5jytHzzAFcEZx2aSk5mSWpRbp2yVwZZw818pUcJi3Ys3qFcwNjE+5uhg5
	OSQETCQ6+rYwQdhiEhfurWfrYuTiEBJYxijxq3UfexcjO1jROzmI8HRGidPbV7JCOL8ZJd5M
	fMAK0swmoCbx5cthoHoODhEBP4l3+0tAapgFDrJKPDrdwA7RsJ1R4tSZfcwgDZwC6hIX3q8D
	axYWCJB4cbKBBaSZRUBV4vjMWJAwr4CtxIm2bjYIW1Dix+R7LCA2s4CWxPqdx5kgbHmJzWve
	MoO0SgCNfPRXFyQsImAksfj3eXaIEhGJfS/eMYKcICFwhUPiwvy7YCewCAhIfJt8iAWiV1Zi
	0wFmSDhIShxccYNlAqPELCSbZyHZPAvJ5llIVixgZFnFKJpakFxQnJReZKpXnJhbXJqXrpec
	n7uJEZJCJu5gvH/A+hBjMtD6icxSosn5wBSUVxJvaGxmZGFqYmpsZG5pRpqwkjhv+qOkICGB
	9MSS1OzU1ILUovii0pzU4kOMTBycUg2M1SvXbPn0pEJ1s7s6c/2Zb2EvufqPKFV2aSa+PRic
	PkdUYDb3mxi7igl7W6cqWsmp6GuECj059Xlv8jFhrWtrtVinFKwRumlxvq35zGP/JZ+W98/S
	b6+V/h+g3+nlUrje5Rbv5tUqM9b53i9xdJLdGvXxTAtTJuO+v8oxpzdvDzITLs49mmanxFKc
	kWioxVxUnAgAWgMuSTcDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpkk+LIzCtJLcpLzFFi42I5/e+xoO65uxrBBrsvyFrcuXuO1WL+ESDx
	6sgPJosF+60tLi+8xGrROXsDu0XvgqtsFpseX2O1uLxrDpvFjPP7mCwurNjIbvGv9yCjxZRF
	h1ktDr9pZ7U4+aeX0WL9jNcsFjNvrWFxEPR4cnAek8fshossHv8O9zN53Lm2h81j85J6j8k3
	ljN69G1ZxejxeZOcx5WjZ5gCOKMaGG0yUhNTUosUUvOS81My89JtlbyD453jTc0MDHUNLS3M
	lRTyEnNTbZVcfAJ03TJzgH5RUihLzCkFCgUkFhcr6dthmhAa4qZrAdMYoesbEgTXY2SABhLW
	MWacPNfKVHCYt2LN6hXMDYxPuboY2TkkBEwk3sl1MXICWWISF+6tZ+ti5OIQEpjOKHF6+0pW
	COc3o8SbiQ9YQarYBNQkvnw5zN7FyMEhIuAn8W5/CUgNs8BBVolHpxvYIRq2M0qcOrOPGaSB
	U0Bd4sL7dWDNwgIBEi9ONrCANLMIqEocnxkLEuYVsJU40dbNBmELSvyYfI8FxGYW0JJYv/M4
	E4QtL7F5zVtmkFYJoJGP/uqChEUEjCQW/z7PDlEiIrHvxTvGCYxCs5BMmoVk0iwkk2YhaVnA
	yLKKUTS1ILmgOCk911CvODG3uDQvXS85P3cTIzhBPZPawbiyweIQowAHoxIP74EojWAh1sSy
	4srcQ4wSHMxKIrzCwPQmxJuSWFmVWpQfX1Sak1p8iDEZ6M+JzFKiyfnA5JlXEm9obGJmZGlk
	ZmFkYm5OmrCSOO+BVutAIYH0xJLU7NTUgtQimC1MHJxSDYyTd7hHT7n04ee7LLZ2x2lRWpty
	FpXdebBnw66VUbOf5zz8kyxm45e6y5U559K3RYJLJzJ5VyxIMFD0FHPMPNmmbrR5Sf8joUhz
	WbfL+5nVOaWkPOdmr3XY9zZ4etmdnbzmFxP2qHpLskpHXxMvTMqZlV3Mrhz+ROranup0HpVt
	Loacs83TupVYijMSDbWYi4oTATG7AuCUAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, March 19, 2014 12:12 AM, Tomasz Figa wrote:
> On 18.03.2014 11:38, Cho KyongHo wrote:
> > On Fri, 14 Mar 2014 14:28:36 +0100, Tomasz Figa wrote:
> >> On 14.03.2014 06:05, Cho KyongHo wrote:
> >>> This patch uses managed device helper functions in the probe().
> >>>
> >>> Signed-off-by: Cho KyongHo <pullip.cho@samsung.com>
> >>> ---
> >>>    drivers/iommu/exynos-iommu.c |   64 +++++++++++++++++-------------------------
> >>>    1 file changed, 26 insertions(+), 38 deletions(-)
> >>>
> >>> diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
> >>> index 36e6b73..33b424d 100644
> >>> --- a/drivers/iommu/exynos-iommu.c
> >>> +++ b/drivers/iommu/exynos-iommu.c

[.....]

> >>>    	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> >>>    	if (!res) {
> >>> -		dev_dbg(dev, "Unable to find IOMEM region\n");
> >>> -		ret = -ENOENT;
> >>> -		goto err_init;
> >>> +		dev_err(dev, "Unable to find IOMEM region\n");
> >>> +		return -ENOENT;
> >>>    	}
> >>
> >> No need to check for error and print message, because
> >> devm_ioremap_resource() already checks the passed resource and handles
> >> error cases.
> >>
> >
> > Yes but devm_ioremap_resource() just tells that the given 'res' is not
> > correct. I think the message in the driver is more informative.
> 
> The common practice used in Linux kernel is to not duplicate such
> messages. It is obvious that devm_ioremap_resource() printing such
> message is related to an IOMEM resource anyway, as you can't used it
> with other types of resources.

+1

I agree with Tomasz Figa's opinion.
These messages have been being removed from Linux kernel.
Thank you.

Best regards,
Jingoo Han

