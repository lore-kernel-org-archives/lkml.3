Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756629AbaHVPCb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 11:02:31 -0400
Received: from mail.kernel.org ([198.145.19.201]:58223 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756582AbaHVPC3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 11:02:29 -0400
Date: Fri, 22 Aug 2014 12:02:24 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Jiri Olsa <jolsa@kernel.org>
Cc: linux-kernel@vger.kernel.org, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jean Pihet <jean.pihet@linaro.org>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 0/2] perf tools: Add +field argument support for
 --field/--sort options
Message-ID: <20140822150224.GB3473@kernel.org>
References: <1408715919-25990-1-git-send-email-jolsa@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1408715919-25990-1-git-send-email-jolsa@kernel.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Aug 22, 2014 at 03:58:37PM +0200, Jiri Olsa escreveu:
> hi,
> adding support to add field(s) to default field and sort orders
> via using the '+' prefix, like for report:
>   $ perf report -F +period,sample
>   $ perf report -s +cpu
> 
> thanks,
> jirka

Really cool feature, (lightly) tested and applied,

Thanks,

- Arnaldo
 
> 
> Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
> Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
> Cc: David Ahern <dsahern@gmail.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Jean Pihet <jean.pihet@linaro.org>
> Cc: Namhyung Kim <namhyung@kernel.org>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
> Jiri Olsa (2):
>       perf tools: Add +field argument support for --field option
>       perf tools: Add +field argument support for --sort option
> 
>  tools/perf/ui/hist.c   |  4 ++--
>  tools/perf/util/sort.c | 52 ++++++++++++++++++++++++++++++++++++++++++++++------
>  tools/perf/util/sort.h |  1 +
>  3 files changed, 49 insertions(+), 8 deletions(-)
