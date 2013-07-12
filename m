Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965069Ab3GLOPa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 10:15:30 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:57359 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964861Ab3GLOP3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 10:15:29 -0400
Date: Fri, 12 Jul 2013 07:15:30 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Dave Jones <davej@redhat.com>, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org
Subject: Re: [ 00/19] 3.10.1-stable review
Message-ID: <20130712141530.GA3629@roeck-us.net>
References: <20130711214830.611455274@linuxfoundation.org>
 <20130711222935.GA11340@redhat.com>
 <20130711224455.GA17222@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130711224455.GA17222@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 11, 2013 at 03:44:55PM -0700, Greg Kroah-Hartman wrote:
> On Thu, Jul 11, 2013 at 06:29:35PM -0400, Dave Jones wrote:
> > On Thu, Jul 11, 2013 at 03:01:17PM -0700, Greg Kroah-Hartman wrote:
> >  > <rant>
> >  >   I'm sitting on top of over 170 more patches that have been marked for
> >  >   the stable releases right now that are not included in this set of
> >  >   releases.  The fact that there are this many patches for stable stuff
> >  >   that are waiting to be merged through the main -rc1 merge window cycle
> >  >   is worrying to me.
> >  > 
> >  >   Why are subsystem maintainers holding on to fixes that are
> >  >   _supposedly_ affecting all users?  I mean, 21 powerpc core changes
> >  >   that I don't see until a -rc1 merge?  It's as if developers don't
> >  >   expect people to use a .0 release and are relying on me to get the
> >  >   fixes they have burried in their trees out to users.  That's not that
> >  >   nice.  6 "core" iscsi-target fixes?  That's the sign of either a
> >  >   broken subsystem maintainer, or a lack of understanding what the
> >  >   normal -rc kernel releases are supposed to be for.
> > 
> > I get the impression as soon as we hit -rc1, some maintainers immediately
> > go into "OH SHIT, I CAN'T SEND PATCHES OR LINUS WILL SHOUT AT ME" mode.
> 
> I agree.  But it seems that I need to now start shouting at them :(
> 
Just like others, I now have a cutoff-point for -stable patches. Depending on
the severity of a bug, it is somewhere between -rc4 and -rc6. After -rc6 I only
push regressions and crash fixes; the rest has to wait for the commit window.

So, yes, there are a couple of hwmon patches in your list.

>From a maintainer perspective, seems to me we are stuck between a rock and a
hard place. Yes, I would prefer to push all -stable material even late in the
-rc game, but that is not how things work nowadays anymore.

This should really be discussed at the Kernel Summit. Overall, I don't really
care too much how to handle it. Just tell me. The outlook of "Either Linus
will shout at you or Greg will" doesn't sound like a good solution, though.

Guenter
