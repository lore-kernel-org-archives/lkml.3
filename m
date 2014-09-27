Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753093AbaI0NQZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2014 09:16:25 -0400
Received: from mail-ig0-f174.google.com ([209.85.213.174]:50589 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751335AbaI0NQX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2014 09:16:23 -0400
MIME-Version: 1.0
In-Reply-To: <20140925132527.GF15315@lukather>
References: <1411570141-29960-1-git-send-email-wens@csie.org>
 <1411570141-29960-2-git-send-email-wens@csie.org> <20140925132527.GF15315@lukather>
From: Chen-Yu Tsai <wens@csie.org>
Date: Sat, 27 Sep 2014 21:16:02 +0800
X-Google-Sender-Auth: u7MkHcOK9NDlrVvPkm44hwZJWr4
Message-ID: <CAGb2v64LwgEZkiuej2KKi+CUU3OkUZaBKJ3ZZn_Y64tDD+LRwg@mail.gmail.com>
Subject: Re: [PATCH v2 1/7] ARM: sunxi: Introduce Allwinner A80 support
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        devicetree <devicetree@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Shuge <shuge@allwinnertech.com>, Meng Zhang <kevin@allwinnertech.com>,
        ctl <ctl@merrii.com>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 25, 2014 at 9:25 PM, Maxime Ripard
<maxime.ripard@free-electrons.com> wrote:
> On Wed, Sep 24, 2014 at 10:48:55PM +0800, Chen-Yu Tsai wrote:
>> The Allwinner A80 is a new Cortex octo-core A7/A15 big.LITTLE SoC.
>> While it's processor cores and interconnecting bus are new, it
>> re-uses many peripherals found in earlier Allwinner SoCs.
>>
>> Signed-off-by: Chen-Yu Tsai <wens@csie.org>
>> ---
>>  arch/arm/mach-sunxi/Kconfig | 5 +++++
>>  arch/arm/mach-sunxi/sunxi.c | 9 +++++++++
>>  2 files changed, 14 insertions(+)
>>
>> diff --git a/arch/arm/mach-sunxi/Kconfig b/arch/arm/mach-sunxi/Kconfig
>> index 1aaa1e1..72f222b 100644
>> --- a/arch/arm/mach-sunxi/Kconfig
>> +++ b/arch/arm/mach-sunxi/Kconfig
>> @@ -42,4 +42,9 @@ config MACH_SUN8I
>>       select MFD_SUN6I_PRCM
>>       select RESET_CONTROLLER
>>
>> +config MACH_SUN9I
>> +     bool "Allwinner A80 (sun9i) SoCs support"
>
> With the new naming scheme, I wonder wether it makes sense to have the
> A80 displayed here and in the machine definition.

I expect anything that falls under sun9i to be compatible, or a trimmed
down version. But that's just me.

We know that Allwinner has released the A33, which should be compatible
with the A23, sun8i. And the A83 has been announced, which looks like
a trimmed down version of the A80. The next SoC should be arm64, and
would not matter here.

Kevin, Shuge, could you provide us with the codenames for the A33 and
A83, and what earlier SoC they are based on?


Thanks
ChenYu
