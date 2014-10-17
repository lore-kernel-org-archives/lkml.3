Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751438AbaJQW2S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 18:28:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42550 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751158AbaJQW2R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 18:28:17 -0400
Date: Fri, 17 Oct 2014 19:27:59 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Jiri Olsa <jolsa@kernel.org>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCHv2 0/7] perf tools: Fix branch report segfaults
Message-ID: <20141017222759.GA28763@redhat.com>
References: <1413468427-31049-1-git-send-email-jolsa@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413468427-31049-1-git-send-email-jolsa@kernel.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Oct 16, 2014 at 04:07:00PM +0200, Jiri Olsa escreveu:
> hi,
> adding some branch_info checks to prevent segfaults
> on data without branch info.
> 
> v2: using cmp_null as suggested by Namhyung

Didn't notice this one, will try and put on next pull req,

- Arnaldo
 
> jirka
> 
> available at:
>   git://git.kernel.org/pub/scm/linux/kernel/git/jolsa/perf.git
>   perf/abort_fix_2
> 
> Cc: Andi Kleen <ak@linux.intel.com>
> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
> Cc: David Ahern <dsahern@gmail.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Namhyung Kim <namhyung@kernel.org>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>  tools/perf/util/sort.c | 102 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++---------------------
>  1 file changed, 76 insertions(+), 26 deletions(-)
