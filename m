Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752957Ab3LCIeW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 03:34:22 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:65122 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752601Ab3LCIeU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 03:34:20 -0500
X-AuditID: cbfec7f4-b7f966d0000003d9-8b-529d978a2267
Message-id: <1386059656.1306.0.camel@AMDC1943>
Subject: Re: [PATCH v2 0/5] rtc: s5m: Bug fixes of the driver after tests
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Sangbeom Kim <sbkim73@samsung.com>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>, Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Alessandro Zummo <a.zummo@towertech.it>, linux-kernel@vger.kernel.org,
        rtc-linux@googlegroups.com,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Kyungmin Park <kyungmin.park@samsung.com>
Date: Tue, 03 Dec 2013 09:34:16 +0100
In-reply-to: <20131202151053.40f055dabf91b0f739d65563@linux-foundation.org>
References: <1385626183-22990-1-git-send-email-k.kozlowski@samsung.com>
 <20131202151053.40f055dabf91b0f739d65563@linux-foundation.org>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.2.3-0ubuntu6
Content-transfer-encoding: 7bit
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrPLMWRmVeSWpSXmKPExsVy+t/xa7pd0+cGGUy+LGWx5OJVdos569ew
	WUx9+ITN4tmtvUwWZ5vesFvc/3qU0eLblQ4mi8u75rBZrD1yl91if2cHo8XpblaLiyu+MDnw
	eOycdZfdY8/Ek2wem1Z1snncubaHzePEjN8sHocOdzB6zDsZ6NG3ZRWjx/R5P5k8Pm+SC+CK
	4rJJSc3JLEst0rdL4Mr4sbabuWA1W0Xn7amsDYwtrF2MnBwSAiYSy16vYoewxSQu3FvP1sXI
	xSEksJRRYt/hKYwQzmdGiZl3XrCBVPEK6Ekc2rGXGcQWFvCU2Nq0ggnEZhMwlti8fAlYjYiA
	rsSq57uYQZqZBZYxS8y7fw5sHYuAqsS/w2fBmjkFvCW+TewEWy0k0MEocac1C8RmFlCXmDRv
	ETPESUoSu9shapgF5CU2r3nLDHGEoMSPyfdYJjAKzELSMgtJ2SwkZQsYmVcxiqaWJhcUJ6Xn
	GuoVJ+YWl+al6yXn525ihETSlx2Mi49ZHWIU4GBU4uGdsGdOkBBrYllxZe4hRgkOZiUR3vnp
	c4OEeFMSK6tSi/Lji0pzUosPMTJxcEo1MEocb5hct9Nx9hWxDY8+uq2NPPnwU5icRu2meXci
	t7QWerQ9NAxrrclzKuG+8CbX0U0j54f0lcPNYcr55jLyrgx1B9YeMtAwcvsTlxLPLiIWvVo2
	M0pF7dazA6tYnohaX57JcVlnglzhr/9BTeGbUq/vlD2klOL0eFLJNjuODexOQVnNV4JWKLEU
	ZyQaajEXFScCAOppHQ2CAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-12-02 at 15:10 -0800, Andrew Morton wrote:
> On Thu, 28 Nov 2013 09:09:38 +0100 Krzysztof Kozlowski <k.kozlowski@samsung.com> wrote:
> 
> > This is a second version of patchset of small but important fixes for rtc-s5m
> > driver. Last patches also add waking up on RTC alarm interrupts.
> > 
> > The patchset is based on v3.13-rc1-229-ge7c0d3d and depends on patch from 
> > Geert Uytterhoeven:
> >  - rtc: s5m-rtc: Fix info->rtc assignment
> >    http://article.gmane.org/gmane.linux.kernel/1595905
> 
> When Geert sent that patch he said "I would be really surprised if this
> driver didn't just crash...  Please test.".  I've been waiting for
> someone to test it!  Can I take it that you have done so?

Yes, I tested the driver with these patches.

Best regards,
Krzysztof

