Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754530AbbAUPrm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 10:47:42 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:40145 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754194AbbAUPrd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 10:47:33 -0500
Message-ID: <1421855244.14076.63.camel@arm.com>
Subject: Re: [PATCH v4 1/3] perf: Use monotonic clock as a source for
 timestamps
From: Pawel Moll <pawel.moll@arm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>, Richard Cochran <richardcochran@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Christopher Covington <cov@codeaurora.org>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tomeu Vizoso <tomeu@tomeuvizoso.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>
Date: Wed, 21 Jan 2015 15:47:24 +0000
In-Reply-To: <20150105130141.GQ30905@twins.programming.kicks-ass.net>
References: <1415292718-19785-1-git-send-email-pawel.moll@arm.com>
	 <1415292718-19785-2-git-send-email-pawel.moll@arm.com>
	 <1417100750.4371.1.camel@arm.com> <1418305153.4037.1.camel@arm.com>
	 <20150105130141.GQ30905@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.10-0ubuntu1~14.10.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2015-01-05 at 13:01 +0000, Peter Zijlstra wrote:
> On Thu, Dec 11, 2014 at 01:39:13PM +0000, Pawel Moll wrote:
> > On Thu, 2014-11-27 at 15:05 +0000, Pawel Moll wrote:
> > > It's been 3 weeks without any negative feedback (no feedback at all, but
> > > I take the optimistic view :-)...
> > > 
> > > How about queuing at least this patch alone for the incoming merge
> > > window? Or at least getting it into -next, with the view at 3.20?
> > 
> > It's been another two weeks... How about getting it queued for v3.20
> > then?
> 
> Yes sorry about that, I had me a kid and took a wee bit of time away
> from computers, then xmas and new years happened.

"a kid" as in: you have forked? :-) It will happen to me in 1.5 month
time (or earlier). All the best luck, we'll both need it ;-)

> In any case, best wishes for the new year to all.

Indeed.

Pawel


