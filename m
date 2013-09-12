Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756615Ab3ILVBm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 17:01:42 -0400
Received: from mail-ee0-f42.google.com ([74.125.83.42]:41812 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753768Ab3ILVBl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 17:01:41 -0400
Date: Thu, 12 Sep 2013 23:01:37 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] perf fixes
Message-ID: <20130912210137.GA7301@gmail.com>
References: <20130912133855.GA23780@gmail.com>
 <CA+55aFwgyjqRHxLaWGxxsg_v07FrxbVTeLdHTGp7MfeSRjrKsQ@mail.gmail.com>
 <CA+55aFyCeXXr=57em8CC_Uzfk5PvOw0RHyA309wuOP-oDL7VxA@mail.gmail.com>
 <CA+55aFxbjX6T2L2LRfdCVDznjtJTMJAz3QCVyMWXH0y6c=S2kQ@mail.gmail.com>
 <20130912203358.GE32644@gmail.com>
 <CA+55aFwwO3+-EndiLxO+2cmpYGvt_R7vbOBbFvELsmDcWDGdAQ@mail.gmail.com>
 <20130912204910.GB3262@gmail.com>
 <CA+55aFyJCJJmwgf0kKFqA-aP-Gq6Y-1RhTsf2NokRcixtbbk3A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFyJCJJmwgf0kKFqA-aP-Gq6Y-1RhTsf2NokRcixtbbk3A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Thu, Sep 12, 2013 at 1:49 PM, Ingo Molnar <mingo@kernel.org> wrote:
> >
> >
> > I think the window of breakage is relatively small (you managed to hit 
> > it), but should we add a quirk for this?
> 
> Was the breakage entirely inside the merge window? ie no released 
> kernels?

Absolutely! Starts at commit 0d99b7087324, stops at commit d008d5258e9c, 
all inside the merge window.

> If so, just ignore it.

Ok, great!

Thanks,

	Ingo
