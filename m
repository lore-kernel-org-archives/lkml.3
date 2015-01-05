Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754048AbbAENCI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 08:02:08 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:50278 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753246AbbAENCF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 08:02:05 -0500
Date: Mon, 5 Jan 2015 14:01:41 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Pawel Moll <pawel.moll@arm.com>
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
Subject: Re: [PATCH v4 1/3] perf: Use monotonic clock as a source for
 timestamps
Message-ID: <20150105130141.GQ30905@twins.programming.kicks-ass.net>
References: <1415292718-19785-1-git-send-email-pawel.moll@arm.com>
 <1415292718-19785-2-git-send-email-pawel.moll@arm.com>
 <1417100750.4371.1.camel@arm.com>
 <1418305153.4037.1.camel@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418305153.4037.1.camel@arm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 11, 2014 at 01:39:13PM +0000, Pawel Moll wrote:
> On Thu, 2014-11-27 at 15:05 +0000, Pawel Moll wrote:
> > It's been 3 weeks without any negative feedback (no feedback at all, but
> > I take the optimistic view :-)...
> > 
> > How about queuing at least this patch alone for the incoming merge
> > window? Or at least getting it into -next, with the view at 3.20?
> 
> It's been another two weeks... How about getting it queued for v3.20
> then?

Yes sorry about that, I had me a kid and took a wee bit of time away
from computers, then xmas and new years happened.

In any case, best wishes for the new year to all.
