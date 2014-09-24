Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754605AbaIXKUQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 06:20:16 -0400
Received: from verein.lst.de ([213.95.11.211]:52766 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753917AbaIXKUO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 06:20:14 -0400
Date: Wed, 24 Sep 2014 12:20:12 +0200
From: Christoph Hellwig <hch@lst.de>
To: Ming Lei <ming.lei@canonical.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v4 06/10] block: remove blk_init_flush() and its pair
Message-ID: <20140924102012.GB19078@lst.de>
References: <1410786675-7761-1-git-send-email-ming.lei@canonical.com> <1410786675-7761-7-git-send-email-ming.lei@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410786675-7761-7-git-send-email-ming.lei@canonical.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 15, 2014 at 09:11:10PM +0800, Ming Lei wrote:
> Now mission of the two helpers is over, and just call
> blk_alloc_flush_queue() and blk_free_flush_queue() directly.

I suspect it might be much easier to fold all previous patches except
for patch 4, which stands alone into one.  There's just too much churn
there which doesn't stay in the final version.
