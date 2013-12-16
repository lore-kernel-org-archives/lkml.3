Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754765Ab3LPP5h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 10:57:37 -0500
Received: from mail-wg0-f53.google.com ([74.125.82.53]:48520 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753978Ab3LPP5g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 10:57:36 -0500
Date: Mon, 16 Dec 2013 16:57:32 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Andi Kleen <ak@linux.intel.com>
Cc: Ingo Molnar <mingo@kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: Re: [PATCH v0 00/71] perf: Add support for Intel Processor Trace
Message-ID: <20131216155730.GB26686@localhost.localdomain>
References: <1386765443-26966-1-git-send-email-alexander.shishkin@linux.intel.com>
 <20131211130448.GA2480@gmail.com>
 <87r49jttqr.fsf@ashishki-desk.ger.corp.intel.com>
 <20131211134724.GC3101@gmail.com>
 <87bo0ht5nj.fsf@ashishki-desk.ger.corp.intel.com>
 <20131216143751.GA7959@gmail.com>
 <20131216151852.GW22695@tassilo.jf.intel.com>
 <20131216153008.GA26686@localhost.localdomain>
 <20131216154527.GX22695@tassilo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131216154527.GX22695@tassilo.jf.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 16, 2013 at 07:45:27AM -0800, Andi Kleen wrote:
> > You're right it's extremely slow. But it can still be relevant for debugging,
> > at least for apps that don't do too much CPU bound stuffs.
> 
> There are patches from Markus already for gdb to use it (using the old
> BTS perf interface). I'm not sure they have been merged into gdb
> mainline yet though.

Ok.

> 
> > My hope has always been that we can make a userspace function graph tracer
> > out of its dumps. And I think we can, I'm pretty sure that would be a useful tool.
> 
> I wrote one, based on the __fentry__, like the kernel:
> http://github.com/andikleen/ftracer

Sounds like nice stuff, but that implies building with the gcc option I think.

> 
> BTS has no timing information, so you could at best do a function tracer
> without timing.

Right, now although the function timing was the initial purpose of the function graph
tracer, the graph itself proved to be much more useful :)

But yeah the timing is nice too when we chase hotspot though probably perf report deprecated it.

> 
> -Andi
> -- 
> ak@linux.intel.com -- Speaking for myself only
