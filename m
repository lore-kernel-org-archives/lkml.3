Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754658AbaIWFz7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 01:55:59 -0400
Received: from verein.lst.de ([213.95.11.211]:49025 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754542AbaIWFz5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 01:55:57 -0400
Date: Tue, 23 Sep 2014 07:55:54 +0200
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@lst.de>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: boot stall regression due to blk-mq: use percpu_ref for mq
	usage count
Message-ID: <20140923055554.GA10189@lst.de>
References: <20140919113815.GA10791@lst.de> <541C8047.80705@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <541C8047.80705@kernel.dk>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens,

can we simply get these commits reverted from now if there's no better
fix?  I'd hate to have this boot stall in the first kernel with blk-mq
support for scsi.

