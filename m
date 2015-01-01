Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751848AbbAAVdP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jan 2015 16:33:15 -0500
Received: from mail-wg0-f43.google.com ([74.125.82.43]:63794 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751507AbbAAVdO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jan 2015 16:33:14 -0500
Date: Thu, 1 Jan 2015 22:25:56 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [GIT PULL 0/3] perf/urgent fixes and improvements
Message-ID: <20150101212555.GB26239@gmail.com>
References: <1419348763-29118-1-git-send-email-acme@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1419348763-29118-1-git-send-email-acme@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arnaldo Carvalho de Melo <acme@kernel.org> wrote:

> Hi Ingo,
> 
> 	Please consider pulling,
> 
> - Arnaldo
> 
> The following changes since commit ac931f87a647ca156f65a4c00e7297165e4fa2d8:
> 
>   perf: Fix building warning on ARM 32 (2014-12-19 13:09:43 +0100)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux.git tags/perf-urgent-for-mingo
> 
> for you to fetch changes up to 82aa019e0098a1e0801df94345c0297448323126:
> 
>   perf callchain: Append callchains only when requested (2014-12-23 12:06:39 -0300)
> 
> ----------------------------------------------------------------
> perf/urgent fixes and improvements:
> 
> User visible:
> 
> - Show progress bar in more places while doing histogram processing
>   in the hists browser (Namhyung Kim)
> 
> - Print backtrace symbols when segfault occurs in 'report' (Namhyung Kim)
> 
> Infrastructure:
> 
> - Append callchains only when requested (Namhyung Kim)
> 
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> 
> ----------------------------------------------------------------
> Namhyung Kim (3):
>       perf report: Show progress bar for output resorting
>       perf ui/tui: Print backtrace symbols when segfault occurs
>       perf callchain: Append callchains only when requested
> 
>  tools/perf/builtin-annotate.c     |  2 +-
>  tools/perf/builtin-diff.c         |  2 +-
>  tools/perf/builtin-report.c       | 24 ++++++++++++++++++++++--
>  tools/perf/builtin-top.c          |  4 ++--
>  tools/perf/tests/hists_cumulate.c |  2 +-
>  tools/perf/tests/hists_filter.c   |  2 +-
>  tools/perf/tests/hists_output.c   | 10 +++++-----
>  tools/perf/ui/tui/setup.c         | 26 ++++++++++++++++++++++++--
>  tools/perf/util/hist.c            | 17 +++++++++++++----
>  tools/perf/util/hist.h            |  2 +-
>  10 files changed, 71 insertions(+), 20 deletions(-)

Pulled into tip:perf/urgent, thanks a lot Arnaldo!

	Ingo
