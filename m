Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752423Ab3GNDuc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jul 2013 23:50:32 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35149 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752260Ab3GNDub (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jul 2013 23:50:31 -0400
Date: Sat, 13 Jul 2013 20:51:28 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "Theodore Ts'o" <tytso@mit.edu>, Willy Tarreau <w@1wt.eu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>, Dave Jones <davej@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable <stable@vger.kernel.org>
Subject: Re: [ 00/19] 3.10.1-stable review
Message-ID: <20130714035128.GA10697@kroah.com>
References: <CA+55aFw7Ti3=51vVzNO5QEmPYP-znM95OqvZV9TX=mRcwaOCrA@mail.gmail.com>
 <20130712173150.GA5534@roeck-us.net>
 <CA+55aFwvCVw6xqGLEhUPMYPZ6XcxSTr4sunG3+kB0WPLY0Djgg@mail.gmail.com>
 <20130712195051.GB32054@1wt.eu>
 <20130713062223.GA15155@kroah.com>
 <20130713063607.GI32054@1wt.eu>
 <20130713064801.GA1305@kroah.com>
 <20130713114211.GA3112@thunk.org>
 <20130713182717.GA16637@kroah.com>
 <20130714022219.GC3112@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130714022219.GC3112@thunk.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 13, 2013 at 10:22:19PM -0400, Theodore Ts'o wrote:
> On Sat, Jul 13, 2013 at 11:27:17AM -0700, Greg Kroah-Hartman wrote:
> > Ugh, the conversation has degenerated now into parsing the meaning of
> > specific words.  This is why lawyers have created whole vocabularies
> > that are not used by "normal" people.  There's a very good reason why
> > I'm not a lawyer, and this is one of them...
> > 
> > If I change the word "critical" to "real", would that make everyone
> > happy here?
> > 
> > It comes down to the simple fact that for stable kernels I _want_ to
> > take bugfixes that any user would hit.  In other words, something that a
> > distro kernel would take.
> 
> Yes, but ***Linus*** has said he only wants critical fixes in his tree
> after -rc4.  It seems pretty clear that what he wants post -rc4 and
> what you want in the stable tree are different.
> 
> You can change the stable_kernel_tree to be "real" bugs, but if Linus
> is still using "critical" as the standard for mainline post-rc4, then
> those of us who are maintainers are stuck between a rock and a hard
> place.

You are confusing the words "real" and "critical" perhaps.  I, and other
large subsystem maintainers, based on how they submit fixes to Linus and
to stable, view the late -rc portion as time for fixes that affect users
and other issues like that.  So far, it's worked out pretty well and we
don't seem to be in disagreement with Linus's view of what is a valid
late -rc fix based on recent kernel development cycles.

The issue now is, we have maintainers who aren't sending stuff to Linus
at all in the late -rc cycle and are relying on me to pick up things
that are obviously "real" and "critical" fixes after .0 is out for .1
and .2 to resolve "real" issues.

You are not one of these people, so I don't understand why you are
getting upset and think that you somehow need to change how you mark
stuff for stable.

The powerpc and iscsi people on the other hand, they need to look out...

chill out please and go enjoy the rest of the weekend,

greg k-h
