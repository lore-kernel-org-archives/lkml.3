Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753199AbaGJQOs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 12:14:48 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:40765 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752850AbaGJQOr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 12:14:47 -0400
Date: Thu, 10 Jul 2014 09:14:38 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Cc: Jens Axboe <axboe@kernel.dk>,
        "dgilbert@interlog.com" <dgilbert@interlog.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Bart Van Assche <bvanassche@fusionio.com>,
        Benjamin LaHaise <bcrl@kvack.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: scsi-mq V2
Message-ID: <20140710161438.GA30792@infradead.org>
References: <1403715121-1201-1-git-send-email-hch@lst.de>
 <20140708144829.GA5539@infradead.org>
 <53BD7041.5010300@interlog.com>
 <53BD9A24.7010203@kernel.dk>
 <94D0CD8314A33A4D9D801C0FE68B402958B9628B@G9W0745.americas.hpqcorp.net>
 <20140710062040.GB20146@infradead.org>
 <94D0CD8314A33A4D9D801C0FE68B402958B96E3B@G9W0745.americas.hpqcorp.net>
 <20140710160422.GA13728@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140710160422.GA13728@infradead.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 10, 2014 at 09:04:22AM -0700, Christoph Hellwig wrote:
> It's starting to look weird.  I'll prepare another two bisect branches
> around some MM changes, which seems the only other possible candidate.

I've pushed out scsi-mq.3-bisect-3 and scsi-mq.3-bisect-4 for you.
