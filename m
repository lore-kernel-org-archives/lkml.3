Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751965Ab3KRRNS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 12:13:18 -0500
Received: from mail-ee0-f53.google.com ([74.125.83.53]:51627 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751375Ab3KRRNO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 12:13:14 -0500
Date: Mon, 18 Nov 2013 18:13:10 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>, tytso@mit.edu,
        adilger.kernel@dilger.ca
Subject: Re: perf bug: bad page map
Message-ID: <20131118171310.GA28736@gmail.com>
References: <alpine.DEB.2.10.1311151300120.12594@vincent-weaver-1.um.maine.edu>
 <20131118151746.GC10022@twins.programming.kicks-ass.net>
 <alpine.DEB.2.10.1311181138390.18020@vincent-weaver-1.um.maine.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1311181138390.18020@vincent-weaver-1.um.maine.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Vince Weaver <vincent.weaver@maine.edu> wrote:

> On Mon, 18 Nov 2013, Peter Zijlstra wrote:
> 
> > On Fri, Nov 15, 2013 at 01:04:23PM -0500, Vince Weaver wrote:
> > > 
> > > (figured out the minicom issue).
> > > 
> > > Anyway while trying to reproduce the last bug I instead got this with
> > > the perf_fuzzer.
> > > 
> > > Is it worth continuing to run and report these issues?  I'm losing track 
> > > of all the open bugs.
> > 
> > This is looks like ext4. Not entirely sure how perf ties into this.
> 
> It's believable the filesystem could have issues (it's a fuzzer 
> machine, so it's had 100+ unclean shutdowns on an SSD drive in the 
> past few months) but as far as I know there shouldn't have been any 
> filesystem accesses happening at all when the bug triggered.
> 
> I thought it might be perf related due to the perf references in the 
> backtrace (and since it was being perf-fuzzed at the time).

Maybe the connection is that ext4 has lots of tracepoints?

Thanks,

	Ingo
