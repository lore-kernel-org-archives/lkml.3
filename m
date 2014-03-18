Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752759AbaCRGIj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 02:08:39 -0400
Received: from mail-we0-f177.google.com ([74.125.82.177]:54313 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751717AbaCRGIh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 02:08:37 -0400
MIME-Version: 1.0
In-Reply-To: <01a301cf426d$55d080b0$01718210$@samsung.com>
References: <1395026886-14325-1-git-send-email-djkurtz@chromium.org>
	<CAAQKjZMeeyD+6fhCaGk9qzX0oLTS=vHU86Y7gF9ZnbwcpTT7Kg@mail.gmail.com>
	<01a301cf426d$55d080b0$01718210$@samsung.com>
Date: Tue, 18 Mar 2014 15:08:36 +0900
X-Google-Sender-Auth: sqGcMu1dGqPRlLubk1avf5_51uw
Message-ID: <CAAQKjZPCq=d_mcWbpVhpMhXr1G3sDD7=BQ3cqOiqQ6_TTWfMCA@mail.gmail.com>
Subject: Re: [PATCH] drm/exynos: Fix (more) freeing issues in exynos_drm_drv.c
From: Inki Dae <inki.dae@samsung.com>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: Daniel Kurtz <djkurtz@chromium.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-03-18 14:45 GMT+09:00 Kukjin Kim <kgene.kim@samsung.com>:
> Inki Dae wrote:
>>
>> Applied.
>>
>> Thanks,
>> Inki Dae
>>
>> 2014-03-17 12:28 GMT+09:00 Daniel Kurtz <djkurtz@chromium.org>:
>> > The following commit [0] fixed a use-after-free, but left the subdrv
>> open
>> > in the error path.
>> >
>> > [0] commit 6ca605f7c70895a35737435f17ae9cc5e36f1466
>> > drm/exynos: Fix freeing issues in exynos_drm_drv.c
>> >
>> > Change-Id: I452e944bf090fb11434d9e34213c890c41c15d73
>
> This should be removed when Inki apply this.
>

No, Daniel's patch just complements above previous one that is what I missed.

Thanks,
Inki Dae

> Thanks,
> Kukjin
>
>> > Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
>> > ---
>> >  drivers/gpu/drm/exynos/exynos_drm_drv.c | 10 +++++++---
>> >  1 file changed, 7 insertions(+), 3 deletions(-)
>
>
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
