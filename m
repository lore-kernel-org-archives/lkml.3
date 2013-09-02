Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758892Ab3IBTfI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 15:35:08 -0400
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:39806 "EHLO
	relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757070Ab3IBTfH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 15:35:07 -0400
X-Originating-IP: 50.43.39.152
Date: Mon, 2 Sep 2013 12:34:56 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: linux-kernel@vger.kernel.org, Joe Perches <joe@perches.com>,
        Andy Whitcroft <apw@canonical.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        ksummit-2013-discuss@lists.linuxfoundation.org
Subject: Re: [Ksummit-2013-discuss] [PATCH] checkpatch: Add comment about
 updating Documentation/CodingStyle
Message-ID: <20130902193456.GA32628@leaf>
References: <9976.1378132260@warthog.procyon.org.uk>
 <1378138205.1953.66.camel@joe-AO722>
 <20130902181510.GA29787@leaf>
 <20130902181856.GB29787@leaf>
 <20130902153945.6d7e510c@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130902153945.6d7e510c@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 02, 2013 at 03:39:45PM -0300, Mauro Carvalho Chehab wrote:
> Em Mon, 2 Sep 2013 11:19:01 -0700
> Josh Triplett <josh@joshtriplett.org> escreveu:
> 
> > Patches to checkpatch that add new style rules should also change
> > Documentation/CodingStyle to document those new style rules; add a
> > comment to that effect to the top of scripts/checkpatch.pl.
> 
> Well, you forgot to c/c LKML on this patch; I think that KS2013 is not the
> proper list to review this patch ;)

My mail went to LKML; it had:
To: linux-kernel@vger.kernel.org

> > Signed-off-by: Josh Triplett <josh@joshtriplett.org>
> > ---
> >  scripts/checkpatch.pl | 4 ++++
> >  1 file changed, 4 insertions(+)
> > 
> > diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> > index 2ee9eb7..ba65ea6 100755
> > --- a/scripts/checkpatch.pl
> > +++ b/scripts/checkpatch.pl
> > @@ -4,6 +4,10 @@
> >  # (c) 2007,2008, Andy Whitcroft <apw@uk.ibm.com> (new conditions, test suite)
> >  # (c) 2008-2010 Andy Whitcroft <apw@canonical.com>
> >  # Licensed under the terms of the GNU GPL License version 2
> > +#
> > +# This file does not define the kernel coding style; Documentation/CodingStyle
> > +# does.  If you add a new style test to this file, add the corresponding style
> > +# rule it enforces to Documentation/CodingStyle.
> >  
> 
> Agreed with that. I would also add another comment there: "in case of
> conflicts between checkpatch.pl and Documentation/CodingStyle, the latter
> takes precedence."

Good point.

> Anyway,
> 
> Acked-by: Mauro Carvalho Chehab <m.chehab@samsung.com>

Thanks.

- Josh Triplett
