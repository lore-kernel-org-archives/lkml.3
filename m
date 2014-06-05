Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751980AbaFEIqH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 04:46:07 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:50044 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082AbaFEIqC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 04:46:02 -0400
Date: Thu, 5 Jun 2014 10:45:56 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Jiri Olsa <jolsa@kernel.org>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Cody P Schafer <dev@codyps.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>, David Binderman <dcb314@hotmail.com>,
        Dianfang Zhang <zhangdianfang@huawei.com>,
        Don Zickus <dzickus@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jean Delvare <jdelvare@suse.de>, Jianyu Zhan <nasa4836@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Peter Zijlstra <peterz@infradead.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Stephane Eranian <eranian@google.com>,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Subject: Re: [GIT PULL 0/9] perf/core improvements and fixes
Message-ID: <20140605084556.GA14647@gmail.com>
References: <1401827776-4443-1-git-send-email-jolsa@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401827776-4443-1-git-send-email-jolsa@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
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
> The following changes since commit 9b261365dd73a5014b49033327ad881708e81f33:
> 
>   Merge tag 'perf-core-for-mingo' of git://git.kernel.org/pub/scm/linux/kernel/git/jolsa/perf into perf/core (2014-06-03 20:22:40 +0200)
> 
> are available in the git repository at:
> 
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/jolsa/perf.git tags/perf-core-for-mingo
> 
> for you to fetch changes up to fc9cabeabf42d76854059e7bce81a02645e7e5ca:
> 
>   perf tools: Fix 'make help' message error (2014-06-03 21:35:12 +0200)
> 
> ----------------------------------------------------------------
> perf/core improvements and fixes:
> 
> . Warn the user when trace command is not available (Arnaldo Carvalho de Melo)
> 
> . Add warning when disabling perl scripting support due to missing devel files (Arnaldo Carvalho de Melo)
> 
> . Consider header files outside perf directory in tags target (Sebastian Andrzej Siewior)
> 
> . Allow overriding sysfs and proc finding with env var (Cody P Schafer)
> 
> . Fix "==" into "=" in ui_browser__warning assignment (zhangdianfang)
> 
> . Factor elide bool handling in sort code (Jiri Olsa)
> 
> . Fix poll return value propagation (Jiri Olsa)
> 
> . Fix 'make help' message error (Jianyu Zhan)
> 
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> 
> ----------------------------------------------------------------
> Arnaldo Carvalho de Melo (2):
>       perf trace: Warn the user when not available
>       perf tools: Add warning when disabling perl scripting support due to missing devel files
> 
> Cody P Schafer (1):
>       perf tools: Allow overriding sysfs and proc finding with env var
> 
> Jianyu Zhan (1):
>       perf tools: Fix 'make help' message error
> 
> Jiri Olsa (3):
>       perf tools: Remove elide setup for SORT_MODE__MEMORY mode
>       perf tools: Move elide bool into perf_hpp_fmt struct
>       perf record: Fix poll return value propagation
> 
> Sebastian Andrzej Siewior (1):
>       perf tools: Consider header files outside perf directory in tags target
> 
> zhangdianfang (1):
>       perf tools: Fix "==" into "=" in ui_browser__warning assignment
> 
>  tools/lib/api/fs/fs.c          |  43 ++++++++++++++++-
>  tools/perf/Makefile.perf       |  13 ++++--
>  tools/perf/builtin-record.c    |   6 ++-
>  tools/perf/config/Makefile     |   3 +-
>  tools/perf/perf.c              |   8 +++-
>  tools/perf/ui/browser.c        |   2 +-
>  tools/perf/ui/browsers/hists.c |   8 ++--
>  tools/perf/util/hist.h         |   8 +++-
>  tools/perf/util/sort.c         | 103 ++++++++++++++++++++++-------------------
>  tools/perf/util/sort.h         |   2 +-
>  10 files changed, 132 insertions(+), 64 deletions(-)

Pulled, thanks a lot Jiri!

	Ingo
