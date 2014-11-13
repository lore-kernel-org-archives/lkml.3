Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933003AbaKMNGZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 08:06:25 -0500
Received: from www.linutronix.de ([62.245.132.108]:46877 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753914AbaKMNGY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 08:06:24 -0500
Date: Thu, 13 Nov 2014 14:06:11 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Li, Aubrey" <aubrey.li@linux.intel.com>
cc: Peter Zijlstra <peterz@infradead.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "Brown, Len" <len.brown@intel.com>,
        "alan@linux.intel.com" <alan@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        "linux-pm@vger.kernel.org >> Linux PM list" 
	<linux-pm@vger.kernel.org>
Subject: Re: [PATCH v2] PM / Sleep: Timer quiesce in freeze state
In-Reply-To: <54648C50.2060104@linux.intel.com>
Message-ID: <alpine.DEB.2.11.1411131405370.3935@nanos>
References: <5446787E.60202@linux.intel.com> <20141024153656.GM12706@worktop.programming.kicks-ass.net> <544DE5CF.9040501@linux.intel.com> <20141027074419.GE10501@worktop.programming.kicks-ass.net> <544F4B31.7050308@linux.intel.com>
 <20141028082503.GN3337@twins.programming.kicks-ass.net> <5450253B.5020802@linux.intel.com> <20141029082432.GV3337@twins.programming.kicks-ass.net> <5451A94F.1090200@linux.intel.com> <alpine.DEB.2.11.1411121558280.3935@nanos> <20141113013707.GQ29390@twins.programming.kicks-ass.net>
 <alpine.DEB.2.11.1411131008280.3935@nanos> <54648C50.2060104@linux.intel.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Nov 2014, Li, Aubrey wrote:

> On 2014/11/13 17:10, Thomas Gleixner wrote:
> > On Thu, 13 Nov 2014, Peter Zijlstra wrote:
> >> On Wed, Nov 12, 2014 at 10:09:47PM +0100, Thomas Gleixner wrote:
> >> But sure, we can add suspend notifiers to stuff to shut down timers; I
> >> should have a patch for at least one of the offenders somewhere. But I
> >> really think that we should not be looking at the individual timers for
> >> this, none of the other suspend modes care about active timers.
> > 
> > Fair enough.
> >  
> 
> If you are okay with the current method to suspend timekeeping entirely,
> then we can go further to fix the rest concerns.

I'm fine with that when it's done proper :)

Thanks,

	tglx
