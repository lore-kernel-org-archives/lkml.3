Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752684AbaKLFi2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 00:38:28 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:45511 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752202AbaKLFi0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 00:38:26 -0500
X-AuditID: cbfee690-f79ab6d0000046f7-76-5462f24fcf5a
Message-id: <5462F24E.7030100@samsung.com>
Date: Wed, 12 Nov 2014 14:38:22 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: kgene.kim@samsung.com
Cc: Chanwoo Choi <cw00.choi@samsung.com>, ben-linux@fluff.org,
        kyungmin.park@samsung.com, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCHv2 0/2] ARM: dts: Fix the number of DMA channels for
 Exynos3250/4
References: <1415760629-1531-1-git-send-email-cw00.choi@samsung.com>
In-reply-to: <1415760629-1531-1-git-send-email-cw00.choi@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprDIsWRmVeSWpSXmKPExsWyRsSkUNf/U1KIwd+/ghaT1h1gsrj+5Tmr
	Re+Cq2wWZ5vesFtsenyN1eLyrjlsFjPO72NyYPf4u+oFs8fmJfUefVtWMXp83iQXwBLFZZOS
	mpNZllqkb5fAlfGhxa1gKnvFru/bmBsYb7N2MXJwSAiYSCy+XtjFyAlkiklcuLeerYuRi0NI
	YCmjxIJF8+FqTlwJhYgvYpT49306K4TzmlHi+IE1LCDdvAJaEi3b57OD2CwCqhIzXl4Hs9mA
	4vtf3GADsUUFwiRWTr8CVS8o8WPyPTBbREBSoqnhDzPIUGaBw4wSc1o/MYEkhIEaVq//BVYk
	JOAicfH4CjCbU8BVonvlJEYQm1lAR2J/6zQ2CFteYvOat2CDJAQOsUv8PnaXGeIiAYlvkw+x
	QLwjK7HpADPEy5ISB1fcYJnAKDYLyU2zkIydhWTsAkbmVYyiqQXJBcVJ6UUmesWJucWleel6
	yfm5mxiBkXb637MJOxjvHbA+xCjAwajEw5uwJilEiDWxrLgy9xCjKdAVE5mlRJPzgfGcVxJv
	aGxmZGFqYmpsZG5ppiTO+1rqZ7CQQHpiSWp2ampBalF8UWlOavEhRiYOTqkGxvRbbeG7Vy0Q
	1bt539ruhf+VAM7HBoJe/+7N4XJOv3tPRKpk/7N+i6VuB/TZL4dV5kw3cHEw2N3leMblxapE
	8Zm31cTEik99Or4pPLDTYNttiRDRxTph/V1zlXKjai91dO1oEE32djn+zMlvlejGXbLvcpwn
	CinNq/LfcarR5ZtbcEVcnFCmEktxRqKhFnNRcSIAFyU/na8CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrOIsWRmVeSWpSXmKPExsVy+t9jAV3/T0khBn/WcVlMWneAyeL6l+es
	Fr0LrrJZnG16w26x6fE1VovLu+awWcw4v4/Jgd3j76oXzB6bl9R79G1ZxejxeZNcAEtUA6NN
	RmpiSmqRQmpecn5KZl66rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDtAFSgpliTml
	QKGAxOJiJX07TBNCQ9x0LWAaI3R9Q4LgeowM0EDCGsaMDy1uBVPZK3Z938bcwHibtYuRg0NC
	wETixJXQLkZOIFNM4sK99WxdjFwcQgKLGCX+fZ/OCuG8ZpQ4fmANC0gVr4CWRMv2+ewgNouA
	qsSMl9fBbDag+P4XN9hAbFGBMImV069A1QtK/Jh8D8wWEZCUaGr4wwwylFngMKPEnNZPTCAJ
	YaCG1et/gRUJCbhIXDy+AszmFHCV6F45iRHEZhbQkdjfOo0NwpaX2LzmLfMERoFZSHbMQlI2
	C0nZAkbmVYyiqQXJBcVJ6blGesWJucWleel6yfm5mxjBkfxMegfjqgaLQ4wCHIxKPLwZm5NC
	hFgTy4orcw8xSnAwK4nwOn0ECvGmJFZWpRblxxeV5qQWH2I0BQbBRGYp0eR8YJLJK4k3NDYx
	M7I0Mje0MDI2VxLnPdhqHSgkkJ5YkpqdmlqQWgTTx8TBKdXAODFV0KEhqeo2C2vJzuu8KfUc
	jLbtU07MLZiRnR0jXszOnpb8xMJ5oy3vrTXz921/v+Ho5DkH7qloVvzf+z1F7UP57D32SwM+
	StZdMJjGL+XAJmZXyPva87ed7yFRjWu7Lz2189ufG684eXEAk+CUsM6VYpH66rKcZq/uqSyZ
	b29+WHZhz7KtSizFGYmGWsxFxYkA3m2w3PoCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Kukjin,

Please ignore this patchset because this patchset are wrong.

Best Regards,
Chanwoo Choi

On 11/12/2014 11:50 AM, Chanwoo Choi wrote:
> This patch fix minor issuse to correct the number of DMA channels for
> Exynos3250 and Exynos4 series. The PL330 DMA of Exynos3250/Exynos4 support
> 16 channels simultaneously but, PL330 DMA driver don't use 'dma-channels'
> property directly. This patchset fix the correct information
> of Exynos3250/Exynos4's PL330 DMA simply.
> 
> Changes from v1:
> - Fix the nubmer for DMA channesl for Exynos4415
> 
> Chanwoo Choi (2):
>   ARM: dts: Fix the number of DMA channels for Exynos3250
>   ARM: dts: Fix the number of DMA channels for Exynos4
> 
>  arch/arm/boot/dts/exynos3250.dtsi | 4 ++--
>  arch/arm/boot/dts/exynos4.dtsi    | 4 ++--
>  arch/arm/boot/dts/exynos4415.dtsi | 4 ++--
>  3 files changed, 6 insertions(+), 6 deletions(-)
> 

