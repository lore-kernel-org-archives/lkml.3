Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759046Ab3IBWIR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 18:08:17 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:47737 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752221Ab3IBWIQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 18:08:16 -0400
X-Originating-IP: 50.43.39.152
Date: Mon, 2 Sep 2013 15:08:05 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: David Howells <dhowells@redhat.com>
Cc: Joe Perches <joe@perches.com>, Andy Whitcroft <apw@canonical.com>,
        ksummit-2013-discuss@lists.linuxfoundation.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: Re: [Ksummit-2013-discuss] [PATCH] checkpatch: Add comment about
 updating Documentation/CodingStyle
Message-ID: <20130902220800.GA934@leaf>
References: <20130902195056.GB32628@leaf>
 <9976.1378132260@warthog.procyon.org.uk>
 <1378138205.1953.66.camel@joe-AO722>
 <20130902181510.GA29787@leaf>
 <20130902181856.GB29787@leaf>
 <20130902153945.6d7e510c@samsung.com>
 <1378148367.1953.98.camel@joe-AO722>
 <13834.1378155023@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <13834.1378155023@warthog.procyon.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 02, 2013 at 09:50:23PM +0100, David Howells wrote:
> Josh Triplett <josh@joshtriplett.org> wrote:
> 
> > > There are many checkpatch rules (like semicolons) that
> > > are not in CodingStyle.
> > 
> > It's a rule of thumb, not a mandate.  In *general*, checkpatch.pl should
> > not be enforcing style rules that aren't documented in CodingStyle.
> 
> Except that it becomes a mandate when someone runs it automatically against
> every one of your patches and then sends you an email for each patch it finds
> a checkpatch niggle against...

I think we're talking about two different things.  I wasn't talking
about checkpatch.pl itself; I was talking about the idea that every
style rule in checkpatch.pl should corresponding documentation in
CodingStyle.  That's what I was calling a rule of thumb rather than a
mandate.

- Josh triplett
