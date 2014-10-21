Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755100AbaJUKqs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 06:46:48 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:56603 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754835AbaJUKqq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 06:46:46 -0400
Date: Tue, 21 Oct 2014 03:46:45 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, Anup Patel <anup.patel@linaro.org>,
        linux-api@vger.kernel.org, linux-kernel@vger.kernel.org,
        Arve Hj?nnev?g <arve@android.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Rebecca Schultz Zavin <rebecca@android.com>,
        John Stultz <john.stultz@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH] staging: android: binder: move to the "real" part of the
 kernel
Message-ID: <20141021104645.GA11538@infradead.org>
References: <20141016124741.GA3832@kroah.com>
 <20141017094329.GB18015@infradead.org>
 <20141019220450.GB3780@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141019220450.GB3780@kroah.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 20, 2014 at 06:04:50AM +0800, Greg Kroah-Hartman wrote:
> There is now work to resolve the interface, it requires someone who has
> the rights to push to Android userspace.  But that is going to be a
> "total rewrite", and until then, this code needs to be used, no matter
> how much we hate this.

It helps to qualify why it absolutely has to, and why this is different
from other interfaces we haven't merged.  Is this the last building
block to run upstream Linux on a common Android device out of the box
without needing any patches or out of tree drivers?  Is there any other
good reason I might have missed.

To convince other people that merging a piece like this absolutely needs
to get merged I'd suggest you start with presenting factual argument,
and then let the broader audience weight their merrits.

I think with the known problems of the code, and the fact that the
real user ABI is a library anyway the stakes are quite high here.

So as a start please prepare a list of arguments, a detailed description
of the ABI, and post a proper patch (not a move) that suggests adding
this driver to all the relevant lists (most importantly linux-fsdevel
and linux-api) so that people with the right experience can review it.
