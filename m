Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760538Ab3EAKyJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 06:54:09 -0400
Received: from mail-ee0-f50.google.com ([74.125.83.50]:58011 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755667Ab3EAKyB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 06:54:01 -0400
Date: Wed, 1 May 2013 12:53:57 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] timer changes for v3.10
Message-ID: <20130501105357.GB19077@gmail.com>
References: <20130430074322.GA20110@gmail.com>
 <CA+55aFwaQMjKDV5aA=_2mNiF1msGZO2hX3gypCZTByzDZxX6DQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwaQMjKDV5aA=_2mNiF1msGZO2hX3gypCZTByzDZxX6DQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Tue, Apr 30, 2013 at 12:43 AM, Ingo Molnar <mingo@kernel.org> wrote:
> >
> > Please pull the latest timers-core-for-linus git tree from:
> >
> >    git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git timers-core-for-linus
> 
> Hmm.. The "Use generic idle loop" patches from the SMP/hotplug pull 
> conflicted with the "Use tick broadcast expired check" patches in this 
> one for both x86 and ARM.
> 
> Both sets of patches were done by Thomas, and I *really* want you guys 
> to take a look at my conflict resolution. I effectively moved the new 
> "don't go into deep idle if boradcast timer is pending" check from x86 
> and arm into the generic idle loop. So my merge resolution is 
> semantically quite different from either branch, but the alternative 
> seemed to be to remove the new check entirely.
> 
> I pushed my merge out, please take a look.

It looks good to me (in fact I missed that semantic conflict when I merged 
these two myself :-/ ) - but it would be nice if Thomas double checked it 
as well.

Thanks,

	Ingo
