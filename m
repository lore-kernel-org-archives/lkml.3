Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161007AbaCOOAW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2014 10:00:22 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:46016 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756580AbaCOOAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2014 10:00:20 -0400
Date: Sat, 15 Mar 2014 07:00:17 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Randy Dunlap <rdunlap@infradead.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] MAINTAINERS: virtio-dev is subscribers only
Message-ID: <20140315140017.GA14601@infradead.org>
References: <531F4528.8000402@infradead.org>
 <87vbvjue71.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87vbvjue71.fsf@rustcorp.com.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 13, 2014 at 11:06:50AM +1030, Rusty Russell wrote:
> Randy Dunlap <rdunlap@infradead.org> writes:
> > From: Randy Dunlap <rdunlap@infradead.org>
> >
> > virtio-dev mailing list is for subscribers only according to the
> > returned message after trying to send to it.
> 
> Thanks, applied.

It's a strict bounce and not even moderator approval for
non-subscribers.  This means it might as well be non-existant for
linux development and we should remove it from MAINTAINERS entirely.

