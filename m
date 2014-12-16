Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751728AbaLPXDD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 18:03:03 -0500
Received: from casper.infradead.org ([85.118.1.10]:50590 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751044AbaLPXDA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 18:03:00 -0500
Date: Wed, 17 Dec 2014 00:02:46 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Mel Gorman <mgorman@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andy Lutomirski <luto@amacapital.net>,
        Steven Rostedt <rostedt@goodmis.org>, Tejun Heo <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Don Zickus <dzickus@redhat.com>, Dave Jones <davej@redhat.com>,
        the arch/x86 maintainers <x86@kernel.org>
Subject: Re: frequent lockups in 3.18rc4
Message-ID: <20141216230246.GA30905@twins.programming.kicks-ass.net>
References: <CA+55aFyEnuByhPM3FEdi=Q0WGuJWiBgtkWNAbRLHDpmPRaqnQA@mail.gmail.com>
 <alpine.DEB.2.11.1411212049220.6439@nanos>
 <CA+55aFzvgxAMpP7kr9qrxyo82vSucQ5G+VByOgsgoyq6y5ExOA@mail.gmail.com>
 <alpine.DEB.2.11.1411212110320.6439@nanos>
 <CA+55aFyt6q7Ed-SS9GeN8jeUZu6yNM14EGyH_8rn8AF2Vv37hg@mail.gmail.com>
 <alpine.DEB.2.11.1411212207150.6439@nanos>
 <CA+55aFyzg=vJqRwh2CsK8WD-E5nRPjdiasMaTBx6qygQhDrGLA@mail.gmail.com>
 <20141216192803.GC3337@twins.programming.kicks-ass.net>
 <CA+55aFx9oTQHnamJ=QEGOKHe2obQEn2NfNa+hJ_Z-V1FyY7QaQ@mail.gmail.com>
 <20141216211921.GA2395@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141216211921.GA2395@suse.de>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 16, 2014 at 09:19:21PM +0000, Mel Gorman wrote:
> On Tue, Dec 16, 2014 at 12:46:57PM -0800, Linus Torvalds wrote:
> > On Tue, Dec 16, 2014 at 11:28 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> > >
> > > While going through this thread I wondered whatever became of this
> > > patch. It seems a shame to forget about it entirely. Maybe just queued
> > > for later while hunting wabbits?
> > 
> > Mel Gorman took it up, cleaned up some stuff, and I think it's in -mm
> > or on its way there. I'm assuming it's 3.20 material by now.
> > 
> 
> I didn't pick up this one. My pickup and cleaning was on the PROT_NONE
> material for automatic NUMA balancing.  It was posted way too close to
> the merge window for -mm. It's post 3.19-rc1 + post Christmas holiday
> material.

OK, should we just stick it in the x86 tree and see if anything
explodes? ;-)
