Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933871AbaDKN0A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 09:26:00 -0400
Received: from toro.web-alm.net ([62.245.132.31]:60953 "EHLO toro.web-alm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932959AbaDKNZ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 09:25:58 -0400
X-Greylist: delayed 1971 seconds by postgrey-1.27 at vger.kernel.org; Fri, 11 Apr 2014 09:25:58 EDT
Message-ID: <5347E475.4020009@osadl.org>
Date: Fri, 11 Apr 2014 14:47:49 +0200
From: Carsten Emde <C.Emde@osadl.org>
Organization: Open Source Automation Development Lab (OSADL)
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
CC: Mike Galbraith <umgwanakikbuti@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Clark Williams <williams@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [RFC PATCH RT V3] rwsem: The return of multi-reader PI rwsems
References: <20140409151922.5fa5d999@gandalf.local.home>	<20140410134217.38cd6db7@gandalf.local.home> <20140410223508.6d0fc135@gandalf.local.home>
In-Reply-To: <20140410223508.6d0fc135@gandalf.local.home>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steven,

> [..] I added Carsten to the Cc, so I'll post the entire change log
> of v1 here again.
I've been listening and testing boxes all the time ...

> [..] If you have any benchmark on large machines I would be very
> happy if you could test this patch against the unpatched version of
> -rt.
Three machines
- an X32 x86_64 (AMD Opteron 6272 @2100 MHz) at rack #1/slot #1,
- an X4x2 x86_64 (Intel i7-2600K @3400 MHz) at rack #4/slot #6, and
- an X4 ARM (i.MX6 Quad @996 MHz) at rack #8/slot #7
are running a v3-patched 3.12.15-rt25 kernel now. I'll equip more
machines later.

What I can say so far is:
- No evidence for any regression, no crashes
- Performance certainly at least as good as unpatched, probably better

I'll do more tests and come back with more precise performance
comparison data.

Thanks,
	-Carsten.
