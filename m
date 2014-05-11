Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757879AbaEKBN1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2014 21:13:27 -0400
Received: from mail-vc0-f171.google.com ([209.85.220.171]:64107 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756273AbaEKBNZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2014 21:13:25 -0400
MIME-Version: 1.0
In-Reply-To: <536E806D.8020808@kernel.dk>
References: <1399741312-10453-1-git-send-email-tom.leiming@gmail.com>
	<536E806D.8020808@kernel.dk>
Date: Sun, 11 May 2014 09:13:24 +0800
Message-ID: <CACVXFVNUGB0g9ZpgVgk3dfhA6M1h8=cP_nwEdewp08fBMBTS6g@mail.gmail.com>
Subject: Re: [PATCH 0/5] blk-mq: bitmap tag: fix and cleanup
From: Ming Lei <tom.leiming@gmail.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 11, 2014 at 3:39 AM, Jens Axboe <axboe@kernel.dk> wrote:
> On 05/10/2014 11:01 AM, Ming Lei wrote:
>> Hi Jens and guys,
>>
>> I just take a look at the new bitmap based tag allocation patches
>> in -next tree, and play it for a while.
>>
>> Some of them are fixes, and some of them are cleanup, please
>> review.
>
> Thanks, applied 1-4, #5 I think you are looking at an older version,
> this one I already fixed yesterday.

Thanks, it should be because I pulled from -next instead of your tree
directly.


Thanks,
-- 
Ming Lei
