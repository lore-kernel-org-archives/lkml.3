Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755349Ab3FKRKZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 13:10:25 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:61379 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755350Ab3FKRKW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 13:10:22 -0400
Date: Tue, 11 Jun 2013 12:10:19 -0500
From: Rob Landley <rob@landley.net>
Subject: Re: [RFC] is it time to split up the MAINTAINERS file?
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1370934825.22004.21.camel@joe-AO722> (from joe@perches.com on
	Tue Jun 11 02:13:45 2013)
X-Mailer: Balsa 2.4.11
Message-Id: <1370970619.2776.97@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/11/2013 02:13:45 AM, Joe Perches wrote:
> On Mon, 2013-06-10 at 23:49 -0500, Rob Landley wrote:
> > You could either have the same entry in more than one MAINTAINERS  
> file
> > or keep it at a higher level. (This wouldn't eliminate the top level
> > MAINTAINERS, merely trim it down a bit.)
> >
> > Just throwing it out there. Seems like it might be a thing, someday
> > anyway...
> 
> Patches talk...

So you suggest sending a patch series to break out arch directories and  
go "here, a whole new task for you the architecture maintainer to take  
on!" and that's the _polite_ way to ask whether or not it's a good idea?

> or add an initial / for the absolutes
> 
> F:	*/			(everything at this directory and lower)
> F:	foo.c			(single file)
> F:	/Documentation/foo.txt	(absolute single file)

That one, obviously. (Optimize for the common case.)

> make could be taught to create an overall integrated
> MAINTAINERS, which would not be part of the files
> managed by git/cvs from these submaintainer files.

Why? (What's the point? Does it make finding who is in charge of $THING  
easier?)

> Still, I think the "best" approach would be to enhance
> git to manage this additional information instead.

Oh please no.

> Something akin to:
> https://lkml.org/lkml/2007/8/14/256

I'm sorry I brought it up.

> Maybe some standardization of "git notes" or
> "git annotate" might work.

The horror! The horror!

> A script could be written to create something like the
> existing MAINTAINERS file from that too.

I won't mention it again.

*shudder*

Rob