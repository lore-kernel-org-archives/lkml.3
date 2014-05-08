Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752814AbaEHFkT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 01:40:19 -0400
Received: from mail-lb0-f173.google.com ([209.85.217.173]:34469 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751192AbaEHFkQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 01:40:16 -0400
Date: Thu, 8 May 2014 09:40:12 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, Don Zickus <dzickus@redhat.com>
Subject: Re: perf_fuzzer crash on pentium 4
Message-ID: <20140508054012.GL8607@moon>
References: <20140506214630.GB1458@moon>
 <alpine.DEB.2.10.1405071244570.6340@vincent-weaver-1.umelst.maine.edu>
 <20140507164902.GD1444@moon>
 <20140507165811.GG1444@moon>
 <alpine.DEB.2.10.1405071305010.6340@vincent-weaver-1.umelst.maine.edu>
 <20140507182410.GA8607@moon>
 <alpine.DEB.2.10.1405071713590.7020@vincent-weaver-1.umelst.maine.edu>
 <20140507215144.GG8607@moon>
 <20140507215430.GH8607@moon>
 <alpine.DEB.2.10.1405080111280.9135@vincent-weaver-1.umelst.maine.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1405080111280.9135@vincent-weaver-1.umelst.maine.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 08, 2014 at 01:14:56AM -0400, Vince Weaver wrote:
> > 
> > There were a bug in p4 pmu Don (CC'ed) fixed not that long ago but I fear
> > not all corner cases might be covered yet.
> 
> I hit the NMI warnings somewhat often on Intel hardware (Haswell, Core2) 
> but it usually doesn't make the system unusable like it does on p4.
> 
> I can try to get a trace, although I'm not sure it will be useful.  I 
> spent a lot of time getting a reproducible test case for the same warnings 
> on core2 and it was unclear what the proble was and it was never fixed.
> 
> The messages look like this:
> 
> [ 2944.203423] Uhhuh. NMI received for unknown reason 31 on CPU 0.
> [ 2944.208006] Do you have a strange power saving mode enabled?
> [ 2944.208006] Dazed and confused, but trying to continue
> [ 2944.208006] Uhhuh. NMI received for unknown reason 21 on CPU 0.
> [ 2944.208006] Do you have a strange power saving mode enabled?
> [ 2944.208006] Dazed and confused, but trying to continue
> [ 2944.208006] Uhhuh. NMI received for unknown reason 31 on CPU 0.
> [ 2944.208006] Do you have a strange power saving mode enabled?
> [ 2944.208006] Dazed and confused, but trying to continue
> 
> repeating forever, system is unusable.

Vince, is it possible to get a trace which exactly events perf-fuzzed
pushed into the kernel? Maybe it would shed some light.
