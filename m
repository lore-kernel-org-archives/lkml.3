Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751278AbaACGFS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 01:05:18 -0500
Received: from ni.piap.pl ([195.187.100.4]:46349 "EHLO ni.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751105AbaACGFQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 01:05:16 -0500
From: khalasa@piap.pl (Krzysztof =?utf-8?Q?Ha=C5=82asa?=)
To: John Stultz <john.stultz@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Willy Tarreau <w@1wt.eu>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-arm-kernel@lists.infradead.org
References: <52C5E675.80701@linaro.org>
	<1388704274-5278-1-git-send-email-john.stultz@linaro.org>
	<1388704274-5278-2-git-send-email-john.stultz@linaro.org>
Date: Fri, 03 Jan 2014 07:05:14 +0100
In-Reply-To: <1388704274-5278-2-git-send-email-john.stultz@linaro.org> (John
	Stultz's message of "Thu, 2 Jan 2014 15:11:14 -0800")
MIME-Version: 1.0
Message-ID: <m3fvp5txb9.fsf@t19.piap.pl>
Content-Type: text/plain
Subject: Re: [PATCH 2/2] sched_clock: Disable seqlock lockdep usage in sched_clock
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.44/RELEASE,
	 bases: 20140103 #7232212, check: 20140103 clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

John Stultz <john.stultz@linaro.org> writes:

> Unforunately the seqlock lockdep enablmenet can't be used
> in sched_clock, since the lockdep infrastructure eventually
> calls into sched_clock, which causes a deadlock.
>
> Thus, this patch changes all generic sched_clock usage
> to use the raw_* methods.

These two patches fix the problem. Thanks to all involved.
-- 
Krzysztof Halasa

Research Institute for Automation and Measurements PIAP
Al. Jerozolimskie 202, 02-486 Warsaw, Poland
