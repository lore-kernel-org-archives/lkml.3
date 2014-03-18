Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754070AbaCRIWt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 04:22:49 -0400
Received: from mail-ee0-f48.google.com ([74.125.83.48]:50361 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752534AbaCRIWq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 04:22:46 -0400
Date: Tue, 18 Mar 2014 09:22:42 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@kernel.org>,
        Patrick Palka <patrick@parcs.ath.cx>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [GIT PULL 0/2] perf/urgent 'perf bench' fixes
Message-ID: <20140318082242.GB28634@gmail.com>
References: <1394817839-26310-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1394817839-26310-1-git-send-email-acme@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arnaldo Carvalho de Melo <acme@infradead.org> wrote:

> From: Arnaldo Carvalho de Melo <acme@redhat.com>
> 
> Hi Ingo,
> 
> 	Please consider pulling,
> 
> - Arnaldo
> 
> The following changes since commit b7b4839d93e50adccef29eccb694807cdcb8bee3:
> 
>   perf/x86: Fix leak in uncore_type_init failure paths (2014-03-11 11:59:34 +0100)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux tags/perf-urgent-for-mingo
> 
> for you to fetch changes up to 6eeefccdcfc2cc9697562e740bfe6c35fddd4e1c:
> 
>   perf bench: Fix NULL pointer dereference in "perf bench all" (2014-03-14 13:45:54 -0300)
> 
> ----------------------------------------------------------------
> perf/urgent 'bench' fixes:
> 
> . Make 'perf bench mem' (i.e. no args) mean 'run all tests' so that we can run
>   all tests, not stopping at the numa ones.  (Arnaldo Carvalho de Melo)
> 
> . Fix NULL pointer dereference after last test in in "perf bench all" (Patrick Palka)
> 
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> 
> ----------------------------------------------------------------
> Arnaldo Carvalho de Melo (1):
>       perf bench numa: Make no args mean 'run all tests'
> 
> Patrick Palka (1):
>       perf bench: Fix NULL pointer dereference in "perf bench all"
> 
>  tools/perf/bench/numa.c    | 1 +
>  tools/perf/builtin-bench.c | 2 +-
>  2 files changed, 2 insertions(+), 1 deletion(-)

Pulled, thanks a lot Arnaldo!

	Ingo
