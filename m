Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753243AbaIXOeI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 10:34:08 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:40116 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751020AbaIXOeE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 10:34:04 -0400
Message-ID: <5422D656.7020006@kernel.dk>
Date: Wed, 24 Sep 2014 08:33:58 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH block/for-3.17-fixes/core] blk-mq, percpu_ref: implement
 a kludge for SCSI blk-mq stall during probe
References: <20140923055554.GA10189@lst.de> <20140923055648.GD11740@mtj.dyndns.org> <20140923055924.GA10295@lst.de> <20140923060141.GF11740@mtj.dyndns.org> <20140923060906.GA10547@lst.de> <20140923061152.GI11740@mtj.dyndns.org> <5421968B.7080309@kernel.dk> <20140923192432.GA24441@mtj.dyndns.org> <20140924082348.GB8894@lst.de> <5422D589.5070009@kernel.dk> <20140924143320.GG16555@htj.dyndns.org>
In-Reply-To: <20140924143320.GG16555@htj.dyndns.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/24/2014 08:33 AM, Tejun Heo wrote:
> On Wed, Sep 24, 2014 at 08:30:33AM -0600, Jens Axboe wrote:
>> On 09/24/2014 02:23 AM, Christoph Hellwig wrote:
>>> Thanks, this fixes the boot stall for me.
>>>
>>> Tested-by: Christoph Hellwig <hch@lst.de>
>>
>> Sweet, I'll shove this off today, so we are done for 3.17 release.
> 
> Cool, once it hits the block branch, I'll pull it into percpu/for-3.18
> and apply the patches for proper fix on top.

It's in for-linus now.


-- 
Jens Axboe

