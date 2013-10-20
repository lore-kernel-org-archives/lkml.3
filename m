Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751501Ab3JTIxr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Oct 2013 04:53:47 -0400
Received: from mail-ee0-f52.google.com ([74.125.83.52]:55196 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751152Ab3JTIxp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Oct 2013 04:53:45 -0400
Date: Sun, 20 Oct 2013 10:53:39 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <ak@linux.intel.com>, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Jiri Olsa <jolsa@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        Waiman Long <Waiman.Long@hp.com>, acme@ghostprotocols.net,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [GIT PULL 0/3] perf/urgent fixes
Message-ID: <20131020085339.GD16236@gmail.com>
References: <1382257646-5808-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1382257646-5808-1-git-send-email-acme@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arnaldo Carvalho de Melo <acme@infradead.org> wrote:

> Hi Ingo,
> 
> 	Please consider pulling,
> 
> - Arnaldo
> 
> The following changes since commit 1651d120baddf68846188bcdf0ef5350068436cf:
> 
>   Merge tag 'perf-urgent-for-mingo' of git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux into perf/urgent (2013-10-08 07:29:09 +0200)
> 
> are available in the git repository at:
> 
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux tags/perf-urgent-for-mingo
> 
> for you to fetch changes up to 3090ffb5a2515990182f3f55b0688a7817325488:
> 
>   perf: Disable PERF_RECORD_MMAP2 support (2013-10-17 16:27:14 -0300)
> 
> ----------------------------------------------------------------
> perf/urgent fixes:
> 
> . Fix build error on Fedora 12.
> 
> . Fix to initialize fname always before use it, bug introduced
>   during this merge window, from Masami Hiramatsu.
> 
> . Disable PERF_RECORD_MMAP2 support, from Stephane Eranian.
> 
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> 
> ----------------------------------------------------------------
> Arnaldo Carvalho de Melo (1):
>       perf scripting perl: Fix build error on Fedora 12
> 
> Masami Hiramatsu (1):
>       perf probe: Fix to initialize fname always before use it
> 
> Stephane Eranian (1):
>       perf: Disable PERF_RECORD_MMAP2 support
> 
>  kernel/events/core.c                               |  4 +++
>  tools/perf/util/event.c                            | 30 ++++++++++------------
>  tools/perf/util/evsel.c                            |  1 -
>  tools/perf/util/probe-finder.c                     |  2 +-
>  .../perf/util/scripting-engines/trace-event-perl.c |  2 +-
>  5 files changed, 19 insertions(+), 20 deletions(-)

Pulled, thanks Arnaldo!

	Ingo
