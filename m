Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751940Ab3KRPgk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 10:36:40 -0500
Received: from mail-ee0-f42.google.com ([74.125.83.42]:35506 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751203Ab3KRPgc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 10:36:32 -0500
Date: Mon, 18 Nov 2013 16:36:29 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Vince Weaver <vincent.weaver@maine.edu>,
        LKML <linux-kernel@vger.kernel.org>, Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>, tytso@mit.edu,
        adilger.kernel@dilger.ca
Subject: Re: perf bug: bad page map
Message-ID: <20131118153629.GA28679@gmail.com>
References: <alpine.DEB.2.10.1311151300120.12594@vincent-weaver-1.um.maine.edu>
 <20131118151746.GC10022@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131118151746.GC10022@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Fri, Nov 15, 2013 at 01:04:23PM -0500, Vince Weaver wrote:
> > 
> > (figured out the minicom issue).
> > 
> > Anyway while trying to reproduce the last bug I instead got this 
> > with the perf_fuzzer.
> > 
> > Is it worth continuing to run and report these issues?  I'm losing 
> > track of all the open bugs.
> 
> This is looks like ext4. Not entirely sure how perf ties into this.
> 
> Anyway, yes, I do think its useful to keep running these tests, we 
> do fix various issues -- although probably not at the rate you seem 
> to be finding them.

I'm trying to slow down the merging of kernel side features, so that 
the fixing effort has a chance to catch up...

Thanks,

	Ingo
