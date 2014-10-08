Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754977AbaJHPWN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 11:22:13 -0400
Received: from mail.kernel.org ([198.145.19.201]:59070 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752604AbaJHPWL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 11:22:11 -0400
Date: Wed, 8 Oct 2014 12:22:04 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: David Ahern <dsahern@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@kernel.org>
Subject: Re: PERF_EVENT_IOC_SET_FILTER has different values based on bitness
Message-ID: <20141008152204.GN14113@kernel.org>
References: <54347238.2060908@gmail.com>
 <20141008072355.GA10832@worktop.programming.kicks-ass.net>
 <54355592.6000604@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54355592.6000604@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Oct 08, 2014 at 09:17:38AM -0600, David Ahern escreveu:
> On 10/8/14, 1:23 AM, Peter Zijlstra wrote:
> >Should be fixed for a while now
> >
> >---
> >commit b3f207855f57b9c8f43a547a801340bb5cbc59e5
> >Author: Pawel Moll <pawel.moll@arm.com>
> >Date:   Fri Jun 13 16:03:32 2014 +0100
> >
> >     perf: Handle compat ioctl
> >
> 
> that works. Can we get this queued to the stable releases (at least as far
> back as v3.4)?

I wonder how that works best, being on the receiving side of such requests
from time to time.

I guess that to scale, that would be better done by:

1. Reporter tests if the patch applies (and works) on the desired
targets.

2. Reporter sends the request, with the above test results, to
stable@kernel.org, following whatever conventions are to get the
attention of the stable release maintainers.

- Arnaldo
