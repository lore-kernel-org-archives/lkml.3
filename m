Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753677Ab3HERhV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 13:37:21 -0400
Received: from longford.logfs.org ([213.229.74.203]:59985 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753284Ab3HERhU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 13:37:20 -0400
Date: Mon, 5 Aug 2013 12:04:18 -0400
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andy Lutomirski <luto@mit.edu>, Al Viro <viro@zeniv.linux.org.uk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: O_TMPFILE fs corruption (Re: Linux 3.11-rc4)
Message-ID: <20130805160418.GA470@logfs.org>
References: <CA+55aFwTX47vLvZckozZub0rUEo-aCBe7weqe=4mfQGfrW7NUA@mail.gmail.com>
 <51FF0F18.5020705@mit.edu>
 <CA+55aFw9AY2GLC3xieuy7jgFwsUePJ+kety-AHqFxkP1pPUAVw@mail.gmail.com>
 <20130805082646.GA14689@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130805082646.GA14689@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 August 2013 01:26:46 -0700, Christoph Hellwig wrote:
> On Sun, Aug 04, 2013 at 08:45:16PM -0700, Linus Torvalds wrote:
> > The patch looks right to me - we should pass in similar flags for the
> > create case as for tmpfile to the filesystem.
> > 
> > But let's make sure we're all on the same page. Al?
> 
> Given all the problems and very limited fs support I'd much prefer
> disabling O_TMPFILE for this release.  That'd give it the needed
> exposure it was missing by being merged without any previous public
> review.

Agreed.  This has not been in -next at all.  It is not an urgent
security thing or regression fix, so there is no good excuse for
avoiding the normal process.

Jörn

--
For a successful technology, reality must take precedence over public
relations, for nature cannot be fooled.
-- Richard Feynman
