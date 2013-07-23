Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754651Ab3GWHin (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 03:38:43 -0400
Received: from mail-ee0-f44.google.com ([74.125.83.44]:50732 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136Ab3GWHil (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 03:38:41 -0400
Date: Tue, 23 Jul 2013 09:38:36 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andi Kleen <ak@linux.intel.com>, Borislav Petkov <bp@alien8.de>,
        Clark Williams <williams@redhat.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>, Feng Tang <feng.tang@intel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Hitoshi Mitake <h.mitake@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [GIT PULL 00/11] perf/core improvements and fixes
Message-ID: <20130723073836.GA13710@gmail.com>
References: <1374524559-9839-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374524559-9839-1-git-send-email-acme@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arnaldo Carvalho de Melo <acme@infradead.org> wrote:

> From: Arnaldo Carvalho de Melo <acme@redhat.com>
> 
> Hi Ingo,
> 
> 	Please consider pulling.
> 
> 	Tomorrow I'll try to process Jiri's group leader patches and David's 'kvm live'
> kits and continue looking for patches not processed during my vacations.
> 
> Thanks,
> 
> - Arnaldo
> 
> The following changes since commit 5a9821321e0a61674fd5c4b5a9e95007d0e7e052:
> 
>   Merge tag 'perf-core-for-mingo' of git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux into perf/core (2013-07-19 09:35:30 +0200)
> 
> are available in the git repository at:
> 
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux tags/perf-core-for-mingo
> 
> for you to fetch changes up to f9ea55d0ddf66ed030b2a478625cd5792d30df16:
> 
>   perf tools: Move weight back to common sort keys (2013-07-22 16:58:28 -0300)
> 
> ----------------------------------------------------------------
> perf/core improvements and fixes.
> 
> . Fix memcpy benchmark for large sizes, from Andi Kleen.
> 
> . Support callchain sorting based on addresses, from Andi Kleen
> 
> . Move weight back to common sort keys, From Andi Kleen.
> 
> . Fix named threads support in 'perf script', from David Ahern.
> 
> . Handle ENODEV on default cycles event, fix from David Ahern.
> 
> . More install tests, from Jiri Olsa.
> 
> . Fix build with perl 5.18, from Kirill A. Shutemov.
> 
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> 
> ----------------------------------------------------------------
> Andi Kleen (3):
>       perf bench: Fix memcpy benchmark for large sizes
>       perf tools: Support callchain sorting based on addresses
>       perf tools: Move weight back to common sort keys
> 
> David Ahern (2):
>       perf script: Fix named threads support
>       perf evsel: Handle ENODEV on default cycles event
> 
> Jiri Olsa (5):
>       perf tests: Run ctags/cscope make tests only with needed binaries
>       perf tests: Rename TMP to TMP_O tests/make variable
>       perf tests: Add DESTDIR=TMP_DEST tests/make variable
>       perf tests: Add 'make install/install-bin' tests into tests/make
>       perf tests: Add broken install-* tests into tests/make
> 
> Kirill A. Shutemov (1):
>       perf tools: Fix build with perl 5.18
> 
>  tools/perf/Documentation/perf-report.txt           |  8 ++-
>  tools/perf/Makefile                                |  4 +-
>  tools/perf/bench/mem-memcpy.c                      |  2 +
>  tools/perf/builtin-report.c                        | 19 ++++--
>  tools/perf/builtin-script.c                        |  6 +-
>  tools/perf/tests/make                              | 67 +++++++++++++++++++---
>  tools/perf/util/callchain.c                        |  7 ++-
>  tools/perf/util/callchain.h                        |  6 ++
>  tools/perf/util/evsel.c                            |  2 +-
>  tools/perf/util/hist.c                             |  3 +-
>  .../perf/util/scripting-engines/trace-event-perl.c | 14 +++--
>  .../util/scripting-engines/trace-event-python.c    |  9 +--
>  tools/perf/util/sort.c                             |  4 +-
>  tools/perf/util/sort.h                             |  6 +-
>  tools/perf/util/trace-event-scripting.c            |  3 +-
>  tools/perf/util/trace-event.h                      |  4 +-
>  16 files changed, 124 insertions(+), 40 deletions(-)

Pulled, thanks a lot Arnaldo!

	Ingo
