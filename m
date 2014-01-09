Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757559AbaAIVzj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 16:55:39 -0500
Received: from mail-la0-f42.google.com ([209.85.215.42]:49592 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756568AbaAIVza (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 16:55:30 -0500
Message-ID: <52CF1ACE.9090000@bjorling.me>
Date: Thu, 09 Jan 2014 22:55:26 +0100
From: Matias Bjorling <m@bjorling.me>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Muthu Kumar <muthu.lkml@gmail.com>
CC: Jens Axboe <axboe@kernel.dk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        tom.leiming@gmail.com
Subject: Re: [block:for-3.14/core] blk-mq: Compile fix for null_blk
References: <CAFR8uedovPTT0562nZSAfatjqqhyi8WXRdHj5wa9oCkVbzrBag@mail.gmail.com>	<52CF0D85.7060905@bjorling.me> <CAFR8ueeDHLe51jm6JRU1r5Qm7trhfPaYgXkzG2c=gUXxU0oU0A@mail.gmail.com>
In-Reply-To: <CAFR8ueeDHLe51jm6JRU1r5Qm7trhfPaYgXkzG2c=gUXxU0oU0A@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/09/2014 10:33 PM, Muthu Kumar wrote:
> Thanks Matias. Yes, Ming Lei's 4th patch does make the function internal.
>
> So, which branch has the laest patches... i am checking for-3.14/core...
>

Depends on what you want to do. You may use the Jens' for-linus branch 
for the latest including blk patches or just cherry pick Ming's patch to 
get 3.14/core nullblk to compile. It will fix itself within a week or two.

> Regards,
> Muthu
>
<snip>

