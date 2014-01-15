Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752056AbaAOU56 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 15:57:58 -0500
Received: from b.ns.miles-group.at ([95.130.255.144]:1661 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751883AbaAOU5z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 15:57:55 -0500
From: Richard Weinberger <richard@nod.at>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Randy Dunlap <rdunlap@infradead.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: linux-next: Tree for Jan 15 (um, rcu)
Date: Wed, 15 Jan 2014 21:57:49 +0100
Message-ID: <1481134.LAgAS757c0@sandpuppy>
User-Agent: KMail/4.11.2 (Linux/3.12.0-34.ge8fa6b4-desktop; KDE/4.11.2; x86_64; ; )
In-Reply-To: <20140116075025.7b7ec09805b5f90c75a36dd2@canb.auug.org.au>
References: <20140115185545.497c14923814b6ecaa540d9f@canb.auug.org.au> <2114717.uibXxy8kL0@sandpuppy> <20140116075025.7b7ec09805b5f90c75a36dd2@canb.auug.org.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

Am Donnerstag, 16. Januar 2014, 07:50:25 schrieb Stephen Rothwell:
> Hi Richard,
> 
> On Wed, 15 Jan 2014 20:39:03 +0100 Richard Weinberger <richard@nod.at> 
wrote:
> > Stephen, can you please add my UML tree to -next?
> > It contains already the fix.
> > git://git.kernel.org/pub/scm/linux/kernel/git/rw/uml.git next
> 
> Sure, added from today.  As long as it only contains stuff for v3.14 ...

Yep, only stuff for 3.14.

> > Please note there is a trivial merge conflict in
> > arch/um/include/asm/Kbuild.
> Yeah, what Geert said.  If you can fix this, then fine, but a single
> conflict is not so bad.

I can update my tree if it saves you time. No problem...

> Thanks for adding your subsystem tree as a participant of linux-next.  As
> you may know, this is not a judgment of your code.  The purpose of
> linux-next is for integration testing and to lower the impact of
> conflicts between subsystems in the next merge window.
> 
> You will need to ensure that the patches/commits in your tree/series have
> been:
>      * submitted under GPL v2 (or later) and include the Contributor's
> 	Signed-off-by,
>      * posted to the relevant mailing list,
>      * reviewed by you (or another maintainer of your subsystem tree),
>      * successfully unit tested, and
>      * destined for the current or next Linux merge window.
> 
> Basically, this should be just what you would send to Linus (or ask him
> to fetch).  It is allowed to be rebased if you deem it necessary.

Thanks,
//richard
