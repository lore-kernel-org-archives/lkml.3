Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753052AbaFMSRw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 14:17:52 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:54353 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751622AbaFMSRv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 14:17:51 -0400
Message-ID: <539B4050.40704@kernel.dk>
Date: Fri, 13 Jun 2014 12:17:52 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Christoph Hellwig <hch@lst.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] blk-mq: properly drain stopped queues
References: <20140613174304.GA20317@lst.de>
In-Reply-To: <20140613174304.GA20317@lst.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/13/2014 11:43 AM, Christoph Hellwig wrote:
> If we need to drain a queue we need to run all queues, even if they
> are marked stopped to make sure the driver has a chance to error out
> on all queued requests.
> 
> This fixes surprise removal with scsi-mq.

Applied this and 2/2 as well, thanks!

-- 
Jens Axboe

