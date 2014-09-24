Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753094AbaIXORa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 10:17:30 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:57337 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751958AbaIXOR2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 10:17:28 -0400
Message-ID: <5422D275.8060300@kernel.dk>
Date: Wed, 24 Sep 2014 08:17:25 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@canonical.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 09/10] blk-mq: handle failure path for initializing
 hctx
References: <1410786675-7761-1-git-send-email-ming.lei@canonical.com> <1410786675-7761-10-git-send-email-ming.lei@canonical.com> <20140924102225.GD19078@lst.de>
In-Reply-To: <20140924102225.GD19078@lst.de>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/24/2014 04:22 AM, Christoph Hellwig wrote:
> On Mon, Sep 15, 2014 at 09:11:13PM +0800, Ming Lei wrote:
>> Failure of initializing one hctx isn't handled, so this patch
>> introduces blk_mq_init_hctx() and its pair to handle it explicitly.
>> Also this patch makes code cleaner.
>>
>> Signed-off-by: Ming Lei <ming.lei@canonical.com>
> 
> Looks good,
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> Shouldn't this go to Jens as a separate fix for 3.18?

I think so, doesn't look like it's tied into the series at all.

-- 
Jens Axboe

