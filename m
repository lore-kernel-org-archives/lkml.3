Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755389AbaIQMNn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 08:13:43 -0400
Received: from mail-qg0-f52.google.com ([209.85.192.52]:33847 "EHLO
	mail-qg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754957AbaIQMNl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 08:13:41 -0400
MIME-Version: 1.0
In-Reply-To: <01ce01cfd270$3b3d31b0$b1b79510$@kernel.org>
References: <1410857409-24767-1-git-send-email-gautam.vivek@samsung.com>
	<CAD=FV=U4rPsfGkTcSY3OYHPgCFOccaHTjG1qC6WAekOEV09Q7A@mail.gmail.com>
	<01ce01cfd270$3b3d31b0$b1b79510$@kernel.org>
Date: Wed, 17 Sep 2014 17:43:40 +0530
X-Google-Sender-Auth: a63JFqh0CJXdmrmLSMeBKi7pgag
Message-ID: <CAFp+6iE07b=juik2Ms4WEzzBw0FxPnAgbxtdqVGBBYZQ7fk5zA@mail.gmail.com>
Subject: Re: [PATCH RESEND] ARM: DTS: correct the capability string for mmc0
From: Vivek Gautam <gautam.vivek@samsung.com>
To: Kukjin Kim <kgene@kernel.org>
Cc: Doug Anderson <dianders@chromium.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Seungwon Jeon <tgih.jun@samsung.com>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Kevin Hilman <khilman@linaro.org>,
        Naveen Krishna Chatradhi <ch.naveen@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kukjin,


On Wed, Sep 17, 2014 at 5:39 PM, Kukjin Kim <kgene@kernel.org> wrote:
> Doug Anderson wrote:
>>
>> Vivek,
>>
> Hi,
>
>> On Tue, Sep 16, 2014 at 1:50 AM, Vivek Gautam <gautam.vivek@samsung.com> wrote:
>> > From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
>> >
>> > MMC capability for HS200 is parsed in mmc/core/host.c as
>> > dts string "mmc-hs200-1_8v".
>> >
>> > This patch corrects the dts string for Exynos5420 based peach-pit
>> > and Exynos5800 based peach-pi boards.
>> >
>> > Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
>
> In this case, Vivek's sign is required here.

Ok, i will resend it with my Signed-off

>
>> > ---
>> >
>> > Hi Kukjin,
>> >
>> > As commented by Doug earlier for this patch, the two patches required
>> >   -- mmc: dw_mmc: Make sure we don't get stuck when we get an error
>> >   -- mmc: dw_mmc: change to use recommended reset procedure
>> > are now merged in upstream.
>> > So you can go ahead and pick this change.
>> >
>> >  arch/arm/boot/dts/exynos5420-peach-pit.dts |    2 +-
>> >  arch/arm/boot/dts/exynos5800-peach-pi.dts  |    2 +-
>> >  2 files changed, 2 insertions(+), 2 deletions(-)
>>
>> Reviewed-by: Doug Anderson <dianders@chromium.org>
>
> Thanks, I will take this patch once Vivek replies his sign on this patch.
>
> - Kukjin
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-samsung-soc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Best Regards
Vivek Gautam
Samsung R&D Institute, Bangalore
India
