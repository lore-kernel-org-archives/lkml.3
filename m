Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752424Ab3KANie (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 09:38:34 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:60528 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750719Ab3KANic (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 09:38:32 -0400
X-AuditID: cbfee68f-b7f836d000001b39-e0-5273aed60cd1
Date: Fri, 01 Nov 2013 22:38:29 +0900
From: Cho KyongHo <pullip.cho@samsung.com>
To: Joerg Roedel <joro@8bytes.org>
Cc: Linux ARM Kernel <linux-arm-kernel@lists.infradead.org>,
        Linux DeviceTree <devicetree@vger.kernel.org>,
        Linux IOMMU <iommu@lists.linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Samsung SOC <linux-samsung-soc@vger.kernel.org>,
        Antonios Motakis <a.motakis@virtualopensystems.com>,
        Grant Grundler <grundler@chromium.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Prathyush <prathyush.k@samsung.com>,
        Rahul Sharma <rahul.sharma@samsung.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Subash Patel <supash.ramaswamy@linaro.org>,
        Varun Sethi <Varun.Sethi@freescale.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>
Subject: Re: [PATCH v10 00/20] iommu/exynos: Fixes and Enhancements of System
 MMU driver with DT
Message-id: <20131101223829.2b705e1fb3cfffd3ac01b1b3@samsung.com>
In-reply-to: <20131101131044.GB3348@8bytes.org>
References: <20131007105212.1c2a9e29166ff4b4a33468f8@samsung.com>
 <20131101114224.GG17455@8bytes.org>
 <20131101213745.68172e8d47182cc64a591775@samsung.com>
 <20131101131044.GB3348@8bytes.org>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.10.14; i686-pc-mingw32)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpgleLIzCtJLcpLzFFi42I5/e+Zse61dcVBBlfXKFncuXuO1WL+ESDx
	6sgPJosF+60tOmdvYLfoXXCVzWLT42usFpd3zWGzmHF+H5PFhRUb2S2mLDrManH4TTurxck/
	vYwWLdd7mSzWz3jNYjHz1hoWBwGPJwfnMXnMbrjI4vHvcD+Tx51re9g8Ni+p95h8YzmjR9+W
	VYwenzfJeVw5eoYpgDOKyyYlNSezLLVI3y6BK2Pn/G/MBUdYKt79PcvUwLiWuYuRk0NCwERi
	y6UmNghbTOLCvfVANheHkMAyRoll7+axwBQtWbuQGSIxnVHizdJjjBDOJCaJSU1XwdpZBFQl
	Tt1uBRvLJqAlsXrucUYQW0RASeL651ZWkAZmgfWsEt9X/mQHSQgLJEn8f7EbrIFXwFHi9+ef
	YA2cAvoSJw+vgtpwhFGifXUH1LEWEheaOtghGgQlfky+B3YfM9C2zduaWCFseYnNa96C3Soh
	sJJDYvbMvywQ5wlIfJt8CMjmAErISmw6ADVTUuLgihssExjFZiEZOwvJ2FlIxi5gZF7FKJpa
	kFxQnJReZKxXnJhbXJqXrpecn7uJERL7/TsY7x6wPsSYDLRyIrOUaHI+MHXklcQbGpsZWZia
	mBobmVuakSasJM57/2FSkJBAemJJanZqakFqUXxRaU5q8SFGJg5OqQbGTKepzs0vqp9JXF/m
	/6B7+Rd1btOzz3irf3zkeuLwzD5CpXbDGxODCXM+vzDhXOuVKydnOolv0pKrF05dXS6opa1j
	pf51+4Vb/J0fDWVtOXV38OUbtaxxlfc733GlL/yS9+u6Vn7uCVs//vgcvaZ95iwbI5GHLtW/
	Vh7YYP/I+g5HsJ129kIZJZbijERDLeai4kQApeoa1hMDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLKsWRmVeSWpSXmKPExsVy+t9jQd1r64qDDJadlrG4c/ccq8X8I0Di
	1ZEfTBYL9ltbdM7ewG7Ru+Aqm8Wmx9dYLS7vmsNmMeP8PiaLCys2sltMWXSY1eLwm3ZWi5N/
	ehktWq73Mlmsn/GaxWLmrTUsDgIeTw7OY/KY3XCRxePf4X4mjzvX9rB5bF5S7zH5xnJGj74t
	qxg9Pm+S87hy9AxTAGdUA6NNRmpiSmqRQmpecn5KZl66rZJ3cLxzvKmZgaGuoaWFuZJCXmJu
	qq2Si0+ArltmDtAbSgpliTmlQKGAxOJiJX07TBNCQ9x0LWAaI3R9Q4LgeowM0EDCOsaMnfO/
	MRccYal49/csUwPjWuYuRk4OCQETiSVrF0LZYhIX7q1n62Lk4hASmM4o8WbpMUYIZxKTxKSm
	q2wgVSwCqhKnbreCdbAJaEmsnnucEcQWEVCSuP65lRWkgVlgPavE95U/2UESwgJJEv9f7AZr
	4BVwlPj9+SdYA6eAvsTJw6ugNhxhlGhf3QF1h4XEhaYOdogGQYkfk++xgNjMQNs2b2tihbDl
	JTavecs8gVFgFpKyWUjKZiEpW8DIvIpRNLUguaA4KT3XUK84Mbe4NC9dLzk/dxMjOLE8k9rB
	uLLB4hCjAAejEg+vw8SiICHWxLLiytxDjBIczEoivDuUioOEeFMSK6tSi/Lji0pzUosPMSYD
	w2Mis5Rocj4w6eWVxBsam5gZWRqZWRiZmJuTJqwkznug1TpQSCA9sSQ1OzW1ILUIZgsTB6dU
	A+NOu+adFRKVkVpRjk90Pyk2sDnUPHK48lLf+/m+ivhL2zw6Q44/P92heeIps9Kq8G8bFym/
	2dyq5cjm6JP3nGFHzU0rzg3PTidUJS/kuuLpUXTxX1p6oPPP9/GR0lLLn7y6clLxtd20hQnP
	Zq2+qreR/Y6EK+8Ed6+DjlMEry6aJjNroXKm1yMlluKMREMt5qLiRACZpikYcAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 01 Nov 2013 14:10:47 +0100, Joerg Roedel wrote:
> Hi Cho,
> 
> On Fri, Nov 01, 2013 at 09:37:45PM +0900, Cho KyongHo wrote:
> > I am preparing next patches to apply Alex Williamson's comment that
> > description of IOMMU's masters must be aligned with ARM SMMU.
> > 
> > It is delayed due to my jobs in the office.
> > 
> > I will post the next patche series in two weeks.
> 
> Thanks for the update. If the merge window is open by then please wait
> with the re-send until the merge window closes.

Ok.

Thank you.

> 
> Thanks,
> 
> 	Joerg
> 
> 
