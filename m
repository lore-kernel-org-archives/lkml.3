Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758927Ab3IBTsk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 15:48:40 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:35027 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757074Ab3IBTsj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 15:48:39 -0400
Date: Mon, 2 Sep 2013 16:48:24 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Joe Perches <joe@perches.com>
Cc: Josh Triplett <josh@joshtriplett.org>, linux-kernel@vger.kernel.org,
        Andy Whitcroft <apw@canonical.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        ksummit-2013-discuss@lists.linuxfoundation.org,
        David Howells <dhowells@redhat.com>
Subject: Re: [Ksummit-2013-discuss] [PATCH] checkpatch: Add comment about
 updating Documentation/CodingStyle
Message-ID: <20130902164824.76da7032@infradead.org>
In-Reply-To: <1378148367.1953.98.camel@joe-AO722>
References: <9976.1378132260@warthog.procyon.org.uk>
	<1378138205.1953.66.camel@joe-AO722>
	<20130902181510.GA29787@leaf>
	<20130902181856.GB29787@leaf>
	<20130902153945.6d7e510c@samsung.com>
	<1378148367.1953.98.camel@joe-AO722>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.19; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, 02 Sep 2013 11:59:27 -0700
Joe Perches <joe@perches.com> escreveu:

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

Well, document them there, please.

> CodingStyle should not become some intensely detailed
> document that specifies the "only one true way" to
> write code.

There will always be things that will be freed to the programmer to
use, but CodingStyle should reflect what is the coding style we're
adopting at the Kernel, or putting it on another way: what things
will make the patch to be rejected because of its style.

> I also think checkpatch should not be used by robots
> to determine that patches are bad or unacceptable.
> 
> checkpatch is just a dumb little tool that has some
> utility but as Dan Carpenter once said, "it's less
> sentient than a squirrel".
> 
> People should always use their own taste before
> relying on dumb tools.

That's easier said than done. There are lots of stupid changes that are
done by developers (like enforcing 80 cols whitespace breaks) just
because of the checkpatch warnings. That happens before those patches 
got sent to the ML's, as most people know that maintainers will curse 
them if the coding style is crap[1].

[1] BTW, most of the time that checkpatch complains, the code is
really crap.

In any case, Documentation/CodingStyle is the reference document that
maintainers and coders should use to know that a code is following the
style (and not checkpatch). So, it requires updates when new
CodingStyle enforcements are created.

In the specific example pointed by David, if "extern", will start
to become a bad word that should be avoided, that should be documented
there at CodingStyle, and checkpatch should just be the dumb monkey
that will check that.

Cheers,
Mauro
