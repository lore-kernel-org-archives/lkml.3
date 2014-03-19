Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933186AbaCSI4J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 04:56:09 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:20812 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932191AbaCSI4F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 04:56:05 -0400
X-AuditID: cbfee68e-b7f566d000002344-de-53295ba2215e
Date: Wed, 19 Mar 2014 17:56:01 +0900
From: Cho KyongHo <pullip.cho@samsung.com>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "'Tomasz Figa'" <t.figa@samsung.com>,
        "'Linux ARM Kernel'" <linux-arm-kernel@lists.infradead.org>,
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
        "'Varun Sethi'" <Varun.Sethi@freescale.com>
Subject: Re: [PATCH v11 10/27] iommu/exynos: use managed device helper functions
Message-id: <20140319175601.4e986eddf36d5157ab54bcc1@samsung.com>
In-reply-to: <001201cf4306$0e16e540$2a44afc0$%han@samsung.com>
References: <20140314140542.f4ded6c50dbd8a1d937bf354@samsung.com>
 <53230404.6070601@samsung.com>
 <20140318193817.3448387b75e109e814b9c025@samsung.com>
 <5328625B.508@samsung.com> <001201cf4306$0e16e540$2a44afc0$%han@samsung.com>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.10.14; i686-pc-mingw32)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrHIsWRmVeSWpSXmKPExsVy+t8zY93F0ZrBBos2MVrcuXuO1WL+ESDx
	6sgPJosF+60tLi+8xGrROXsDu0XvgqtsFpseX2O1uLxrDpvFjPP7mCwurNjIbjFl0WFWi8Nv
	2lktTv7pZbRYP+M1i8XMW2tYHAQ8nhycx+Qxu+Eii8e/w/1MHneu7WHz2Lyk3mPyjeWMHn1b
	VjF6fN4k53Hl6BmmAM4oLpuU1JzMstQifbsErowPe2YxFbzgq+heeZaxgfEkdxcjB4eEgIlE
	57eSLkZOIFNM4sK99WxdjFwcQgLLGCUuvp3LBpEwkXjS8IYdIrGIUeLlvS5WkISQwGQmifWv
	TEBsFgFVibaGg0wgNpuAlsTquccZQWwRARWJz+uPg01lFjjMKnH2UStYs7BAgMSLkw0sIDav
	gKPEtr+bwBo4BewkWt/3sEBse8kosXXVVxaIMywkLjR1sEM0CEr8mHwPLM4MtG3ztiZWCFte
	YvOat8wgzRICKzkkuldDJFgEBCS+TT7EAvGzrMSmA8wQMyUlDq64wTKBUWwWkrGzkIydhWTs
	AkbmVYyiqQXJBcVJ6UVGesWJucWleel6yfm5mxghcd+3g/HmAetDjMlAKycyS4km5wPTRl5J
	vKGxmZGFqYmpsZG5pRlpwkrivIseJgUJCaQnlqRmp6YWpBbFF5XmpBYfYmTi4JRqYFwaU6D6
	ouvHioRAJtP1BnkX3/cwRq35yPc83XOCuajK4Tfvearam5xv5MvNMNY7v/Hz/eeSBc+lNgVt
	fOvXsTZz1pGQ496tH8/scLDca8awQj4rW2hHj3jvutILp/4zdMaxNqep3Bfrdzx/Qe1OrNW5
	eLaIXo/I+gMO8nf/T4yor/y/hr9PS4mlOCPRUIu5qDgRADK0f8QRAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDKsWRmVeSWpSXmKPExsVy+t9jAd1F0ZrBBttOWFjcuXuO1WL+ESDx
	6sgPJosF+60tLi+8xGrROXsDu0XvgqtsFpseX2O1uLxrDpvFjPP7mCwurNjIbjFl0WFWi8Nv
	2lktTv7pZbRYP+M1i8XMW2tYHAQ8nhycx+Qxu+Eii8e/w/1MHneu7WHz2Lyk3mPyjeWMHn1b
	VjF6fN4k53Hl6BmmAM6oBkabjNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTc
	VFslF58AXbfMHKA3lBTKEnNKgUIBicXFSvp2mCaEhrjpWsA0Ruj6hgTB9RgZoIGEdYwZH/bM
	Yip4wVfRvfIsYwPjSe4uRk4OCQETiScNb9ghbDGJC/fWs3UxcnEICSxilHh5r4sVJCEkMJlJ
	Yv0rExCbRUBVoq3hIBOIzSagJbF67nFGEFtEQEXi8/rjYM3MAodZJc4+agVrFhYIkHhxsoEF
	xOYVcJTY9ncTWAOngJ1E6/seFohtLxkltq76ygJxhoXEhaYOdogGQYkfk++BxZmBtm3e1sQK
	YctLbF7zlnkCo8AsJGWzkJTNQlK2gJF5FaNoakFyQXFSeq6RXnFibnFpXrpecn7uJkZwWnkm
	vYNxVYPFIUYBDkYlHt4DURrBQqyJZcWVuYcYJTiYlUR4he8ChXhTEiurUovy44tKc1KLDzEm
	A8NjIrOUaHI+MOXllcQbGpuYGVkamVkYmZibkyasJM57sNU6UEggPbEkNTs1tSC1CGYLEwen
	VAOjvMLLc6zTOBIEVCrOnkl55F/1TKZ5pqn8TcGnvMoN82//0M6V3zTJ0eif8e9Fcwr+8Ekt
	8+WwPC+X6PLGuzP1sOr589bnTupJPr2npvX/z8Gi9Vtv/v/L0nBPek/g1AezuJfausr7ZNdN
	6r9n12i8YIbfHvtKYRH52VuK86zPP5xkq/6rTny7EktxRqKhFnNRcSIATXNIj28DAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Mar 2014 08:59:09 +0900, Jingoo Han wrote:
> On Wednesday, March 19, 2014 12:12 AM, Tomasz Figa wrote:
> > On 18.03.2014 11:38, Cho KyongHo wrote:
> > > On Fri, 14 Mar 2014 14:28:36 +0100, Tomasz Figa wrote:
> > >> On 14.03.2014 06:05, Cho KyongHo wrote:
> > >>> This patch uses managed device helper functions in the probe().
> > >>>
> > >>> Signed-off-by: Cho KyongHo <pullip.cho@samsung.com>
> > >>> ---
> > >>>    drivers/iommu/exynos-iommu.c |   64 +++++++++++++++++-------------------------
> > >>>    1 file changed, 26 insertions(+), 38 deletions(-)
> > >>>
> > >>> diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
> > >>> index 36e6b73..33b424d 100644
> > >>> --- a/drivers/iommu/exynos-iommu.c
> > >>> +++ b/drivers/iommu/exynos-iommu.c
> 
> [.....]
> 
> > >>>    	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> > >>>    	if (!res) {
> > >>> -		dev_dbg(dev, "Unable to find IOMEM region\n");
> > >>> -		ret = -ENOENT;
> > >>> -		goto err_init;
> > >>> +		dev_err(dev, "Unable to find IOMEM region\n");
> > >>> +		return -ENOENT;
> > >>>    	}
> > >>
> > >> No need to check for error and print message, because
> > >> devm_ioremap_resource() already checks the passed resource and handles
> > >> error cases.
> > >>
> > >
> > > Yes but devm_ioremap_resource() just tells that the given 'res' is not
> > > correct. I think the message in the driver is more informative.
> > 
> > The common practice used in Linux kernel is to not duplicate such
> > messages. It is obvious that devm_ioremap_resource() printing such
> > message is related to an IOMEM resource anyway, as you can't used it
> > with other types of resources.
> 
> +1
> 
> I agree with Tomasz Figa's opinion.
> These messages have been being removed from Linux kernel.
> Thank you.
> 
Ok.

Thank you for the advice.

Kyong Ho 
