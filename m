Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757351Ab3IYBgy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 21:36:54 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:41700 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756153Ab3IYBgv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 21:36:51 -0400
X-AuditID: cbfee691-b7f4a6d0000074fc-33-52423e31bcd4
From: Jingoo Han <jg1.han@samsung.com>
To: "'Joerg Roedel'" <joro@8bytes.org>
Cc: "'Andrew Morton'" <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, "'David Brown'" <davidb@codeaurora.org>,
        "'Stephen Boyd'" <sboyd@codeaurora.org>,
        "'Suman Anna'" <s-anna@ti.com>, "'Jingoo Han'" <jg1.han@samsung.com>
References: <001501ce9eda$5660b2c0$03221840$%han@samsung.com>
 <20130924124131.GA5150@8bytes.org>
In-reply-to: <20130924124131.GA5150@8bytes.org>
Subject: Re: [PATCH] iommu: remove unnecessary platform_set_drvdata()
Date: Wed, 25 Sep 2013 10:36:49 +0900
Message-id: <000901ceb98f$b3f7dab0$1be79010$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac65I2uRvnA43G5KSkytr1SFKYhqZgAay0/A
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGIsWRmVeSWpSXmKPExsVy+t8zfV1DO6cgg5bNIhZz1q9hs3i8/B+b
	xeWFl1gtOmdvYLe4vGsOm8XeX/tYLX6c6WZxYPd4cnAek8flvl4mjxMzfrN49G1Zxehx/MZ2
	Jo/Pm+QC2KK4bFJSczLLUov07RK4Mu7suctacIq14saMTywNjFtYuhg5OSQETCQeXmlghLDF
	JC7cW8/WxcjFISSwjFFi6atvjDBFy+bfg0osYpQ4PecwM4Tzi1Gi+9EjsCo2ATWJL18Os4PY
	IgIqEi3nfoAVMQs8ZJS4f2Ul0D4OoI4kie4DHCA1nAL6EpfObWcFsYUFXCUuTzzAClLCIqAq
	seY5G0iYV8BWovv7RnYIW1Dix+R7YFczC2hJrN95nAnClpfYvOYtM0irhIC6xKO/uhAXGEnM
	OfObGaJERGLfi3eMINdICHxll9jVvQ8swSIgIPFt8iEWiF5ZiU0HmCH+lZQ4uOIGywRGiVlI
	Ns9CsnkWks2zkKxYwMiyilE0tSC5oDgpvchUrzgxt7g0L10vOT93EyMkjifuYLx/wPoQYzLQ
	+onMUqLJ+cA0kFcSb2hsZmRhamJqbGRuaUaasJI4r3qLdaCQQHpiSWp2ampBalF8UWlOavEh
	RiYOTqkGRrtgrQA9ja7y4L0vEjnErqmxXsgo3qDaJnW1koW13elGFEPgu1MntvbPYpvhksK2
	rN1qZ+vb0Oa17QcztuU2Xr1feY2f+ZfkRFPxs4ce+S/2ZwoqXbzwWqN2xPQIluLDp3KfLTm/
	Y8b9+x92z1JePi/3uWXkwdSAnyIGIYsf1i5sYPc8vNYsRomlOCPRUIu5qDgRAM0mT1r5AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrMKsWRmVeSWpSXmKPExsVy+t9jAV1DO6cgg+UTBSzmrF/DZvF4+T82
	i8sLL7FadM7ewG5xedccNou9v/axWvw4083iwO7x5OA8Jo/Lfb1MHidm/Gbx6NuyitHj+I3t
	TB6fN8kFsEU1MNpkpCampBYppOYl56dk5qXbKnkHxzvHm5oZGOoaWlqYKynkJeam2iq5+ATo
	umXmAB2jpFCWmFMKFApILC5W0rfDNCE0xE3XAqYxQtc3JAiux8gADSSsY8y4s+cua8Ep1oob
	Mz6xNDBuYeli5OSQEDCRWDb/HhuELSZx4d56IJuLQ0hgEaPE6TmHmSGcX4wS3Y8eMYJUsQmo
	SXz5cpgdxBYRUJFoOfcDrIhZ4CGjxP0rK4HGcgB1JEl0H+AAqeEU0Je4dG47K4gtLOAqcXni
	AVaQEhYBVYk1z8EW8wrYSnR/38gOYQtK/Jh8D+w4ZgEtifU7jzNB2PISm9e8ZQZplRBQl3j0
	VxfiAiOJOWd+M0OUiEjse/GOcQKj0Cwkk2YhmTQLyaRZSFoWMLKsYhRNLUguKE5KzzXSK07M
	LS7NS9dLzs/dxAhOEs+kdzCuarA4xCjAwajEwytw1DFIiDWxrLgy9xCjBAezkgivv7lTkBBv
	SmJlVWpRfnxRaU5q8SHGZKA/JzJLiSbnAxNYXkm8obGJmZGlkZmFkYm5OWnCSuK8B1utA4UE
	0hNLUrNTUwtSi2C2MHFwSjUwbogMnfFtrR2zwa5Fu/zVQ5arfNtp1yZoq53z92L9ojUnX3J8
	+/9qnvJM+ZKGNJZd0/3Oedqr5DkmbBMw5l20ZpFUT7OifiGTS6B4zYnPD39Oz91Z1cr2opCn
	qjfuYFbLvMgTfQFbraX/PJ9/loU3XVBBeeb9LzZH3z7rW7j85MrGfUk+feG8SizFGYmGWsxF
	xYkAwXCgRlYDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, September 24, 2013 9:42 PM, Joerg Roedel wrote:
> On Thu, Aug 22, 2013 at 10:53:01AM +0900, Jingoo Han wrote:
> > The driver core clears the driver data to NULL after device_release
> > or on probe failure. Thus, it is not needed to manually clear the
> > device driver data to NULL.
> 
> Please split that into two patches, one for msm and one for omap so that
> I can put them into their respective topic-branches. Also add the
> Acked-by while you are at it, please.
> 

Hi Joerg Roedel,

This patch was already merged to v3.12-rc1 through mm-tree.
Commit: 5e42781 "drivers/iommu: remove unnecessary platform_set_drvdata()"

Thank you for caring. :-)

Best regards,
Jingoo Han

