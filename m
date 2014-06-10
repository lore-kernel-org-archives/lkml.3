Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751463AbaFJLzm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 07:55:42 -0400
Received: from mail-ve0-f182.google.com ([209.85.128.182]:38436 "EHLO
	mail-ve0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750891AbaFJLzl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 07:55:41 -0400
MIME-Version: 1.0
In-Reply-To: <20140610113540.GA26195@infradead.org>
References: <1402057225-7312-1-git-send-email-m@bjorling.me>
	<1402057225-7312-2-git-send-email-m@bjorling.me>
	<CACVXFVOieM2cT4FFJhD9MecfCLBtE3AwjCpOeGGRUcmWnN=B=A@mail.gmail.com>
	<5395BFF2.2080402@fb.com>
	<20140609145944.GA30626@infradead.org>
	<5395D24D.9000306@fb.com>
	<CACVXFVNNm5PJ8g=QD5zm49kaqW_oKCM+utMz+qSd=3WfsE4U2g@mail.gmail.com>
	<20140610113540.GA26195@infradead.org>
Date: Tue, 10 Jun 2014 19:55:40 +0800
Message-ID: <CACVXFVMG0SY57A4kMKE8WC=dNOiDJO+P4GLhzdVXVzMLset6sQ@mail.gmail.com>
Subject: Re: [PATCH v6] NVMe: conversion to blk-mq
From: Ming Lei <tom.leiming@gmail.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <axboe@fb.com>, "Matias Bj??rling" <m@bjorling.me>,
        Matthew Wilcox <willy@linux.intel.com>,
        Keith Busch <keith.busch@intel.com>,
        "Sam Bradshaw (sbradshaw)" <sbradshaw@micron.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-nvme <linux-nvme@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 10, 2014 at 7:35 PM, Christoph Hellwig <hch@infradead.org> wrote:
> On Mon, Jun 09, 2014 at 11:35:00PM +0800, Ming Lei wrote:
>>
>> Use-after-free may cause duplicate completions.
>>
>> BTW, is the scsi-mq patchset public now?
>
> It always has been.  I've posted it fairly frequently to linux-scsi,
> and git://git.infradead.org/users/hch/scsi.git always has the latest
> code, with scsi-mq-wip.11 as the current iteration.

That is great, thanks a lot for sharing it.

Even google can't tell me where the tree is, :-(

Thanks,
-- 
Ming Lei
