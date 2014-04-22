Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752624AbaDVBZU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 21:25:20 -0400
Received: from mail-ve0-f176.google.com ([209.85.128.176]:63938 "EHLO
	mail-ve0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751167AbaDVBZR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 21:25:17 -0400
MIME-Version: 1.0
In-Reply-To: <5355BFCC.2000909@kernel.dk>
References: <1397901619-27226-1-git-send-email-tom.leiming@gmail.com>
	<5355BFCC.2000909@kernel.dk>
Date: Tue, 22 Apr 2014 09:25:15 +0800
Message-ID: <CACVXFVOwq_1KgfdGfa1pQf8nKi689BYynVtz-sCQLuV1zw5ong@mail.gmail.com>
Subject: Re: [PATCH v1 next 0/4] blk-mq: misc changes
From: Ming Lei <tom.leiming@gmail.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2014 at 9:03 AM, Jens Axboe <axboe@kernel.dk> wrote:
> On 2014-04-19 04:00, Ming Lei wrote:
>>
>> Hi,
>>
>> Three of them are fixes, another one is cleanup.
>>
>> V1:
>>         - line break(2/4)
>>         - use explicit cast(3/4)
>
>
> I believe this is v2, but I guess your first posting was v0 :-)
> Applied for testing for 3.16, thanks.

Yeah, it is the C programming style, :-)

Thanks,
-- 
Ming Lei
