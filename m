Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754532AbaIXIXy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 04:23:54 -0400
Received: from verein.lst.de ([213.95.11.211]:52370 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753943AbaIXIXv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 04:23:51 -0400
Date: Wed, 24 Sep 2014 10:23:48 +0200
From: Christoph Hellwig <hch@lst.de>
To: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH block/for-3.17-fixes/core] blk-mq, percpu_ref:
	implement a kludge for SCSI blk-mq stall during probe
Message-ID: <20140924082348.GB8894@lst.de>
References: <20140919113815.GA10791@lst.de> <541C8047.80705@kernel.dk> <20140923055554.GA10189@lst.de> <20140923055648.GD11740@mtj.dyndns.org> <20140923055924.GA10295@lst.de> <20140923060141.GF11740@mtj.dyndns.org> <20140923060906.GA10547@lst.de> <20140923061152.GI11740@mtj.dyndns.org> <5421968B.7080309@kernel.dk> <20140923192432.GA24441@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140923192432.GA24441@mtj.dyndns.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks, this fixes the boot stall for me.

Tested-by: Christoph Hellwig <hch@lst.de>
