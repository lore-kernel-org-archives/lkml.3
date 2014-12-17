Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751783AbaLQJ2I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 04:28:08 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:51488 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751033AbaLQJ2G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 04:28:06 -0500
Date: Wed, 17 Dec 2014 01:28:04 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Richard Weinberger <richard.weinberger@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
Subject: Re: [GIT PULL] Staging driver patches for 3.19-rc1
Message-ID: <20141217092804.GA9424@infradead.org>
References: <20141215175535.GA4665@kroah.com>
 <CAFLxGvwvj_ihWQQV3yY8Czxt0F2ieP=CRBrPMKqUatpjj9zdvQ@mail.gmail.com>
 <20141215183915.GA15554@infradead.org>
 <20141215184103.GA6761@kroah.com>
 <20141215185638.GA8036@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141215185638.GA8036@kroah.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 15, 2014 at 10:56:38AM -0800, Greg KH wrote:
> Ok, that was a bit snotty on my part, I apologize.
> 
> But really, this is self-contained, doesn't touch any core
> infrastructure, and is really just like any other driver for hardware
> that people don't use.  It shouldn't affect anything elsewhere in the
> kernel, so objecting to it seems odd to me.

I does dig into internals in quite nasty ways.  I driver that is always
modular and just uses existing exported APIs in proper ways and adds no
to little new userspaces ABIs is one things.  A new IPCs mechanisms that
pokes into internals and exposes a huge ABI/API is a totally different
thing.

