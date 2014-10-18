Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751360AbaJRHFJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2014 03:05:09 -0400
Received: from mail-wg0-f48.google.com ([74.125.82.48]:36626 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750937AbaJRHFF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2014 03:05:05 -0400
Date: Sat, 18 Oct 2014 09:04:59 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <andi@firstfloor.org>, Borislav Petkov <bp@suse.de>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>, Don Zickus <dzickus@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jean Pihet <jean.pihet@linaro.org>,
        Jen-Cheng Huang <tommy24@gatech.edu>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [GIT PULL 0/5] perf/core improvements and fixes
Message-ID: <20141018070459.GA4088@gmail.com>
References: <1413575373-10787-1-git-send-email-acme@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413575373-10787-1-git-send-email-acme@kernel.org>
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
> The following changes since commit 691286b5561aab2e1b00119bc328598c01250548:
> 
>   kprobes/x86: Remove stale ARCH_SUPPORTS_KPROBES_ON_FTRACE define (2014-10-17 07:18:34 +0200)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux.git tags/perf-core-for-mingo
> 
> for you to fetch changes up to e8564b710c6df2c3aeb56c507c22f4bcfa4c0b2d:
> 
>   perf script: Add period as a default output column (2014-10-17 15:22:19 -0300)
> 
> ----------------------------------------------------------------
> perf/core improvements and fixes:
> 
> User visible:
> 
> o Add period data column and make it default in 'perf script' (Jiri Olsa)
> 
> Infrastructure:
> 
> * Move exit stuff from perf_evsel__delete to perf_evsel__exit, delete
>   should be just a front end for exit + free (Arnaldo Carvalho de Melo)
> 
> * Add missing 'struct option' forward declaration (Arnaldo Carvalho de Melo)
> 
> * No need to drag util/cgroup.h into evsel.h (Arnaldo Carvalho de Melo)
> 
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> 
> ----------------------------------------------------------------
> Arnaldo Carvalho de Melo (3):
>       perf evsel: Move exit stuff from __delete to __exit
>       perf evlist: Add missing 'struct option' forward declaration
>       perf evsel: No need to drag util/cgroup.h
> 
> Jiri Olsa (2):
>       perf script: Add period data column
>       perf script: Add period as a default output column
> 
>  tools/perf/Documentation/perf-script.txt |  2 +-
>  tools/perf/builtin-record.c              |  1 +
>  tools/perf/builtin-script.c              | 21 +++++++++++++++++----
>  tools/perf/builtin-stat.c                |  1 +
>  tools/perf/util/evlist.h                 |  2 ++
>  tools/perf/util/evsel.c                  | 11 ++++++-----
>  tools/perf/util/evsel.h                  |  3 ++-
>  7 files changed, 30 insertions(+), 11 deletions(-)

Pulled, thanks a lot Arnaldo!

	Ingo
