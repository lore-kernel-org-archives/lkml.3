Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754819AbaE1PuN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 11:50:13 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:35569 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753841AbaE1PuL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 11:50:11 -0400
Date: Wed, 28 May 2014 08:50:08 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: Christoph Hellwig <hch@infradead.org>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE] scsi patch queue tree
Message-ID: <20140528155008.GA6913@infradead.org>
References: <20140519140614.GA12183@infradead.org>
 <20140520100343.31490551@canb.auug.org.au>
 <20140520053928.GA1751@infradead.org>
 <20140521094636.515289e8@canb.auug.org.au>
 <1400639101.2481.19.camel@dabdike>
 <20140528105429.GA20549@infradead.org>
 <538602BB.2080609@cs.wisc.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <538602BB.2080609@cs.wisc.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 28, 2014 at 10:37:31AM -0500, Mike Christie wrote:
> On 05/28/2014 05:54 AM, Christoph Hellwig wrote:
> >       be2iscsi: Fix processing cqe for cxn whose endpoint is freed
> 
> I didn't look at your tree, but when this patch was posted on the list I
> think it had a bug.
> 
> http://www.spinics.net/lists/linux-scsi/msg74191.html

I read through it and saw your comment, but so far it seems the patch
and especially the series does more good than harm.  I'll ping the
author again to get a fix for the issue you pointed out - I was planning
to do that anwyay.
