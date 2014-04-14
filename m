Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755232AbaDNOw6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 10:52:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40119 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755120AbaDNOwy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 10:52:54 -0400
Date: Mon, 14 Apr 2014 16:52:05 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Cody P Schafer <cody@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>, Don Zickus <dzickus@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jean Pihet <jean.pihet@linaro.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Ramkumar Ramachandra <artagnon@gmail.com>,
        Richard Yao <ryao@gentoo.org>, Stephane Eranian <eranian@google.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        William Cohen <wcohen@redhat.com>
Subject: Re: [GIT PULL v3 00/17] perf/core fixes
Message-ID: <20140414145205.GA8192@krava.brq.redhat.com>
References: <1397485061-17215-1-git-send-email-jolsa@redhat.com>
 <20140414144236.GB22659@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140414144236.GB22659@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 14, 2014 at 04:42:36PM +0200, Ingo Molnar wrote:

SNIP

> >       perf machine: Search for modules in %s/lib/modules/%s
> > 
> >  MAINTAINERS                             |   2 +-
> >  tools/lib/traceevent/event-parse.c      | 109 +++++++++++++++----------
> >  tools/perf/Documentation/perf-bench.txt |  22 +++++
> >  tools/perf/Documentation/perf-top.txt   |   1 -
> >  tools/perf/Makefile.perf                |   4 +-
> >  tools/perf/bench/numa.c                 |   4 +
> >  tools/perf/builtin-bench.c              |   2 +-
> >  tools/perf/builtin-stat.c               | 140 ++++++++++++++++++++------------
> >  tools/perf/config/Makefile              |   7 +-
> >  tools/perf/tests/code-reading.c         |   1 +
> >  tools/perf/util/machine.c               |   2 +-
> >  tools/perf/util/probe-finder.c          |  15 ++--
> >  12 files changed, 197 insertions(+), 112 deletions(-)
> 
> I've pulled most of the patches, up to patch #13, thanks Jiri!
> 
> I left out #14 because it seems incomplete to me - see my previous 
> mail.
> 
> You could rebase #15,16,17 on top of #13 to get the rest to me as 
> well, until #14 is resolved.

ok, will do

thanks,
jirka
