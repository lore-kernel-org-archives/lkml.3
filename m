Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754836AbaBRKk1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 05:40:27 -0500
Received: from mail-qc0-f176.google.com ([209.85.216.176]:52671 "EHLO
	mail-qc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754806AbaBRKkW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 05:40:22 -0500
MIME-Version: 1.0
In-Reply-To: <52FA1E59.1000307@linaro.org>
References: <1392027058-11680-1-git-send-email-ivan.khoronzhuk@ti.com>
	<1392027058-11680-2-git-send-email-ivan.khoronzhuk@ti.com>
	<52FA1E59.1000307@linaro.org>
Date: Tue, 18 Feb 2014 11:40:21 +0100
Message-ID: <CABuKBeJNwe5VXi2SvPX6Cne-iMHP7bbZarJDNAzuCMbg0E-bCQ@mail.gmail.com>
Subject: Re: [PATCH v6 1/3] clocksource: timer-keystone: introduce clocksource
 driver for Keystone
From: Matthias Brugger <matthias.bgg@gmail.com>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>, santosh.shilimkar@ti.com,
        Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>,
        galak@codeaurora.org, mark.rutland@arm.com, devicetree@vger.kernel.org,
        grygorii.strashko@ti.com, pawel.moll@arm.com,
        ijc+devicetree@hellion.org.uk, joshc@codeaurora.org,
        linux-doc@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        robh+dt@kernel.org, tglx@linutronix.de,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-02-11 13:58 GMT+01:00 Daniel Lezcano <daniel.lezcano@linaro.org>:
> On 02/10/2014 11:10 AM, Ivan Khoronzhuk wrote:
>>
>> Add broadcast clock-event device for the Keystone arch.
>>
>> The timer can be configured as a general-purpose 64-bit timer,
>> dual general-purpose 32-bit timers. When configured as dual 32-bit
>> timers, each half can operate in conjunction (chain mode) or
>> independently (unchained mode) of each other.
>>
>> Reviewed-by: Stephen Boyd <sboyd@codeaurora.org>
>> Acked-by: Santosh shilimkar <santosh.shilimkar@ti.com>
>> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
>> ---
>
>
> Applied to my tree for 3.15

I wanted to send a trivial follow-up patch, but I can't find the tree
to which you have applied this patch.
Would you mind to indicate me where I can find it.

Cheers,
Matthias

>
> --
>  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs
>
> Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
> <http://twitter.com/#!/linaroorg> Twitter |
> <http://www.linaro.org/linaro-blog/> Blog
>
>
>
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel



-- 
motzblog.wordpress.com
