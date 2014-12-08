Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754775AbaLHKqP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 05:46:15 -0500
Received: from mail-wg0-f53.google.com ([74.125.82.53]:44063 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752982AbaLHKqO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 05:46:14 -0500
Date: Mon, 8 Dec 2014 11:46:09 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: linux-kernel@vger.kernel.org, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Matt Fleming <matt.fleming@intel.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [GIT PULL 0/1] perf/urgent fix
Message-ID: <20141208104609.GB22066@gmail.com>
References: <1417210123-19500-1-git-send-email-acme@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417210123-19500-1-git-send-email-acme@kernel.org>
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
> The following changes since commit 7ddc6a2199f1da405a2fb68c40db8899b1a8cd87:
> 
>   x86/asm/traps: Disable tracing and kprobes in fixup_bad_iret and sync_regs (2014-11-25 07:26:55 +0100)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux.git tags/perf-urgent-for-mingo
> 
> for you to fetch changes up to f61ff6c06dc8f32c7036013ad802c899ec590607:
> 
>   perf session: Do not fail on processing out of order event (2014-11-28 18:19:37 -0300)
> 
> ----------------------------------------------------------------
> perf/urgent fix:
> 
> * Do not stop processing when out of order events are detected, just count them
>   and notify the user about it after processing all events. (Jiri Olsa)
> 
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> 
> ----------------------------------------------------------------
> Jiri Olsa (1):
>       perf session: Do not fail on processing out of order event
> 
>  tools/perf/util/event.h   |  1 +
>  tools/perf/util/session.c | 11 +++++------
>  2 files changed, 6 insertions(+), 6 deletions(-)

Pulled, thanks a lot Arnaldo!

	Ingo
