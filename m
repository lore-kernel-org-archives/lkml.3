Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752603Ab3KDGug (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 01:50:36 -0500
Received: from mail-ee0-f52.google.com ([74.125.83.52]:50650 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751629Ab3KDGue (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 01:50:34 -0500
Date: Mon, 4 Nov 2013 07:50:31 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jean Pihet <jean.pihet@linaro.org>, Jiri Olsa <jolsa@redhat.com>,
        Michael Hudson-Doyle <michael.hudson@linaro.org>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Wei Yang <weiyang@linux.vnet.ibm.com>,
        Will Deacon <will.deacon@arm.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [GIT PULL 0/3] perf/urgent fixes
Message-ID: <20131104065031.GA13030@gmail.com>
References: <1383317807-25062-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1383317807-25062-1-git-send-email-acme@infradead.org>
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
> The following changes since commit e8a923cc1fff6e627f906655ad52ee694ef2f6d7:
> 
>   perf/x86: Fix NMI measurements (2013-10-29 12:01:20 +0100)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux tags/perf-urgent-for-mingo
> 
> for you to fetch changes up to 46d525eae2a076adfde92dca1db12d9a3b8ad8bb:
> 
>   perf test: Update command line callchain attribute tests (2013-11-01 10:42:57 -0300)
> 
> ----------------------------------------------------------------
> perf/urgent fixes:
> 
> . Fix command line callchain attribute tests to handle the new
>   -g/--call-chain semantics.
> 
> . Remove cast of non-variadic function to variadic, fixing perf output
>   on armhf arch. Fix from Michael Hudson-Doyle.
> 
> . Fix 32-bit building of 'perf bench', from Wei Yang.
> 
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> 
> ----------------------------------------------------------------
> Arnaldo Carvalho de Melo (1):
>       perf test: Update command line callchain attribute tests
> 
> Michael Hudson-Doyle (1):
>       perf tools: Remove cast of non-variadic function to variadic
> 
> Wei Yang (1):
>       perf bench: Fix two warnings
> 
>  tools/perf/bench/numa.c                         |  4 ++--
>  tools/perf/tests/attr/README                    |  6 +++---
>  tools/perf/tests/attr/test-record-graph-default |  2 +-
>  tools/perf/tests/attr/test-record-graph-dwarf   |  2 +-
>  tools/perf/tests/attr/test-record-graph-fp      |  2 +-
>  tools/perf/ui/hist.c                            |  2 +-
>  tools/perf/util/color.c                         | 11 +++++++++--
>  tools/perf/util/color.h                         |  2 +-
>  8 files changed, 19 insertions(+), 12 deletions(-)

Pulled, thanks Arnaldo!

	Ingo
