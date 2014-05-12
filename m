Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752987AbaELP7K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 11:59:10 -0400
Received: from mail-ee0-f45.google.com ([74.125.83.45]:45606 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751542AbaELP7I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 11:59:08 -0400
Date: Mon, 12 May 2014 17:59:03 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Jiri Olsa <jolsa@kernel.org>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Bernhard Rosenkraenzer <Bernhard.Rosenkranzer@linaro.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Dongsheng <yangds.fnst@cn.fujitsu.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Irina Tirdea <irina.tirdea@intel.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [GIT PULL 0/6] perf/core improvements and fixes
Message-ID: <20140512155903.GA27283@gmail.com>
References: <1399886833-15472-1-git-send-email-jolsa@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1399886833-15472-1-git-send-email-jolsa@kernel.org>
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
> The following changes since commit 3e46d21285577a8c9e4c37f9b1002e567c440b28:
> 
>   Merge tag 'perf-core-for-mingo' of git://git.kernel.org/pub/scm/linux/kernel/git/jolsa/perf into perf/core (2014-05-05 19:37:51 +0200)
> 
> are available in the git repository at:
> 
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/jolsa/perf.git tags/perf-core-for-mingo
> 
> for you to fetch changes up to 13ce34df11833482cd698331fdbb3f8ced06340d:
> 
>   perf tools: Use tid for finding thread (2014-05-12 11:09:50 +0200)
> 
> ----------------------------------------------------------------
> perf/core improvements and fixes:
> 
> . Propagate exit status of a command line workload for
>   record command (Namhyung Kim)
> 
> . Use tid for finding thread (Namhyung Kim)
> 
> . Clarify the output of perf sched map plus small sched
>   command fixies (Dongsheng Yang)
> 
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> 
> ----------------------------------------------------------------
> Dongsheng (3):
>       perf tools: Add missing event for perf sched record.
>       perf tools: Adapt the TASK_STATE_TO_CHAR_STR to new value in kernel space.
>       perf tools: Clarify the output of perf sched map.
> 
> Namhyung Kim (3):
>       perf record: Propagate exit status of a command line workload
>       perf tools: Get rid of on_exit() feature test
>       perf tools: Use tid for finding thread
> 
>  tools/perf/builtin-inject.c                     |   2 +-
>  tools/perf/builtin-kmem.c                       |   2 +-
>  tools/perf/builtin-record.c                     | 158 +++++++++---------------
>  tools/perf/builtin-sched.c                      |  38 +++---
>  tools/perf/config/Makefile                      |   8 --
>  tools/perf/config/feature-checks/Makefile       |   4 -
>  tools/perf/config/feature-checks/test-all.c     |   5 -
>  tools/perf/config/feature-checks/test-on-exit.c |  16 ---
>  tools/perf/tests/code-reading.c                 |   2 +-
>  tools/perf/tests/hists_filter.c                 |   1 +
>  tools/perf/tests/hists_link.c                   |   2 +
>  tools/perf/util/build-id.c                      |   2 +-
>  tools/perf/util/event.c                         |   2 +-
>  13 files changed, 90 insertions(+), 152 deletions(-)
>  delete mode 100644 tools/perf/config/feature-checks/test-on-exit.c

Pulled, thanks a lot Jiri!

	Ingo
