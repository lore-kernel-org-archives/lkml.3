Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751631AbaKGFY7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 00:24:59 -0500
Received: from mail-wi0-f172.google.com ([209.85.212.172]:44650 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751510AbaKGFY4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 00:24:56 -0500
Date: Fri, 7 Nov 2014 06:24:51 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung.kim@lge.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [GIT PULL 00/18] perf/core improvements and fixes
Message-ID: <20141107052451.GA30298@gmail.com>
References: <1415307879-912-1-git-send-email-acme@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415307879-912-1-git-send-email-acme@kernel.org>
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
> The following changes since commit daa01794a4a36a1da1b09a529adec0c8c0b94ab2:
> 
>   perf evsel: Do not call pevent_free_format when deleting tracepoint (2014-11-06 17:47:14 -0300)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux.git tags/perf-core-for-mingo
> 
> for you to fetch changes up to daa01794a4a36a1da1b09a529adec0c8c0b94ab2:
> 
>   perf evsel: Do not call pevent_free_format when deleting tracepoint (2014-11-06 17:47:14 -0300)
> 
> ----------------------------------------------------------------
> perf/core improvements and fixes:
> 
> Infrastructure:
> 
> o Add gzip decompression support for kernel modules (Namhyung Kim)
> 
> o More prep patches for Intel PT, including a a thread stack and
>   more stuff made available via the database export mechanism (Adrian Hunter)
> 
> o Optimize checking that tracepoint events are defined in perf script perl/python (Jiri Olsa)
> 
> o Do not free pevent when deleting tracepoint evsel (Jiri Olsa)
> 
> o Fix build-id matching for vmlinux (Namhyung Kim)
> 
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> 
> ----------------------------------------------------------------

Pulled, thanks a lot Arnaldo!

	Ingo
