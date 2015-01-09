Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756818AbbAIKE7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 05:04:59 -0500
Received: from mail-wg0-f47.google.com ([74.125.82.47]:61785 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751865AbbAIKE5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 05:04:57 -0500
Date: Fri, 9 Jan 2015 11:04:52 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <andi@firstfloor.org>, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [GIT PULL 0/3] perf/urgent fixes
Message-ID: <20150109100452.GA2278@gmail.com>
References: <1420731408-8631-1-git-send-email-acme@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420731408-8631-1-git-send-email-acme@kernel.org>
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
> The following changes since commit ed9eb845d7916b2bc863e5b93c82e18be8faf032:
> 
>   Merge tag 'perf-urgent-for-mingo' of git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux into perf/urgent (2015-01-08 08:59:22 +0100)
> 
> are available in the git repository at:
> 
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux.git tags/perf-urgent-for-mingo
> 
> for you to fetch changes up to c09e31cc128cf1aec3a6cd47203508fbf0082873:
> 
>   perf hists browser: Fix segfault when showing callchain (2015-01-08 11:59:16 -0300)
> 
> ----------------------------------------------------------------
> perf/urgent fixes:
> 
> . Free callchains when hist entries are deleted, plugging a massive leak in
>   'top -g', where hist_entries (and its callchains) are decayed over time. (Namhyung Kim)
> 
> . Fix segfault when showing callchain in the hists browser (report & top) (Namhyung Kim)
> 
> . Fix children sort key behavior, and also the 'perf test 32' test that
>   was failing due to reliance on undefined behaviour (Namhyung Kim)
> 
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> 
> ----------------------------------------------------------------
> Namhyung Kim (3):
>       perf hists: Fix children sort key behavior
>       perf callchain: Free callchains when hist entries are deleted
>       perf hists browser: Fix segfault when showing callchain
> 
>  tools/perf/tests/hists_cumulate.c | 64 +++++++++++++++++++--------------------
>  tools/perf/ui/browsers/hists.c    |  2 +-
>  tools/perf/ui/hist.c              |  3 ++
>  tools/perf/util/callchain.c       | 30 ++++++++++++++++++
>  tools/perf/util/callchain.h       |  2 ++
>  tools/perf/util/hist.c            |  1 +
>  6 files changed, 69 insertions(+), 33 deletions(-)

Pulled, thanks a lot Arnaldo!

	Ingo
