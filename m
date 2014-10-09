Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752945AbaJIHVy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 03:21:54 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:48362 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750918AbaJIHVs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 03:21:48 -0400
Date: Thu, 9 Oct 2014 09:21:43 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Tuan Bui <tuan.d.bui@hp.com>
Cc: linux-kernel@vger.kernel.org, dbueso@suse.de, a.p.zijlstra@chello.nl,
        paulus@samba.org, acme@kernel.org, artagnon@gmail.com,
        jolsa@redhat.com, dvhart@linux.intel.com,
        Aswin Chandramouleeswaran <aswin@hp.com>,
        Jason Low <jason.low2@hp.com>, akpm@linux-foundation.org
Subject: Re: [RFC PATCH] Perf Bench: Locking Microbenchmark
Message-ID: <20141009072143.GA21018@gmail.com>
References: <1412120999.2941.11.camel@u64>
 <20141001052832.GA32248@gmail.com>
 <1412806419.2908.6.camel@u64>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412806419.2908.6.camel@u64>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Tuan Bui <tuan.d.bui@hp.com> wrote:

> > > +static const struct option options[] = {
> > > +	OPT_UINTEGER('s', "start", &start_nr_threads, "Numbers of processes to start"),
> > > +	OPT_UINTEGER('e', "end", &end_nr_threads, "Numbers of process to end"),
> > > +	OPT_UINTEGER('i', "increment", &increment_threads_by, "Number of threads to increment)"),
> > > +	OPT_UINTEGER('r', "runtime", &bench_dur, "Specify benchmark runtime in seconds"),
> > > +	OPT_END()
> > > +};
> > 
> > Is this the kind of parameters that AIM7 takes as well?
> > 
> > In any case, this is a very nice benchmarking utility.
> 
> Yes these parameters are similar to what AIM7 take except for 
> the runtime parameter.  AIM7 does not have the option to 
> specify how long the benchmark will run.  Also in AIM7 you can 
> also specify numbers of jobs per run which i did not include 
> since i added a runtime parameter for the benchmark.

It might make sense to add that parameter - which would only be 
allowed if no runtime is specified, or so.

I.e. to make it as easy for people to use this new tool when they 
come with AIM7 benchmarking knowledge.

Thanks,

	Ingo
