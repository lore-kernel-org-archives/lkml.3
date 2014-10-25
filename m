Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933172AbaJYAh4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 20:37:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54445 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932111AbaJYAhz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 20:37:55 -0400
Date: Fri, 24 Oct 2014 22:37:40 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Jiri Olsa <jolsa@kernel.org>, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCHv2 0/7] perf tools: Fix branch report segfaults
Message-ID: <20141025003740.GA8322@redhat.com>
References: <1413468427-31049-1-git-send-email-jolsa@kernel.org>
 <87egu0ga2n.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87egu0ga2n.fsf@sejong.aot.lge.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Oct 22, 2014 at 10:36:00AM +0900, Namhyung Kim escreveu:
> Hi Jiri,
> 
> On Thu, 16 Oct 2014 16:07:00 +0200, Jiri Olsa wrote:
> > hi,
> > adding some branch_info checks to prevent segfaults
> > on data without branch info.
> >
> > v2: using cmp_null as suggested by Namhyung
> 
> For the series,
> 
> Acked-by: Namhyung Kim <namhyung@kernel.org>

Thanks, applied.

- Arnaldo
