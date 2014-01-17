Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752477AbaAQKXb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 05:23:31 -0500
Received: from s3.sipsolutions.net ([144.76.43.152]:46608 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751296AbaAQKX3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 05:23:29 -0500
Message-ID: <1389954205.10404.1.camel@jlt4.sipsolutions.net>
Subject: Re: gcc tickets for sparse attributes
From: Johannes Berg <johannes@sipsolutions.net>
To: Josh Triplett <josh@joshtriplett.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        Linux-Sparse <linux-sparse@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Fri, 17 Jan 2014 11:23:25 +0100
In-Reply-To: <20140117092223.GC577@leaf>
References: <52D8BF2C.9090604@zytor.com>
	 <1389947596.4354.2.camel@jlt4.sipsolutions.net> <20140117092223.GC577@leaf>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > IMHO the context extension doesn't work well enough in sparse to
> > document and implement as is. It would be much better if it actually was
> > able to differentiate between contexts, rather than treating each one
> > the same.
> 
> That would certainly be nice, but that's something actually much more
> easily done in GCC than in Sparse, given the types of information GCC
> already has available to implement features like alias analysis.

Right.

> In any case, the spec I wrote up assumes a distinction between contexts,
> but allows for an initial implementation like Sparse's that ignores the
> distinction.

Ok cool. :)

> > This would avoid the problem that locking one lock and
> > unlocking another (in the kernel's __acquire/ __release mechanism) could
> > still result in a warning.
> 
> That would actually *not* produce a warning, though it should.  In
> general, I *think* an implementation like Sparse's that ignores the
> distinction between locks should produce false negatives but not false
> positives.

Right, it doesn't report one now.

johannes

