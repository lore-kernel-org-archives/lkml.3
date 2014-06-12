Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933400AbaFLOck (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 10:32:40 -0400
Received: from mail-lb0-f177.google.com ([209.85.217.177]:59090 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752874AbaFLOcj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 10:32:39 -0400
Message-ID: <5399BA00.7000705@bjorling.me>
Date: Thu, 12 Jun 2014 16:32:32 +0200
From: =?UTF-8?B?TWF0aWFzIEJqw7hybGluZw==?= <m@bjorling.me>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Keith Busch <keith.busch@intel.com>
CC: Matthew Wilcox <willy@linux.intel.com>, Jens Axboe <axboe@fb.com>,
        "sbradshaw@micron.com" <sbradshaw@micron.com>,
        "tom.leiming@gmail.com" <tom.leiming@gmail.com>,
        "hch@infradead.org" <hch@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>
Subject: Re: [PATCH v7] NVMe: conversion to blk-mq
References: <1402392038-5268-2-git-send-email-m@bjorling.me> <alpine.LRH.2.03.1406100945250.4699@AMR> <A52B97CC-6D77-468B-9A9B-A5888AE63580@fb.com> <alpine.LRH.2.03.1406101140490.4699@AMR> <5397636F.9050209@fb.com> <alpine.LRH.2.03.1406101458470.4699@AMR> <5397753B.2020009@fb.com> <alpine.LRH.2.03.1406101515430.4699@AMR> <20140610213333.GA10055@linux.intel.com> <539889DC.7090704@fb.com> <20140611170917.GA12025@linux.intel.com> <CAOu_J6kocZZ1mRQeSidyqJ_Ew0F_POS30v2kgUZX2wDOOnuExg@mail.gmail.com> <alpine.LRH.2.03.1406111641180.4699@AMR>
In-Reply-To: <alpine.LRH.2.03.1406111641180.4699@AMR>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/12/2014 12:51 AM, Keith Busch wrote:
> On Wed, 11 Jun 2014, Matias Bjørling wrote:
>> I've rebased nvmemq_review and added two patches from Jens that add
>> support for requests with single range virtual addresses.
>>
>> Keith, will you take it for a spin and see if it fixes 068 for you?
>>
>> There might still be a problem with some flushes, I'm looking into this.
>
> So far so good: it passed the test that was previously failing. I'll
> let the remaining xfstests run and see what happens.

Great.

The flushes was a fluke. I haven't been able to reproduce.
