Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751642AbaETGhj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 02:37:39 -0400
Received: from mail-ee0-f47.google.com ([74.125.83.47]:48874 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751158AbaETGhh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 02:37:37 -0400
Date: Tue, 20 May 2014 08:37:32 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Jiri Olsa <jolsa@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Dongsheng Yang <yangds.fnst@cn.fujitsu.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jean Pihet <jean.pihet@linaro.org>,
        Masanari Iida <standby24x7@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Peter Zijlstra <peterz@infradead.org>,
        Will Deacon <will.deacon@arm.com>
Subject: Re: [GIT PULL 0/8] perf/core improvements and fixes
Message-ID: <20140520063732.GA31186@gmail.com>
References: <1400502656-20751-1-git-send-email-jolsa@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400502656-20751-1-git-send-email-jolsa@kernel.org>
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
> The following changes since commit 26f273802b6ed28e059f4359bc7711dffceda022:
> 
>   Merge tag 'perf-core-for-mingo' of git://git.kernel.org/pub/scm/linux/kernel/git/jolsa/perf into perf/core (2014-05-12 17:57:48 +0200)
> 
> are available in the git repository at:
> 
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/jolsa/perf.git tags/perf-core-for-mingo
> 
> for you to fetch changes up to 97eac381b113932bd7bd4a5c3c68b18e9ff7a2a0:
> 
>   perf tools: Add libdw DWARF post unwind support for ARM (2014-05-16 11:39:29 +0200)
> 
> ----------------------------------------------------------------
> perf/core improvements and fixes:
> 
> . Add libdw DWARF post unwind support for ARM (Jean Pihet)
> 
> . Consolidate types.h for ARM and ARM64 (Jean Pihet)
> 
> . Fix possible null pointer dereference in session.c (Masanari Iida)
> 
> . Cleanup, remove unused variables in map_switch_event() (Dongsheng Yang)
> 
> . Remove nr_state_machine_bugs in perf latency (Dongsheng Yang)
> 
> . Remove usage of trace_sched_wakeup(.success) (Peter Zijlstra)
> 
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> 
> ----------------------------------------------------------------
> Dongsheng Yang (2):
>       perf sched: Remove nr_state_machine_bugs in perf latency
>       perf sched: Cleanup, remove unused variables in map_switch_event()
> 
> Jean Pihet (4):
>       perf tools: Consolidate types.h for ARM and ARM64
>       perf tests: Introduce perf_regs_load function on ARM
>       perf tests: Add dwarf unwind test on ARM
>       perf tools: Add libdw DWARF post unwind support for ARM
> 
> Masanari Iida (1):
>       perf session: Fix possible null pointer dereference in session.c
> 
> Peter Zijlstra (1):
>       perf tools: Remove usage of trace_sched_wakeup(.success)
> 
>  tools/perf/Makefile.perf                  |  2 +-
>  tools/perf/arch/arm/Makefile              |  7 ++++
>  tools/perf/arch/arm/include/perf_regs.h   |  7 +++-
>  tools/perf/arch/arm/tests/dwarf-unwind.c  | 60 +++++++++++++++++++++++++++++++
>  tools/perf/arch/arm/tests/regs_load.S     | 58 ++++++++++++++++++++++++++++++
>  tools/perf/arch/arm/util/unwind-libdw.c   | 36 +++++++++++++++++++
>  tools/perf/arch/arm64/include/perf_regs.h |  2 +-
>  tools/perf/builtin-sched.c                | 32 ++++++-----------
>  tools/perf/config/Makefile                |  4 +--
>  tools/perf/tests/builtin-test.c           |  2 +-
>  tools/perf/tests/evsel-tp-sched.c         |  3 --
>  tools/perf/tests/tests.h                  |  2 +-
>  tools/perf/util/session.c                 |  5 +--
>  13 files changed, 187 insertions(+), 33 deletions(-)
>  create mode 100644 tools/perf/arch/arm/tests/dwarf-unwind.c
>  create mode 100644 tools/perf/arch/arm/tests/regs_load.S
>  create mode 100644 tools/perf/arch/arm/util/unwind-libdw.c

Pulled, thanks a lot Jiri!

	Ingo
