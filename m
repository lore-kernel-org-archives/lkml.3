Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753384Ab3LZPam (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Dec 2013 10:30:42 -0500
Received: from mail-we0-f179.google.com ([74.125.82.179]:59470 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753289Ab3LZPak (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Dec 2013 10:30:40 -0500
Date: Thu, 26 Dec 2013 16:30:35 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: David Ahern <dsahern@gmail.com>
Cc: Joseph Schuchart <joseph.schuchart@tu-dresden.de>,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        thomas.ilsche@tu-dresden.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Perf: Correct Assumptions about Sample Timestamps in
 Passes
Message-ID: <20131226153033.GC15303@localhost.localdomain>
References: <528490DE.4080204@tu-dresden.de>
 <20131114100552.GA5064@gmail.com>
 <528E1EE6.9040407@tu-dresden.de>
 <20131127135137.GA24403@gmail.com>
 <52B437AA.4090102@tu-dresden.de>
 <52B479E1.7020204@gmail.com>
 <20131223131051.GB585@localhost.localdomain>
 <52B84C49.70001@gmail.com>
 <20131226151429.GA15303@localhost.localdomain>
 <52BC4A13.1090508@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52BC4A13.1090508@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 26, 2013 at 10:24:03AM -0500, David Ahern wrote:
> On 12/26/13, 10:14 AM, Frederic Weisbecker wrote:
> >>I was carrying that patch while working on perf-kvm-stat-live last
> >>Fall. It does not solve the problem for live commands, so ended up
> >>dropping it and going with local (to the command) hacks. I still
> >>think for live commands getting a perf_clock timestamp at the start
> >>of a round and using that as the flush time will work best.
> >
> >Ok, but how would you fetch this perf clock timestamp, with an explicit read?
> 
> One option is exporting perf_clock to userspace.
> 
> Preferably a built-in option, https://lkml.org/lkml/2013/12/10/781,
> but I can go the module route if I have to:
> https://github.com/dsahern/linux/blob/perf-full-monty/README.ahern

I see, that's one of the very verbose threads I've seen lately ;)
