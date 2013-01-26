Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753662Ab3AZMRG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2013 07:17:06 -0500
Received: from mail-ee0-f47.google.com ([74.125.83.47]:53009 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753475Ab3AZMRE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2013 07:17:04 -0500
Date: Sat, 26 Jan 2013 13:16:59 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Clark Williams <williams@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH v2] sched: add a tuning knob to allow changing RR tmeslice
Message-ID: <20130126121659.GH13445@gmail.com>
References: <20121108195113.2dd51d43@redhat.com>
 <20130124165955.GA9324@gmail.com>
 <20130124135427.1748d057@redhat.com>
 <20130125081916.GC25314@gmail.com>
 <20130125120256.52733b51@redhat.com>
 <20130125183610.GA31022@gmail.com>
 <20130125154353.0d47d334@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130125154353.0d47d334@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Clark Williams <williams@redhat.com> wrote:

> On Fri, 25 Jan 2013 19:36:10 +0100
> Ingo Molnar <mingo@kernel.org> wrote:
> 
> > 
> > * Clark Williams <williams@redhat.com> wrote:
> > 
> > > > Shouldn't this be in kernel/sched/sched.h instead of the 
> > > > (already too large) linux/sched.h?
> > > 
> > > I don't think that will work be cause kernel/sysctl.c needs 
> > > the externs and I doubt we want to include 
> > > kernel/sched/sched.h from there.
> > 
> > Then at least introduce a new include/linux/sched_sysctl.h file 
> > please, and include it in sysctl.c and move this new knob there?
> > 
> > Other scheduler related sysctl knobs can move there too later 
> > on, reducing the burden on sched.h.
> > 
> > Thanks,
> > 
> > 	Ingo
> 
> 
> Like this?

I only suggested to create it for this new sysctl, but you doing 
the whole work for all scheduler sysctls is a perfect solution 
of course :-)

Thanks,

	Ingo
