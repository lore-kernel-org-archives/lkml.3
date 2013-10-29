Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753346Ab3J2JUi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 05:20:38 -0400
Received: from mail-ea0-f175.google.com ([209.85.215.175]:64659 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751932Ab3J2JUg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 05:20:36 -0400
Date: Tue, 29 Oct 2013 10:20:33 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jiri Olsa <jolsa@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 6/8] perf tools: Add new comm infrastructure
Message-ID: <20131029092031.GC17514@localhost.localdomain>
References: <526AB61B.80505@gmail.com>
 <871u369cq0.fsf@sejong.aot.lge.com>
 <CAFTL4hxbfJy9Tfw2j5ptW5k5AjCBYSuf5_+7U9ShWUQaDqOpdw@mail.gmail.com>
 <8738nl92oh.fsf@sejong.aot.lge.com>
 <20131028101248.GA6491@localhost.localdomain>
 <20131028124309.GE16948@ghostprotocols.net>
 <20131028142912.GF16948@ghostprotocols.net>
 <20131028160528.GA10452@localhost.localdomain>
 <20131028170111.GG16948@ghostprotocols.net>
 <20131028174843.GH16948@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131028174843.GH16948@ghostprotocols.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 28, 2013 at 02:48:43PM -0300, Arnaldo Carvalho de Melo wrote:
> Em Mon, Oct 28, 2013 at 02:01:11PM -0300, Arnaldo Carvalho de Melo escreveu:
> > Em Mon, Oct 28, 2013 at 05:05:30PM +0100, Frederic Weisbecker escreveu:
> > > 
> > > Also it differentiate between pre-exec and post-fork events, which looks
> > > more precise (and it fixes some comm mangling as well):
> > > 
> > > 
> > > Before:
> > > 
> > >      # Overhead          Command
> > >      # ........  ...............
> > >      #
> > >        100.00%  sched-me
> > 
> > I noticed the above, just on the --stdio tho, checking why this is so...
> > Can you try without --stdio, even using --tui?
> 
> Thanks for this report, if you try my perf/urgent now it should be
> fixed, was a problem fixed by Jiri Olsa that I thought affected only
> perf/core.
> 
> I cherry picked it and it fixed the problem for me, can you check that?

Yep, I checked your perf/urgent queue 8e50d384cc1d5afd2989cf0f7093756ed7164eb2 and it's
fixed there, although I can't find the particular patch fixing this, but it works :)

Thanks.

> 
> - Arnaldo
