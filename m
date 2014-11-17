Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752566AbaKQTvQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 14:51:16 -0500
Received: from mail-pd0-f177.google.com ([209.85.192.177]:38336 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752088AbaKQTvO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 14:51:14 -0500
Message-ID: <546A51AD.50602@kernel.dk>
Date: Mon, 17 Nov 2014 12:51:09 -0700
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the block tree
References: <20141117144415.6af6c9d6@canb.auug.org.au>
In-Reply-To: <20141117144415.6af6c9d6@canb.auug.org.au>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/16/2014 08:44 PM, Stephen Rothwell wrote:
> Hi Jens,
>
> After merging the block tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
>
> ERROR: "blk_mq_free_request" [drivers/block/nvme.ko] undefined!
>
> Caused by commit b94ebc3c7a0f ("NVMe: replace blk_put_request() with
> blk_mq_free_request()").
>
> I have used te block tree from next-20141114 for today.

Thanks Stephen, fixed.

