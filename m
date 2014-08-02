Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751869AbaHBFHD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2014 01:07:03 -0400
Received: from mail-vc0-f179.google.com ([209.85.220.179]:37117 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750819AbaHBFHA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2014 01:07:00 -0400
MIME-Version: 1.0
In-Reply-To: <5965899.y405fxfhDg@diego>
References: <1406846976-23127-4-git-send-email-dianders@chromium.org>
	<5965899.y405fxfhDg@diego>
Date: Fri, 1 Aug 2014 22:06:59 -0700
X-Google-Sender-Auth: 2JLsAKy9H-x_5X8YN0AGGRuwgrA
Message-ID: <CAD=FV=WkBeBUMQQwUOR1dDzsVcU-54izhoDwuiMb6Myd0hB+0g@mail.gmail.com>
Subject: Re: [PATCH v4 4/5] ARM: dts: Fix the sort ordering of EHCI and HSIC
 in rk3288.dtsi
From: Doug Anderson <dianders@chromium.org>
To: =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>
Cc: Olof Johansson <olof@lixom.net>, Paul Zimmerman <paulz@synopsys.com>,
        Kever Yang <kever.yang@rock-chips.com>,
        Sonny Rao <sonnyrao@chromium.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Heiko,

On Fri, Aug 1, 2014 at 2:17 AM, Heiko Stübner <heiko@sntech.de> wrote:
> Am Donnerstag, 31. Juli 2014, 15:49:35 schrieb Doug Anderson:
>> The EHCI and HSIC device tree nodes were added in the wrong place.
>> Fix them.
>>
>> Signed-off-by: Doug Anderson <dianders@chromium.org>
>> Signed-off-by: Kever Yang <kever.yang@rock-chips.com>
>
> hmm, not sure if this counts as fix ... aka material for 3.17-rc2 or should
> wait for 3.18. Simply because it's more a cosmetic thing.
>
> If it is a fix, could base it on the appropriate dts revision, because here
> it's in the middle of the dwc2 series, including the
>         usb_host1: usb@ff540000
> nodes.

It didn't seem too urgent since it's just cosmetic.  ...but I didn't
want to send up my fixup and then cause an immediate conflict with
Kever.  :(  ...that's why I asked him to just include it in his
series.

If you want me to spin this patch separately (and then Kever can spin
his), let me know.  I know that for me Kever's series was still not
making the dwc2 controller work 100% correctly for me (so maybe he'll
need to spin anyway?), but someone else at work had it working so
something is fishy.  Unfortunately I'm away from my computer and board
for the next several days, so it might be a while before I can
investigate more...

-Doug
