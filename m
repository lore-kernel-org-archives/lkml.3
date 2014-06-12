Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755326AbaFLA6n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 20:58:43 -0400
Received: from mail-vc0-f172.google.com ([209.85.220.172]:56370 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752521AbaFLA6j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 20:58:39 -0400
MIME-Version: 1.0
In-Reply-To: <CACVXFVNzyu7k0wf-Gw9VgtHCtrYDdOs3OEDdpzivujpQOVyQfA@mail.gmail.com>
References: <1402057225-7312-1-git-send-email-m@bjorling.me>
	<1402057225-7312-2-git-send-email-m@bjorling.me>
	<CACVXFVOieM2cT4FFJhD9MecfCLBtE3AwjCpOeGGRUcmWnN=B=A@mail.gmail.com>
	<CAOu_J6kXB0rFJ+Z1-FcUwEVQ7dhKZseQBzVONhT1wG=41zFNGA@mail.gmail.com>
	<CACVXFVNGB0JzRVE8rQru3s12s0U9gtxd0t_ZhnUHQao4ppH8DQ@mail.gmail.com>
	<CACVXFVM-OUFv+gUnNcGt86FhS1BABV4sQxhCqPf20KKZTwNbyQ@mail.gmail.com>
	<CACVXFVNzyu7k0wf-Gw9VgtHCtrYDdOs3OEDdpzivujpQOVyQfA@mail.gmail.com>
Date: Thu, 12 Jun 2014 08:58:38 +0800
Message-ID: <CACVXFVPu6yZZXV_ET1M1zpnY-oa6QP6NqPdO9RzCT97nReGLvQ@mail.gmail.com>
Subject: Re: [PATCH v6] NVMe: conversion to blk-mq
From: Ming Lei <tom.leiming@gmail.com>
To: =?UTF-8?Q?Matias_Bj=C3=B8rling?= <m@bjorling.me>
Cc: Matthew Wilcox <willy@linux.intel.com>,
        Keith Busch <keith.busch@intel.com>,
        "Sam Bradshaw (sbradshaw)" <sbradshaw@micron.com>,
        Jens Axboe <axboe@fb.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-nvme <linux-nvme@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 9, 2014 at 6:40 PM, Ming Lei <tom.leiming@gmail.com> wrote:
> The root cause is that device returns
> NVME_INTERNAL_DEV_ERROR(0x6) with your conversion
> patch.

The above problem is caused by qemu not handling -EAGAIN from
io_submit(), so please ignore the report.


Thanks,
-- 
Ming Lei
