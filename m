Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932788AbaEPPWa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 11:22:30 -0400
Received: from mail-ve0-f171.google.com ([209.85.128.171]:52802 "EHLO
	mail-ve0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932760AbaEPPW1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 11:22:27 -0400
MIME-Version: 1.0
In-Reply-To: <53762BF4.2040701@kernel.dk>
References: <1400157181-17800-1-git-send-email-tom.leiming@gmail.com>
	<53762662.2050702@kernel.dk>
	<5376275F.8030709@kernel.dk>
	<CACVXFVP8ZT-eSHMmHnZ2Trx63HW+X2qtekpkLW35NWGXWsJ0GQ@mail.gmail.com>
	<53762BF4.2040701@kernel.dk>
Date: Fri, 16 May 2014 23:22:26 +0800
Message-ID: <CACVXFVOE4UH4k9nxE_0HO_8WVGw8FBnHvoHU-Vy6aDC55ag6NA@mail.gmail.com>
Subject: Re: [PATCH] virtio_blk: fix race between start and stop queue
From: Ming Lei <tom.leiming@gmail.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rusty Russell <rusty@rustcorp.com.au>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 16, 2014 at 11:17 PM, Jens Axboe <axboe@kernel.dk> wrote:
> On 2014-05-16 09:15, Ming Lei wrote:
>
>
> virtio-blk just has one queue, so the flag is at least pointless for now.
> And since the other code stops all of them anyway, I don't see any reason
> not to just rely on that.

OK, if you don't care the little loading of calling
blk_mq_start_stopped_hw_queues() for each
interrupt, I will remove the flag.

Thanks,
-- 
Ming Lei
