Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752418Ab3GMGnQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jul 2013 02:43:16 -0400
Received: from mail-pb0-f54.google.com ([209.85.160.54]:46593 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751208Ab3GMGnO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jul 2013 02:43:14 -0400
Date: Fri, 12 Jul 2013 23:43:17 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Willy Tarreau <w@1wt.eu>, Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable <stable@vger.kernel.org>
Subject: Re: [ 00/19] 3.10.1-stable review
Message-ID: <20130713064317.GA11614@roeck-us.net>
References: <20130711214830.611455274@linuxfoundation.org>
 <20130711222935.GA11340@redhat.com>
 <20130711224455.GA17222@kroah.com>
 <20130712141530.GA3629@roeck-us.net>
 <CA+55aFw7Ti3=51vVzNO5QEmPYP-znM95OqvZV9TX=mRcwaOCrA@mail.gmail.com>
 <20130712173150.GA5534@roeck-us.net>
 <CA+55aFwvCVw6xqGLEhUPMYPZ6XcxSTr4sunG3+kB0WPLY0Djgg@mail.gmail.com>
 <20130712195051.GB32054@1wt.eu>
 <20130713062223.GA15155@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130713062223.GA15155@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 12, 2013 at 11:22:23PM -0700, Greg Kroah-Hartman wrote:
> On Fri, Jul 12, 2013 at 09:50:51PM +0200, Willy Tarreau wrote:
> > On Fri, Jul 12, 2013 at 10:50:08AM -0700, Linus Torvalds wrote:
> > > So I'm not going to argue that your particular patches were the
> > > problem here. I'm more arguing against your arguments than against the
> > > patches themselves. I'm not looking for some hard black-and-white
> > > rules that say "this is exactly how things have to work", because I
> > > don't think such rules can exist. But I _do_ want people to see the
> > > stable rules as fairly strict.
> > 
> > I think that maintainers are balanced between the wish to satisfy their
> > users and the risk of getting shouted at. Users expect stable versions
> > to be bug-free. Most people I talk with have a different understanding
> > of the development model than the one you present to contributors. They
> > think that the .0 release is a draft and that all bugs will be fixed in
> > -stable. I even know one person who uses -rc1 in production, claiming
> > that these ones are stable. So end users don't necessarily understand
> > the development model and ask what something they think is due : no
> > known bugs.
> > 
> > On the other hand, we've seen many regressions introduced as fixes
> > into -stable that had to be reverted afterwards, or sometimes
> > completed with a missing patch.
> > 
> > I think that maintainers use the Cc:stable as a status for commits
> > meaning "this is a bug fix". It's true that when you're digging into
> > the commits to try to qualify fixes from features, it's really hard,
> > and the new Cc:stable tag helps a lot.
> > 
> > So probably we should incite patch contributors to add a specific
> > tag such as "Fixes: 3.5 and later", so that non-important patches
> > do not need the Cc:stable anymore, but users who experience an issue
> > can easily spot them and ask for their inclusion.
> 
> Huh?  What's wrong with the existing way people mark stable patches to
> go back to much older kernel versions?  Is that not working well enough
> for you?
> 
It appears it may not be good enough for some, otherwise we would not have
this discussion.

> And if something "fixes" an issue, then I want it in stable, just like
> Linus wants that in his tree.
> 
Except if it is not critical, for a given definition of the word.

> Don't add another tag that requires users to dig for fixes that we are
> just too lazy to be including for all users, that way is crazy.
> 
Depends. If -stable rules are going to be followed by the letter, as has
been suggested, only critical bug fixes would be applied to -stable.
The idea here is to provide guidance to distribution maintainers
if that is happening. This tag would mean something like "This patch
fixes a real bug which affects the following releases, but it will not
be applied to -stable because it is not critical".

Guenter
