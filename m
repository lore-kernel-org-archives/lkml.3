Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751157AbaLOSlJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 13:41:09 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38775 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750772AbaLOSlE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 13:41:04 -0500
Date: Mon, 15 Dec 2014 10:41:03 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Richard Weinberger <richard.weinberger@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
Subject: Re: [GIT PULL] Staging driver patches for 3.19-rc1
Message-ID: <20141215184103.GA6761@kroah.com>
References: <20141215175535.GA4665@kroah.com>
 <CAFLxGvwvj_ihWQQV3yY8Czxt0F2ieP=CRBrPMKqUatpjj9zdvQ@mail.gmail.com>
 <20141215183915.GA15554@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141215183915.GA15554@infradead.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 15, 2014 at 10:39:15AM -0800, Christoph Hellwig wrote:
> On Mon, Dec 15, 2014 at 07:23:35PM +0100, Richard Weinberger wrote:
> > I don't understand this kind of logic.
> > a) Binder is considered a piece of shite.
> > b) Google is working on a (hopefully sane) replacement.
> > 
> > Why moving it out of staging then? What is the benefit?
> 
> There is none, and Greg didn't even bother addressing the various
> comments when this first came up.

I thought I did, it was a long thread at the time, and I was on the road
for 3 weeks, sorry if I missed something.

> So a clear NAK from me on this one.

You don't have to maintain it, I do, so why does it concern you?

thanks,

greg k-h
