Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756108AbaIWTsk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 15:48:40 -0400
Received: from mail-qg0-f51.google.com ([209.85.192.51]:41887 "EHLO
	mail-qg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751746AbaIWTsi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 15:48:38 -0400
Date: Tue, 23 Sep 2014 15:48:34 -0400
From: Tejun Heo <tj@kernel.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH block/for-3.17-fixes/core] blk-mq, percpu_ref: implement
 a kludge for SCSI blk-mq stall during probe
Message-ID: <20140923194834.GA14111@mtj.dyndns.org>
References: <541C8047.80705@kernel.dk>
 <20140923055554.GA10189@lst.de>
 <20140923055648.GD11740@mtj.dyndns.org>
 <20140923055924.GA10295@lst.de>
 <20140923060141.GF11740@mtj.dyndns.org>
 <20140923060906.GA10547@lst.de>
 <20140923061152.GI11740@mtj.dyndns.org>
 <5421968B.7080309@kernel.dk>
 <20140923192432.GA24441@mtj.dyndns.org>
 <5421C9FF.5030903@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5421C9FF.5030903@kernel.dk>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oops, I forgot to cc Kent.  Kent, the patch is at

 http://lkml.kernel.org/g/20140923192432.GA24441@mtj.dyndns.org

On Tue, Sep 23, 2014 at 01:29:03PM -0600, Jens Axboe wrote:
> The hack looks fine to me, if it passes Christophs boot stall test. The
> hack isn't THAT nasty, since you already have a series queued up to fix
> it for real for 3.18.

Yeah, then I can pull in block fixes branch into a percpu for-3.18
branch, revert the hack and then apply the patches to implement the
proper fix.

Thanks.

-- 
tejun
