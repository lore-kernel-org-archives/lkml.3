Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751923Ab3GMGgS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jul 2013 02:36:18 -0400
Received: from 1wt.eu ([62.212.114.60]:34573 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751169Ab3GMGgR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jul 2013 02:36:17 -0400
Date: Sat, 13 Jul 2013 08:36:07 +0200
From: Willy Tarreau <w@1wt.eu>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>, Dave Jones <davej@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable <stable@vger.kernel.org>
Subject: Re: [ 00/19] 3.10.1-stable review
Message-ID: <20130713063607.GI32054@1wt.eu>
References: <20130711214830.611455274@linuxfoundation.org> <20130711222935.GA11340@redhat.com> <20130711224455.GA17222@kroah.com> <20130712141530.GA3629@roeck-us.net> <CA+55aFw7Ti3=51vVzNO5QEmPYP-znM95OqvZV9TX=mRcwaOCrA@mail.gmail.com> <20130712173150.GA5534@roeck-us.net> <CA+55aFwvCVw6xqGLEhUPMYPZ6XcxSTr4sunG3+kB0WPLY0Djgg@mail.gmail.com> <20130712195051.GB32054@1wt.eu> <20130713062223.GA15155@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130713062223.GA15155@kroah.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 12, 2013 at 11:22:23PM -0700, Greg Kroah-Hartman wrote:
> > So probably we should incite patch contributors to add a specific
> > tag such as "Fixes: 3.5 and later", so that non-important patches
> > do not need the Cc:stable anymore, but users who experience an issue
> > can easily spot them and ask for their inclusion.
> 
> Huh?  What's wrong with the existing way people mark stable patches to
> go back to much older kernel versions?  Is that not working well enough
> for you?
> 
> And if something "fixes" an issue, then I want it in stable, just like
> Linus wants that in his tree.

It's the difference between "this is a fix" and "please backport this
fix into stable". As we aid in this thread, cc:stable is a bit too much
automatic and sometimes not appropriate (not important enough fixes).
But when fixes not apparently suitable for stable are merged into
mainline, having the ability to spot them is useful, whether it is for
later inclusion or just for users who'd like to run a kernel with more
fixes than the critical ones accepted for stable.

> Don't add another tag that requires users to dig for fixes that we are
> just too lazy to be including for all users, that way is crazy.

I don't think so. If there is a gap between what is fixed and what is
acceptable for -stable, this just fills this gap. It means less automatic
submissions for -stable, only the important ones, and at the same time,
a simple way of more easily spotting if a known bug affects your kernel
when you're a -stable user and are experiencing an issue.

Willy

