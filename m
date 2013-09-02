Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758910Ab3IBS7a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 14:59:30 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:35995 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758849Ab3IBS73 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 14:59:29 -0400
Message-ID: <1378148367.1953.98.camel@joe-AO722>
Subject: Re: [Ksummit-2013-discuss] [PATCH] checkpatch: Add comment about
 updating Documentation/CodingStyle
From: Joe Perches <joe@perches.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Josh Triplett <josh@joshtriplett.org>, linux-kernel@vger.kernel.org,
        Andy Whitcroft <apw@canonical.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        ksummit-2013-discuss@lists.linuxfoundation.org
Date: Mon, 02 Sep 2013 11:59:27 -0700
In-Reply-To: <20130902153945.6d7e510c@samsung.com>
References: <9976.1378132260@warthog.procyon.org.uk>
	 <1378138205.1953.66.camel@joe-AO722> <20130902181510.GA29787@leaf>
	 <20130902181856.GB29787@leaf> <20130902153945.6d7e510c@samsung.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-09-02 at 15:39 -0300, Mauro Carvalho Chehab wrote:
> Em Mon, 2 Sep 2013 11:19:01 -0700
> Josh Triplett <josh@joshtriplett.org> escreveu:
[]
> > +# This file does not define the kernel coding style; Documentation/CodingStyle
> > +# does.  If you add a new style test to this file, add the corresponding style
> > +# rule it enforces to Documentation/CodingStyle.

> Agreed with that.

I do not.

> I would also add another comment there: "in case of
> conflicts between checkpatch.pl and Documentation/CodingStyle, the latter
> takes precedence."

There are many checkpatch rules (like semicolons) that
are not in CodingStyle.

CodingStyle should not become some intensely detailed
document that specifies the "only one true way" to
write code.

I also think checkpatch should not be used by robots
to determine that patches are bad or unacceptable.

checkpatch is just a dumb little tool that has some
utility but as Dan Carpenter once said, "it's less
sentient than a squirrel".

People should always use their own taste before
relying on dumb tools.


