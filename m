Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754220AbaDOR0X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 13:26:23 -0400
Received: from mail-ee0-f49.google.com ([74.125.83.49]:39623 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751169AbaDOR0W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 13:26:22 -0400
Date: Tue, 15 Apr 2014 19:26:17 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, Cody P Schafer <cody@linux.vnet.ibm.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@kernel.org>
Subject: Re: [GIT PULL 0/2] perf/urgent fixes
Message-ID: <20140415172616.GA707@gmail.com>
References: <1397567226-27516-1-git-send-email-jolsa@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1397567226-27516-1-git-send-email-jolsa@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jiri Olsa <jolsa@redhat.com> wrote:

> hi Ingo,
> please consider pulling
> 
> thanks,
> jirka
> 
> 
> The following changes since commit fbdd17ec5ce2e5e4027356fcfde769b88d15702f:
> 
>   Merge branch 'perf-core-for-mingo' into perf/urgent (2014-04-14 16:45:39 +0200)
> 
> are available in the git repository at:
> 
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/jolsa/perf.git tags/perf-urgent-for-mingo
> 
> for you to fetch changes up to c9e87a472594fd237b2d19dcbe4a3424297f0b1a:
> 
>   perf tools: Instead of redirecting flex output, use -o (2014-04-15 13:57:21 +0200)
> 
> ----------------------------------------------------------------
> perf/urgent fixes:
> 
> Developer stuff:
> . Instead of redirecting flex output, use -o (Cody P Schafer)
> 
> . Fix double free in perf test 21 (Adrian Hunter)
> 
> Signed-off-by: Jiri Olsa <jolsa@redhat.com>
> 
> ----------------------------------------------------------------
> Adrian Hunter (1):
>       perf tools: Fix double free in perf test 21 (code-reading.c)
> 
> Cody P Schafer (1):
>       perf tools: Instead of redirecting flex output, use -o
> 
>  tools/perf/Makefile.perf        | 4 ++--
>  tools/perf/tests/code-reading.c | 1 +
>  2 files changed, 3 insertions(+), 2 deletions(-)

Pulled, thanks a lot Jiri!

	Ingo
