Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756269AbaGSAOa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 20:14:30 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:37781 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752278AbaGSAO3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 20:14:29 -0400
Message-ID: <53C9B862.5050106@linaro.org>
Date: Fri, 18 Jul 2014 17:14:26 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Stephen Boyd <sboyd@codeaurora.org>
CC: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] sched_clock: Avoid corrupting hrtimer tree during suspend
References: <1405721392-30795-1-git-send-email-sboyd@codeaurora.org> <53C99EC5.2060602@linaro.org> <53C9A1EC.8060905@codeaurora.org> <53C9A2E7.8020307@linaro.org> <53C9ACCA.3070306@codeaurora.org>
In-Reply-To: <53C9ACCA.3070306@codeaurora.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/18/2014 04:24 PM, Stephen Boyd wrote:
> On 07/18/14 15:42, John Stultz wrote:
>> If its a regression (and needs -stable backports) it needs to go in via
>> tip/timers/urgent, and not via the regular merge window.
>>
>> Whats the additional risk -stable wise for canceling the timer during
>> suspend and starting it back up during resume?
>>
> I'd say close to zero given that we'd only be making the timer run a
> little bit later and we have slack in there already. Here's that version.

Ok, thanks. I'll try to do a closer review it and get it queued. Is
there anyone who might be able to validate this and provide a Tested-by: ?

thanks
-john


