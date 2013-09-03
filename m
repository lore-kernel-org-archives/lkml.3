Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760839Ab3ICVjo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 17:39:44 -0400
Received: from mail.linux-iscsi.org ([67.23.28.174]:34640 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759917Ab3ICVjm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 17:39:42 -0400
Message-ID: <1378244811.32763.420.camel@haakon3.risingtidesystems.com>
Subject: Re: Linux 3.11
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Tue, 03 Sep 2013 14:46:51 -0700
In-Reply-To: <1378169449.32763.347.camel@haakon3.risingtidesystems.com>
References: <CA+55aFyqCJakY1+RwKXTPiGJsUcXM1W2B5gyryuq65_RKkGs0w@mail.gmail.com>
	 <1378161032.32763.341.camel@haakon3.risingtidesystems.com>
	 <CA+55aFwKowLGVGKrYh=ejPi1nj4ZqG+9F-kyOxHX0C+r=5=LWA@mail.gmail.com>
	 <1378169449.32763.347.camel@haakon3.risingtidesystems.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi again Linus,

On Mon, 2013-09-02 at 17:50 -0700, Nicholas A. Bellinger wrote:
> On Mon, 2013-09-02 at 15:50 -0700, Linus Torvalds wrote:
> > On Mon, Sep 2, 2013 at 3:30 PM, Nicholas A. Bellinger
> > <nab@linux-iscsi.org> wrote:
> > >
> > > Unfortunately, this doesn't include the remaining target fixes for
> > > v3.11:
> > >
> > > Re: [GIT PULL -v2] target fixes for v3.11
> > > http://marc.info/?l=linux-kernel&m=137799048226191&w=2
> > >
> > > Is there a reason why these did not get PULLed..?
> > 
> > Very simple: I have no such email in my mailbox. I see the "target
> > updates for v3.11-rc1" email (and I pulled that), and there is nothing
> > since.
> > 
> > I don't even have that mail in my lkml archives, much less as a private email.
> > 
> > I see neither youe "-v2 PULL request" nor the "One more late v3.11
> > specific regression" one. In fact, I see no emails from you at all
> > from Aug 31.
> > 
> > It may be that gmail hates you for some reason...
> > 
> > [ time passes ]
> > 
> > Yup. It's in my spam-box, with gmail helpfully telling me:
> > 
> >    Why is this message in Spam? We've found that lots of messages from
> > linux-iscsi.org are spam.  Learn more
> > 
> > so something is rotten in the state of linux-iscsi.org.
> > 
> > Recent messages from you were similarly tagged:
> > 
> >  "[GIT PULL -v2] target fixes for 3.11"
> >  "Re: LIO FC Target"
> >  "Re: [GIT PULL] target fixes for v3.11-rc7"
> > 
> > there might have been more. You might want to try to figure out why
> > gmail thinks that linux-iscsi.org is spammy.
> 
> Mmmm, that is what I was afraid of, looking into that now..
> 
> So if you would, please go ahead and pull target-pending/master ASAP for
> the fixes, and I'll send the parts that need to goto Greg-KH separately.
> 

Ok, so another PULL request was sent out last night for the missing
target fixes below, after putting DKIM + SPF authentication in place for
linux-iscsi.org:

[GIT PULL -v3] target fixes for v3.12-rc0 (was v3.11)
http://marc.info/?l=linux-kernel&m=137818849925625&w=2

Watching the recent git activity, I can't tell if you've (not) reached
this point in the PULL queue yet, or if this email also landed in your
spam folder..?

Care to give me a hint if your receiving these PULL emails now, or if I
need to continue looking at why gmail is unhappy..?

Thank you,

--nab 

