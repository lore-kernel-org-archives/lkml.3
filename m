Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752894AbaIYJ6R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 05:58:17 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:53387 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752149AbaIYJ6P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 05:58:15 -0400
MIME-Version: 1.0
X-Originating-IP: [95.23.101.112]
In-Reply-To: <542271E8.4020606@samsung.com>
References: <1411499141-26551-1-git-send-email-tomasz.figa@gmail.com>
	<542271E8.4020606@samsung.com>
Date: Thu, 25 Sep 2014 11:58:14 +0200
Message-ID: <CABxcv=nWddbECGxBEZCa1K3KDeR5uhNWaEzFsuTfNxC1xq2gFQ@mail.gmail.com>
Subject: Re: [PATCH 0/5] pinctrl: samsung: Data structure clean-up
From: Javier Martinez Canillas <javier@dowhile0.org>
To: Tomasz Figa <tomasz.figa@gmail.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Tomasz,

On Wed, Sep 24, 2014 at 9:25 AM, Marek Szyprowski
<m.szyprowski@samsung.com> wrote:
>>
>> This series should not introduce any functional changes.
>>
>> Tested on S3C6410-based Mini6410 board, booting with device tree.
>>
>> Marek, Bart, could you do some testing on Exynos-based boards,
>> just to make sure?
>
>
> Works fine on Exynos4412 based OdroidU3+ and Exynos4210 Universal C210.
>
> For the whole patchset:
> Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
>

I tested this series on an Exynos5250 Snow and an Exynos5420 Peach Pit
Chromebook and both were working fine.

Tested by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>

Best regards,
Javier
