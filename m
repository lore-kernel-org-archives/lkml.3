Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758422Ab3FDATz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 20:19:55 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:47432 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754049Ab3FDATu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 20:19:50 -0400
Message-ID: <51AD32A4.5070609@linaro.org>
Date: Mon, 03 Jun 2013 17:19:48 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Stephen Boyd <sboyd@codeaurora.org>
CC: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>, arm@kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCHv2 0/6] Make ARM's sched_clock generic + 64 bit friendly
References: <1370155183-31421-1-git-send-email-sboyd@codeaurora.org>
In-Reply-To: <1370155183-31421-1-git-send-email-sboyd@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/01/2013 11:39 PM, Stephen Boyd wrote:
> This is mostly a resend of a patch series I sent a little over a month
> ago. I've reordered the patches so that John can pick up the first three
> and get a generic sched_clock layer without having to take the 64 bit
> patches. The last three patches add 64 bit support and move the architected
> timers on ARM64 and ARM to use it.


Yea, so from the initial look over it, I think I'm happy with queuing 
the first three patches, although I'd like to get some acks from arm 
folks on at least the first two, just so no one is surprised with it 
going through the -tip tree.

It looks like the arm64 bit stuff needs a few more iterations w/ 
Russell, so I'll not touch those.

We still have a ways to go to consolidate x86 into this (need to handle 
pv hooks), but it should provide a base to get some of the simpler 
arches sharing the same infrastructure.

Also I suspect we can maybe further combine this with the 
kernel/sched/clock.c code, but I think this is a good start for now.

thanks
-john

