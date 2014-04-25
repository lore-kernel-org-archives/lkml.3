Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752422AbaDYIGB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 04:06:01 -0400
Received: from mail-ee0-f53.google.com ([74.125.83.53]:57404 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751726AbaDYIFv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 04:05:51 -0400
Date: Fri, 25 Apr 2014 10:05:46 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Jiri Olsa <jolsa@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [GIT PULL 00/11] perf/core improvements and fixes
Message-ID: <20140425080545.GA21360@gmail.com>
References: <1398354045-16505-1-git-send-email-jolsa@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398354045-16505-1-git-send-email-jolsa@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jiri Olsa <jolsa@kernel.org> wrote:

> hi Ingo,
> please consider pulling
> 
> thanks,
> jirka
> 
> 
> The following changes since commit a81fef347b32dea2b31275826afe1c93fa0d2d54:
> 
>   Merge tag 'perf-core-for-mingo' of git://git.kernel.org/pub/scm/linux/kernel/git/jolsa/perf into perf/core (2014-04-22 20:28:23 +0200)
> 
> are available in the git repository at:
> 
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/jolsa/perf.git tags/perf-core-for-mingo
> 
> for you to fetch changes up to c3b789527b236873557f53740ceac47747e0e1cb:
> 
>   perf hists/tui: Count callchain rows separately (2014-04-24 16:34:27 +0200)
> 
> ----------------------------------------------------------------
> perf/core improvements and fixes:
> 
> . Factor hists statistics counts processing which in turn also
>   fixes several bugs in TUI report command (Namhyung Kim)
> 
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> 
> ----------------------------------------------------------------
> Namhyung Kim (11):
>       perf report: Count number of entries separately
>       perf hists: Rename hists__inc_stats()
>       perf hists: Move column length calculation out of hists__inc_stats()
>       perf hists: Add a couple of hists stat helper functions
>       perf hists: Collapse expanded callchains after filter is applied
>       perf tools: Account entry stats when it's added to the output tree
>       perf hists: Add missing update on filtered stats in hists__decay_entries()
>       perf ui/tui: Fix off-by-one in hist_browser__update_nr_entries()
>       perf ui/tui: Rename hist_browser__update_nr_entries()
>       perf top/tui: Update nr_entries properly after a filter is applied
>       perf hists/tui: Count callchain rows separately
> 
>  tools/perf/builtin-annotate.c  |  3 +-
>  tools/perf/builtin-diff.c      | 23 ++++++-----
>  tools/perf/builtin-report.c    | 64 ++++++++++++++---------------
>  tools/perf/ui/browsers/hists.c | 92 +++++++++++++++++++++++++++++-------------
>  tools/perf/util/hist.c         | 83 ++++++++++++++++++++++++-------------
>  tools/perf/util/hist.h         |  9 ++++-
>  6 files changed, 171 insertions(+), 103 deletions(-)

Pulled, thanks a lot Jiri!

	Ingo
