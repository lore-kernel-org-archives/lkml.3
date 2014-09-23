Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754813AbaIWF73 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 01:59:29 -0400
Received: from verein.lst.de ([213.95.11.211]:49049 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752942AbaIWF70 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 01:59:26 -0400
Date: Tue, 23 Sep 2014 07:59:24 +0200
From: Christoph Hellwig <hch@lst.de>
To: Tejun Heo <tj@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: boot stall regression due to blk-mq: use percpu_ref for mq
	usage count
Message-ID: <20140923055924.GA10295@lst.de>
References: <20140919113815.GA10791@lst.de> <541C8047.80705@kernel.dk> <20140923055554.GA10189@lst.de> <20140923055648.GD11740@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140923055648.GD11740@mtj.dyndns.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 23, 2014 at 01:56:48AM -0400, Tejun Heo wrote:
> On Tue, Sep 23, 2014 at 07:55:54AM +0200, Christoph Hellwig wrote:
> > Jens,
> > 
> > can we simply get these commits reverted from now if there's no better
> > fix?  I'd hate to have this boot stall in the first kernel with blk-mq
> > support for scsi.
> 
> Patches going out right now.

"[PATCHSET percpu/for-3.18] percpu_ref: implement switch_to_atomic/percpu()"

looks way to big for 3.17, and the regression was introduced in the 3.17
merge window.  I'm not sure what was broken before, but it defintively
survived a lot of testing.
