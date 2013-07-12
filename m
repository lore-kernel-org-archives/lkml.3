Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757593Ab3GLKbX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 06:31:23 -0400
Received: from mail-ea0-f179.google.com ([209.85.215.179]:41630 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757244Ab3GLKbV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 06:31:21 -0400
Date: Fri, 12 Jul 2013 12:31:17 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Dave Jones <davej@redhat.com>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Peter Anvin <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>,
        Dave Hansen <dave.hansen@linux.intel.com>
Subject: Re: Yet more softlockups.
Message-ID: <20130712103117.GA14862@gmail.com>
References: <20130704015525.GA8486@redhat.com>
 <CA+55aFykwkTVtZuoCEvwpF+5q1LUscw1shkWNPtGdHu+1DgDJA@mail.gmail.com>
 <20130705143821.GB325@redhat.com>
 <alpine.DEB.2.02.1307051710070.32106@ionos.tec.linutronix.de>
 <20130705160043.GF325@redhat.com>
 <20130706072408.GA14865@gmail.com>
 <20130710151324.GA11309@redhat.com>
 <20130710152015.GA757@x4>
 <20130710154029.GB11309@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130710154029.GB11309@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Dave Jones <davej@redhat.com> wrote:

> On Wed, Jul 10, 2013 at 05:20:15PM +0200, Markus Trippelsdorf wrote:
>  > On 2013.07.10 at 11:13 -0400, Dave Jones wrote:
>  > > I get this right after booting..
>  > > 
>  > > [  114.516619] perf samples too long (4262 > 2500), lowering kernel.perf_event_max_sample_rate to 50000
>  > 
>  > You can disable this warning by:
>  > 
>  > echo 0 > /proc/sys/kernel/perf_cpu_time_max_percent
> 
> Yes, but why is this even being run when I'm not running perf ?
> 
> The only NMI source running should be the watchdog.

The NMI watchdog is a perf event.

I've Cc:-ed Dave Hansen, the author of those changes - is this a false 
positive or some real problem?

Thanks,

	Ingo
