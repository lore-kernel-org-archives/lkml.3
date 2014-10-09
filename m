Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751278AbaJIGXk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 02:23:40 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:37515 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750752AbaJIGXc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 02:23:32 -0400
Date: Thu, 9 Oct 2014 08:23:27 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [GIT pull] timer changes for 3.18
Message-ID: <20141009062327.GA19598@gmail.com>
References: <alpine.DEB.2.11.1410082001460.4292@nanos>
 <CA+55aFwF+YjvoFbwemtkkD76_=b5dQdE7HC0ELXKhogbWZCusQ@mail.gmail.com>
 <20141008223623.GB21582@lerouge>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141008223623.GB21582@lerouge>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> On Wed, Oct 08, 2014 at 05:54:49PM -0400, Linus Torvalds wrote:
> > On Wed, Oct 8, 2014 at 2:12 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> > >
> > > please pull the latest timers-core-for-linus git tree from:
> > >
> > >    git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git timers-core-for-linus
> > >
> > > Nothing really exciting this time:
> > >
> > >  - A few fixlets in the NOHZ code
> > 
> > .. but apparently *still* not the fixes from Frederic for the 
> > issue that people are complaining about killing their 
> > machines in 3.17.
> > 
> > WTF? What happened to those?
> 
> Thomas just pulled these in -tip today. I'm pretty sure he 
> plans to make a 2nd timers pile after this one during the merge 
> window. We just found a non-trivial conflict in my branch 
> against the RCU tree so this probably needs a bit of last 
> minute adjustment and testing.

Thomas won't be around until next week, I'll send these fixes 
later today.

Thanks,

	Ingo
