Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752204AbaFMGU3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 02:20:29 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:37157 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751554AbaFMGU1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 02:20:27 -0400
Date: Fri, 13 Jun 2014 08:20:22 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Jiri Olsa <jolsa@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jean Pihet <jean.pihet@linaro.org>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [GIT PULL 00/14] perf/core improvements and fixes
Message-ID: <20140613062022.GA21785@gmail.com>
References: <1402587045-5461-1-git-send-email-jolsa@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1402587045-5461-1-git-send-email-jolsa@kernel.org>
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
> The following changes since commit 7184062b94b4bfac08715fb786fd2df399c5d6ee:
> 
>   Merge tag 'perf-core-for-mingo' of git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux into perf/core (2014-06-12 13:54:42 +0200)
> 
> are available in the git repository at:
> 
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/jolsa/perf.git tags/perf-core-for-mingo
> 
> for you to fetch changes up to 45dc1bb5c1d47f9519e2101f6b073bb4bb1d1f99:
> 
>   perf tests: Add test for closing dso objects on EMFILE error (2014-06-12 16:53:23 +0200)
> 
> ----------------------------------------------------------------
> perf/core improvements and fixes:
> 
> . Honor user freq/interval properly in record command (Namhyung Kim)
> 
> . Speedup DWARF unwind (Jiri Olsa)
> 
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> 
> ----------------------------------------------------------------
> Jiri Olsa (13):
>       perf tools: Cache register accesses for unwind processing
>       perf tools: Separate dso data related variables
>       perf tools: Add data_fd into dso object
>       perf tools: Add global list of opened dso objects
>       perf tools: Add global count of opened dso objects
>       perf tools: Cache dso data file descriptor
>       perf tools: Add file size check and factor dso__data_read_offset
>       perf tools: Allow to close dso fd in case of open failure
>       perf tools: Add dso__data_* interface descriptons
>       perf tests: Spawn child for each test
>       perf tests: Allow reuse of test_file function
>       perf tests: Add test for caching dso file descriptors
>       perf tests: Add test for closing dso objects on EMFILE error
> 
> Namhyung Kim (1):
>       perf record: Fix to honor user freq/interval properly
> 
>  tools/perf/tests/builtin-test.c    |  42 +++++-
>  tools/perf/tests/dso-data.c        | 214 +++++++++++++++++++++++++++-
>  tools/perf/tests/tests.h           |   2 +
>  tools/perf/util/dso.c              | 279 +++++++++++++++++++++++++++++++++----
>  tools/perf/util/dso.h              |  50 ++++++-
>  tools/perf/util/event.h            |   5 +
>  tools/perf/util/evsel.c            |   4 +-
>  tools/perf/util/perf_regs.c        |  10 +-
>  tools/perf/util/perf_regs.h        |   4 +-
>  tools/perf/util/unwind-libunwind.c |   2 -
>  10 files changed, 574 insertions(+), 38 deletions(-)

Pulled, thanks a lot Jiri!

	Ingo
