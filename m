Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755501Ab3FKRdQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 13:33:16 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:43819 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754660Ab3FKRdM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 13:33:12 -0400
Message-ID: <1370971991.22004.34.camel@joe-AO722>
Subject: Re: [RFC] is it time to split up the MAINTAINERS file?
From: Joe Perches <joe@perches.com>
To: Rob Landley <rob@landley.net>
Cc: linux-kernel@vger.kernel.org
Date: Tue, 11 Jun 2013 10:33:11 -0700
In-Reply-To: <1370970619.2776.97@driftwood>
References: <1370970619.2776.97@driftwood>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-06-11 at 12:10 -0500, Rob Landley wrote:
> On 06/11/2013 02:13:45 AM, Joe Perches wrote:
> > On Mon, 2013-06-10 at 23:49 -0500, Rob Landley wrote:
> > > You could either have the same entry in more than one MAINTAINERS  
> > file
> > > or keep it at a higher level. (This wouldn't eliminate the top level
> > > MAINTAINERS, merely trim it down a bit.)
> > >
> > > Just throwing it out there. Seems like it might be a thing, someday
> > > anyway...
> > 
> > Patches talk...
>
> So you suggest sending a patch series to break out arch directories and  
> go "here, a whole new task for you the architecture maintainer to take  
> on!" and that's the _polite_ way to ask whether or not it's a good idea?

I replied with suggestions, but I'm not about to
bother with implementations.

Throwing it out there without doing the work to
implement it doesn't generally inspire others to do
very much about it.

It's your itch, scratch away.

> > or add an initial / for the absolutes
> > 
> > F:	*/			(everything at this directory and lower)
> > F:	foo.c			(single file)
> > F:	/Documentation/foo.txt	(absolute single file)
> 
> That one, obviously. (Optimize for the common case.)

Not really as get_maintainers or another tool would
have to snarf all these files together before searching
once or every time it was run.

> > make could be taught to create an overall integrated
> > MAINTAINERS, which would not be part of the files
> > managed by git/cvs from these submaintainer files.
> 
> Why? (What's the point? Does it make finding who is in charge of $THING  
> easier?)

To make it easier for those that don't use git to find
maintainers and lists to send bug reports and patches.

> > Still, I think the "best" approach would be to enhance
> > git to manage this additional information instead.
> Oh please no.
> > Something akin to:
> > https://lkml.org/lkml/2007/8/14/256
> 
> I'm sorry I brought it up.

<smile>  What makes it horrific?
I think it'd be useful for more than lkml.


