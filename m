Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754631AbaFYFld (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 01:41:33 -0400
Received: from mail-wg0-f48.google.com ([74.125.82.48]:46095 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752785AbaFYFlc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 01:41:32 -0400
Date: Wed, 25 Jun 2014 07:41:27 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Jiri Olsa <jolsa@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Simon Que <sque@chromium.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [GIT PULL 0/2] perf/urgent fixes
Message-ID: <20140625054127.GB21231@gmail.com>
References: <1403510076-3917-1-git-send-email-jolsa@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403510076-3917-1-git-send-email-jolsa@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
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
> The following changes since commit cf230918cda19532e4a5cc4f0d5c82fa7e5e94f6:
> 
>   Merge branch 'perf/core' into perf/urgent, to pick up the latest fixes (2014-06-14 14:10:08 +0200)
> 
> are available in the git repository at:
> 
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/jolsa/perf.git tags/perf-urgent-for-mingo
> 
> for you to fetch changes up to a93f0e551af9e194db38bfe16001e17a3a1d189a:
> 
>   perf symbols: Get kernel start address by symbol name (2014-06-20 09:34:22 +0200)
> 
> ----------------------------------------------------------------
> perf/urgent fixes:
> 
> . Fix kernel start address lookup in report code (Simon Que)
> 
> . Fix segfault in cumulative.callchain report (Jiri Olsa)
> 
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> 
> ----------------------------------------------------------------
> Jiri Olsa (1):
>       perf tools: Fix segfault in cumulative.callchain report
> 
> Simon Que (1):
>       perf symbols: Get kernel start address by symbol name
> 
>  tools/perf/ui/browsers/hists.c | 21 ++++++++++++----
>  tools/perf/util/machine.c      | 54 +++++++++++++++++-------------------------
>  2 files changed, 38 insertions(+), 37 deletions(-)

Pulled, thanks a lot Jiri!

	Ingo
