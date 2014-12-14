Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751729AbaLNRhY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 12:37:24 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:38949 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751104AbaLNRhW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 12:37:22 -0500
Date: Sun, 14 Dec 2014 09:37:15 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: question about the luto-misc tree
Message-ID: <20141214173715.GB5310@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20141214175747.2e6c506e@canb.auug.org.au>
 <CALCETrXu19aHhudTfPAr5PM05FR0xKBiSHgbubVhh6QUrHCADw@mail.gmail.com>
 <20141214120318.GA5310@linux.vnet.ibm.com>
 <CALCETrWsy5sxVTmjNu7t+o-QvEVY-csQHkP-PXT1aMFiXnzzhQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrWsy5sxVTmjNu7t+o-QvEVY-csQHkP-PXT1aMFiXnzzhQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14121417-0013-0000-0000-0000070F4BAC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 14, 2014 at 08:29:33AM -0800, Andy Lutomirski wrote:
> On Sun, Dec 14, 2014 at 4:03 AM, Paul E. McKenney
> <paulmck@linux.vnet.ibm.com> wrote:
> > On Sat, Dec 13, 2014 at 11:26:36PM -0800, Andy Lutomirski wrote:
> >> On Dec 13, 2014 10:58 PM, "Stephen Rothwell" <sfr@canb.auug.org.au> wrote:
> >> >
> >> > Hi Andy,
> >> >
> >> > The luto-misc tree seems to have a whole series of commits in it that
> >> > have just bee removed from the rcu tree ...  You really have to be very
> >> > careful if you base your work on a tree that is regularly rebased.
> >>
> >> Hmm.  They were there a couple days ago.  Paul, what should I do about
> >> this?  I only need the one NMI nesting change for the stuff in
> >> luto/next.
> >>
> >> > I also wonder if the other commits in that tree are destined for
> >> > v3.19?  If they are for v3.20, then they should not be in linux-next
> >> > until after v3.19-rc1 has been released.
> >>
> >> They're for 3.20.  I'll drop the whole series from the next branch for now.
> >
> > You mean the NMI nesting change below, correct?  One approach would be
> > to include the branch rcu/dev from my -rcu tree.  Would that work for you?
> 
> That would work.
> 
> The problem is that, if you rebase again and I don't notice, then
> it'll generate a pile of conflicts.  Is there someway that I can flag
> my next tree as depending on a certain commi existing in another tree
> so that the scripts that generate linux-next will ignore it if the
> base commit goes away?

The commits would still stick around because I keep date-encoded branches.
But just to make things easier, I created a andy.2014.11.21a branch that
points to the current commit and will stay there.  Please let me know how
it goes.

							Thanx, Paul

