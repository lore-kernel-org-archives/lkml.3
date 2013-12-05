Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756964Ab3LEQyf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 11:54:35 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:56401 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756863Ab3LEQye (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 11:54:34 -0500
Date: Thu, 5 Dec 2013 16:54:29 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Pavel Machek <pavel@ucw.cz>
Cc: Matthew Garrett <matthew.garrett@nebula.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Remove unnecessarily gendered language
Message-ID: <20131205165429.34468e1b@alan.etchedpixels.co.uk>
In-Reply-To: <20131205104808.GA6455@amd.pavel.ucw.cz>
References: <1386033532-25431-1-git-send-email-matthew.garrett@nebula.com>
	<20131205104808.GA6455@amd.pavel.ucw.cz>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Dec 2013 11:48:08 +0100
Pavel Machek <pavel@ucw.cz> wrote:

> On Mon 2013-12-02 20:18:52, Matthew Garrett wrote:
> > The kernel as a number of cases of gendered language. The majority of these
> > refer to objects that don't have gender in English, and so I've replaced
> > them with "it" and "its". Some refer to people (developers or users), and
> > I've replaced these with the singular "they" variant. Some are simply
> > typos that I've fixed up.
> 
> Why is this good idea?
> 
> I don't think this makes documentation better.

It makes it more inclusive and modern. It doesn't make it worse in theory
but some of the changes it does seem a bit muddled.

> > @@ -127,7 +127,7 @@ gid=
> >  umask=			Provide default owner, group, and access mode mask.
> >  			These options work as documented in mount(8).  By
> >  			default, the files/directories are owned by root and
> > -			he/she has read and write permissions, as well as
> > +			they have read and write permissions, as well as
> >  			browse permission for directories.  No one else has any
> >  			access permissions.  I.e. the mode on all files is by
> >  			default rw------- and for directories rwx------, a
> 
> So... we had unambiguous text "user has read and write permissions"
> and now you have to wonder if they refers to "user" or
> "files/directories".

Changing he/she into they seems silly. It's already perfectly sensible
language. Quite frankly if you want to avoid he/she in that text why not
just use "owned by root, and root has" ?

> (And I'm pretty sure most people will parse it the wrong way.)
> 
> > @@ -23,7 +24,7 @@ Quota netlink interface
> >  When user exceeds a softlimit, runs out of grace time or reaches hardlimit,
> >  quota subsystem traditionally printed a message to the controlling terminal of
> >  the process which caused the excess. This method has the disadvantage that
> > -when user is using a graphical desktop he usually cannot see the message.
> > +when user is using a graphical desktop they usually cannot see the
> >  message.
> 
> Is this even correct english?

That would depend who you ask and English has no "correct". There are
people who will go to the grave refusing to split an infinitive let alone
use "their" in this fashion, but it does reflect modern English language
usage in much of the UK. Some areas of the UK ascribe gender to a lot of
objects not just the usual bizarre exception of ships and trains 8) so
don't expect consensus.

I would argue that "This method has the disadvantage that when user
is using a graphical desktop he usually cannot see the message." 

really wants fixing for other language reasons anyway. In fact the whole
paragraph wants a rewrite - but I appreciate the author of that text was
not first language English.

Alan

