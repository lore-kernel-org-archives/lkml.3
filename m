Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933720AbaH0NAA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 09:00:00 -0400
Received: from mail-lb0-f182.google.com ([209.85.217.182]:37378 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933257AbaH0M76 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 08:59:58 -0400
MIME-Version: 1.0
In-Reply-To: <CAMuHMdWwhLuPp_-4Mhnk4tb_azCeLU7bYEgBUf4zR5bMmd6RHQ@mail.gmail.com>
References: <1408969564-6335-1-git-send-email-ulf.hansson@linaro.org>
	<CAMuHMdWwhLuPp_-4Mhnk4tb_azCeLU7bYEgBUf4zR5bMmd6RHQ@mail.gmail.com>
Date: Wed, 27 Aug 2014 14:59:57 +0200
Message-ID: <CAPDyKFr3b6zKAdGrUDM_aMOymLsAag=UvUVX2V4jLYOt_rzKAg@mail.gmail.com>
Subject: Re: [PATCH 00/12] mmc: tmio: Fixup PM support
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Linux MMC List <linux-mmc@vger.kernel.org>,
        Ian Molton <ian.molton@codethink.co.uk>, Chris Ball <chris@printf.net>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26 August 2014 09:46, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> Hi Ulf,
>
> On Mon, Aug 25, 2014 at 2:25 PM, Ulf Hansson <ulf.hansson@linaro.org> wrote:
>> This patchset fixup the PM support for tmio and the tmio hosts.
>> Some re-structuring of the code was also necessary to accomplish the above.
>>
>> A few of these patches has been posted earlier, but at that time I couldn't get
>> help in testing them on hardware. Let's give this a second try now.
>>
>> http://www.spinics.net/lists/linux-mmc/msg23177.html
>>
>> Ulf Hansson (12):
>>   mmc: tmio: Keep host active while SDIO IRQ is enabled
>>   mmc: tmio: Keep host active while serving requests
>>   mmc: tmio: Extract bus_width modifications to a separate function
>>   mmc: tmio: Restructure ->set_ios() and adapt ->probe() to it
>>   mmc: tmio: Handle clock gating from runtime PM functions
>>   mmc: tmio: Mask all IRQs when inactive
>>   mmc: tmio: Make runtime PM callbacks available for CONFIG_PM
>>   mmc: sdhi: Make runtime PM callbacks available for CONFIG_PM
>>   mmc: tmio_mmc: Enable runtime PM support
>>   mmc: sdhi: Fixup system PM suspend lock-up
>>   mmc: tmio_mmc: Fixup system PM suspend lock-up
>>   mmc: tmio: Remove library functions for system PM
>
> I gave this series a test run on r8a7791/Koelsch, everything seems to
> work fine.
> Even more important, s2ram was fixed by "mmc: sdhi: Fixup system PM
> suspend lock-up".
>
> For the whole series:
> Acked-by: Geert Uytterhoeven <geert+renesas@glider.be>
>
> Thanks!
>
> Gr{oetje,eeting}s,
>
>                         Geert

Geert, thanks helping out testing etc.

I have applied this series with your ack/tested by tag.

Kind regards
Uffe
