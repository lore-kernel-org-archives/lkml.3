Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753728AbaFXS41 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 14:56:27 -0400
Received: from mail-lb0-f177.google.com ([209.85.217.177]:57904 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753224AbaFXS4Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 14:56:25 -0400
MIME-Version: 1.0
In-Reply-To: <CAMuHMdXB4U=tkGgV=UE5KRBgP7jqyB8Wpjn1x6ei-wq-MYkLqQ@mail.gmail.com>
References: <1403259380-13634-6-git-send-email-geert+renesas@glider.be>
	<20140621101959.GM5099@sirena.org.uk>
	<CAMuHMdXB4U=tkGgV=UE5KRBgP7jqyB8Wpjn1x6ei-wq-MYkLqQ@mail.gmail.com>
Date: Tue, 24 Jun 2014 20:56:23 +0200
X-Google-Sender-Auth: LPj_zyW4haoc19_Amj_iqcMl5wA
Message-ID: <CAMuHMdUEkCm_N0zGTftp5_N_u_FQ4-=KH8h8qsrAqLgk6Kk=iQ@mail.gmail.com>
Subject: Re: [PATCH 5/5] spi: sh-msiof: Add DMA support
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Mark Brown <broonie@kernel.org>
Cc: Geert Uytterhoeven <geert+renesas@glider.be>,
        Magnus Damm <magnus.damm@gmail.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        linux-spi <linux-spi@vger.kernel.org>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Sun, Jun 22, 2014 at 10:06 AM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> On Sat, Jun 21, 2014 at 12:19 PM, Mark Brown <broonie@kernel.org> wrote:
>> On Fri, Jun 20, 2014 at 12:16:20PM +0200, Geert Uytterhoeven wrote:
>>> Add DMA support to the MSIOF driver using platform data.
>>
>> This doesn't apply against current code, can you please check and
>> resend?
>
> My patches were based on your for-next branch, which has
> commit 1e8231b79ccbb3e6e7b3f6af9f998dca16b00efe
> Author: Jingoo Han <jg1.han@samsung.com>
> Date:   Tue Apr 29 17:21:25 2014 +0900
>
>     spi: sh-msiof: remove unnecessary OOM messages

Sorry, wrong copy and paste, I meant:

commit b8fa0abd47f3f2fa47c1b2b06182c422d0c2350d
Author: Alexander Shiyan <shc_work@mail.ru>
Date:   Wed Jun 4 18:17:09 2014 +0400

    spi: sh-msiof: Remove unnecessary platform_set_drvdata()

    Drop call to platform_set_drvdata() as driver data is not used
    anywhere in the driver.

    Signed-off-by: Alexander Shiyan <shc_work@mail.ru>
    Signed-off-by: Mark Brown <broonie@linaro.org>

> (from topic/cleanup), but topic/sh-msiof hasn't.

Do you want me to resend? Against which branch?

Basically I had to revert the above commit, as I do use the driver data.
So if I would rebase and resend against topic/sh-msiof, you'll get a merge
conflict when merging this into for-next.

Thanks!

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
