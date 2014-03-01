Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752697AbaCAJPU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2014 04:15:20 -0500
Received: from mail-ee0-f47.google.com ([74.125.83.47]:44373 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752576AbaCAJOm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2014 04:14:42 -0500
Date: Sat, 1 Mar 2014 10:14:38 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [GIT PULL 0/2] perf/urgent fixes
Message-ID: <20140301091438.GC5885@gmail.com>
References: <1393622751-21513-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393622751-21513-1-git-send-email-acme@infradead.org>
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
> The following changes since commit b6e53f321ee6f4b237d8cc54fbace3217fa96e05:
> 
>   Merge tag 'perf-urgent-for-mingo' of git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux into perf/urgent (2014-02-27 12:47:59 +0100)
> 
> are available in the git repository at:
> 
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux tags/perf-urgent-for-mingo
> 
> for you to fetch changes up to b39c2a57a00a841f057a75b41df4c26173288b66:
> 
>   perf tools: Fix strict alias issue for find_first_bit (2014-02-28 10:39:40 -0300)
> 
> ----------------------------------------------------------------
> perf/urgent build fixes:
> 
> . Problem on recent gcc on x86-32 related to strict alias issue for
>   find_first_bit (Jiri Olsa).
> 
> . OpenSuSE: BFD detection problems related to not explicitely listing all
>   required libraries (Andi Kleen)
> 
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> 
> ----------------------------------------------------------------
> Andi Kleen (1):
>       perf tools: fix BFD detection on opensuse
> 
> Jiri Olsa (1):
>       perf tools: Fix strict alias issue for find_first_bit
> 
>  tools/perf/config/Makefile                | 2 +-
>  tools/perf/config/feature-checks/Makefile | 2 +-
>  tools/perf/util/include/linux/bitops.h    | 4 +++-
>  3 files changed, 5 insertions(+), 3 deletions(-)

Pulled, thanks a lot Arnaldo!

	Ingo
