Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935899Ab3BOPjQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 10:39:16 -0500
Received: from mail-ea0-f181.google.com ([209.85.215.181]:58443 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932605Ab3BOPjP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 10:39:15 -0500
Date: Fri, 15 Feb 2013 16:39:07 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Andi Kleen <andi@firstfloor.org>, Borislav Petkov <bp@alien8.de>,
        Daniel Baluta <dbaluta@ixiacom.com>,
        Dirk Behme <dirk.behme@de.bosch.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Li Zefan <lizefan@huawei.com>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>, Pekka Enberg <penberg@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Vinson Lee <vlee@twitter.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [GIT PULL 00/10] perf/core improvements and fixes
Message-ID: <20130215153907.GA3324@gmail.com>
References: <1360878263-12694-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1360878263-12694-1-git-send-email-acme@infradead.org>
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
> The following changes since commit a3d4fd7a2d81604fedfa270d29c824b8d3380c2e:
> 
>   Merge branch 'uprobes/core' of git://git.kernel.org/pub/scm/linux/kernel/git/oleg/misc into perf/core (2013-02-11 10:41:53 +0100)
> 
> are available in the git repository at:
> 
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux tags/perf-core-for-mingo
> 
> for you to fetch changes up to 02e176af92f3e2e9ec3a48792036566af2dcd534:
> 
>   perf/hwbp: Fix cleanup in case of kzalloc failure (2013-02-14 17:06:39 -0300)
> 
> ----------------------------------------------------------------
> perf/core improvements and fixes:
> 
> . Fix cleanup in case of kzalloc failure, from Daniel Baluta.
> 
> . Limit unwind support to x86 archs, fix from Jiri Olsa.
> 
> . Initial GTK+ annotate browser, from Namhyung Kim.
> 
> . Fix build with bison 2.3 and older, from Vinson Lee.
> 
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> 
> ----------------------------------------------------------------
> Daniel Baluta (1):
>       perf/hwbp: Fix cleanup in case of kzalloc failure
> 
> Jiri Olsa (1):
>       perf tools: Limit unwind support to x86 archs
> 
> Namhyung Kim (7):
>       perf buildid-cache: Add --update option
>       perf annotate: Fix warning message on a missing vmlinux
>       perf ui/gtk: Implement basic GTK2 annotation browser
>       perf gtk/annotate: Support multiple event annotation
>       perf gtk/annotate: Show source lines with gray color
>       perf gtk/annotate: Fail early if it can't annotate
>       perf annotate: Make it to be able to skip unannotatable symbols
> 
> Vinson Lee (1):
>       perf tools: Fix build with bison 2.3 and older.
> 
>  kernel/events/hw_breakpoint.c                   |   2 +-
>  tools/perf/Documentation/perf-annotate.txt      |   7 +-
>  tools/perf/Documentation/perf-buildid-cache.txt |   4 +
>  tools/perf/Makefile                             |  10 +-
>  tools/perf/builtin-annotate.c                   |  27 ++-
>  tools/perf/builtin-buildid-cache.c              |  50 +++++-
>  tools/perf/ui/gtk/annotate.c                    | 229 ++++++++++++++++++++++++
>  tools/perf/ui/gtk/gtk.h                         |   1 +
>  tools/perf/ui/setup.c                           |   2 +-
>  tools/perf/util/annotate.c                      |   2 +-
>  tools/perf/util/annotate.h                      |  24 +++
>  tools/perf/util/parse-events.y                  |   1 -
>  tools/perf/util/pmu.y                           |   1 -
>  13 files changed, 349 insertions(+), 11 deletions(-)
>  create mode 100644 tools/perf/ui/gtk/annotate.c

Pulled, thanks a lot Arnaldo!

	Ingo
