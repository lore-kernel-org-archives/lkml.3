Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751212AbaJIGyM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 02:54:12 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:63675 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750824AbaJIGyH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 02:54:07 -0400
Date: Thu, 9 Oct 2014 08:54:02 +0200
From: Ingo Molnar <mingo@kernel.org>
To: David Ahern <dsahern@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@kernel.org>
Subject: Re: PERF_EVENT_IOC_SET_FILTER has different values based on bitness
Message-ID: <20141009065402.GA20178@gmail.com>
References: <54347238.2060908@gmail.com>
 <20141008072355.GA10832@worktop.programming.kicks-ass.net>
 <54355592.6000604@gmail.com>
 <20141008152204.GN14113@kernel.org>
 <5435575E.2090308@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5435575E.2090308@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Ahern <dsahern@gmail.com> wrote:

> On 10/8/14, 9:22 AM, Arnaldo Carvalho de Melo wrote:
> >I wonder how that works best, being on the receiving side of such requests
> >from time to time.
> >
> >I guess that to scale, that would be better done by:
> >
> >1. Reporter tests if the patch applies (and works) on the desired
> >targets.
> >
> >2. Reporter sends the request, with the above test results, to
> >stable@kernel.org, following whatever conventions are to get the
> >attention of the stable release maintainers.
> 
> My understanding is that subsystem maintainers do the stable 
> requests.

At least for perf bits, the usual workflow is that pretty much 
anyone can make requests for backports that we maintainers 
missed, and subsystem maintainers look over them and object if 
they don't like the suggestion. (Obviously you need to Cc: 
maintainers.)

In other words, feel free to forward (tested!) backport commit 
IDs to -stable, with maintainers Cc:-ed, and feel free to provide 
conflict resolution as well, in cases where they don't apply 
cleanly.

> A patch adjustment is needed for v3.4 and v3.10. I am willing 
> to do the necessary patch mods for 3.4, 3.10, and 3.14.

That would be useful.

Thanks,

	Ingo
