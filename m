Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932649Ab3J1O7a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 10:59:30 -0400
Received: from mail-ee0-f48.google.com ([74.125.83.48]:37465 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932209Ab3J1O7Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 10:59:25 -0400
Date: Mon, 28 Oct 2013 15:59:21 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Joseph Schuchart <joseph.schuchart@tu-dresden.de>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [GIT PULL 0/2] perf/urgent fixes
Message-ID: <20131028145921.GA11150@gmail.com>
References: <1382971525-2078-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1382971525-2078-1-git-send-email-acme@infradead.org>
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
> The following changes since commit e4f8eaad70ea186b8da290c99239dce721a34f88:
> 
>   Merge tag 'perf-urgent-for-mingo' of git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux into perf/urgent (2013-10-20 10:51:35 +0200)
> 
> are available in the git repository at:
> 
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux tags/perf-urgent-for-mingo
> 
> for you to fetch changes up to 2fd869f08aec5a8e4cbf01bc3fa345c4e53342d7:
> 
>   perf tools: Fix up /proc/PID/maps parsing (2013-10-28 09:38:12 -0300)
> 
> ----------------------------------------------------------------
> perf/urgent fixes:
> 
> . Fix up /proc/PID/maps parsing, where perfectly fine mmap entries
>   were being trown away when synthesizing PERF_RECORD_MMAP for
>   preexisting threads, prevenging symbol resolution to work
>   for those threads, broken in the MMAP2 removal. Reported and
>   pinpointed by Markus Trippelsdorf,
> 
> . Fix mem leak in the python 'perf script' backend, due to missing Py_DECREFs
>   on dict entries, fix from Joseph Schuchart.
> 
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> 
> ----------------------------------------------------------------
> Arnaldo Carvalho de Melo (1):
>       perf tools: Fix up /proc/PID/maps parsing
> 
> Joseph Schuchart (1):
>       perf script python: Fix mem leak due to missing Py_DECREFs on dict entries
> 
>  tools/perf/util/event.c                            |  2 +-
>  .../util/scripting-engines/trace-event-python.c    | 37 ++++++++++++++--------
>  2 files changed, 25 insertions(+), 14 deletions(-)

Pulled, thanks Arnaldo!

	Ingo
