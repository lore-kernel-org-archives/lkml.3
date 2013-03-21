Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754126Ab3CUXS6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 19:18:58 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:55682 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754037Ab3CUXS4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 19:18:56 -0400
X-AuditID: cbfee68d-b7f786d000005188-c6-514b955e89a4
From: Jingoo Han <jg1.han@samsung.com>
To: "'David Rientjes'" <rientjes@google.com>,
        "'Herbert Xu'" <herbert@gondor.hengli.com.au>
Cc: "'Andrew Morton'" <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, "'Matt Mackall'" <mpm@selenic.com>
References: <003a01ce1ee4$ed8842b0$c898c810$%han@samsung.com>
 <20130321095430.GC26931@gondor.apana.org.au>
 <alpine.DEB.2.02.1303211214230.5662@chino.kir.corp.google.com>
In-reply-to: <alpine.DEB.2.02.1303211214230.5662@chino.kir.corp.google.com>
Subject: Re: [PATCH] hwrng: exynos - add CONFIG_PM_SLEEP to suspend/resume
 functions
Date: Fri, 22 Mar 2013 08:18:54 +0900
Message-id: <008301ce268a$74fb9470$5ef2bd50$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4maLCAnoPLbPq5SP2LUUT9cu6i7wAITkLA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrEIsWRmVeSWpSXmKPExsVy+t8zQ924qd6BBvvem1nMWb+GzaL7lYzF
	5V1z2CwWbOtjtGhbspHJgdVj2wFVjwWbSj1OzPjN4tH3cgOjx+dNcgGsUVw2Kak5mWWpRfp2
	CVwZ2yZPZypo5axY82oBYwPjPvYuRg4OCQETiWnHIrsYOYFMMYkL99azdTFycQgJLGOU2D5n
	MiNEwkSitfk4E0RiOqPE9Ol/mSGcX4wSe3pbWUCq2ATUJL58OcwOYosIREi8OPUTLM4sUCgx
	oeUAK0TDWkaJ+7c/giU4Bbwlzt+9xwJyhrBAmMSeFt0uRnYOFgFVic/GIAW8ArYS+/o/sEDY
	ghI/Jt+DmqglsX4nyD0gtrzE5jVvmSF+UZd49FcX4gAjiXn9C5ghSkQk9r14xwhygITANXaJ
	6ZsXgvWyCAhIfJt8iAWiV1Zi0wFmiHclJQ6uuMEygVFiFpLNs5BsnoVk8ywkKxYwsqxiFE0t
	SC4oTkovMtQrTswtLs1L10vOz93ECInP3h2Mtw9YH2JMBlo/kVlKNDkfGN95JfGGxmZGFqYm
	psZG5pZmpAkrifOqtVgHCgmkJ5akZqemFqQWxReV5qQWH2Jk4uCUamBc0B/32EYvd9fk9z9n
	59rc872jn725+5YRZ6BwdtAab97djxcGvo5SnTBtIqtK/YfGKR98SgJ3xsk82XPFfnnmsYcP
	p6wIYjU6Y9n7coOotJuoStSWwwxGMj16BaKMjf8LZzUH3HjqJd1zS/2L2o4rK+8/zVsxzz10
	ZouJft4ZFZOPpgsjtvMosRRnJBpqMRcVJwIAhmwluOUCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrAKsWRmVeSWpSXmKPExsVy+t9jQd24qd6BBi/vGFnMWb+GzaL7lYzF
	5V1z2CwWbOtjtGhbspHJgdVj2wFVjwWbSj1OzPjN4tH3cgOjx+dNcgGsUQ2MNhmpiSmpRQqp
	ecn5KZl56bZK3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+AbpumTlAq5UUyhJzSoFCAYnFxUr6
	dpgmhIa46VrANEbo+oYEwfUYGaCBhHWMGdsmT2cqaOWsWPNqAWMD4z72LkZODgkBE4nW5uNM
	ELaYxIV769m6GLk4hASmM0pMn/6XGcL5xSixp7eVBaSKTUBN4suXw2DdIgIREi9O/QSLMwsU
	SkxoOcAK0bCWUeL+7Y9gCU4Bb4nzd+8B2RwcwgJhEntadLsY2TlYBFQlPhuDFPAK2Ers6//A
	AmELSvyYfA9qopbE+p0QtzELyEtsXvOWGWSIhIC6xKO/uhAHGEnM61/ADFEiIrHvxTvGCYxC
	s5BMmoVk0iwkk2YhaVnAyLKKUTS1ILmgOCk911CvODG3uDQvXS85P3cTIzj+n0ntYFzZYHGI
	UYCDUYmHV0PHO1CINbGsuDL3EKMEB7OSCG9kClCINyWxsiq1KD++qDQntfgQYzLQmxOZpUST
	84GpKa8k3tDYxMzI0sjMwsjE3Jw0YSVx3gOt1oFCAumJJanZqakFqUUwW5g4OKUaGOsqIpJ/
	nHRl5XK7p5j94dr6fapuyloP9U98vdp9ffas72KJIYdWHto8X/eUm2NtoZzQsicsk84knZtf
	ydy+dQar4k+3g9+v/6nQaZ8d9G3dm8cpK3KsLm3n7TFu/KGSvYkngm/X9H5Dw9lbFx7RsmI8
	W3di5zUXsyvfuXkDBKZW7c79J1X2z0WJpTgj0VCLuag4EQDfxms3QwMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, March 22, 2013 4:17 AM, David Rientjes wrote:
> 
> On Thu, 21 Mar 2013, Herbert Xu wrote:
> 
> > > This patch adds CONFIG_PM_SLEEP to suspend/resume functions to fix
> > > the following build warning when CONFIG_PM_SLEEP is not selected.
> > >
> > > drivers/char/hw_random/exynos-rng.c:147:12: warning: 'exynos_rng_runtime_suspend' defined but not
> used [-Wunused-function]
> > > drivers/char/hw_random/exynos-rng.c:157:12: warning: 'exynos_rng_runtime_resume' defined but not
> used [-Wunused-function]
> > >
> > > Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> >
> > Patch applied.  Thanks.
> 
> Nack, it causes build errors when CONFIG_PM_SLEEP is disabled:
> 
> drivers/char/hw_random/exynos-rng.c:167:8: error: 'exynos_rng_runtime_suspend' undeclared here (not in a
> function)
> drivers/char/hw_random/exynos-rng.c:167:8: error: 'exynos_rng_runtime_resume' undeclared here (not in a
> function)

OK, I see.

UNIVERSAL_DEV_PM_OPS is related to both CONFIG_PM_SLEEP and CONFIG_PM_RUNTIME.
Thus, CONFIG_PM_RUNTIME is also necessary.

I will send an additional patch, soon.

Best regards,
Jingoo Han




