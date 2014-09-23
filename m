Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753693AbaIWF5a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 01:57:30 -0400
Received: from mail-qa0-f42.google.com ([209.85.216.42]:42496 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752130AbaIWF51 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 01:57:27 -0400
Date: Tue, 23 Sep 2014 01:57:24 -0400
From: Tejun Heo <tj@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: Re: boot stall regression due to blk-mq: use percpu_ref for mq usage
 count
Message-ID: <20140923055724.GE11740@mtj.dyndns.org>
References: <20140919113815.GA10791@lst.de>
 <541C8047.80705@kernel.dk>
 <20140923055554.GA10189@lst.de>
 <20140923055648.GD11740@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140923055648.GD11740@mtj.dyndns.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
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

And the original implementation was broken, so...

-- 
tejun
