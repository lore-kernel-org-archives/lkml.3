Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751394AbaDQOWe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 10:22:34 -0400
Received: from mail-ee0-f50.google.com ([74.125.83.50]:60126 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751465AbaDQOWS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 10:22:18 -0400
Date: Thu, 17 Apr 2014 16:22:13 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Vince Weaver <vincent.weaver@maine.edu>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [perf] more perf_fuzzer memory corruption
Message-ID: <20140417142213.GA29338@gmail.com>
References: <alpine.DEB.2.10.1404151729230.17264@vincent-weaver-1.um.maine.edu>
 <20140416141514.GS11182@twins.programming.kicks-ass.net>
 <alpine.DEB.2.10.1404161326380.19325@vincent-weaver-1.um.maine.edu>
 <alpine.DEB.2.10.1404161337350.19325@vincent-weaver-1.um.maine.edu>
 <20140417094815.GA9348@gmail.com>
 <20140417114533.GJ11096@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140417114533.GJ11096@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Thu, Apr 17, 2014 at 11:48:15AM +0200, Ingo Molnar wrote:
> > Is there some place where I can pick up the latestest of your fuzzer?
> > 
> > PeterZ has trouble reproducing the corruption locally - I'd like to 
> > run it too, maybe I have hardware that triggers it more readily.
> 
> From a few emails up:
> 
> "If you want to try running the fuzzer on your machine too just do:
>         git clone https://github.com/deater/perf_event_tests.git
>         cd fuzzer
>         make
> and then try running the "./fast_repro98.sh" script, as that's the forking
> workload I've been using when tracking this issue."

Cool, thanks!

	Ingo
