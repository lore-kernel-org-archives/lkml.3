Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754754AbaIWF44 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 01:56:56 -0400
Received: from mail-qc0-f181.google.com ([209.85.216.181]:53931 "EHLO
	mail-qc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754688AbaIWF4x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 01:56:53 -0400
Date: Tue, 23 Sep 2014 01:56:48 -0400
From: Tejun Heo <tj@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: Re: boot stall regression due to blk-mq: use percpu_ref for mq usage
 count
Message-ID: <20140923055648.GD11740@mtj.dyndns.org>
References: <20140919113815.GA10791@lst.de>
 <541C8047.80705@kernel.dk>
 <20140923055554.GA10189@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140923055554.GA10189@lst.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 23, 2014 at 07:55:54AM +0200, Christoph Hellwig wrote:
> Jens,
> 
> can we simply get these commits reverted from now if there's no better
> fix?  I'd hate to have this boot stall in the first kernel with blk-mq
> support for scsi.

Patches going out right now.

Thanks.

-- 
tejun
