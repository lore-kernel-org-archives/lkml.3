Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752012Ab3KRXKU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 18:10:20 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:34276 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751301Ab3KRXKR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 18:10:17 -0500
Date: Mon, 18 Nov 2013 23:05:53 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>, tytso@mit.edu,
        adilger.kernel@dilger.ca
Subject: Re: perf bug: bad page map
Message-ID: <20131118230553.32c478df@alan.etchedpixels.co.uk>
In-Reply-To: <alpine.DEB.2.10.1311181138390.18020@vincent-weaver-1.um.maine.edu>
References: <alpine.DEB.2.10.1311151300120.12594@vincent-weaver-1.um.maine.edu>
	<20131118151746.GC10022@twins.programming.kicks-ass.net>
	<alpine.DEB.2.10.1311181138390.18020@vincent-weaver-1.um.maine.edu>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Nov 2013 11:41:22 -0500 (EST)
Vince Weaver <vincent.weaver@maine.edu> wrote:

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
> It's believable the filesystem could have issues (it's a fuzzer machine, 
> so it's had 100+ unclean shutdowns on an SSD drive in the past few months)
> but as far as I know there shouldn't have been any filesystem accesses 
> happening at all when the bug triggered.

Obvious question - does it pass fsck currently. If it does then
presumably it was sane at the time it went pop ?
