Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753901AbaJWIpj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 04:45:39 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:51497 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753677AbaJWIpf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 04:45:35 -0400
Date: Thu, 23 Oct 2014 01:45:30 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Meelis Roos <mroos@linux.ee>,
        David Miller <davem@davemloft.net>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: fix blk-mq for SPI hosts
Message-ID: <20141023084530.GB20233@infradead.org>
References: <1413731638-28305-1-git-send-email-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413731638-28305-1-git-send-email-hch@lst.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ping?

On Sun, Oct 19, 2014 at 05:13:56PM +0200, Christoph Hellwig wrote:
> Fix the assumption that we can treat all blk-mq requests as tagged.  For
> traditional SCSI that's wrong, as being tagged has a very explicit meaning
> on the wire.
> 
> This is a little bit different from the version Meelis tested earlier, but
> the concept is the same.  I didn't want to add a Tested-by tag as it's
> different enough, though.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
---end quoted text---
