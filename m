Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756978AbaGVVDr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 17:03:47 -0400
Received: from www.linutronix.de ([62.245.132.108]:40588 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751482AbaGVVDp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 17:03:45 -0400
Date: Tue, 22 Jul 2014 23:03:25 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Waiman Long <waiman.long@hp.com>
cc: Darren Hart <dvhart@linux.intel.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Peter Zijlstra <peterz@infradead.org>,
        Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@kernel.org>,
        Davidlohr Bueso <davidlohr@hp.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux API <linux-api@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Jason Low <jason.low2@hp.com>, Scott J Norton <scott.norton@hp.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [RFC PATCH 0/5] futex: introduce an optimistic spinning futex
In-Reply-To: <53CEC7B3.5030109@hp.com>
Message-ID: <alpine.DEB.2.10.1407222252460.23352@nanos>
References: <1405956271-34339-1-git-send-email-Waiman.Long@hp.com> <8761iq3bp3.fsf@tassilo.jf.intel.com> <871tte3bjw.fsf@tassilo.jf.intel.com> <CFF29A00.9D44A%dvhart@linux.intel.com> <CFF29E4A.9D44E%dvhart@linux.intel.com> <alpine.DEB.2.10.1407212025130.20847@nanos>
 <20140721212740.GS3935@laptop> <CALCETrXSaWM6-nxr4ggtMh5qcfTQg4wRvkW8FTSbri5+_1ZbVg@mail.gmail.com> <alpine.DEB.2.10.1407212344130.20847@nanos> <CFF2E3D6.9D525%dvhart@linux.intel.com> <alpine.DEB.2.10.1407220047490.20847@nanos> <53CEC7B3.5030109@hp.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Jul 2014, Waiman Long wrote:
> On 07/21/2014 09:01 PM, Thomas Gleixner wrote:
> > So before anyone comes up with a "solution" for all of this tomorrow
> > afternoon in form of another half baken patch, please sit back mull it
> > in your head and lets have a proper discussion about the approach
> > first.
> > 
> > Thanks,
> > 
> > 	tglx
> 
> Thank for your thorough analysis and suggestions on what to do to support
> spinning futexes. You certainly know more about the internal working of futex
> than most of us. I can  live with what you have suggested. My patch is just a
> proof of concept piece to demonstrate optimistic spinning on futex is
> something worthwhile to do. I think I have achieved my goal of stirring

We knew that already as Darren has proven that optimistic spinning in
a simpler form provides a huge benefit. So you do not have achieved
anything except annoying people with your sloppiness.

> interest in this area. My next step will be to look into the direction of what
> you have suggested and figure out what actual code changes will be needed.

You really can do what you want with your time. You can either reread
AND understand the paragraph, which I left as a quote from my previous
mail, AND act acoordingly or just stay away from futex.c.

Thanks,

	tglx
