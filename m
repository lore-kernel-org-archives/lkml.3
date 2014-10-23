Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755965AbaJWRQN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 13:16:13 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:55760 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752037AbaJWRQL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 13:16:11 -0400
Message-ID: <544937DB.7060803@kernel.dk>
Date: Thu, 23 Oct 2014 11:16:11 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>, Meelis Roos <mroos@linux.ee>
CC: Christoph Hellwig <hch@lst.de>, David Miller <davem@davemloft.net>,
        linux-scsi@vger.kernel.org,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: fix blk-mq for SPI hosts
References: <1413731638-28305-1-git-send-email-hch@lst.de> <20141023084530.GB20233@infradead.org> <alpine.LRH.2.11.1410231151160.2821@adalberg.ut.ee> <20141023171454.GA16990@infradead.org>
In-Reply-To: <20141023171454.GA16990@infradead.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/23/2014 11:14 AM, Christoph Hellwig wrote:
> On Thu, Oct 23, 2014 at 01:49:07PM +0300, Meelis Roos wrote:
>>> ping?
>>
>> Sorry, forgot to reply. Yes, it worked fine, on the initial Ultra 1 and 
>> additionally on Ultra 2 too.
> 
> Thanks!
> 
> Can I get a review from Jens and some SCSI developers, too?

Yes, I did read them, you can add my reviewed/acked.

> Jens, are you fine taking the blkdev.h revert through the SCSI tree?

Sure, that seems to be the easiest way to do it.

-- 
Jens Axboe

