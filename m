Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758180Ab3KIAHQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 19:07:16 -0500
Received: from mail-qe0-f43.google.com ([209.85.128.43]:39422 "EHLO
	mail-qe0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757975Ab3KIAHH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 19:07:07 -0500
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:1b02:6e3b:e5ff:fe16:f1aa]
In-Reply-To: <20131109000123.GV16735@n2100.arm.linux.org.uk>
References: <526DBEAA.4030707@linaro.org>
	<1382984701-2371-1-git-send-email-sboyd@codeaurora.org>
	<878uxcq1m7.fsf@linaro.org>
	<20131029060058.GD21983@codeaurora.org>
	<CAOesGMhjC=NDn4YiY4tQ3ZcW_rK9_qOY03CVD1eyVFC74ucdrA@mail.gmail.com>
	<CAOesGMhB2Akf_B2_J3LVdt1bDvcsTE7+8Kq=NvsXmkf3EwGsiw@mail.gmail.com>
	<527D5D5C.2080409@codeaurora.org>
	<CAOesGMhyPaMUs3XJshqZ-KYhtWhenttq7qDpF0+4dQ9PvBYVGA@mail.gmail.com>
	<527D7621.2000105@codeaurora.org>
	<20131109000123.GV16735@n2100.arm.linux.org.uk>
Date: Fri, 8 Nov 2013 16:07:06 -0800
Message-ID: <CAOesGMj5X13YRX+K_BdE1X4YHEzWt992-S4r+VdJvB=ujiageA@mail.gmail.com>
Subject: Re: [PATCH] ARM: Support arch_irq_work_raise() via self IPIs
From: Olof Johansson <olof@lixom.net>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Stephen Boyd <sboyd@codeaurora.org>, Kevin Hilman <khilman@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 8, 2013 at 4:01 PM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Fri, Nov 08, 2013 at 03:39:13PM -0800, Stephen Boyd wrote:
>> On 11/08/13 15:35, Olof Johansson wrote:
>> > On Fri, Nov 8, 2013 at 1:53 PM, Stephen Boyd <sboyd@codeaurora.org> wrote:
>> >>
>> >> Ah yes. We don't have IPI support on UP kernels but SMP_ON_UP exposes
>> >> arch_irq_work_raise(). How about this? We should just skip this function
>> >> if we're running on UP.
>> > Yep.
>> >
>> > Tested-by: Olof Johansson <olof@lixom.net>
>> >
>> > Send it to Russell's tracker, plz.
>> >
>>
>> Thanks. 7887/1.
>
> It's probably going to miss Stephen's pull from my tree this evening (if
> he even does one) so... that gives me two options: either drop the original
> commit or apply this.

It's Saturday for Stephen, so he won't do another one until Sunday
night our time.

> I think I'll apply this and put it in place just after the original commit
> which caused the breakage.

Thanks, sounds good to me.


-Olof
