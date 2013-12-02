Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752908Ab3LBGHk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 01:07:40 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:46760 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751179Ab3LBGHi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 01:07:38 -0500
Date: Mon, 2 Dec 2013 11:37:29 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: David Ahern <dsahern@gmail.com>
Cc: acme@ghostprotocols.net, linux-kernel@vger.kernel.org, namhyung@kernel.org,
        Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Galbraith <efault@gmx.de>, Jiri Olsa <jolsa@redhat.com>,
        Stephane Eranian <eranian@google.com>,
        Pekka Enberg <penberg@kernel.org>
Subject: Re: [PATCH 2/2] perf sched: Add documentation for timehist options
Message-ID: <20131202060729.GA28684@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <1385943795-11761-1-git-send-email-dsahern@gmail.com>
 <1385943795-11761-3-git-send-email-dsahern@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1385943795-11761-3-git-send-email-dsahern@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13120206-5806-0000-0000-000023904BB8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* David Ahern <dsahern@gmail.com> [2013-12-01 17:23:15]:

> Add entry to perf-sched documentation for timehist command and its
> options.
> 
> v2: Addressed comments by Namhyung
> 
> Signed-off-by: David Ahern <dsahern@gmail.com>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Mike Galbraith <efault@gmx.de>
> Cc: Jiri Olsa <jolsa@redhat.com>
> Cc: Namhyung Kim <namhyung@kernel.org>
> Cc: Stephane Eranian <eranian@google.com>
> Cc: Pekka Enberg <penberg@kernel.org>
> ---
>  tools/perf/Documentation/perf-sched.txt | 61 ++++++++++++++++++++++++++++++++-
>  1 file changed, 60 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/perf/Documentation/perf-sched.txt b/tools/perf/Documentation/perf-sched.txt
> index 8ff4df956951..e7bb19fcdbff 100644
> --- a/tools/perf/Documentation/perf-sched.txt
> +++ b/tools/perf/Documentation/perf-sched.txt
> @@ -8,7 +8,7 @@ perf-sched - Tool to trace/measure scheduler properties (latencies)
>  SYNOPSIS
>  --------
>  [verse]
> -'perf sched' {record|latency|map|replay|script}
> +'perf sched' {record|latency|map|replay|script|timehist}
>  
>  DESCRIPTION
>  -----------
> @@ -36,6 +36,11 @@ There are five variants of perf sched:

Nit: There are six variants now.

-- 
Thanks and Regards
Srikar Dronamraju

