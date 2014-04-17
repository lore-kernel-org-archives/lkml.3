Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161050AbaDQLpm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 07:45:42 -0400
Received: from merlin.infradead.org ([205.233.59.134]:57882 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754933AbaDQLpk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 07:45:40 -0400
Date: Thu, 17 Apr 2014 13:45:33 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Vince Weaver <vincent.weaver@maine.edu>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [perf] more perf_fuzzer memory corruption
Message-ID: <20140417114533.GJ11096@twins.programming.kicks-ass.net>
References: <alpine.DEB.2.10.1404151729230.17264@vincent-weaver-1.um.maine.edu>
 <20140416141514.GS11182@twins.programming.kicks-ass.net>
 <alpine.DEB.2.10.1404161326380.19325@vincent-weaver-1.um.maine.edu>
 <alpine.DEB.2.10.1404161337350.19325@vincent-weaver-1.um.maine.edu>
 <20140417094815.GA9348@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140417094815.GA9348@gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 17, 2014 at 11:48:15AM +0200, Ingo Molnar wrote:
> Is there some place where I can pick up the latestest of your fuzzer?
> 
> PeterZ has trouble reproducing the corruption locally - I'd like to 
> run it too, maybe I have hardware that triggers it more readily.

>From a few emails up:

"If you want to try running the fuzzer on your machine too just do:
        git clone https://github.com/deater/perf_event_tests.git
        cd fuzzer
        make
and then try running the "./fast_repro98.sh" script, as that's the forking
workload I've been using when tracking this issue."

