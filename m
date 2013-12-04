Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755200Ab3LDJSh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 04:18:37 -0500
Received: from mail-bk0-f48.google.com ([209.85.214.48]:39132 "EHLO
	mail-bk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754378Ab3LDJSd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 04:18:33 -0500
Date: Wed, 4 Dec 2013 10:18:29 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Dongsheng Yang <yangds.fnst@cn.fujitsu.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Hurley <peter@hurleysoftware.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Stanislav Fomichev <stfomichev@yandex-team.ru>,
        Stephane Eranian <eranian@google.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [GIT PULL 00/12] perf/core improvements and fixes
Message-ID: <20131204091829.GA32531@gmail.com>
References: <1386017349-24486-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386017349-24486-1-git-send-email-acme@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arnaldo Carvalho de Melo <acme@infradead.org> wrote:

> From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
> 
> Hi Ingo,
> 
> 	Please consider pulling,
> 
> - Arnaldo
> 
> The following changes since commit 0ed1e0bee0b2c6b4cc6d7a63787739a9d3ac8aa8:
> 
>   Merge tag 'perf-core-for-mingo' of git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux into perf/core (2013-11-30 13:42:48 +0100)
> 
> are available in the git repository at:
> 
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux tags/perf-core-for-mingo
> 
> for you to fetch changes up to f885037ef6400ce4a4c122a88845dea2c9bca256:
> 
>   perf trace: Honour -m option (2013-12-02 16:29:40 -0300)
> 
> ----------------------------------------------------------------
> perf/tools improvements and fixes:
> 
> . Honour -m option in 'trace', the tool was offering the option to
>   set the mmap size, but wasn't using it when doing the actual mmap
>   on the events file descriptors, fix from Jiri Olsa.
> 
> . Correct the message in feature-libnuma checking, swowing the right
>   devel package names for various distros, from Dongsheng Yang.
> 
> . Polish 'readn' function and introduce its counterpart, 'writen', from
>   Jiri Olsa.
> 
> . Start moving timechart state from global variables to a 'perf_tool' derived
>   'timechart' struct.
> 
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> 
> ----------------------------------------------------------------
> Arnaldo Carvalho de Melo (4):
>       perf timechart: Introduce tool struct
>       perf timechart: Move all_data per_pid list to 'struct timechart'
>       perf timechart: Move power_events list to 'struct timechart'
>       perf timechart: Move wake_events list to 'struct timechart'
> 
> Dongsheng Yang (1):
>       perf tools: Correct the message in feature-libnuma checking.
> 
> Jiri Olsa (7):
>       perf record: Unify data output code into perf_record__write function
>       perf tools: Use correct return type for readn function
>       perf tools: Fine tune readn function
>       perf tools: Add writen function
>       perf tools: Add perf_data_file__write interface
>       perf tools: Include test-stackprotector-all.c in test-all
>       perf trace: Honour -m option
> 
>  tools/perf/builtin-record.c                 |  20 +-
>  tools/perf/builtin-timechart.c              | 364 +++++++++++++++-------------
>  tools/perf/builtin-trace.c                  |   2 +-
>  tools/perf/config/Makefile                  |   2 +-
>  tools/perf/config/feature-checks/test-all.c |   5 +
>  tools/perf/util/data.c                      |   6 +
>  tools/perf/util/data.h                      |  14 +-
>  tools/perf/util/header.c                    |  18 +-
>  tools/perf/util/session.c                   |   2 +-
>  tools/perf/util/util.c                      |  32 ++-
>  tools/perf/util/util.h                      |   3 +-
>  11 files changed, 256 insertions(+), 212 deletions(-)

Pulled, thanks a lot Arnaldo!

	Ingo
