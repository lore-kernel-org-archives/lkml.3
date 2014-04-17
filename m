Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754370AbaDQIIJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 04:08:09 -0400
Received: from mail-ee0-f42.google.com ([74.125.83.42]:42058 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751331AbaDQIIA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 04:08:00 -0400
Date: Thu, 17 Apr 2014 10:07:55 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ramkumar Ramachandra <artagnon@gmail.com>
Subject: Re: [GIT PULL 00/11] perf/core improvements and fixes
Message-ID: <20140417080755.GA29375@gmail.com>
References: <1397673699-25824-1-git-send-email-jolsa@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1397673699-25824-1-git-send-email-jolsa@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jiri Olsa <jolsa@redhat.com> wrote:

> hi Ingo,
> please consider pulling
> 
> thanks,
> jirka
> 
> 
> The following changes since commit fbdd17ec5ce2e5e4027356fcfde769b88d15702f:
> 
>   Merge branch 'perf-core-for-mingo' into perf/urgent (2014-04-14 16:45:39 +0200)
> 
> are available in the git repository at:
> 
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/jolsa/perf.git tags/perf-core-for-mingo
> 
> for you to fetch changes up to a83edb2dfc5989fbadc594109c933bae528a2809:
> 
>   perf sched: Introduce --list-cmds for use by scripts (2014-04-16 17:16:05 +0200)
> 
> ----------------------------------------------------------------
> perf/core improvements and fixes:
> 
> User visible:
> 
> . Add --percentage option to control absolute/relative percentage output (Namhyung Kim)
> 
> Developer stuff:
> 
> . Add --list-cmds to 'kmem', 'mem', 'lock' and 'sched', for use by completion scripts (Ramkumar Ramachandra)
> 
> Signed-off-by: Jiri Olsa <jolsa@redhat.com>
> 
> ----------------------------------------------------------------
> Namhyung Kim (7):
>       perf hists: Add support for showing relative percentage
>       perf report: Add --percentage option
>       perf top: Add --percentage option
>       perf diff: Add --percentage option
>       perf tools: Add hist.percentage config option
>       perf ui/tui: Add 'F' hotkey to toggle percentage output
>       perf tools: Show absolute percentage by default
> 
> Ramkumar Ramachandra (4):
>       perf kmem: Introduce --list-cmds for use by scripts
>       perf mem: Introduce --list-cmds for use by scripts
>       perf lock: Introduce --list-cmds for use by scripts
>       perf sched: Introduce --list-cmds for use by scripts
> 
>  tools/perf/Documentation/perf-diff.txt   | 21 ++++++++++--
>  tools/perf/Documentation/perf-report.txt | 24 +++++++++----
>  tools/perf/Documentation/perf-top.txt    | 18 ++++++++--
>  tools/perf/builtin-diff.c                | 32 ++++++++++++-----
>  tools/perf/builtin-kmem.c                |  8 +++--
>  tools/perf/builtin-lock.c                | 10 +++---
>  tools/perf/builtin-mem.c                 | 15 ++++----
>  tools/perf/builtin-report.c              | 22 ++++++++++--
>  tools/perf/builtin-sched.c               | 10 +++---
>  tools/perf/builtin-top.c                 |  8 +++--
>  tools/perf/perf-completion.sh            |  4 +--
>  tools/perf/ui/browsers/hists.c           | 39 ++++++++++++++++-----
>  tools/perf/ui/gtk/hists.c                | 11 +++---
>  tools/perf/ui/hist.c                     |  8 ++---
>  tools/perf/util/config.c                 |  4 +++
>  tools/perf/util/hist.c                   | 59 +++++++++++++++++++++++++-------
>  tools/perf/util/hist.h                   | 10 ++++++
>  tools/perf/util/symbol.h                 |  3 +-
>  18 files changed, 230 insertions(+), 76 deletions(-)

Pulled, thanks a lot Jiri!

	Ingo
