Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753020AbaIXH1f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 03:27:35 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:38285 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750940AbaIXH1d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 03:27:33 -0400
MIME-Version: 1.0
In-Reply-To: <54227038.2020805@free-electrons.com>
References: <1411311493-24344-1-git-send-email-wens@csie.org>
 <1411311493-24344-4-git-send-email-wens@csie.org> <20140924063738.GQ15315@lukather>
 <CAGb2v64voZpK_82wtkErRowR0vjEUALNUwvCx_sd8Q5wb4Hq-g@mail.gmail.com> <54227038.2020805@free-electrons.com>
From: Chen-Yu Tsai <wens@csie.org>
Date: Wed, 24 Sep 2014 15:27:13 +0800
X-Google-Sender-Auth: XdIKgMCWN5wrtJPtKipLY7pjXCs
Message-ID: <CAGb2v66WvZXVD6r70wCP_ZyfMH8rf04JO2B4K+DtDvwoBTaP5Q@mail.gmail.com>
Subject: Re: [linux-sunxi] Re: [PATCH 3/6] ARM: dts: sunxi: Add Allwinner A80 dtsi
To: linux-sunxi <linux-sunxi@googlegroups.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        devicetree <devicetree@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Shuge <shuge@allwinnertech.com>, Meng Zhang <kevin@allwinnertech.com>,
        yhf <yhf@merrii.com>, ctl <ctl@merrii.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2014 at 3:18 PM, Gregory CLEMENT
<gregory.clement@free-electrons.com> wrote:
> Hi Chen-Yu,
>
>
>>>> +
>>>> +     memory {
>>>> +             reg = <0x20000000 0x40000000>;
>>>
>>> Usually, what we put there was the maximum amount of RAM that can be
>>> handled by the SoC. I think that it can go above 1GB
>>
>> With LPAE, it can handle 8GB. But the DT won't take 64bit values.
>> I'm not sure how to get it in. I'll look around for examples.
>
> You can have a look on what we did for Armada XP:
>
> arch/arm/boot/dts/armada-370-xp.dtsi
> arch/arm/boot/dts/armada-xp.dtsi
> arch/arm/boot/dts/armada-xp-gp.dts
>
> I created a skeleton64.dtsi for this case

Thanks! I was wondering what that was for.

ChenYu
