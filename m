Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756181Ab3IIX3C (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 19:29:02 -0400
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:59485 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755612Ab3IIX27 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 19:28:59 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhkRAJ5YLlJ5Lapl/2dsb2JhbABbgwc4gxKrJgOOfoU3gSQXdIIlAQEEATocGgkFCwgDEgYJJQ8FJQMNFBMaAYdhBcNKFo4igTMHhB0Dl3SRZ4MyKoEt
Date: Tue, 10 Sep 2013 09:28:54 +1000
From: Dave Chinner <david@fromorbit.com>
To: Marco Stornelli <marco.stornelli@gmail.com>
Cc: Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Vladimir Davydov <vdavydov@parallels.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 00/19] pramfs
Message-ID: <20130909232854.GW12779@dastard>
References: <522AE04C.6000002@gmail.com>
 <20130908234031.GS12779@dastard>
 <522E0FDF.8000108@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <522E0FDF.8000108@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 09, 2013 at 08:13:51PM +0200, Marco Stornelli wrote:
> Il 09/09/2013 01:40, Dave Chinner ha scritto:
> >On Sat, Sep 07, 2013 at 10:14:04AM +0200, Marco Stornelli wrote:
> >>Hi all,
> >>
> >>this is an attempt to include pramfs in mainline. At the moment pramfs
> >>has been included in LTSI kernel. Since last review the code is more
> >>or less the same but, with a really big thanks to Vladimir Davydov and
> >>Parallels, the development of fsck has been started and we have now
> >>the possibility to correct fs errors due to corruption. It's a "young"
> >>tool but we are working on it. You can clone the code from our repos:
> >>
> >>git clone git://git.code.sf.net/p/pramfs/code pramfs-code
> >>git clone git://git.code.sf.net/p/pramfs/Tools pramfs-Tools
> >
> >The 1980s are calling, and they want their filesytem back. :)
> >
> >So, Devil's Advocate time. Convince me as to why pramfs should be
> >merged.
> >
> 
> Never used in my embedded project with more of few mb, and maybe you
> are asking for cases not targeted. Pramfs is in LTSI not why I asked
> Greg to include it, but because there are several companies asked me
> to do. The message wasn't "hey, pramfs is in LTSI, so we must
> include it in mainline" but it was only a consideration and
> indication that there is need of something like that out there. Sure
> we can talk about if it's the best option or not, however this is
> the real world.

Then lets talk about whether it's the best solution or not. You've
said "too hard, I'm going home" the moment someone has asked hard
questions and pointed out problems. You haven't even attempted to
discuss the issues or explain why things were done in the way they
have been done.  Instead, you've just cut all the context out
completely and handwaved about time to market issues and upstream
being unfriendly.

News Flash: I'm not here to be your friend.

I'm here to make sure code that is merged is robust and solid and
solves the problems we know need to be solved. I know that we need a
solution to persistent memory storage, but pramfs has many
deficiencies and doesn't address the requirements that vendors of
emerging technologies have communicated to us in various public
forums.

You may not know about these requirements - that's part of the
iterative peer review process - you learn about other people's
requirements for the technology and try to address them or explain
why you're not going to handle those cases...

> It's not possible to have a 10 years review. It's a never
> ending story.

Filesystems architectures last much longer than 10 years. Suitablity
of the current filesystem architecture for known medium- and
long-term needs is definitely part of any code review. There's lots
of people on -fsdevel that have the knowledge and experience to be
able to do this sort of review....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
