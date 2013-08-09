Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967014Ab3HIKbA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 06:31:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15419 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966685Ab3HIKa7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 06:30:59 -0400
Date: Fri, 9 Aug 2013 12:30:36 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>,
        Jeremy Eder <jeder@redhat.com>
Subject: Re: [PATCHSET 00/17] perf tools: Introduce new 'ftrace' command (v4)
Message-ID: <20130809103036.GD1045@krava.brq.redhat.com>
References: <1375175954-798-1-git-send-email-namhyung@kernel.org>
 <20130809102515.GB1045@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130809102515.GB1045@krava.brq.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 09, 2013 at 12:25:15PM +0200, Jiri Olsa wrote:
> On Tue, Jul 30, 2013 at 06:18:57PM +0900, Namhyung Kim wrote:
> > This patchset implements a front-end tool for kernel's ftrace.  It
> > uses function_graph tracer by default and normal function tracer is
> > also supported.  (Of course you need to enable those tracers in your
> > kernel first.)
> > 
> > v4 changes:
> >  * use pid instead of tid for -p option (David)
> >  * not to poll() for reading ftrace pipes (Jiri)
> >  * rename to create_perf_header() (Jiri)
> >  * canonicalize directory name (Jiri)
> >  * show more info when -D option was given (Jiri)
> >  * update documentation (Jiri)
> >  * and few more bug fixes
> > 
> > I pushed it out to 'perf/ftrace-v4' branch on my tree at:
> > 
> >   git://git.kernel.org/pub/scm/linux/kernel/git/namhyung/linux-perf.git
> 
> also, this one works now:
> 
> ./perf --no-pager ftrace live -t function -p `pgrep yes`
> 
> but if I kill 'yes' perf live commands hangs,
> I'd expect it'd stop

on the other hand it looks like it's common behaviour
for standard record/stat... ;-)

jirka
