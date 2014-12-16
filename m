Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751601AbaLPVT3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 16:19:29 -0500
Received: from cantor2.suse.de ([195.135.220.15]:34907 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750791AbaLPVT2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 16:19:28 -0500
Date: Tue, 16 Dec 2014 21:19:21 +0000
From: Mel Gorman <mgorman@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andy Lutomirski <luto@amacapital.net>,
        Steven Rostedt <rostedt@goodmis.org>, Tejun Heo <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Don Zickus <dzickus@redhat.com>, Dave Jones <davej@redhat.com>,
        the arch/x86 maintainers <x86@kernel.org>
Subject: Re: frequent lockups in 3.18rc4
Message-ID: <20141216211921.GA2395@suse.de>
References: <CA+55aFxn_T=UgBUwqkRJvALygrNORaB6ox3nowvHpV6yFBfDoA@mail.gmail.com>
 <CA+55aFyEnuByhPM3FEdi=Q0WGuJWiBgtkWNAbRLHDpmPRaqnQA@mail.gmail.com>
 <alpine.DEB.2.11.1411212049220.6439@nanos>
 <CA+55aFzvgxAMpP7kr9qrxyo82vSucQ5G+VByOgsgoyq6y5ExOA@mail.gmail.com>
 <alpine.DEB.2.11.1411212110320.6439@nanos>
 <CA+55aFyt6q7Ed-SS9GeN8jeUZu6yNM14EGyH_8rn8AF2Vv37hg@mail.gmail.com>
 <alpine.DEB.2.11.1411212207150.6439@nanos>
 <CA+55aFyzg=vJqRwh2CsK8WD-E5nRPjdiasMaTBx6qygQhDrGLA@mail.gmail.com>
 <20141216192803.GC3337@twins.programming.kicks-ass.net>
 <CA+55aFx9oTQHnamJ=QEGOKHe2obQEn2NfNa+hJ_Z-V1FyY7QaQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <CA+55aFx9oTQHnamJ=QEGOKHe2obQEn2NfNa+hJ_Z-V1FyY7QaQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 16, 2014 at 12:46:57PM -0800, Linus Torvalds wrote:
> On Tue, Dec 16, 2014 at 11:28 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> >
> > While going through this thread I wondered whatever became of this
> > patch. It seems a shame to forget about it entirely. Maybe just queued
> > for later while hunting wabbits?
> 
> Mel Gorman took it up, cleaned up some stuff, and I think it's in -mm
> or on its way there. I'm assuming it's 3.20 material by now.
> 

I didn't pick up this one. My pickup and cleaning was on the PROT_NONE
material for automatic NUMA balancing.  It was posted way too close to
the merge window for -mm. It's post 3.19-rc1 + post Christmas holiday
material.

-- 
Mel Gorman
SUSE Labs
