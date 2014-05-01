Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752131AbaEAGZR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 02:25:17 -0400
Received: from mail-ee0-f41.google.com ([74.125.83.41]:64402 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985AbaEAGZP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 02:25:15 -0400
Date: Thu, 1 May 2014 08:25:10 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Jiri Olsa <jolsa@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jean Pihet <jean.pihet@linaro.org>,
        Mathias Krause <minipli@googlemail.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Richard Yao <ryao@gentoo.org>,
        Xia Kaixu <xiakaixu@huawei.com>
Subject: Re: [GIT PULL 0/7] perf/urgent fixes
Message-ID: <20140501062510.GA15071@gmail.com>
References: <1398871971-381-1-git-send-email-jolsa@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398871971-381-1-git-send-email-jolsa@kernel.org>
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
> The following changes since commit 9f7ff8931e3c5ddc8535476971ec9501e9555c05:
> 
>   perf/x86: Fix RAPL rdmsrl_safe() usage (2014-04-24 08:12:41 +0200)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/jolsa/perf.git tags/perf-urgent-for-mingo
> 
> for you to fetch changes up to 9a126728165eef9b1e9349fe57b9747ac6c6f7e3:
> 
>   perf tests x86: Fix stack map lookup in dwarf unwind test (2014-04-30 17:02:31 +0200)
> 
> ----------------------------------------------------------------
> perf/urgent fixes:
> 
> . Fix perf to use non-executable stack, again (Mathias Krause)
> 
> . Remove extra '/' character in events file path (Xia Kaixu)
> 
> . Search for modules in %s/lib/modules/%s (Richard Yao)
> 
> . Build related fixies plus static build test (Jiri Olsa)
> 
> . Fix stack map lookup in dwarf unwind test (Jiri Olsa)
> 
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> 
> ----------------------------------------------------------------
> Jiri Olsa (4):
>       perf tools: Use LDFLAGS instead of ALL_LDFLAGS
>       perf tools: Fix bfd dependency libraries detection
>       perf tests: Add static build make test
>       perf tests x86: Fix stack map lookup in dwarf unwind test
> 
> Mathias Krause (1):
>       perf x86: Fix perf to use non-executable stack, again
> 
> Richard Yao (1):
>       perf machine: Search for modules in %s/lib/modules/%s
> 
> Xia Kaixu (1):
>       perf tools: Remove extra '/' character in events file path
> 
>  tools/lib/api/fs/debugfs.c               |  4 ++--
>  tools/perf/Makefile.perf                 |  2 +-
>  tools/perf/arch/x86/tests/dwarf-unwind.c |  2 +-
>  tools/perf/arch/x86/tests/regs_load.S    |  8 ++++++-
>  tools/perf/config/Makefile               | 38 +++++++++++++++++++++++---------
>  tools/perf/tests/make                    |  2 ++
>  tools/perf/util/machine.c                | 16 ++++++++++----
>  7 files changed, 52 insertions(+), 20 deletions(-)

Pulled, thanks a lot Jiri!

	Ingo
