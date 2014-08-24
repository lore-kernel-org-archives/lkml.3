Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752661AbaHXKLa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2014 06:11:30 -0400
Received: from mail-wg0-f52.google.com ([74.125.82.52]:53276 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752417AbaHXKL3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2014 06:11:29 -0400
Date: Sun, 24 Aug 2014 12:11:24 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <andi@firstfloor.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>, Don Zickus <dzickus@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jean Pihet <jean.pihet@linaro.org>, Jiri Olsa <jolsa@redhat.com>,
        Joe Mario <jmario@redhat.com>, Michael Ellerman <michaele@au1.ibm.com>,
        Namhyung Kim <namhyung.kim@lge.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [GIT PULL 00/16] perf/core improvements and fixes
Message-ID: <20140824101123.GB1309@gmail.com>
References: <1408724968-3441-1-git-send-email-acme@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1408724968-3441-1-git-send-email-acme@kernel.org>
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
> The following changes since commit af924aa35129edf338ebc8da6a4eae08cf7cb297:
> 
>   Merge tag 'perf-core-for-mingo' of git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux into perf/core (2014-08-18 10:14:43 +0200)
> 
> are available in the git repository at:
> 
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux.git tags/perf-core-for-mingo
> 
> for you to fetch changes up to 141da74d2eff8de134c5a5ffaf2800a8a1b27517:
> 
>   perf hists browser: Consolidate callchain print functions in TUI (2014-08-22 13:12:15 -0300)
> 
> ----------------------------------------------------------------
> perf/core improvements and fixes:
> 
> User visible:
> 
> o Don't try to find DSOs in SYSV maps (Don Zickus)
> 
> o Fallback to MAP__FUNCTION if daddr maps are NULL,
>   i.e. addresses get looked upon more maps (Don Zickus)
> 
> o Kernel fix to properly handle exited tasks, by returning POLLHUP values
>   on perf event file descriptors. Tooling changes will come next, but were
>   tested with this kernel fix. (Jiri Olsa)

So the signoffs are really weird (and invalid) here:

commit ce1d77c667e40631d6673717e65e72f72265bf10
Author: Jiri Olsa <jolsa@kernel.org>
Date:   Fri Aug 15 16:24:45 2014 -0300

    perf top: Use set_term_quiet() instead of open coded equivalent

...    
    Cc: Jiri Olsa <jolsa@kernel.org>
    Cc: Namhyung Kim <namhyung@kernel.org>
    Cc: Paul Mackerras <paulus@samba.org>
    Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
    Link: http://lkml.kernel.org/n/tip-h7n9te70flmaqfnj6l06ay6r@git.kernel.org
    [ Yanked this out of a patch containing this and some other change ]
    Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>


and in 7713886adc15 and f017bf0a8d92 - results of a rebase gone wrong?

Thanks,

	Ingo
