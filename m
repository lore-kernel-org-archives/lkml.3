Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752040Ab3J2TBl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 15:01:41 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:44744 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751305Ab3J2TBk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 15:01:40 -0400
From: Kevin Hilman <khilman@linaro.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH] ARM: Support arch_irq_work_raise() via self IPIs
References: <526DBEAA.4030707@linaro.org>
	<1382984701-2371-1-git-send-email-sboyd@codeaurora.org>
	<878uxcq1m7.fsf@linaro.org> <20131029060058.GD21983@codeaurora.org>
Date: Tue, 29 Oct 2013 11:55:53 -0700
In-Reply-To: <20131029060058.GD21983@codeaurora.org> (Stephen Boyd's message
	of "Mon, 28 Oct 2013 23:00:58 -0700")
Message-ID: <874n7zq53a.fsf@linaro.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Boyd <sboyd@codeaurora.org> writes:

> On 10/28, Kevin Hilman wrote:
>> Stephen Boyd <sboyd@codeaurora.org> writes:
>> 
>> > This will allow the scheduler tick to be restarted if we're in
>> > full NOHZ mode.
>> >
>> > Cc: Kevin Hilman <khilman@linaro.org>
>> > Cc: Frederic Weisbecker <fweisbec@gmail.com>
>> > Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
>> 
>> Minor nit, but I'd prefer a more verbose changelog (I forget things
>> quickly and like to rely on changelogs for my memory.)  Probably worth
>> adding something like: "By default, irq_work is tied to the tick
>> processing (update_process_times()) but in full NOHZ mode, no tick means
>> no IRQ work.  In order for IRQ work to be done in full NOHZ mode, a
>> self-IPI is used to process IRQ work."
>> 
>> Other than the changelog nit, patch looks good, feel free to add
>> 
>> Reviewed-by: Kevin Hilman <khilman@linaro.org>
>> 
>> If Russell is OK with this, it can go to his patch system.
>> 
>
> Fair enough. This is what I came up with. I'll send it off to the
> patch tracker in about 12 hours if nobody else has anymore
> comments.

Nice description, thanks for the respin.

Kevin
