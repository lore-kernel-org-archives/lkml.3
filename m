Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751239AbaLQJMO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 04:12:14 -0500
Received: from www.linutronix.de ([62.245.132.108]:53496 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790AbaLQJML (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 04:12:11 -0500
Date: Wed, 17 Dec 2014 10:11:58 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Fengguang Wu <fengguang.wu@intel.com>,
        Frederic Weisbecker <frederic@kernel.org>,
        "Pan, Jacob jun" <jacob.jun.pan@intel.com>,
        LKML <linux-kernel@vger.kernel.org>, LKP <lkp@01.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [nohz] 2a16fc93d2c: kernel lockup on idle injection
In-Reply-To: <20141217001219.GA19459@lerouge>
Message-ID: <alpine.DEB.2.11.1412171008260.17382@nanos>
References: <CAKohpokEw6f5+u8J_AoV76sOAQO=J8dGhX1eZb=QZOuE+Jhq_A@mail.gmail.com> <548E8D01.9050707@linux.vnet.ibm.com> <CAKohpo=C8Jv-+CtmDO+QJ-_=3dNwsk6_W0gtRRHmtSQ8_LgObQ@mail.gmail.com> <20141215234443.GA23297@lerouge> <CAKohpokOuOqvpNt4_y2tHPTM8nKLyEg=-gN4NDe1_mqpy=Vrow@mail.gmail.com>
 <548FFD20.1040102@linux.vnet.ibm.com> <alpine.DEB.2.11.1412161105470.17382@nanos> <20141216142029.GA27375@lerouge> <alpine.DEB.2.11.1412161533210.17382@nanos> <alpine.DEB.2.11.1412161802570.17382@nanos> <20141217001219.GA19459@lerouge>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Dec 2014, Frederic Weisbecker wrote:
> On Tue, Dec 16, 2014 at 10:21:27PM +0100, Thomas Gleixner wrote:
> > So instead of evaluating the whole nonsense a gazillion times in a row
> > and firing pointless self ipis why are you not looking at the obvious
> > solution of sane state change tracking?
> 
> Because I had to do it wrong first before somebody like you with a fresh mind
> comes, look at the whole picture and propose a rethink :-)

Point taken.
 
> >     I told all of you from the very beginning that remote accounting
> >     is a key mechanism for this, but you keep insisting on hacking
> >     around it.
> 
> I don't, and I think everybody has understood we are not going to accept
> hacks to solve the 1hz issue.

You wish.

> I'm pretty sure you know what this is about to maintain a project with a
> (variably) cruel lack of manpower ;-)

Oh yes! :(
 
> Moreover I'm not the kind of kernel developer who ignores reviews (whether pre or
> post merge).

I know that.
 
> So, no point in threatening a dependency to BROKEN or ripping out except perhaps to
> push me out to other projects with more thankful managers.

This was not directed to you, really.

This was directed at the folks who randomly "fix" that code by voodoo
bandaids instead of analyzing the root causes in the first
place. You're the least one to blame for that.

Thanks,

	tglx



