Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758053AbaFSQIL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 12:08:11 -0400
Received: from imap.thunk.org ([74.207.234.97]:47906 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757539AbaFSQIJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 12:08:09 -0400
Date: Thu, 19 Jun 2014 12:08:01 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Jens Axboe <axboe@fb.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: BUG: scheduling while atomic in blk_mq codepath?
Message-ID: <20140619160801.GB4907@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>, Jens Axboe <axboe@fb.com>,
	linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
References: <20140619153550.GA12836@thunk.org>
 <53A308DE.7080000@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53A308DE.7080000@fb.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 19, 2014 at 08:59:26AM -0700, Jens Axboe wrote:
> I believe you already reported this issue a while back, and it should be
> fixed by commit cb96a42c in the kernel.

Ah yes, I had forgotten.  Thanks for the reminder!

> The other issue, not sure, not a lot of detail. It may be fixed by the pull
> request I sent out yesterday. You can try pulling in:
> 
> git://git.kernel.dk/linux-block.git for-linus

Thanks, I'll give that a try.

				- Ted
