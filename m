Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752226AbaF0A2q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 20:28:46 -0400
Received: from mail-ve0-f181.google.com ([209.85.128.181]:60222 "EHLO
	mail-ve0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750699AbaF0A2p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 20:28:45 -0400
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:157d:19a6:92bf:f0af:3806]
In-Reply-To: <20140623092650.GE8847@lee--X1>
References: <1402953143-24681-1-git-send-email-dianders@chromium.org>
	<20140618092012.GF23945@lee--X1>
	<CAD=FV=UiA=bsvune6A=wq+zKFq1+pkem0gTa-utxmBB6tKYM=A@mail.gmail.com>
	<20140623092650.GE8847@lee--X1>
Date: Thu, 26 Jun 2014 17:28:44 -0700
Message-ID: <CAOesGMj5+28u-sVithbOg-=SXeanje9jO8H=mzgp5AEA8kCABQ@mail.gmail.com>
Subject: Re: [PATCH] mfd: cros_ec_spi: set wakeup capability
From: Olof Johansson <olof@lixom.net>
To: Lee Jones <lee.jones@linaro.org>
Cc: Doug Anderson <dianders@chromium.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 23, 2014 at 2:26 AM, Lee Jones <lee.jones@linaro.org> wrote:
>> Lee (-others),
>
> Re-CC'ing the list.
>
>> On Wed, Jun 18, 2014 at 2:20 AM, Lee Jones <lee.jones@linaro.org> wrote:
>> >> From: Prathyush K <prathyush.k@samsung.com>
>> >>
>> >> Set the device as wakeup capable and register the wakeup source.
>> >>
>> >> Note: Though it makes more sense to have the SPI framework do this,
>> >> (either via device tree or by board_info)
>> >> this change is as per an existing mail chain:
>> >> https://lkml.org/lkml/2009/8/27/291
>> >>
>> >> Signed-off-by: Prathyush K <prathyush.k@samsung.com>
>> >> Signed-off-by: Doug Anderson <dianders@chromium.org>
>> >> ---
>> >> Note that I don't have suspend/resume actually working upstream, but I
>> >> see that /sys/bus/spi/drivers/cros-ec-spi/spi2.0/power/wakeup exists
>> >> with this patch and doesn't exist without it.
>> >
>> > Very well.  Applied, thanks.
>>
>> Thanks for applying!  ...did this go in some non-standard branch?  I
>> see another of my patches got committed to your "for-mfd-next" tree on
>> the 19th but I don't see this one...
>
> Patience Grasshopper.  When I say that it's applied, it means that I
> have done so locally only.  After I've collected a few local patches
> I'll usually then fix them all with with my SoB and push them out to
> the public MFD tree.
>
> BTW, it's always best to leave the ML in as CC, so others can see the
> answer to these types of questions.  It may save a few emails a year,
> but every little helps. :)

It's great to see this on the list, because I find your workflow as a
maintainer to be hard to follow as a developer.

You applying patches but taking several days to push out makes it
completely opaque for someone to know if you just accidentally missed
to apply the patch after all (it happens, I've done that myself). It's
pretty common to expect a "thanks, applied" patch to show up in
linux-next within one day or so depending on timing.

The fact that you had already pushed out a patch that you had replied
to even later makes for extra confusion. So I'm sorry Lee, but I don't
think Doug was unreasonable in asking for status here. Sometimes
maintainers forget to push, which is why it's a good idea to ping a
few days later if the patch hasn't showed up in -next.


-Olof
