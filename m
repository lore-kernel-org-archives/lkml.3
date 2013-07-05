Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757478Ab3GEOis (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 10:38:48 -0400
Received: from merlin.infradead.org ([205.233.59.134]:42096 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756718Ab3GEOiq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 10:38:46 -0400
Date: Fri, 5 Jul 2013 16:38:33 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Alex Shi <alex.shi@intel.com>, tglx@linutronix.de, hpa@linux.intel.com,
        tim.c.chen@linux.intel.com, linux-kernel@vger.kernel.org,
        andi.kleen@intel.com, mingo@elte.hu
Subject: Re: [URGENT rfc patch 0/3] tsc clocksource bug fix
Message-ID: <20130705143833.GT23916@twins.programming.kicks-ass.net>
References: <1372916056-24301-1-git-send-email-alex.shi@intel.com>
 <20130704075840.GH18898@dyad.programming.kicks-ass.net>
 <CAFTL4hy24+=2++CN5rBhn9v+pvxR+tTja9Z-wRLSS__LGQBWaQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFTL4hy24+=2++CN5rBhn9v+pvxR+tTja9Z-wRLSS__LGQBWaQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 05, 2013 at 04:23:33PM +0200, Frederic Weisbecker wrote:
> Nope, I haven't touched that. I prefer not to fiddle with unstable
> clocksource for now :)
> 
> As for unstable TSCs, if sched_clock_tick() needs to be fed, we simply
> don't stop the tick.

Not entirely the same thing; I thought the clocksource watchdog was ran
even when we have a 'stable' TSC, just to make sure it stays stable.
There's known cases where the BIOS f*cks us over and wrecks TSC sync.


