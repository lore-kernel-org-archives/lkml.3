Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753475AbaIXPBH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 11:01:07 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:49367 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753859AbaIXPBD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 11:01:03 -0400
MIME-Version: 1.0
In-Reply-To: <5422D275.8060300@kernel.dk>
References: <1410786675-7761-1-git-send-email-ming.lei@canonical.com>
	<1410786675-7761-10-git-send-email-ming.lei@canonical.com>
	<20140924102225.GD19078@lst.de>
	<5422D275.8060300@kernel.dk>
Date: Wed, 24 Sep 2014 23:01:00 +0800
Message-ID: <CACVXFVMGvW0m-F_SwFgbNzbe8Zbzw4gq6_aLwi-QpyvyxKr=zg@mail.gmail.com>
Subject: Re: [PATCH v4 09/10] blk-mq: handle failure path for initializing hctx
From: Ming Lei <ming.lei@canonical.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@lst.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2014 at 10:17 PM, Jens Axboe <axboe@kernel.dk> wrote:
> On 09/24/2014 04:22 AM, Christoph Hellwig wrote:
>> On Mon, Sep 15, 2014 at 09:11:13PM +0800, Ming Lei wrote:
>>> Failure of initializing one hctx isn't handled, so this patch
>>> introduces blk_mq_init_hctx() and its pair to handle it explicitly.
>>> Also this patch makes code cleaner.
>>>
>>> Signed-off-by: Ming Lei <ming.lei@canonical.com>
>>
>> Looks good,
>>
>> Reviewed-by: Christoph Hellwig <hch@lst.de>
>>
>> Shouldn't this go to Jens as a separate fix for 3.18?
>
> I think so, doesn't look like it's tied into the series at all.

Without this one, patch 10 becomes quite ugly.

OK, I will split this one from this patchset.

Thank,
