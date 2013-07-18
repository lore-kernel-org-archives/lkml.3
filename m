Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757811Ab3GRDlN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 23:41:13 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:34579 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753923Ab3GRDlL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 23:41:11 -0400
Message-ID: <51E763D3.4000308@linaro.org>
Date: Wed, 17 Jul 2013 20:41:07 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Stephen Boyd <sboyd@codeaurora.org>
CC: arm@kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>
Subject: Re: [PATCH 0/3] Cleanup sched_clock.h users
References: <1374115161-675-1-git-send-email-sboyd@codeaurora.org>
In-Reply-To: <1374115161-675-1-git-send-email-sboyd@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/17/2013 07:39 PM, Stephen Boyd wrote:
> This patchset cleans up the last few stragglers using the sched_clock.h
> header file in asm and removes the asm header.
>
> A new one appeared in drivers/clocksource so I'm not sure who
> wants to take that one.

Thanks for doing this!

I'll queue the drivers/clocksource one on its own in a separate branch, 
that way I'll merge it into my own 3.12 queue, and Arnd/Olof can also 
merge just that change it in before they drop the asm/sched_clock.h header.

I just pushed it out here:

git://git.linaro.org/people/jstultz/linux.git fortglx/3.12/sched-clock-cleanups


thanks
-john
