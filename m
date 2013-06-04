Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751136Ab3FDR4G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 13:56:06 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:47607 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750883Ab3FDR4E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 13:56:04 -0400
Message-ID: <51AE2A30.4010903@linaro.org>
Date: Tue, 04 Jun 2013 10:56:00 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Stephen Boyd <sboyd@codeaurora.org>
CC: Baruch Siach <baruch@tkos.co.il>, Russell King <linux@arm.linux.org.uk>,
        linux-arm-msm@vger.kernel.org, Will Deacon <will.deacon@arm.com>,
        linux-kernel@vger.kernel.org, arm@kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCHv2 3/6] sched_clock: Make ARM's sched_clock generic for
 all architectures
References: <1370155183-31421-1-git-send-email-sboyd@codeaurora.org> <1370155183-31421-4-git-send-email-sboyd@codeaurora.org> <20130603071235.GO11798@tarshish> <51ACF374.5040606@codeaurora.org>
In-Reply-To: <51ACF374.5040606@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/03/2013 12:50 PM, Stephen Boyd wrote:
> On 06/03/13 00:12, Baruch Siach wrote:
>> Hi Stephen,
>>
>> On Sat, Jun 01, 2013 at 11:39:40PM -0700, Stephen Boyd wrote:
>>>   {arch/arm/include/asm => include/linux}/sched_clock.h | 9 +++++++--
>> Shouldn't we just merge this header into the existing linux/sched.h?
> I don't know. John/Thomas, any thoughts? One benefit with it this way is
> that we don't have to recompile all the timer drivers if we change
> sched.h for other reasons.

Yea, I'm fine keeping it separate for now. We can merge them together if 
we see fit later.

But if anyone feels particularly strongly, let me know.

thanks
-john

