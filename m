Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753227Ab3EUKLy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 06:11:54 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:40706 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752471Ab3EUKLw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 06:11:52 -0400
Date: Tue, 21 May 2013 05:11:47 -0500
From: Rob Landley <rob@landley.net>
Subject: Re: Would like to form a pool of Linux copyright holders for faster
 GPL enforcement against Anthrax Kernels
To: "luke.leighton" <luke.leighton@gmail.com>
Cc: Eric Appleman <erappleman@gmail.com>, legal@lists.gpl-violations.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <CAPweEDxgT+ZygfPZDd8YePe7RurTU7o_UtiBqjUvCMimChpTug@mail.gmail.com>
	(from luke.leighton@gmail.com on Sat May 18 13:27:21 2013)
X-Mailer: Balsa 2.4.11
Message-Id: <1369131107.2776.6@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/18/2013 01:27:21 PM, luke.leighton wrote:
> On Sat, May 18, 2013 at 8:24 AM, Eric Appleman <erappleman@gmail.com>  
> wrote:
> > Would anyone be interested in forming such a pool?
> 
>  count me in.
> 
> > Last I checked, I have 1 long-time poster of this list on board.  
> Would
> > anyone else like to join? Ideally I'd like to get the LKML (which I  
> have
> > CC'd) involved so that authors of critical Linux components be a  
> part of
> > this. I'm not sure if my defconfig commits to Android kernel  
> branches count
> > as contributions,
> 
>  even if you did not explicitly put "Copyright (C) {your name}" in
> them, you still retain copyright.  depending on the country you are in
> you cannot even get rid of the copyright even if you say "i forever
> renounce irrevocably and without restriction or limitation all
> copyright and place this into the public domain signed me" - you have
> to actively assign the copyright to someone else.
> 
> > so I'm not going to consider myself a Linux contributor
> > unless told otherwise.
> 
>  you wrote something that's copyrighted.  therefore you're a copyright
> holder [therefore automatically any copyright violator must request
> your permission to have their GPLv2 license rights reinstated].
> 
>  my linux kernel modifications are small, too - they sort of winged
> their way by a slow process of migration into tmpfs by way of selinux
> xattrs.  and there are likely some unattributed contributions that
> came from the xanadux.sf.net project originally (depending on whether
> they were picked up or not over time)
> 
>  but that makes no odds: i am still a copyright holder, ergo a
> contributor, ergo i'd like to be included in the pool please.
> 
> > This pool would be used in the following manner:
> >
> > * Formally requesting source for binaries (means to request source
> > * Formally requesting removal of critical copyrighted code that  
> Linux cannot
> > function without
> > * Informing interested parties with respect to refusals of the above
> 
>  it would also serve as a useful point of contact for criminal
> copyright violators wishing to have their license rights reinstated.
> 
>  also it would serve as a good starting point to be able to contact
> large numbers of people wishing to explicitly dual-license their code
> contributions to the linux kernel.
> 
>  actually, that's a good point.  please can it be specifically noted,
> from this moment onwards, that all contributions that i have made to
> the linux kernel are dual-licensed under both the GPLv2 and also the
> GPLv3+ license?

I have a git repository that goes back to 0.0.1. The word "leighton"  
(case insensitive) occurs in the full log exactly once, in a single  
2004 commit that wasn't even done by you but was apparently inspired by  
a patch you did.

> someone has to start somewhere on this.  it doesn't matter if it takes
> 20 years for all GPLv2-exlusive contributions to be made obselete,
> deleted or replaced: a start has to be made.

You're aware that copyleft in general is declining, right?

"The GPL" was synonymous with copyleft. It was a terminal node in a  
directed graph of license convertability, and the only thing  
programmers had to know is whether or not some other license was  
GPL-compatible. If it was: treat it as GPL. If it wasn't: ignore it.

But there's no "the GPL" anymore. Linux and Samba can't share code,  
even though they implement two ends of the same protocol. And making  
your project "GPLv2 or later" means you can't take code from _either_  
source. These days the GPL largely serves to _prevent_ code re-use, and  
people have responded to the percieved problems with "GPL-next"  
initiatives where they fragment copyleft further with Affero variants,  
by using creative commons on code, and so on. But copyleft only ever  
worked as one big universal license, and now it doesn't.

In the absence of a universal receiver, most developers have switched  
to universal donor licenses: MIT/BSD or even public domain. Yes,  
"most": the most common license on Github is "no license specified",  
and that's not just ignorance, that's napster-style civil disobedience  
from a generation of coders who lump copyright in with software patents  
and consider it all "too dumb to live". (You think GPL enforcement  
suits are viewed any differently than DMCA takedown notices on youtube,  
both coming from clueless old people?)

Now add in Android's official "no GPL in userspace" policy, which means  
that if you preinstall GPL (or LGPL) software in your install image,  
you can't use the Android trademark to describe your product. (Did I  
mention that smartphones are replacing the PC? Mainframe, minicomputer,  
microcomputer, smartphone:  
http://www.youtube.com/watch?v=SGmtP5Lg_t0#t=30s and that's why Android  
matters; it can get preinstalled on that class of hardware. Linux has  
been trying for 20 years and still has less than 2% marketshare on any  
device an end-user interacts directly with.)

I'm sorry, but Richard Stallman _screwed_up_. GPLv3 suceeded where  
Sun's CDDL failed: it split copyleft into incompatible warring factions  
which are collectively shrinking in market share because none of them  
are as useful a "The GPL" was.

I miss "the GPL". But it's gone. It seems to be being replaced by a  
gradual shift to public domain code on the part of younger coders.  
(Part of this may just be that proprietary software ran its course. The  
ability to sell binary-only software was invented by the Apple vs  
Franklin decision in 1983 extending copyright to binaries, and over the  
next 20 years the market proved that just leads to abandonware and  
monopoly exclusion. That's about when Microsoft peaked and started  
stagnating, a dozen years ago. Making a killing selling shrinkwrapped  
software isn't nearly as attractive as it used to be.*)

Advocating for GPLv2 to go away is sad, but understandable. Expecting  
GPLv2 to be replaced by GPLv3 is just delusional.

Rob

* Except for terminal nodes like games where there can't be any lock-in  
because users don't derive work product from the software. Users seem  
to have developed a resistance to "you can hold my thesis for ransom  
because I wrote it with your software and your gatekeeper program can  
revoke my access to my own work", presumably because so many tools have  
gone away over the years. Of course the lesson has to be learned all  
over again with web services, and some things like photoshop are  
grandfathered in. As always, reality is complicated...