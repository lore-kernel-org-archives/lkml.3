Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756999Ab3GLAAi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 20:00:38 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:24510 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756827Ab3GLAAa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 20:00:30 -0400
X-AuditID: cbfee690-b7f6f6d00000740c-bb-51df471d877e
From: Jingoo Han <jg1.han@samsung.com>
To: "'Kishon Vijay Abraham I'" <kishon@ti.com>
Cc: "'Bjorn Helgaas'" <bhelgaas@google.com>, linux-pci@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Pratyush Anand'" <pratyush.anand@st.com>,
        "'Mohit KUMAR'" <Mohit.KUMAR@st.com>,
        "'Arnd Bergmann'" <arnd@arndb.de>, "'Sean Cross'" <xobs@kosagi.com>,
        "'SRIKANTH TUMKUR SHIVANAND'" <ts.srikanth@samsung.com>,
        linux-kernel@vger.kernel.org,
        "'Thierry Reding'" <thierry.reding@gmail.com>,
        Jingoo Han <jg1.han@samsung.com>
References: <001201ce7dfa$716b3370$54419a50$@samsung.com>
 <51DE72CC.9050001@ti.com>
In-reply-to: <51DE72CC.9050001@ti.com>
Subject: Re: [PATCH V2] pci: exynos: split into two parts such as Synopsys part
 and Exynos part
Date: Fri, 12 Jul 2013 09:00:28 +0900
Message-id: <001301ce7e92$d19a04e0$74ce0ea0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQMw1eBP/VKXWuT2/qwqXEWC1QeRsgGtjU66lo4LNxA=
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprIKsWRmVeSWpSXmKPExsVy+t8zI11Z9/uBBo9vsFn8nXSM3WJJU4bF
	y0OaFpcXXmK16F1wlc3iwtMeNovLu+awWZydd5zNYsb5fUwWG6f+YrRov6Rs8XPXPBaLxqMP
	WC1anzxgdODz+P1rEqPHzll32T0WbCr1+L5wPrtH35ZVjB5Pf+xl9jh+YzuTx+dNcgEcUVw2
	Kak5mWWpRfp2CVwZm5/cYyzYyFWxYNsylgbGdRxdjJwcEgImEp2fDrNC2GISF+6tZ+ti5OIQ
	EljGKHGwq5sNpujezgZGiMQiRonTv85COb8YJaY++s8EUsUmoCbx5cthdhBbREBHYuHp9cwg
	NrPAGWaJTRvtQWwhgVCJ5V93M4LYnED1+548AVstLJAo8W/lA7BtLAKqEj+WtYDZvAKWEsve
	HGOEsAUlfky+xwIxU0ti/c7jTBC2vMTmNW+ZIS5VkNhx9jUjxA1WEgu+fYeqF5HY9+Id2NES
	Ams5JLZtusUEsUxA4tvkQ0BFHEAJWYlNB6DmSEocXHGDZQKjxCwkq2chWT0LyepZSFYsYGRZ
	xSiaWpBcUJyUXmSiV5yYW1yal66XnJ+7iRGSHCbsYLx3wPoQYzLQ+onMUqLJ+cDkklcSb2hs
	ZmRhamJqbGRuaUaasJI4r3qLdaCQQHpiSWp2ampBalF8UWlOavEhRiYOTqkGRsPtU1t4s2xW
	RSqXrAlcvq/ld7eB+8e/E/4yW68JVjZ88PiZQ/emmfYLQ3k+WRzdrJl6kMHpc7yU5f77L6eW
	2C4PdmX/cU34zEeVhYFH1E4vlZx8IX/Hi64i0cufcvUEl7j1ewrqHD1Zw3Kl6l2O1dTbWwzK
	uQ7c1DGM92q2bskpvhVUWGLXpMRSnJFoqMVcVJwIAM8XgR8kAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrLKsWRmVeSWpSXmKPExsVy+t9jAV1Z9/uBBpOKLf5OOsZusaQpw+Ll
	IU2LywsvsVr0LrjKZnHhaQ+bxeVdc9gszs47zmYx4/w+JouNU38xWrRfUrb4uWsei0Xj0Qes
	Fq1PHjA68Hn8/jWJ0WPnrLvsHgs2lXp8Xzif3aNvyypGj6c/9jJ7HL+xncnj8ya5AI6oBkab
	jNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKCjlRTKEnNK
	gUIBicXFSvp2mCaEhrjpWsA0Ruj6hgTB9RgZoIGEdYwZm5/cYyzYyFWxYNsylgbGdRxdjJwc
	EgImEvd2NjBC2GISF+6tZ+ti5OIQEljEKHH611lGCOcXo8TUR/+ZQKrYBNQkvnw5zA5iiwjo
	SCw8vZ4ZxGYWOMMssWmjPYgtJBAqsfzrbrCpnED1+548YQWxhQUSJf6tfMAGYrMIqEr8WNYC
	ZvMKWEose3OMEcIWlPgx+R4LxEwtifU7jzNB2PISm9e8ZYa4VEFix9nXjBA3WEks+PYdql5E
	Yt+Ld4wTGIVmIRk1C8moWUhGzULSsoCRZRWjaGpBckFxUnqukV5xYm5xaV66XnJ+7iZGcOJ5
	Jr2DcVWDxSFGAQ5GJR7eghP3AoVYE8uKK3MPMUpwMCuJ8N40ux8oxJuSWFmVWpQfX1Sak1p8
	iDEZ6NOJzFKiyfnApJhXEm9obGJmZGlkZmFkYm5OmrCSOO/BVutAIYH0xJLU7NTUgtQimC1M
	HJxSDYzZd/7uzqj1+T8/OIP9yVTnLWk7lVU0mA5M2xx3gCv+pub5KVHWnI4s/ZVG+bU78o8+
	3ZIZqVa+PDlxbWzBtm62n0w7Ik8GzymU1X4sx15evNbngvmKhebujdskd+ldX/OdxfDz5k1B
	zExLr/WvvLjtN7Mavyin3dLAx913c+PrjrdOlYqQD1RiKc5INNRiLipOBADncHEYgAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, July 11, 2013 5:55 PM, Kishon Vijay Abraham I wrote:
> On Thursday 11 July 2013 11:19 AM, Jingoo Han wrote:
> > Exynos PCIe IP consists of Synopsys specific part and Exynos
> > specific part. Only core block is a Synopsys designware part;
> > other parts are Exynos specific.
> > Also, the Synopsys designware part can be shared with other
> > platforms; thus, it can be split two parts such as Synopsys
> > designware part and Exynos specific part.
> >
> > Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> > Cc: Pratyush Anand <pratyush.anand@st.com>
> > Cc: Mohit KUMAR <Mohit.KUMAR@st.com>
> > ---
> .
> .
> <snip>
> .
> .
> > +
> > +/* Exynos PCIe driver does not allow module unload */
> 
> Just curious, why is this restriction?

CC'ed Thierry Reding,

Hi Kishon,

That's a good question.

Now, we don't have the solution to "be able to load and unload
the PCI host driver in a loop definitely without crashing or exposing
any races  or leaks", as Arnd Bergmann said.
Please refer to the following thread in mailing-list.
(http://archive.arm.linux.org.uk/lurker/message/20130614.123849.4ff363c5.pl.html)

Thus, Exynos PCIe did not support unloading module.
(http://archive.arm.linux.org.uk/lurker/message/20130614.125338.7d2bbf62.pl.html)

Best regards,
Jingoo Han


