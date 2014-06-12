Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756079AbaFLOML (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 10:12:11 -0400
Received: from www.linutronix.de ([62.245.132.108]:41694 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755819AbaFLOMI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 10:12:08 -0400
Date: Thu, 12 Jun 2014 16:12:03 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
cc: LKML <linux-kernel@vger.kernel.org>, John Stultz <john.stultz@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [patch 08/13] firewire: Use ktime_get_ts()
In-Reply-To: <20140612143549.4c00c1ed@kant>
Message-ID: <alpine.DEB.2.10.1406121611471.5170@nanos>
References: <20140611234024.103571777@linutronix.de> <20140611234607.351283464@linutronix.de> <20140612143549.4c00c1ed@kant>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Jun 2014, Stefan Richter wrote:

> On Jun 11 Thomas Gleixner wrote:
> > do_posix_clock_monotonic_gettime() is a leftover from the initial
> > posix timer implementation which maps to ktime_get_ts()
> > 
> > Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> > Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>
> 
> Acked-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
> 
> (Though I am noticing increasing entropy WRT whitespace.)

Fixed it up.
