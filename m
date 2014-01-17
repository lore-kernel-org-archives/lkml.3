Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752482AbaAQQHr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 11:07:47 -0500
Received: from mail-ee0-f47.google.com ([74.125.83.47]:44821 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751248AbaAQQHq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 11:07:46 -0500
Date: Fri, 17 Jan 2014 17:07:42 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, acme@ghostprotocols.net
Subject: Re: [PATCH 2/3] perf tools: Spare double comparison of callchain
 first entry
Message-ID: <20140117160740.GA11734@localhost.localdomain>
References: <1389713836-13375-1-git-send-email-fweisbec@gmail.com>
 <1389713836-13375-3-git-send-email-fweisbec@gmail.com>
 <87y52h930t.fsf@sejong.aot.lge.com>
 <20140115165927.GA21574@localhost.localdomain>
 <87d2js9132.fsf@sejong.aot.lge.com>
 <20140116173454.GA5328@localhost.localdomain>
 <20140116194734.GA2373@infradead.org>
 <87ob3b6nz1.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ob3b6nz1.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 17, 2014 at 04:56:18PM +0900, Namhyung Kim wrote:
> Hi Arnaldo and Frederic,
> 
> On Thu, 16 Jan 2014 17:47:34 -0200, Arnaldo Carvalho de Melo wrote:
> > Em Thu, Jan 16, 2014 at 06:34:58PM +0100, Frederic Weisbecker escreveu:
> >> On Thu, Jan 16, 2014 at 10:17:53AM +0900, Namhyung Kim wrote: 
> >> > I think if the sort key doesn't contain "symbol", unmatch case would be
> >> > increased as more various callchains would go into a same entry.
> >> 
> >> You mean -g fractal,0.5,callee,address ?
> >> 
> >> Hmm, actually I haven't seen much difference there.
> >
> > I guess he will, but will wait for Namhyung's final ack here, ok?
> 
> I meant sorting of hist entry like "-s cpu".   So as your number said
> it's not an issue IMHO.  Arnaldo, I'm good with this change please merge
> it. :)

Thanks a lot guys! :)
