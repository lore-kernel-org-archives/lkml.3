Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751874Ab3IZF3T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 01:29:19 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:14026 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750795Ab3IZF3R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 01:29:17 -0400
X-AuditID: cbfee68e-b7f756d000004512-b9-5243c629a22e
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Tomasz Figa'" <tomasz.figa@gmail.com>,
        linux-arm-kernel@lists.infradead.org
Cc: "'Mateusz Krawczuk'" <m.krawczuk@partner.samsung.com>,
        t.stanislaws@samsung.com, linux-samsung-soc@vger.kernel.org,
        linux@arm.linux.org.uk, s.nawrocki@samsung.com,
        b.zolnierkie@samsung.com, t.figa@samsung.com,
        linux-kernel@vger.kernel.org,
        "'Kyungmin Park'" <kyungmin.park@samsung.com>, ben-linux@fluff.org,
        m.szyprowski@samsung.com
References: <1380038363-487-1-git-send-email-m.krawczuk@partner.samsung.com>
 <2123658.6S6hP57GRg@flatron>
In-reply-to: <2123658.6S6hP57GRg@flatron>
Subject: RE: [PATCH v2] ARM: SAMSUNG: S5P: If detected device tree skip irq init
Date: Thu, 26 Sep 2013 14:29:13 +0900
Message-id: <02c901ceba79$55b382c0$011a8840$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac65WwnstFZDvCfGRWKnTNbCOf1WlgBHdzgg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupgleLIzCtJLcpLzFFi42I5/e+Zka7mMecgg52TpS02zljPajFp3QEm
	i7NNb9gtNj2+xmpxedccNosZ5/cxWdy+zGtxes0pZou1R+6yWxx+085qsX7GaxaLee0vWS1W
	7frD6MDr0dLcw+bxd9ULZo+ds+6ye2xeUu9x8N0eJo++LasYPT5vkgtgj+KySUnNySxLLdK3
	S+DKeLfqDHPBG9aKu81nWBoYL7J0MXJySAiYSCx8fYkNwhaTuHBvPZDNxSEksIxRovHwMkaY
	ogULethBbCGBRYwSxw4pQRT9ZZTYsGIXK0iCTUBD4vD7Z2BFIgL+ElduHGcEKWIWuMYkMfFy
	J1R3tsTWu9OZQGxOAU2Jg++mgG0QFgiQWHqnC6yGRUBVouXZLrAaXgFbiXdbLjNC2IISPybf
	AzubWUBLYv3O40wQtrzE5jVvmbsYOYAuVZd49FcX4gYjiY8rH7NBlIhI7HvxDuweCYGlHBJr
	zi1jgdglIPFt8iEWiF5ZiU0HmCEelpQ4uOIGywRGiVlINs9CsnkWks2zkKxYwMiyilE0tSC5
	oDgpvchIrzgxt7g0L10vOT93EyMkFfTtYLx5wPoQYzLQ+onMUqLJ+cBUklcSb2hsZmRhamJq
	bGRuaUaasJI4r1qLdaCQQHpiSWp2ampBalF8UWlOavEhRiYOTqkGxt7gr4KL/hydWOw+T3+x
	+4Oe+6f2rJije9uxa3Mb53enrZbdx4yTEg8sTsudsvgbM1tI2MbE4El8lo7SN/fdjq3R+fIn
	XLrEmvntpVmOr3c3sG2R/Mu2mvN1sdCNuPN5B7hFzfIXJjsU1S5TvOO8XFp82gUpLYsPSyvT
	L8nNDEj7p6/UfI+3RImlOCPRUIu5qDgRANZHK0AbAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKKsWRmVeSWpSXmKPExsVy+t9jAV3NY85BBs87xCw2zljPajFp3QEm
	i7NNb9gtNj2+xmpxedccNosZ5/cxWdy+zGtxes0pZou1R+6yWxx+085qsX7GaxaLee0vWS1W
	7frD6MDr0dLcw+bxd9ULZo+ds+6ye2xeUu9x8N0eJo++LasYPT5vkgtgj2pgtMlITUxJLVJI
	zUvOT8nMS7dV8g6Od443NTMw1DW0tDBXUshLzE21VXLxCdB1y8wBulZJoSwxpxQoFJBYXKyk
	b4dpQmiIm64FTGOErm9IEFyPkQEaSFjHmPFu1RnmgjesFXebz7A0MF5k6WLk5JAQMJFYsKCH
	HcIWk7hwbz0biC0ksIhR4tghpS5GLiD7L6PEhhW7WEESbAIaEoffPwNrEBHwl7hy4zgjSBGz
	wDUmiYmXO9khurMltt6dzgRicwpoShx8N4URxBYWCJBYeqcLrIZFQFWi5dkusBpeAVuJd1su
	M0LYghI/Jt8Du45ZQEti/c7jTBC2vMTmNW+Zuxg5gC5Vl3j0VxfiBiOJjysfs0GUiEjse/GO
	cQKj0Cwkk2YhmTQLyaRZSFoWMLKsYhRNLUguKE5KzzXUK07MLS7NS9dLzs/dxAhONM+kdjCu
	bLA4xCjAwajEw3uB2TlIiDWxrLgy9xCjBAezkgjvNyOgEG9KYmVValF+fFFpTmrxIcZkoEcn
	MkuJJucDk2BeSbyhsYmZkaWRmYWRibk5acJK4rwHWq0DhQTSE0tSs1NTC1KLYLYwcXBKNTB6
	6dmx9D7pEvkze50WX270+Zfx86NV9bf38ilkRZ+4fLBt+wR7xtBf7y+Gb652TzC+GGgQmm/L
	9DHydfHOwg9Hlk/mq7G9/83p3cuPn42b1I33eAewPJ+5zEg54+qJF6onDt8WPJa5/NhpT4YZ
	nzILX4XNTPFf3xrI2t/HcNZEn/VEi6TBdyslluKMREMt5qLiRACu6hnCeAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tomasz Figa wrote:
> 
> Hi Mateusz,
> 
> On Tuesday 24 of September 2013 17:59:23 Mateusz Krawczuk wrote:
> > It prevents from executing things already handled by pinctrl-exynos
> > driver, when device tree is available.
> >
> > Signed-off-by: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
> > Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> > ---
> >  arch/arm/plat-samsung/s5p-irq-eint.c | 4 ++++
> >  1 file changed, 4 insertions(+)
> 
> Acked-by: Tomasz Figa <t.figa@samsung.com>
> 
> [as a temporary solution until we move all the users of this code to
> device tree]
> 
Yes, agreed.

The 'skip irq init' in subject would be changed to 'skip eint init' for
clear meaning.

Applied.

Thanks,
Kukjin

