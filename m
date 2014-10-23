Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755219AbaJWKtN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 06:49:13 -0400
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:39402 "EHLO smtp2.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755187AbaJWKtL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 06:49:11 -0400
Date: Thu, 23 Oct 2014 13:49:07 +0300 (EEST)
From: Meelis Roos <mroos@linux.ee>
To: Christoph Hellwig <hch@infradead.org>
cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        David Miller <davem@davemloft.net>, linux-scsi@vger.kernel.org,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: fix blk-mq for SPI hosts
In-Reply-To: <20141023084530.GB20233@infradead.org>
Message-ID: <alpine.LRH.2.11.1410231151160.2821@adalberg.ut.ee>
References: <1413731638-28305-1-git-send-email-hch@lst.de> <20141023084530.GB20233@infradead.org>
User-Agent: Alpine 2.11 (LRH 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> ping?

Sorry, forgot to reply. Yes, it worked fine, on the initial Ultra 1 and 
additionally on Ultra 2 too.

> On Sun, Oct 19, 2014 at 05:13:56PM +0200, Christoph Hellwig wrote:
> > Fix the assumption that we can treat all blk-mq requests as tagged.  For
> > traditional SCSI that's wrong, as being tagged has a very explicit meaning
> > on the wire.
> > 
> > This is a little bit different from the version Meelis tested earlier, but
> > the concept is the same.  I didn't want to add a Tested-by tag as it's
> > different enough, though.
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> ---end quoted text---
> 

-- 
Meelis Roos (mroos@linux.ee)
