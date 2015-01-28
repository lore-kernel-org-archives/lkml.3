Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756391AbbA2BkB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 20:40:01 -0500
Received: from mail-wi0-f176.google.com ([209.85.212.176]:56274 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755163AbbA2Bj6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 20:39:58 -0500
Date: Wed, 28 Jan 2015 15:42:19 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Borislav Petkov <bp@suse.de>, David Ahern <dsahern@gmail.com>,
        Don Zickus <dzickus@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Li Zefan <lizefan@huawei.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>, Rabin Vincent <rabin@rab.in>,
        Stephane Eranian <eranian@google.com>, Wang Nan <wangnan0@huawei.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [GIT PULL 0/9] perf/urgent fixes
Message-ID: <20150128144219.GA6559@gmail.com>
References: <1421852470-20153-1-git-send-email-acme@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421852470-20153-1-git-send-email-acme@kernel.org>
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
> The following changes since commit d01de2389c0190f5959f0a1258a2e87d2fe4ca82:
> 
>   Merge tag 'perf-urgent-for-mingo' of git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux into perf/urgent (2015-01-17 11:04:35 +0100)
> 
> are available in the git repository at:
> 
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux.git tags/perf-urgent-for-mingo
> 
> for you to fetch changes up to 25dd9171f51c482eb7c4dc8618766ae733756e2d:
> 
>   perf probe: Fix probing kretprobes (2015-01-21 10:06:24 -0300)
> 
> ----------------------------------------------------------------
> perf/urgent fixes:
> 
> User visible:
> 
> - Fix probing at function return (Namhyumg Kim)
> 
> Developer stuff:
> 
> - Symbol processing changes necessary for fixing support for
>   kretprobes in 'perf probe' (Namhyung Kim, Arnaldo Carvalho de Melo)
> 
> - Annotation memory leaks and instruction parsing fixes (Rabin Vincent)
> 
> - Fix perl build on ARM64 (Wang Nam)
> 
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> 
> ----------------------------------------------------------------
> Arnaldo Carvalho de Melo (3):
>       perf evlist: Remove extraneous 'was' on error message
>       perf symbols: Introduce method to iterate symbols ordered by name
>       perf symbols: Introduce 'for' method to iterate over the symbols with a given name
> 
> Namhyung Kim (3):
>       perf symbols: Return the first entry with a given name in find_by_name method
>       perf probe: Do not rely on map__load() filter to find symbols
>       perf probe: Fix probing kretprobes
> 
> Rabin Vincent (2):
>       perf annotate: Handle ins parsing failures
>       perf annotate: Fix memory leaks in LOCK handling
> 
> Wang Nan (1):
>       perf scripting perl: Force to use stdbool
> 
>  tools/perf/scripts/perl/Perf-Trace-Util/Context.c |  5 +++-
>  tools/perf/util/annotate.c                        | 18 +++++++++---
>  tools/perf/util/evlist.c                          |  2 +-
>  tools/perf/util/map.h                             | 16 +++++++++++
>  tools/perf/util/probe-event.c                     | 34 +++++++++++------------
>  tools/perf/util/symbol.c                          | 31 +++++++++++++++++++--
>  tools/perf/util/symbol.h                          |  1 +
>  7 files changed, 80 insertions(+), 27 deletions(-)

Pulled, thanks a lot Arnaldo!

	Ingo
