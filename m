Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753089Ab3GHTCg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 15:02:36 -0400
Received: from mail-vb0-f50.google.com ([209.85.212.50]:63331 "EHLO
	mail-vb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753064Ab3GHTCd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 15:02:33 -0400
Date: Mon, 8 Jul 2013 15:08:12 -0400 (EDT)
From: Vince Weaver <vincent.weaver@maine.edu>
To: Peter Zijlstra <peterz@infradead.org>
cc: Vince Weaver <vincent.weaver@maine.edu>, linux-kernel@vger.kernel.org,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: perf: more ABI breakage
In-Reply-To: <20130708164721.GC22923@dyad.programming.kicks-ass.net>
Message-ID: <alpine.DEB.2.10.1307081504130.10386@vincent-weaver-1.um.maine.edu>
References: <alpine.DEB.2.10.1307081115350.2281@vincent-weaver-1.um.maine.edu> <20130708164721.GC22923@dyad.programming.kicks-ass.net>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Jul 2013, Peter Zijlstra wrote:

> Urgh, so the 3.9 patches should never have been merged and sunk in while I was
> doing my vegetable imitation.
> 
> Stephane agreed with the change in 3.10; and I suppose he overlooked the fact
> that people were already using it :/ I specifically asked if there were already
> users as that would indeed require some form of backwards compatibility --
> however annoying.

I probably was just hoping no one was using it, and since I don't own any 
fam15h hardware myself it didn't affect me directly.

The problem is that AMD NB support was so long in coming that everyone 
eagerly jumped on it when it arrived, to the extent of running -rc 3.9
kernels.

We can only hope that 3.9 is not chosen as long-term-stable, and that
RHEL and the HPC vendors don't decide to backport the 3.9 support to their 
older kernels.  If so we're stuck with it for a while :(

It looks like it will be possible for libpfm4/PAPI to sort of paper over 
this but it's going to be annoying :(

Vince
