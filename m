Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752976Ab3KWGfN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Nov 2013 01:35:13 -0500
Received: from mout.gmx.net ([212.227.15.18]:49239 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750759Ab3KWGfK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Nov 2013 01:35:10 -0500
Message-ID: <1385188503.5296.17.camel@marge.simpson.net>
Subject: Re: [PATCH 0/5] futex: Wakeup optimizations
From: Mike Galbraith <efault@gmx.de>
To: Darren Hart <dvhart@linux.intel.com>
Cc: Davidlohr Bueso <davidlohr@hp.com>, linux-kernel@vger.kernel.org,
        mingo@kernel.org, peterz@infradead.org, tglx@linutronix.de,
        jeffm@suse.com, torvalds@linux-foundation.org, scott.norton@hp.com,
        tom.vaden@hp.com, aswin@hp.com, Waiman.Long@hp.com, jason.low2@hp.com
Date: Sat, 23 Nov 2013 07:35:03 +0100
In-Reply-To: <1385186145.29354.175.camel@dvhart-mobl4.amr.corp.intel.com>
References: <1385168197-8612-1-git-send-email-davidlohr@hp.com>
	 <1385186145.29354.175.camel@dvhart-mobl4.amr.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V03:K0:EGZ5H1ZD/LsFWxWh7Bwzy8kOgwZ0ZDRwejjlIs3xMHokm+Ex1Fi
 sksHcz8/lSZ8p/wq1PUG6HcUxpgKa4w6pWmTGkq1sJZWTYkggJt10Wpm1GyZ0WdAamg5rg5
 y0WnNyRrJWToAfANU/TjXhc9Hc3n55W4+A2PHRx78pIKjkJhKGjEqb9423t6PFv80pEFmoo
 BjycLCw8dG/fR7MjngXKg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-11-22 at 21:55 -0800, Darren Hart wrote: 
> On Fri, 2013-11-22 at 16:56 -0800, Davidlohr Bueso wrote:

> > This patchset has also been tested on smaller systems for a variety of
> > benchmarks, including java workloads, kernel builds and custom bang-the-hell-out-of
> > hb locks programs. So far, no functional or performance regressions have been seen.
> > Furthermore, no issues were found when running the different tests in the futextest 
> > suite: http://git.kernel.org/cgit/linux/kernel/git/dvhart/futextest.git/
> 
> Excellent. Would you be able to contribute any of these (C only please)
> to the stress test group?

FWIW, I plugged this series into an rt kernel (extra raciness) and beat
it up a bit on a 64 core box too.  Nothing fell out, nor did futextest
numbers change outside variance (poor box has 8 whole gig ram, single
numa node, so kinda crippled/wimpy, and not good box for benchmarking).

What concerned me most about the series was 5/5.. looks like a great
idea to me, but the original thread did not have a happy ending.

-Mike

