Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751051AbaLOSjT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 13:39:19 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:38475 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750755AbaLOSjR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 13:39:17 -0500
Date: Mon, 15 Dec 2014 10:39:15 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Richard Weinberger <richard.weinberger@gmail.com>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
Subject: Re: [GIT PULL] Staging driver patches for 3.19-rc1
Message-ID: <20141215183915.GA15554@infradead.org>
References: <20141215175535.GA4665@kroah.com>
 <CAFLxGvwvj_ihWQQV3yY8Czxt0F2ieP=CRBrPMKqUatpjj9zdvQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFLxGvwvj_ihWQQV3yY8Czxt0F2ieP=CRBrPMKqUatpjj9zdvQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 15, 2014 at 07:23:35PM +0100, Richard Weinberger wrote:
> I don't understand this kind of logic.
> a) Binder is considered a piece of shite.
> b) Google is working on a (hopefully sane) replacement.
> 
> Why moving it out of staging then? What is the benefit?

There is none, and Greg didn't even bother addressing the various
comments when this first came up.

So a clear NAK from me on this one.  

