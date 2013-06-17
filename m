Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752126Ab3FQQXG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 12:23:06 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:54888 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751174Ab3FQQXE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 12:23:04 -0400
Message-ID: <51BF37E4.8020006@linaro.org>
Date: Mon, 17 Jun 2013 09:23:00 -0700
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
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCHv2 0/6] Make ARM's sched_clock generic + 64 bit friendly
References: <1370155183-31421-1-git-send-email-sboyd@codeaurora.org> <51AD32A4.5070609@linaro.org> <20130604160907.GW27516@mudshark.cambridge.arm.com> <51AE2980.6010005@linaro.org> <20130616094501.GG10269@tarshish>
In-Reply-To: <20130616094501.GG10269@tarshish>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/16/2013 02:45 AM, Baruch Siach wrote:
> Hi John,
>
> On Tue, Jun 04, 2013 at 10:53:04AM -0700, John Stultz wrote:
>> On 06/04/2013 09:09 AM, Will Deacon wrote:
>>> On Tue, Jun 04, 2013 at 01:19:48AM +0100, John Stultz wrote:
>>>> On 06/01/2013 11:39 PM, Stephen Boyd wrote:
>>>>> This is mostly a resend of a patch series I sent a little over a month
>>>>> ago. I've reordered the patches so that John can pick up the first three
>>>>> and get a generic sched_clock layer without having to take the 64 bit
>>>>> patches. The last three patches add 64 bit support and move the architected
>>>>> timers on ARM64 and ARM to use it.
>>>> Yea, so from the initial look over it, I think I'm happy with queuing
>>>> the first three patches, although I'd like to get some acks from arm
>>>> folks on at least the first two, just so no one is surprised with it
>>>> going through the -tip tree.
>>> The first two patches are pretty simple so, FWIW, you can add my ack on those:
>>>
>>>    Acked-by: Will Deacon <will.deacon@arm.com>
>> Thanks! Added to the commits.
> What is the status of this series then? Is there a chance of seeing it in
> 3.11? I want to base some xtensa architecture work on this, so I'd like to
> know whether there is a stable base to start from.
I've got the first three in my internal tree, and was going to send it 
by Thomas for 3.11 this week.

Thanks for the ping!
-john
