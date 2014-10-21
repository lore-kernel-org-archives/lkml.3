Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755611AbaJUNB1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 09:01:27 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:49599 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755428AbaJUNBZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 09:01:25 -0400
Date: Tue, 21 Oct 2014 06:01:18 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Boaz Harrosh <ooo@electrozaur.com>
Cc: Jeff Garzik <jgpobox@gmail.com>, Jeff Garzik <jgarzik@pobox.com>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        osd-dev@open-osd.org
Subject: Re: state of the osdblk driver?
Message-ID: <20141021130118.GA6122@infradead.org>
References: <20141021120653.GA9530@infradead.org>
 <CAFtxgO5cPNTMqyY5Foqp_Y+pqCH=zTiatREn-4xRCTm8o5GLwA@mail.gmail.com>
 <544655E8.8070004@electrozaur.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <544655E8.8070004@electrozaur.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 21, 2014 at 03:47:36PM +0300, Boaz Harrosh wrote:
> It is used in testing, its a good way to compare ext4 over objects
> vs exofs over objects, kind of compare apples with apples.
> (Also at the get go it was a good test that found some bugs in the
>  bring up of the osd target)
> 
> If there is an old tagging API need removing its fine to just drop
> the support, and/or do the minimal change possible. What was the
> tag used for anyway?
> 
> If it bothers you very much then please remove it, send a patch
> and I'll ACK it.

I'm mostly just trying to figure out if anyone cares.  Would you be
willing to sign up as a maintainer, and maybe even look into a blk-mq
conversion?  I'd be happy to help to answer questions and review it.

> [Just that I thought we don't do that. I can show you a dozen
>  ISA scsi LLD controllers which are a complete pain in the neck
>  with a all subsection core support. There is not a single system
>  on the planet that has this even possible, yet we do not remove
>  them nor the ISA bus crap. osdblk at least is a SW only exercise
>  that can be very much valid in any system.
> ]

Not sure what exactly you mean, but I'm open to any serious proposal to
get rid of not actually usable cruft in old SCSI HBA drivers.  Feel
free to send a proposal to linux-scsi - I was planning to come up with
one of my own, but never got to it.
