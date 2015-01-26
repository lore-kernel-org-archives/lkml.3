Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755913AbbAZOcB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 09:32:01 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45504 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753909AbbAZOb7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 09:31:59 -0500
Date: Mon, 26 Jan 2015 15:31:48 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Olsa <jolsa@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: Re: [PATCH 2/5] tools lib api fs: Add tracefs mount helper functions
Message-ID: <20150126143148.GA2122@krava.brq.redhat.com>
References: <20150124181330.195149364@goodmis.org>
 <20150124181448.680347393@goodmis.org>
 <20150125165619.GF31987@krava.brq.redhat.com>
 <20150125142645.3c5156e7@gandalf.local.home>
 <20150126090255.GC13287@krava.brq.redhat.com>
 <20150126092621.263160aa@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150126092621.263160aa@gandalf.local.home>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 26, 2015 at 09:26:21AM -0500, Steven Rostedt wrote:
> On Mon, 26 Jan 2015 10:02:55 +0100
> Jiri Olsa <jolsa@redhat.com> wrote:
> 
> > > Note, WTF is perf checking the magic number for debugfs?? If events
> > > move, even if its at the same path, this will break perf!
> > 
> > good question.. it's there since 2009:
> >   f6bdafef2ab9 perf_counter: Add tracepoint support to perf list, perf stat
> > 
> > I guess we didn't want anyone to trick us with fake tracepoints ;-)
> 
> But that would be a feature not a bug. I could imagine admins doing
> this for some work around.
> 
> But can we nuke that check? I don't think it's very useful.

I'd be ok with that

jirka
