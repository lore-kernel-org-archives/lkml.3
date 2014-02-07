Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753053AbaBGUqB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 15:46:01 -0500
Received: from mail-pa0-f50.google.com ([209.85.220.50]:35551 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751842AbaBGUp7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 15:45:59 -0500
Date: Fri, 7 Feb 2014 13:45:55 -0700
From: Jens Axboe <axboe@kernel.dk>
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH 0/4] minor blk-mq updates
Message-ID: <20140207204555.GB23865@kernel.dk>
References: <20140207182235.659185141@bombadil.infradead.org>
 <1391801805.1155.30.camel@haakon3.risingtidesystems.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1391801805.1155.30.camel@haakon3.risingtidesystems.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 07 2014, Nicholas A. Bellinger wrote:
> On Fri, 2014-02-07 at 10:22 -0800, Christoph Hellwig wrote:
> > Hi Jens,
> > 
> > these small blk-mq core updates fell out of the scsi multiqueue work.
> 
> That reminds me, the following blk-mq patch was required to get DIF
> working with scsi-mq.
> 
> Jens, care to pick this up as well..?

Yep, added, thanks!

-- 
Jens Axboe

