Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758968Ab3IBTvG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 15:51:06 -0400
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:40886 "EHLO
	relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758923Ab3IBTvF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 15:51:05 -0400
X-Originating-IP: 50.43.39.152
Date: Mon, 2 Sep 2013 12:50:56 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: Joe Perches <joe@perches.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>, linux-kernel@vger.kernel.org,
        Andy Whitcroft <apw@canonical.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        ksummit-2013-discuss@lists.linuxfoundation.org
Subject: Re: [Ksummit-2013-discuss] [PATCH] checkpatch: Add comment about
 updating Documentation/CodingStyle
Message-ID: <20130902195056.GB32628@leaf>
References: <9976.1378132260@warthog.procyon.org.uk>
 <1378138205.1953.66.camel@joe-AO722>
 <20130902181510.GA29787@leaf>
 <20130902181856.GB29787@leaf>
 <20130902153945.6d7e510c@samsung.com>
 <1378148367.1953.98.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1378148367.1953.98.camel@joe-AO722>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 02, 2013 at 11:59:27AM -0700, Joe Perches wrote:
> On Mon, 2013-09-02 at 15:39 -0300, Mauro Carvalho Chehab wrote:
> > Em Mon, 2 Sep 2013 11:19:01 -0700
> > Josh Triplett <josh@joshtriplett.org> escreveu:
> []
> > > +# This file does not define the kernel coding style; Documentation/CodingStyle
> > > +# does.  If you add a new style test to this file, add the corresponding style
> > > +# rule it enforces to Documentation/CodingStyle.
> 
> > Agreed with that.
> 
> I do not.
> 
> > I would also add another comment there: "in case of
> > conflicts between checkpatch.pl and Documentation/CodingStyle, the latter
> > takes precedence."
> 
> There are many checkpatch rules (like semicolons) that
> are not in CodingStyle.

It's a rule of thumb, not a mandate.  In *general*, checkpatch.pl should
not be enforcing style rules that aren't documented in CodingStyle.

> CodingStyle should not become some intensely detailed
> document that specifies the "only one true way" to
> write code.

Any rule that maintainers are likely to enforce on patches they review
should live in Documentation/CodingStyle; unwritten rules are a bad
idea.  Any rule that maintainers are *not* likely to enforce shouldn't
go in scripts/checkpatch.pl.

- Josh Triplett
