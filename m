Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752811AbaHCMOs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2014 08:14:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19414 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752322AbaHCMOr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2014 08:14:47 -0400
Date: Sun, 3 Aug 2014 14:12:59 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Yann Droneaud <ydroneaud@opteya.com>
Cc: Jiri Olsa <jolsa@kernel.org>, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Paul Mackerras <paulus@samba.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@gmail.com>,
        Stephane Eranian <eranian@google.com>,
        William Cohen <wcohen@redhat.com>
Subject: Re: [PATCH] perf tools: report PERF_FLAG_FD_CLOEXEC probing error
 once
Message-ID: <20140803121259.GB1181@krava.brq.redhat.com>
References: <1406908014-8312-1-git-send-email-jolsa@kernel.org>
 <1407003202-13672-1-git-send-email-ydroneaud@opteya.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1407003202-13672-1-git-send-email-ydroneaud@opteya.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 02, 2014 at 08:13:22PM +0200, Yann Droneaud wrote:
> In case of failure, unrelated to PERF_FLAG_FD_CLOEXEC,
> perf_flag_probe() reports the error twice. For example:
> 
>   $ perf record ls
>   Error:
>   perf_event_open(..., PERF_FLAG_FD_CLOEXEC) failed with unexpected error 16 (Device or resource busy)
>   perf_event_open(..., 0) failed unexpectedly with error 16 (Device or resource busy)

seems ok,
but since your patch is not based on my other patch,
please provide the changelog perf out without it

---
>   The PMU counters are busy/taken by another profiler.
>   We found oprofile daemon running, please stop it and try again.
---

also, please provide both before and after outputs
I'll queue it up with those other 2 patches

thanks,
jirka
