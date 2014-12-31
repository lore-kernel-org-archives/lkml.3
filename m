Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751622AbaLaNQL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2014 08:16:11 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:52185 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751237AbaLaNQI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2014 08:16:08 -0500
Date: Wed, 31 Dec 2014 05:16:02 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: question about the luto-misc tree
Message-ID: <20141231131602.GP11609@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20141214175747.2e6c506e@canb.auug.org.au>
 <CALCETrXu19aHhudTfPAr5PM05FR0xKBiSHgbubVhh6QUrHCADw@mail.gmail.com>
 <20141214120318.GA5310@linux.vnet.ibm.com>
 <CALCETrWsy5sxVTmjNu7t+o-QvEVY-csQHkP-PXT1aMFiXnzzhQ@mail.gmail.com>
 <20141214173715.GB5310@linux.vnet.ibm.com>
 <CALCETrWT7SLO3E+nV2g=QzJHAeWU4FBRENq=7OvoNDrHA7W0fg@mail.gmail.com>
 <20141214181744.GF5310@linux.vnet.ibm.com>
 <CALCETrXfc5SpjOUfRuj7d5Kzushjucw-njcGT+XW6L26c3BFyA@mail.gmail.com>
 <20141226123336.30fba599@canb.auug.org.au>
 <CALCETrWaT019BZoyhp-CkcCiEXYEumvjF2pA6GHk0Mo-sPngTQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrWaT019BZoyhp-CkcCiEXYEumvjF2pA6GHk0Mo-sPngTQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14123113-0029-0000-0000-000006DA6786
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 28, 2014 at 07:33:43AM -0800, Andy Lutomirski wrote:
> On Dec 25, 2014 5:33 PM, "Stephen Rothwell" <sfr@canb.auug.org.au> wrote:
> >
> > Hi Andy,
> >
> > On Mon, 22 Dec 2014 11:16:56 -0800 Andy Lutomirski <luto@amacapital.net>
> wrote:
> > >
> > > I'm re-adding the branch, since 3.19-rc1 is out, the change appears to
> > > still exist as-is in your tree, and it merges cleanly and builds in
> > > the latest -next for me.  Let me know if this will be problematic for
> > > any reason.
> >
> > So, now we have a problem because Paul has rebased a whole set of
> > commits that you have in your tree.  Commits c6dc129cf2d1 to
> > f58d100f65ae in your tree Paul has rebased on top of v3.19-rc1.  If you
> > are going to base your tree on (part of) Paul's tree, then Paul has to
> > agree to not rebase that part of his tree or you have to keep a watch
> > on his tree and rebase you tree on top of those rebased commits.
> > Really, the first should happen.
> 
> Are there any scripts out there that can do this for me?
> 
> Paul, when do you expect to be done rebasing?  Or, even better, when do you
> expect to send all of this to -tip?  If the latter will be reasonably soon,
> I can just wait for that.

I believe that I have it where it will live from here on out, namely
at 734d16801349 (rcu: Make rcu_nmi_enter() handle nesting) in -rcu.
The only reason I would move it is if it turned out to be fatally buggy,
but given your testing the odds of this happening are hopefully quite low.
(Famous last words!)

							Thaxnx, Paul

