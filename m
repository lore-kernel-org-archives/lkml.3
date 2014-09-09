Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757200AbaIIPUd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 11:20:33 -0400
Received: from verein.lst.de ([213.95.11.211]:47129 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750816AbaIIPUb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 11:20:31 -0400
Date: Tue, 9 Sep 2014 17:20:28 +0200
From: Christoph Hellwig <hch@lst.de>
To: Ming Lei <ming.lei@canonical.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH 0/8] block: per-distpatch_queue flush machinery
Message-ID: <20140909152028.GA13699@lst.de>
References: <1410267949-21904-1-git-send-email-ming.lei@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410267949-21904-1-git-send-email-ming.lei@canonical.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ming,

thanks for doing this work!

I've only taken a very cursory look at the series and I like most of it.

But can you explain why you're not simply incrementing the number of
allocated requests in the blk-mq request allocation code instead of
allocating the flush request separately in the last patch?

(A more throughout review will follow too)

