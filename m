Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752823Ab3AWBrd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 20:47:33 -0500
Received: from mout.gmx.net ([212.227.15.19]:63078 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751965Ab3AWBrb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 20:47:31 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19KHBN3hDtKtLSmcnhBCSs0OX5BrZFao+NsWorp4q
	TJdp7Ek0T2gt8q
Message-ID: <1358905643.5752.8.camel@marge.simpson.net>
Subject: Re: [PATCH v3 09/22] sched: compute runnable load avg in cpu_load
 and cpu_avg_load_per_task
From: Mike Galbraith <efault@gmx.de>
To: Alex Shi <alex.shi@intel.com>
Cc: Paul Turner <pjt@google.com>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>, namhyung@kernel.org,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        preeti@linux.vnet.ibm.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Wed, 23 Jan 2013 02:47:23 +0100
In-Reply-To: <50FF3090.1090608@intel.com>
References: <1357375071-11793-1-git-send-email-alex.shi@intel.com>
	 <1357375071-11793-10-git-send-email-alex.shi@intel.com>
	 <50E7EAB1.6020302@intel.com> <50E92DC3.4050906@intel.com>
	 <CA+55aFxbS-u1Zfwg2oKOmHq6FBF+dRRhrdssqc9PpC_gXoV3+g@mail.gmail.com>
	 <50EFB1DB.7090804@intel.com> <50FD54EA.4060804@intel.com>
	 <50FE0575.6090005@intel.com> <1358837740.5782.209.camel@marge.simpson.net>
	 <50FE44B5.6020004@intel.com> <1358848338.5782.331.camel@marge.simpson.net>
	 <50FF3090.1090608@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-01-23 at 08:36 +0800, Alex Shi wrote: 
> On 01/22/2013 05:52 PM, Mike Galbraith wrote:
> > On Tue, 2013-01-22 at 15:50 +0800, Alex Shi wrote:
> > 
> >> Thanks for your suggestions and example, Mike!
> >> I just can't understand the your last words here, Sorry. what the
> >> detailed concern of you on 'both performance profiles with either
> >> metric'? Could you like to give your preferred solutions?
> > 
> > Hm.. I'll try rephrasing.  Any power saving gain will of necessity be
> > paid for in latency currency.  I don't have a solution other than make a
> > button, let the user decide whether history influences fast path task
> > placement or not.  Any other decision maker will get it wrong.
> 
> Um, if no other objection, I'd like to move the runnable load only used
> for power friendly policy -- for this patchset, they are 'powersaving'
> and 'balance', Can I?

Yeah, that should work be fine.

-Mike

