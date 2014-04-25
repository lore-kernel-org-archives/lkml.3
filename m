Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752529AbaDYNt6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 09:49:58 -0400
Received: from imap.thunk.org ([74.207.234.97]:60954 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752639AbaDYNtz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 09:49:55 -0400
Date: Fri, 25 Apr 2014 09:49:51 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH 1/1] random: export add_disk_randomness
Message-ID: <20140425134951.GF11124@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>,
	linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
References: <20140425073610.GA2143@infradead.org>
 <20140425073637.GB2143@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140425073637.GB2143@infradead.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 25, 2014 at 12:36:37AM -0700, Christoph Hellwig wrote:
> This will be needed for pending changes to the scsi midlayer that now calls
> lower level block APIs, as well as any blk-mq driver that wants to contribute
> to the random pool.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Acked-by: "Theodore Ts'o" <tytso@mit.edu>

