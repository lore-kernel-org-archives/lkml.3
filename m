Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752193AbaF3PZb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 11:25:31 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:37623 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750771AbaF3PZ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 11:25:29 -0400
Date: Mon, 30 Jun 2014 08:25:24 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
        Bart Van Assche <bvanassche@fusionio.com>,
        Robert Elliott <Elliott@hp.com>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Chris Mason <clm@fb.com>
Subject: Re: scsi-mq V2
Message-ID: <20140630152524.GA3709@infradead.org>
References: <1403715121-1201-1-git-send-email-hch@lst.de>
 <53ABA6A4.8090400@kernel.dk>
 <53B18053.2030805@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53B18053.2030805@kernel.dk>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 30, 2014 at 09:20:51AM -0600, Jens Axboe wrote:
> Ran stress testing from Friday to now, 65h of beating up on it and no
> problems observed. 47TB read and 20TB written for a total of 17.7
> billion of IOs issued and completed. Latencies look good. I officially
> declare this code for bug free.
> 
> Bug-free-by: Jens Axboe <axboe@fb.com>
> 
> Now lets get this queued up for inclusion, pretty please.

I'm still looking for one (or better two) persons familar with the
SCSI and/or block code to go over it and do a real detailed review.

