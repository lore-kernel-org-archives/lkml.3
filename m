Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932080AbaA1MMp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 07:12:45 -0500
Received: from mail-yk0-f177.google.com ([209.85.160.177]:64542 "EHLO
	mail-yk0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754268AbaA1MMo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 07:12:44 -0500
Date: Tue, 28 Jan 2014 09:12:36 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Davidlohr Bueso <davidlohr@hp.com>
Cc: Darren Hart <dvhart@linux.intel.com>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org, mingo@redhat.com, peterz@infradead.org,
        tglx@linutronix.de, jason.low2@hp.com, Waiman.Long@hp.com,
        scott.norton@hp.com, aswin@hp.com
Subject: Re: [PATCH 0/3] perf-bench: introduce futex microbenchmarks
Message-ID: <20140128121236.GC3998@ghostprotocols.net>
References: <1387081917-9102-1-git-send-email-davidlohr@hp.com>
 <20131216100828.GA21304@gmail.com>
 <1387205098.2797.3.camel@buesod1.americas.hpqcorp.net>
 <1390587227.912.18.camel@dvhart-mobl.amr.corp.intel.com>
 <1390882362.27421.22.camel@buesod1.americas.hpqcorp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1390882362.27421.22.camel@buesod1.americas.hpqcorp.net>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Jan 27, 2014 at 08:12:42PM -0800, Davidlohr Bueso escreveu:
> On Fri, 2014-01-24 at 10:13 -0800, Darren Hart wrote:
> > I agree that we should take whatever makes sense for perf out of
> > futex-test and merge it with perf. It will see greater use and receive
> > more review and improvements than it will in my obscure repository.

> > With trinity covering the fuzz testing and perf handling performance
> > tests, I think futex-test can be reduced down to a functional
> > test-suite, which is perfectly fine with me.

> > If there is still interest here, I'll support it.

> Arnaldo, could you consider this for 3.15? I've also got some additional
> work for perf-bench but am waiting for this to get settled first.

Sure, I'll try applying it later today.

- Arnaldo
