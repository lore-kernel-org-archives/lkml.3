Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754521AbaJMSMS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 14:12:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61271 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752453AbaJMSMR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 14:12:17 -0400
Date: Mon, 13 Oct 2014 20:11:58 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCHSET 0/5] perf tools: Speed up dwarf callchain
 post-unwinding for libunwind (v4)
Message-ID: <20141013181158.GA28191@krava.redhat.com>
References: <1412556363-26229-1-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412556363-26229-1-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 06, 2014 at 09:45:58AM +0900, Namhyung Kim wrote:
> Hello,
> 
> This is v4 for libunwind callchain post processing speed up.  It was
> able to reduce 50% of processing time by using global cache provided
> in libunwind.  In this version, I decided to use the existing
> callchain_param.record_mode instead of adding a new field in the
> symbol_conf.
> 
> The patch 4 and 5 are just cleanups so that we can easily find out
> that which part of code uses the thread->priv.
> 
> You can also get it from 'perf/callchain-unwind-v4' branch on my tree:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/namhyung/linux-perf.git
> 
> Thanks,
> Namhyung
> 
> 
> Namhyung Kim (5):
>   perf report: Set callchain_param.record_mode for future use
>   perf callchain: Create an address space per thread
>   perf callchain: Use global caching provided by libunwind
>   perf kvm: Use thread_{,_set}_priv helpers
>   perf trace: Use thread_{,_set}_priv helpers

Acked-by: Jiri Olsa <jolsa@kernel.org>

thanks,
jirka
