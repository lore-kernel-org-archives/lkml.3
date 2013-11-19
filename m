Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752692Ab3KSTM7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 14:12:59 -0500
Received: from mail-ee0-f54.google.com ([74.125.83.54]:55000 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751821Ab3KSTM5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 14:12:57 -0500
Date: Tue, 19 Nov 2013 20:12:54 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Russell King <rmk@arm.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, voice.shen@atmel.com,
        sboyd@codeaurora.org, akpm@linux-foundation.org, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:sched/urgent] sched_clock: Document 4Mhz vs 1Mhz decision
Message-ID: <20131119191254.GA22311@gmail.com>
References: <tip-ce5dae03973461e2a42098c53d62946b98baab42@git.kernel.org>
 <20131119184248.GA27599@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131119184248.GA27599@flint.arm.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Russell King <rmk@arm.linux.org.uk> wrote:

> On Tue, Nov 19, 2013 at 10:12:23AM -0800, tip-bot for Stephen Boyd wrote:
> > +	/*
> > +	 * Use 4MHz instead of 1MHz so that things like 1.832Mhz show as
> > +	 * 1832Khz
> 
> How about getting proper SI units.

Note that I objected to this patch earlier today, I think this code 
should look differently - so your objection to this particular patch 
is mooted.

Thanks,

	Ingo
