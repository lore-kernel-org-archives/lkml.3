Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932269AbaD2Gmu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 02:42:50 -0400
Received: from mail-ee0-f52.google.com ([74.125.83.52]:53707 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932125AbaD2Gmt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 02:42:49 -0400
Date: Tue, 29 Apr 2014 08:42:44 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Jiri Olsa <jolsa@kernel.org>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>, Don Zickus <dzickus@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [GIT PULL  0/7] perf/core improvements and fixes
Message-ID: <20140429064244.GA26365@gmail.com>
References: <1398686405-31951-1-git-send-email-jolsa@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398686405-31951-1-git-send-email-jolsa@kernel.org>
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
> The following changes since commit 2933d7813d8618f18632a7dc7f4e7f1f7d17383a:
> 
>   Merge tag 'perf-core-for-mingo' of git://git.kernel.org/pub/scm/linux/kernel/git/jolsa/perf into perf/core (2014-04-25 10:04:46 +0200)
> 
> are available in the git repository at:
> 
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/jolsa/perf.git tags/perf-core-for-mingo
> 
> for you to fetch changes up to fabf01238289e9ae009499594fc54642f5802a24:
> 
>   perf tests: Add map groups sharing with thread object test (2014-04-28 13:43:40 +0200)
> 
> ----------------------------------------------------------------
> perf/core improvements and fixes:
> 
> . Add a test case for hists filtering (Namhyung Kim)
> 
> . Share map_groups among threads of the same group (Arnaldo Carvalho de Melo, Jiri Olsa)
> 
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> 
> ----------------------------------------------------------------
> Arnaldo Carvalho de Melo (2):
>       perf tools: Allocate thread map_groups's dynamically
>       perf tools: Reference count map_groups objects
> 
> Jiri Olsa (3):
>       perf tests: Add thread maps lookup automated tests
>       perf tools: Share map_groups among threads of the same group
>       perf tests: Add map groups sharing with thread object test
> 
> Namhyung Kim (2):
>       perf tests: Factor out fake_setup_machine()
>       perf tests: Add a test case for hists filtering
> 
>  tools/perf/Makefile.perf                 |   4 +
>  tools/perf/arch/x86/tests/dwarf-unwind.c |   2 +-
>  tools/perf/perf.h                        |   6 +
>  tools/perf/tests/builtin-test.c          |  12 ++
>  tools/perf/tests/hists_common.c          | 148 +++++++++++++++
>  tools/perf/tests/hists_common.h          |  44 +++++
>  tools/perf/tests/hists_filter.c          | 315 +++++++++++++++++++++++++++++++
>  tools/perf/tests/hists_link.c            | 141 +-------------
>  tools/perf/tests/mmap-thread-lookup.c    | 233 +++++++++++++++++++++++
>  tools/perf/tests/tests.h                 |   3 +
>  tools/perf/tests/thread-mg-share.c       |  90 +++++++++
>  tools/perf/ui/stdio/hist.c               |   2 +-
>  tools/perf/util/event.c                  |   2 +-
>  tools/perf/util/machine.c                |  11 ++
>  tools/perf/util/map.c                    |  23 +++
>  tools/perf/util/map.h                    |  12 ++
>  tools/perf/util/thread.c                 |  52 +++--
>  tools/perf/util/thread.h                 |   3 +-
>  18 files changed, 948 insertions(+), 155 deletions(-)
>  create mode 100644 tools/perf/tests/hists_common.c
>  create mode 100644 tools/perf/tests/hists_common.h
>  create mode 100644 tools/perf/tests/hists_filter.c
>  create mode 100644 tools/perf/tests/mmap-thread-lookup.c
>  create mode 100644 tools/perf/tests/thread-mg-share.c

Pulled, thanks a lot Jiri!

	Ingo
