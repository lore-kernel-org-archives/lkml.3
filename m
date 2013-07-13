Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756303Ab3GMG6x (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jul 2013 02:58:53 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:60239 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751473Ab3GMG6v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jul 2013 02:58:51 -0400
Date: Fri, 12 Jul 2013 23:58:49 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Willy Tarreau <w@1wt.eu>, Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable <stable@vger.kernel.org>
Subject: Re: [ 00/19] 3.10.1-stable review
Message-ID: <20130713065849.GA1910@kroah.com>
References: <20130711214830.611455274@linuxfoundation.org>
 <20130711222935.GA11340@redhat.com>
 <20130711224455.GA17222@kroah.com>
 <20130712141530.GA3629@roeck-us.net>
 <CA+55aFw7Ti3=51vVzNO5QEmPYP-znM95OqvZV9TX=mRcwaOCrA@mail.gmail.com>
 <20130712173150.GA5534@roeck-us.net>
 <CA+55aFwvCVw6xqGLEhUPMYPZ6XcxSTr4sunG3+kB0WPLY0Djgg@mail.gmail.com>
 <20130712195051.GB32054@1wt.eu>
 <20130713062223.GA15155@kroah.com>
 <20130713064317.GA11614@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130713064317.GA11614@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 12, 2013 at 11:43:17PM -0700, Guenter Roeck wrote:
> > And if something "fixes" an issue, then I want it in stable, just like
> > Linus wants that in his tree.
> > 
> Except if it is not critical, for a given definition of the word.

I'm not going to try to parse definitions here, but this is just crazy.

> > Don't add another tag that requires users to dig for fixes that we are
> > just too lazy to be including for all users, that way is crazy.
> > 
> Depends. If -stable rules are going to be followed by the letter, as has
> been suggested, only critical bug fixes would be applied to -stable.
> The idea here is to provide guidance to distribution maintainers
> if that is happening. This tag would mean something like "This patch
> fixes a real bug which affects the following releases, but it will not
> be applied to -stable because it is not critical".

What?  It's a fix for a problem that is "real", why would that _not_ go
into stable and Linus's tree?

Anyway, again, that's not the real issue here at all, the real issues
are, again:
  - people marking stuff for -stable that they shouldn't.
  - people sitting on stuff for -stable way longer than they should be,
    relying on me to get stuff merged for the .1 or .2 release instead
    of getting it to Linus for .0.

let's work on those two first before we start worrying about if a
specific "fix" shouldn't go into the stable tree or not.

greg k-h
