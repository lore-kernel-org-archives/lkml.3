Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750839Ab3FDRxL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 13:53:11 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:60262 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750748Ab3FDRxI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 13:53:08 -0400
Message-ID: <51AE2980.6010005@linaro.org>
Date: Tue, 04 Jun 2013 10:53:04 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Will Deacon <will.deacon@arm.com>
CC: Stephen Boyd <sboyd@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@arm.linux.org.uk>,
        "arm@kernel.org" <arm@kernel.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCHv2 0/6] Make ARM's sched_clock generic + 64 bit friendly
References: <1370155183-31421-1-git-send-email-sboyd@codeaurora.org> <51AD32A4.5070609@linaro.org> <20130604160907.GW27516@mudshark.cambridge.arm.com>
In-Reply-To: <20130604160907.GW27516@mudshark.cambridge.arm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/04/2013 09:09 AM, Will Deacon wrote:
> On Tue, Jun 04, 2013 at 01:19:48AM +0100, John Stultz wrote:
>> On 06/01/2013 11:39 PM, Stephen Boyd wrote:
>>> This is mostly a resend of a patch series I sent a little over a month
>>> ago. I've reordered the patches so that John can pick up the first three
>>> and get a generic sched_clock layer without having to take the 64 bit
>>> patches. The last three patches add 64 bit support and move the architected
>>> timers on ARM64 and ARM to use it.
>>
>> Yea, so from the initial look over it, I think I'm happy with queuing
>> the first three patches, although I'd like to get some acks from arm
>> folks on at least the first two, just so no one is surprised with it
>> going through the -tip tree.
> The first two patches are pretty simple so, FWIW, you can add my ack on those:
>
>    Acked-by: Will Deacon <will.deacon@arm.com>
Thanks! Added to the commits.

-john

