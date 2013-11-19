Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753142Ab3KSSnJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 13:43:09 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:43168 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751663Ab3KSSnG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 13:43:06 -0500
Date: Tue, 19 Nov 2013 18:42:48 +0000
From: Russell King <rmk@arm.linux.org.uk>
To: linux-kernel@vger.kernel.org, mingo@kernel.org, hpa@zytor.com,
        voice.shen@atmel.com, sboyd@codeaurora.org, akpm@linux-foundation.org,
        tglx@linutronix.de
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:sched/urgent] sched_clock: Document 4Mhz vs 1Mhz decision
Message-ID: <20131119184248.GA27599@flint.arm.linux.org.uk>
References: <tip-ce5dae03973461e2a42098c53d62946b98baab42@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-ce5dae03973461e2a42098c53d62946b98baab42@git.kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 19, 2013 at 10:12:23AM -0800, tip-bot for Stephen Boyd wrote:
> +	/*
> +	 * Use 4MHz instead of 1MHz so that things like 1.832Mhz show as
> +	 * 1832Khz

How about getting proper SI units.

Hertz is Hz - that's capital H and lower case z.  It's also the surname
of an engineer.

Kilo is always lower case k.  Therefore, the unit of 1000 cycles per
second is kHz and not KHZ, khz, Khz, khZ or any other stupid mixture
of cases.

Given that we are programmers, and programming computers requires an
attention to detail, completely ignoring such detail when it comes to
SI units is extremely poor - and suggests that we are illerate.

May I suggest more care is taken in the future?

-- 
Russell King
ARM architecture Linux Kernel maintainer
