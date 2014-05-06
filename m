Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753873AbaEFQIK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 12:08:10 -0400
Received: from mail-qc0-f180.google.com ([209.85.216.180]:57425 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751129AbaEFQIJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 12:08:09 -0400
X-Google-Original-From: Vince Weaver <vince@vincent-weaver-1.umelst.maine.edu>
Date: Tue, 6 May 2014 12:11:49 -0400 (EDT)
From: Vince Weaver <vincent.weaver@maine.edu>
To: Peter Zijlstra <peterz@infradead.org>
cc: Vince Weaver <vincent.weaver@maine.edu>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>, Cyrill Gorcunov <gorcunov@openvz.org>
Subject: Re: perf_fuzzer crash on pentium 4
In-Reply-To: <20140506154637.GW26782@laptop.programming.kicks-ass.net>
Message-ID: <alpine.DEB.2.10.1405061205550.3372@vincent-weaver-1.umelst.maine.edu>
References: <alpine.DEB.2.10.1405061137560.3220@vincent-weaver-1.umelst.maine.edu> <20140506154637.GW26782@laptop.programming.kicks-ass.net>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 May 2014, Peter Zijlstra wrote:

> On Tue, May 06, 2014 at 11:42:58AM -0400, Vince Weaver wrote:
> > 
> > So just to be difficult I fired up the perf_fuzzer on a Pentium 4 machine.
> > 
> > It crashes more or less instantly (sorry for the line wrapping, 
> > just got the serial console hooked up and don't have minicom configured 
> > right yet).
> > 
> > this is 3.15-rc4 with the anti-memory corruption patch applied.
> 
> *sigh*.. the one x86 PMU driver I really don't know. I might actually
> have some P4 class hardware, I'll try and get it wired up this week
> somewhere.

I have a Pentium II in working condition I can fire up too.  All my other 
older x86 hardware (K6-2, 486) pre-dates performance counters.

Just be glad that when I moved I had to leave behind the itanium, PA-RISC, 
Power-G3, Alpha, SPARC niagara, pentium-pro and K7-athlon machines.  
Though I guess other than the latter two those wouldn't be your problems.

If I had infinite time I'd try to get the SGI Octane, Ultrasparc, and 
avr32 boards up and going again.

Vince
