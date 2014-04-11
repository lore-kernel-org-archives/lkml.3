Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965200AbaDKN4u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 09:56:50 -0400
Received: from mail-pb0-f54.google.com ([209.85.160.54]:61628 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757817AbaDKN4r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 09:56:47 -0400
Message-ID: <5347F4A1.4060403@kernel.dk>
Date: Fri, 11 Apr 2014 07:56:49 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@fb.com>
CC: Matias Bjorling <m@bjorling.me>, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH 3/4] blk-mq: move request structures into struct blk_mq_tags
References: <1396277175-21382-1-git-send-email-hch@lst.de> <1396277175-21382-4-git-send-email-hch@lst.de> <53457404.5070800@fb.com> <20140410100144.GB20342@lst.de> <53475693.7050609@fb.com> <20140411073336.GA26328@lst.de>
In-Reply-To: <20140411073336.GA26328@lst.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/11/2014 01:33 AM, Christoph Hellwig wrote:
> On Thu, Apr 10, 2014 at 08:42:27PM -0600, Jens Axboe wrote:
>> Great. Will you send out an updated patchset?
>
> I was waiting for you to apply the previous series, but I'll just resend my
> whole set of outstanding patches, it'll need a bit of rebasing against
> your updated tree anyway.

I'll take a look at the previous series and apply/comment.

-- 
Jens Axboe

