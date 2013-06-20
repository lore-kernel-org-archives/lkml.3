Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030351Ab3FTP0p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 11:26:45 -0400
Received: from mail-ee0-f50.google.com ([74.125.83.50]:55910 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030221Ab3FTP0o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 11:26:44 -0400
Date: Thu, 20 Jun 2013 17:26:40 +0200
From: Ingo Molnar <mingo@kernel.org>
To: David Ahern <dsahern@gmail.com>
Cc: acme@ghostprotocols.net, linux-kernel@vger.kernel.org,
        peterz@infradead.org, fweisbec@gmail.com, jolsa@redhat.com,
        namhyung@kernel.org, eranian@google.com
Subject: Re: [RFC PATCH 4/4] perf: add timehist command
Message-ID: <20130620152640.GC17638@gmail.com>
References: <1370643734-9579-1-git-send-email-dsahern@gmail.com>
 <1370643734-9579-5-git-send-email-dsahern@gmail.com>
 <20130620104656.GA11256@gmail.com>
 <51C318F6.2030301@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51C318F6.2030301@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Ahern <dsahern@gmail.com> wrote:

> On 6/20/13 4:46 AM, Ingo Molnar wrote:
> >Looks very useful!
> >
> >This is the kind of analysis I thought 'perf sched' might one day end up
> >doing.
> >
> >Do you plan to submit it non-RFC, to be merged?
> 
> Yes. Hopefully I can find time to work on it over the next 2 months
> for 3.12, 3.13 at the latest.
> 
> >
> >Your tool could take over the somewhat stale 'perf sched' command as well
> >btw., while possibly carrying over some of the perf sched features like
> >'replay'.
> >
> >'perf sched record' enough events to support the ones you need:
> >
> >>>        perf record -e cs -c 1 -ag -- <workload>
> >plus:
> >
> >  'perf sched sum[mary]'       # show the summary
> >  'perf sched tree'            # could show the tree.
> >  'perf sched hist[ogram]'     # would show the histogram
> >
> >i.e. feel free to take over 'perf sched' to suit your 'timehist' workflow
> >and logic. As the main (and somewhat overworked) author of 'perf sched' I
> >have no problem with you taking it over, at all.
> 
> It should be part of perf-sched. It is not at the moment for a number of 
> (mostly shortcut) reasons. For the next iteration I will look at 
> combining it with perf-sched and in the process I will go through the 
> existing code for perf-sched.

If it's easier you could start by using your code as the starting point 
and add back perf sched features after that. I find your tool 
fundamentally more valuable because it's in active use.

> As an FYI I also have a daemon that provides the functionality in a 
> flight recorder mode but with data dumped only when requested. Future 
> project to integrate that with perf. ;-)

:-)

Thanks,

	Ingo
