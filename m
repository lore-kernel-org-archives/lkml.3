Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751969AbaAKIYm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jan 2014 03:24:42 -0500
Received: from mail-ea0-f170.google.com ([209.85.215.170]:58633 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751033AbaAKIYk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jan 2014 03:24:40 -0500
MIME-Version: 1.0
In-Reply-To: <52CF0D85.7060905@bjorling.me>
References: <CAFR8uedovPTT0562nZSAfatjqqhyi8WXRdHj5wa9oCkVbzrBag@mail.gmail.com>
	<52CF0D85.7060905@bjorling.me>
Date: Sat, 11 Jan 2014 15:24:36 +0700
X-Google-Sender-Auth: EX2ciiLp_ylYG8eANDm6_-Lg-7I
Message-ID: <CA+55aFwC75Afeo8KKm5=v2c8_ynVG9E5VFGjbUnhyB765Ro4PA@mail.gmail.com>
Subject: Re: [block:for-3.14/core] blk-mq: Compile fix for null_blk
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Matias Bjorling <m@bjorling.me>
Cc: Muthu Kumar <muthu.lkml@gmail.com>, Jens Axboe <axboe@kernel.dk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ming Lei <tom.leiming@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 10, 2014 at 3:58 AM, Matias Bjorling <m@bjorling.me> wrote:
>
> The patch from Ming Lei is missing in -rc6
>
> 4af48694451676403188a62385dd1a2849fc05c5
> block: null_blk: fix queue leak inside removing device
>
> Its queued for -rc7. It removes the usage of blk_mq_free_queue in blk_null.

Jens? I'm going to do an rc8 tomorrow, and I haven't seen any pull requests..

              Linus
