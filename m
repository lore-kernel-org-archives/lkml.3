Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753728Ab3FQSON (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 14:14:13 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:35693 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750929Ab3FQSOK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 14:14:10 -0400
Message-ID: <51BF51EE.9020305@linaro.org>
Date: Mon, 17 Jun 2013 11:14:06 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Baruch Siach <baruch@tkos.co.il>
CC: Will Deacon <will.deacon@arm.com>, Russell King <linux@arm.linux.org.uk>,
        Peter Zijlstra <peterz@infradead.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "arm@kernel.org" <arm@kernel.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Chris Zankel <chris@zankel.net>, Max Filippov <jcmvbkbc@gmail.com>
Subject: Re: [PATCHv2 0/6] Make ARM's sched_clock generic + 64 bit friendly
References: <1370155183-31421-1-git-send-email-sboyd@codeaurora.org> <51AD32A4.5070609@linaro.org> <20130604160907.GW27516@mudshark.cambridge.arm.com> <51AE2980.6010005@linaro.org> <20130616094501.GG10269@tarshish> <51BF37E4.8020006@linaro.org> <20130617180211.GJ10269@tarshish>
In-Reply-To: <20130617180211.GJ10269@tarshish>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/17/2013 11:02 AM, Baruch Siach wrote:
>> to send
>> >it by Thomas for 3.11 this week.
> Good, thanks. This means that the xtensa ccount sched_clock patch
> (http://lists.linux-xtensa.org/pipermail/linux-xtensa/Week-of-Mon-20130617/001077.html)
> that depends on the third patch in this series, can go in for 3.11, if the
> xtensa maintainer acks it (added to Cc). How should we handle the dependency
> then?
Well, Thomas hasn't picked them up yet, so he could still object, so no 
promises yet :)

As for the dependency, either you can base your patches off of 
tip/timers/core (once the patches land there) and send a pull request to 
the maintainer (so he gets the dependencies in -tip), or we can see 
about queuing your changes via tip/timers/core (assuming you get 
maintainer acks).

thanks
-john
