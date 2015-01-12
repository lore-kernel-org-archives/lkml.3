Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753482AbbALOkx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 09:40:53 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:46421 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751204AbbALOkw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 09:40:52 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX195CrUggUKzAC6lZpGFsLjs3wQvcZszEzA=
X-DKIM: OpenDKIM Filter v2.0.1 titan C7FE1644134
Date: Mon, 12 Jan 2015 09:40:47 -0500
From: Jason Cooper <jason@lakedaemon.net>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Arno Tiemersma <arno.tiemersma@gmail.com>, devel@driverdev.osuosl.org,
        eric.rost@mybabylon.net, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, jake@lwn.net, antonysaraev@gmail.com
Subject: Re: [PATCH] staging: skein: Fix checkpatch warnings
Message-ID: <20150112144047.GY24989@titan.lakedaemon.net>
References: <1420902047-7569-1-git-send-email-arno.tiemersma@gmail.com>
 <20150112141418.GW24989@titan.lakedaemon.net>
 <20150112143347.GE7568@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150112143347.GE7568@mwanda>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2015 at 05:33:47PM +0300, Dan Carpenter wrote:
> On Mon, Jan 12, 2015 at 09:14:18AM -0500, Jason Cooper wrote:
> > Arno,
> > 
> > On Sat, Jan 10, 2015 at 04:00:47PM +0100, Arno Tiemersma wrote:
> > > Remove do {} while (0) loops around single statements in
> > > skein/skein_block.c
> > > 
> > > Signed-off-by: Arno Tiemersma <arno.tiemersma@gmail.com>
> > > ---
> > >  drivers/staging/skein/skein_block.c | 16 ++++------------
> > >  1 file changed, 4 insertions(+), 12 deletions(-)
> > 
> > Is this a V2?  Several people have been submitting patches for this
> > checkpatch issue.  Please check the staging ML and deconflict with other
> > submitters.
> 
> Why would it be a v2?

I had asked one person to do a little extra work validating that
removing the do{}while's hadn't changed the resulting object code.
Unfortunately, I forgot who that was :(  Only because there have been so
many people submitting the exact same thing, though...

> It's really normal to get a wave of people sending the exact same patch.
> There was one time where 7 people deleted the same whitespace in
> panel.c.

I suspect this is a combination of a) checkpatch.pl getting a more
enhanced handling of do{}while's in macros, and b) more folks doing the
Eudiptula (sp?) challenge.

> Don't worry too much about conflicts.  It either applies when Greg reads
> it or it doesn't and he kicks off an email.  Not a big deal.

Agreed from a patch management side.  I was attempting to encourage the
new submitters to starting integrating the mailinglist into their
workflow.

thx,

Jason.
