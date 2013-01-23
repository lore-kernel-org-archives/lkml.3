Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752299Ab3AWFRr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 00:17:47 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:57365 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750897Ab3AWFRq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 00:17:46 -0500
Message-ID: <50FF7295.2000300@ti.com>
Date: Wed, 23 Jan 2013 10:48:13 +0530
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Tony Lindgren <tony@atomide.com>
CC: John Stultz <john.stultz@linaro.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, Peter Zijlstra <peterz@infradead.org>,
        Matt Sealey <matt@genesi-usa.com>, LKML <linux-kernel@vger.kernel.org>,
        Ben Dooks <ben@simtec.co.uk>, Ingo Molnar <mingo@redhat.com>,
        Linux ARM Kernel ML <linux-arm-kernel@lists.infradead.org>
Subject: Re: One of these things (CONFIG_HZ) is not like the others..
References: <CAKGA1bkiowcO7OPSfPmaB6eRj_3FNr+4ONnaQHEZkpxB2XfduQ@mail.gmail.com> <20130121232322.GK15361@atomide.com> <50FE307F.9000701@ti.com> <201301220931.24570.arnd@arndb.de> <50FE666B.10902@ti.com> <20130122145113.GK23505@n2100.arm.linux.org.uk> <50FEE175.90504@linaro.org> <20130122215257.GU22517@atomide.com>
In-Reply-To: <20130122215257.GU22517@atomide.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 23 January 2013 03:22 AM, Tony Lindgren wrote:
> * John Stultz <john.stultz@linaro.org> [130122 11:02]:
>>
>> Correct, with HRT, we actually trigger the HZ-frequency timer tick
>> from an hrtimer (which expires based on the system time driven by
>> the clocksource). Thus even if there is a theoretical error between
>> the ideal HZ and what the hardware can do, that error will not
>> propagate forward.
>
> If there's no cumulative error, sounds like the way to go is to select
> HRT for ARM multiplatform builds and set the HZ to 100 then.
>
HIGH_RES_TIMERS are always enabled by default for OMAP as well as
multi-platform build.

Regards,
Santosh
