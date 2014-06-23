Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752275AbaFWHJT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 03:09:19 -0400
Received: from verein.lst.de ([213.95.11.211]:39841 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751293AbaFWHJR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 03:09:17 -0400
Date: Mon, 23 Jun 2014 09:09:13 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Cc: Christoph Hellwig <hch@lst.de>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Jens Axboe <axboe@kernel.dk>,
        Bart Van Assche <bvanassche@fusionio.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 10/14] scsi: only maintain target_blocked if the driver
	has a target queue limit
Message-ID: <20140623070913.GA12267@lst.de>
References: <1402580946-11470-1-git-send-email-hch@lst.de> <1402580946-11470-11-git-send-email-hch@lst.de> <94D0CD8314A33A4D9D801C0FE68B402958B42223@G9W0745.americas.hpqcorp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B402958B42223@G9W0745.americas.hpqcorp.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 21, 2014 at 10:10:14PM +0000, Elliott, Robert (Server Storage) wrote:
> >   not_ready:
> >  	/*
> >  	 * lock q, handle tag, requeue req, and decrement device_busy. We
> 
> There's an extra & in that if statement.

Indeed, this crept in during a rebase and a later patch fixes it.  I'll make
sure this one works on its own.

