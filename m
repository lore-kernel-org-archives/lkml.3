Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752586AbaHDLLt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 07:11:49 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:44475 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751987AbaHDLLs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 07:11:48 -0400
Date: Mon, 4 Aug 2014 04:11:47 -0700
From: Christoph Hellwig <hch@infradead.org>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [ANNOUNCE] scsi patch queue tree updated
Message-ID: <20140804111147.GA29148@infradead.org>
References: <20140708134003.GA7790@infradead.org>
 <20140801122042.GA10771@infradead.org>
 <1406925121.2654.21.camel@jarvis>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406925121.2654.21.camel@jarvis>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 01, 2014 at 04:32:01PM -0400, James Bottomley wrote:
> On Fri, 2014-08-01 at 05:20 -0700, Christoph Hellwig wrote:
> > I've pushed out updates to both the core-for-3.17 and drivers-for-3.17
> > branches.
> 
> So I'm afraid we missed the last -next build on these, so they can't go
> in with the early SCSI pull.  I'm open to doing one mid merge window,
> but Linus tends not to like that.

I don't think there are any hard and fast rules.


The core-for-3.17 commit is a trivial printk specifier regression fix for
something introduced in the 3.17 merge window, so pulling it in is
an absolute non-brainer.

The drivers side are a bunch of smaller fixes for iscsi and pm8001 which
never have been a problem to put in near the end of the merge window,
especially if they have a few more days linux-next exposure in
Linux-next even after the 3.16 release.  They absolutely would be
candidates for a second pull even if they'd miss the first pull.

