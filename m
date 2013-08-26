Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752481Ab3HZQQh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 12:16:37 -0400
Received: from merlin.infradead.org ([205.233.59.134]:41053 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752028Ab3HZQQg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 12:16:36 -0400
Date: Mon, 26 Aug 2013 18:16:24 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Adrian Hunter <adrian.hunter@intel.com>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 1/3] perf: add a dummy software event to keep tracking
Message-ID: <20130826161624.GC10002@twins.programming.kicks-ass.net>
References: <1375882231-18339-1-git-send-email-adrian.hunter@intel.com>
 <1375882231-18339-2-git-send-email-adrian.hunter@intel.com>
 <521B54F6.5060304@intel.com>
 <20130826135305.GA1885@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130826135305.GA1885@ghostprotocols.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 26, 2013 at 10:53:05AM -0300, Arnaldo Carvalho de Melo wrote:
> Em Mon, Aug 26, 2013 at 04:15:34PM +0300, Adrian Hunter escreveu:
> > On 07/08/13 16:30, Adrian Hunter wrote:
> > > When an event is disabled the "tracking" events
> > > selected by the 'mmap', 'comm' and 'task' bits of
> > > struct perf_event_attr, are also disabled.  However,
> > > the information those events provide is necessary to
> > > resolve symbols for when the main event is re-enabled.
> > > 
> > > The "tracking" events can be kept enabled by putting
> > > them on another event, but that requires an event
> > > that otherwise does nothing.  A new software event
> > > PERF_COUNT_SW_DUMMY is added for that purpose.
> > > 
> > > Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
> > 
> > Any comments?
> 
> Ok with me, Peter?

Yeah I suppose so.. I don't really like it and I've made a start at
looking at the problem twice now but never got anywhere, so sure lets go
with this.

Acked-by: Peter Zijlstra <peterz@infradead.org>
