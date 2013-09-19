Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753966Ab3ISNC4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 09:02:56 -0400
Received: from mail-vc0-f177.google.com ([209.85.220.177]:46151 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753810Ab3ISNCz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 09:02:55 -0400
Date: Thu, 19 Sep 2013 09:10:07 -0400 (EDT)
From: Vince Weaver <vincent.weaver@maine.edu>
To: Andi Kleen <andi@firstfloor.org>
cc: Vince Weaver <vincent.weaver@maine.edu>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Dave Jones <davej@redhat.com>
Subject: Re: perf-related lockup on 3.11
In-Reply-To: <8761tx5ie2.fsf@tassilo.jf.intel.com>
Message-ID: <alpine.DEB.2.10.1309190906220.31380@vincent-weaver-1.um.maine.edu>
References: <alpine.DEB.2.10.1309111130410.31828@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1309171710130.15599@vincent-weaver-1.um.maine.edu> <8761tx5ie2.fsf@tassilo.jf.intel.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Sep 2013, Andi Kleen wrote:

> Vince Weaver <vincent.weaver@maine.edu> writes:
> 
> > On Wed, 11 Sep 2013, Vince Weaver wrote:
> >
> >> 
> >> I got this hard lockup running my perf_fuzzer on 3.11 on a core2.
> >> I guess I should try to reproduce it on linus-git but was hoping
> >> I could wait until -rc1 before trying that.
> >
> > OK, I can also lock up 3.12-rc1 using the perf_fuzzer.  Last message
> > logged is below.
> 
> If it's easily reproducible and a regression, could you perhaps bisect it?

It's not necessarily easy to reproduce.  It shows up eventually, but it 
varies a bit.

It's also unclear whether it is a regression or not.  It only started 
appearing because I already got fixed the 5 or so other bugs that the 
fuzzer would trigger first.  So bisecting will be a pain because older 
kernels would have to be patched and the patches don't necessarily apply 
cleanly further back.

I'm working on seeing if I can get a reproducible trace that I can work 
with, but there's a lot of other stuff going on right now so it's semi low 
priority until I can spare a machine from doing 3.12-rc1 validation tests.

Vince
