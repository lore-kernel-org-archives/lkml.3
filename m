Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751143AbaDQOju (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 10:39:50 -0400
Received: from mail-qa0-f50.google.com ([209.85.216.50]:56857 "EHLO
	mail-qa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750971AbaDQOjk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 10:39:40 -0400
Date: Thu, 17 Apr 2014 10:42:47 -0400 (EDT)
From: Vince Weaver <vincent.weaver@maine.edu>
To: Ingo Molnar <mingo@kernel.org>
cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [perf] more perf_fuzzer memory corruption
In-Reply-To: <20140417142213.GA29338@gmail.com>
Message-ID: <alpine.DEB.2.10.1404171037590.22226@vincent-weaver-1.um.maine.edu>
References: <alpine.DEB.2.10.1404151729230.17264@vincent-weaver-1.um.maine.edu> <20140416141514.GS11182@twins.programming.kicks-ass.net> <alpine.DEB.2.10.1404161326380.19325@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1404161337350.19325@vincent-weaver-1.um.maine.edu>
 <20140417094815.GA9348@gmail.com> <20140417114533.GJ11096@twins.programming.kicks-ass.net> <20140417142213.GA29338@gmail.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Apr 2014, Ingo Molnar wrote:

> 
> * Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > On Thu, Apr 17, 2014 at 11:48:15AM +0200, Ingo Molnar wrote:
> > > Is there some place where I can pick up the latestest of your fuzzer?
> > > 
> > > PeterZ has trouble reproducing the corruption locally - I'd like to 
> > > run it too, maybe I have hardware that triggers it more readily.
> > 
> > From a few emails up:
> > 
> > "If you want to try running the fuzzer on your machine too just do:
> >         git clone https://github.com/deater/perf_event_tests.git
> >         cd fuzzer
> >         make
> > and then try running the "./fast_repro98.sh" script, as that's the forking
> > workload I've been using when tracking this issue."

I have to admit the slab corruption message is a new development with 
3.15-rc1.

I've been trying to track a possibly-the-same (but harder to debug)
memory corruption issue for a while now.

I can trigger this type of error easily on both a core2 and haswell 
machine.

I have a few more test machines I can run, and just got some extra 
serial cables so maybe I can hook up a few more serial consoles and do 
some additional testing.

Vince
