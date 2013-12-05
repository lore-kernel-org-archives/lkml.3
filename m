Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756310Ab3LEC0k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 21:26:40 -0500
Received: from mail-oa0-f48.google.com ([209.85.219.48]:42207 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751994Ab3LEC0i convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 21:26:38 -0500
Date: Wed, 04 Dec 2013 19:35:19 -0600
From: Rob Landley <rob@landley.net>
Subject: Re: [PATCH v2] Documentation: gpiolib: document new interface
To: Alexandre Courbot <gnurou@gmail.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <acourbot@nvidia.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <CAAVeFuLqRBrHShK-gvmRHyDJ5c3gdKJJwX1UKNNTLCCUbVczKg@mail.gmail.com>
	(from gnurou@gmail.com on Sun Nov 24 00:02:30 2013)
X-Mailer: Balsa 2.4.11
Message-Id: <1386207319.1974.312@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/24/2013 12:02:30 AM, Alexandre Courbot wrote:
> Hi Rob,
> 
> On Sun, Nov 24, 2013 at 8:31 AM, Rob Landley <rob@landley.net> wrote:
> >> > Linus, I hope this can be merged during the -rc cycle of 3.13,  
> since the
> >> > gpiod_ interface is going to be introduced there. It would not  
> make much
> >> > sense for it to come without its documentation.
> >>
> >> You're right of course. I'll read through it and apply fixes on top
> >> (or squash into your patch.)
> >>
> >> Formal stuff:
> >> Don't we need an 00-INDEX file?
> >> (Maybe Rob can tell whether this is desirable.)
> >
> >
> > A 00-INDEX file wouldn't hurt, but it can always be added later. No  
> reason
> > to hold up the series for that. (I was using them to generate html  
> indexes
> > for kernel.org/doc but after the breakin they eliminated all non-git
> > functionality so I haven't been able to update it since. They  
> replaced
> > kernel.org/doc/Documentation with a raw git checkout, and I expect  
> them to
> > replace kernel.org/doc/menuconfig with a raw git checkout any day  
> now.)
> >
> > That said, a 00-INDEX file would let you know where to start  
> reading to find
> > the file with the intro paragraph at the start of the old file, the  
> bit
> > explaining what GPIO is. Here the first file alphabetically is  
> "board.txt",
> > and I have no idea why it's named that, given how it starts. (I was  
> sort of
> > hoping that somebody who already knows the subsystem would comment  
> before I
> > do. I have no way of knowing if this documentation is _right_.)
> 
> I actually submitted a patch that introduces a 00-INDEX file
> yesterday. It's probably a few other gazillions mails under in your
> inbox. ;)

I'm a couple weeks behind on my email. I'll get to it eventually. (My  
time's spread between a few too many projects these days...)

Most documentation goes in through the trees of the people whose  
subsystems it documents. I mostly catch the stuff that falls through  
the cracks. I'm somewhere between a librarian shelving abandoned books  
and a janitor.

...
> > But I really don't have time to go through every paragraph like  
> that, and
> > was hoping the gpio guys would (or just sign off on it so I don't  
> have
> > to)...
> 
> I will make another pass and send an update (or a new version of the
> patch maybe, since we are still in -rc1 - whatever is more convenient
> to Linus). Hopefully early users of the new (oops) interface will send
> fixes to the documentation as well, if only to improve my approximate
> English.

It's not so much the english, it's that Documentation should be aimed  
at people who _don't_ already know this stuff. Since it tends to be  
written by people who _do_ already know the stuff (kinda hard to do the  
other way, although I've done it), this can be tricky to pull off. You  
have to maintain a "But what if this _wasn't_ a rhetorical question?"  
mindset and emulate a Virtual Newbie. (I suggest qemu for this.)

Still, thanks for taking a stab at it. Imperfect's better than  
obsolete...

Rob