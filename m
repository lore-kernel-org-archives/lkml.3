Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932198Ab3HMQAv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 12:00:51 -0400
Received: from mail-ea0-f175.google.com ([209.85.215.175]:63360 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932068Ab3HMQAs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 12:00:48 -0400
Date: Tue, 13 Aug 2013 18:00:43 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Vince Weaver <vince@deater.net>, Christoph Hellwig <hch@infradead.org>,
        Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>, Namhyung Kim <namhyung.kim@lge.com>,
        peterz@infradead.org
Subject: Re: [PATCH] RFC: perf, tools: Move gtk browser into separate perfgtk
 executable
Message-ID: <20130813160043.GB5280@gmail.com>
References: <20130805081641.GA24808@gmail.com>
 <20130805082320.GA9562@infradead.org>
 <20130805083132.GE26746@gmail.com>
 <20130805083434.GA20606@infradead.org>
 <20130805090857.GA26940@gmail.com>
 <20130806061932.GA20485@infradead.org>
 <20130812181956.GB19405@gmail.com>
 <alpine.DEB.2.02.1308121521170.25956@pianoman.cluster.toy>
 <20130813104821.GB2170@gmail.com>
 <20130813121141.GB2188@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130813121141.GB2188@ghostprotocols.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arnaldo Carvalho de Melo <acme@ghostprotocols.net> wrote:

> Em Tue, Aug 13, 2013 at 12:48:21PM +0200, Ingo Molnar escreveu:
> > To resolve this situation you could help us out by doing either of these:
>  
> >  1) integrate your tests into tools/, there's 'perf test' that has a ton
> >     of testcases already
> 
> I think Jiri is working on merging some of those tests, Jiri?
> 
> Yeah, these at least:
> 
> commit 06933e3a732bb305b0721f1051a45264588e0519
> Author: Jiri Olsa <jolsa@redhat.com>
> Date:   Sun Mar 10 19:41:11 2013 +0100
> 
>     perf tests: Test breakpoint overflow signal handler counts
> 
> commit 5a6bef47b418676546ab86d25631c3cfb9ffaf2a
> Author: Jiri Olsa <jolsa@redhat.com>
> Date:   Sun Mar 10 19:41:10 2013 +0100
> 
>     perf tests: Test breakpoint overflow signal handler
>  
> >  2) run your testsuite more frequently - instead of waiting for a stable
> >     kernel to be released and then complain about breakage.
> 
> My feeling is that he increased the frequency of such tests.
> 
> > So far you refused to do any of this and blamed others for non-reported 
> > breakages :-/
> 
> He has been using the perf trinity fuzzer and reporting problems, thanks
> Vince!

Absolutely, it's much appreciated, thanks Vince!

I was reacting to this claim:

> > I've had perf ABI changes break programs I maintain at least three 
> > times in the last 2 kernel releases.

that can only be addressed by either extending 'perf test' or by testing 
libpfm et al sooner. The upstream kernel can only address regressions that 
get reported.

Thanks,

	Ingo
