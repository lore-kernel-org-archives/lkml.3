Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933388AbaFIPQB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 11:16:01 -0400
Received: from mail-vc0-f179.google.com ([209.85.220.179]:47374 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751611AbaFIPP6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 11:15:58 -0400
MIME-Version: 1.0
In-Reply-To: <5395CE64.6040402@fb.com>
References: <1402057225-7312-1-git-send-email-m@bjorling.me>
	<1402057225-7312-2-git-send-email-m@bjorling.me>
	<CACVXFVOieM2cT4FFJhD9MecfCLBtE3AwjCpOeGGRUcmWnN=B=A@mail.gmail.com>
	<5395BFF2.2080402@fb.com>
	<CACVXFVPGO9vsOv_uVa0+5AdBduu1RJ0Fmg8XPx1QgJAvnjKj_g@mail.gmail.com>
	<5395CE64.6040402@fb.com>
Date: Mon, 9 Jun 2014 23:15:58 +0800
Message-ID: <CACVXFVMQ_ehnsj=7+6-WmKLSQAhDRDvOEnE6Ekbwj8sfYuuRAA@mail.gmail.com>
Subject: Re: [PATCH v6] NVMe: conversion to blk-mq
From: Ming Lei <tom.leiming@gmail.com>
To: Jens Axboe <axboe@fb.com>
Cc: =?UTF-8?Q?Matias_Bj=C3=B8rling?= <m@bjorling.me>,
        Matthew Wilcox <willy@linux.intel.com>,
        Keith Busch <keith.busch@intel.com>,
        "Sam Bradshaw (sbradshaw)" <sbradshaw@micron.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-nvme <linux-nvme@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 9, 2014 at 11:10 PM, Jens Axboe <axboe@fb.com> wrote:
> On 2014-06-09 09:07, Ming Lei wrote:
>
> You are right, I didn't get to the bottom of the thread first.
> Might be better to just have ->start_time set always, regardless of io stats
> being enabled or not.

Yes, just like what non-mq code did.


Thanks,
-- 
Ming Lei
