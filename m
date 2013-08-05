Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755060Ab3HEI0u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 04:26:50 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:60103 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754669Ab3HEI0t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 04:26:49 -0400
Date: Mon, 5 Aug 2013 01:26:46 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andy Lutomirski <luto@mit.edu>, Al Viro <viro@zeniv.linux.org.uk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: O_TMPFILE fs corruption (Re: Linux 3.11-rc4)
Message-ID: <20130805082646.GA14689@infradead.org>
References: <CA+55aFwTX47vLvZckozZub0rUEo-aCBe7weqe=4mfQGfrW7NUA@mail.gmail.com>
 <51FF0F18.5020705@mit.edu>
 <CA+55aFw9AY2GLC3xieuy7jgFwsUePJ+kety-AHqFxkP1pPUAVw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFw9AY2GLC3xieuy7jgFwsUePJ+kety-AHqFxkP1pPUAVw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 04, 2013 at 08:45:16PM -0700, Linus Torvalds wrote:
> The patch looks right to me - we should pass in similar flags for the
> create case as for tmpfile to the filesystem.
> 
> But let's make sure we're all on the same page. Al?

Given all the problems and very limited fs support I'd much prefer
disabling O_TMPFILE for this release.  That'd give it the needed
exposure it was missing by being merged without any previous public
review.

