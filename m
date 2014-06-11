Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754368AbaFKWvQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 18:51:16 -0400
Received: from mga09.intel.com ([134.134.136.24]:58051 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752625AbaFKWvP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 18:51:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,461,1400050800"; 
   d="scan'208";a="555991069"
Date: Wed, 11 Jun 2014 16:51:13 -0600 (MDT)
From: Keith Busch <keith.busch@intel.com>
X-X-Sender: vmware@localhost.localdom
To: =?ISO-8859-15?Q?Matias_Bj=F8rling?= <m@bjorling.me>
cc: Matthew Wilcox <willy@linux.intel.com>, Jens Axboe <axboe@fb.com>,
        Keith Busch <keith.busch@intel.com>,
        "sbradshaw@micron.com" <sbradshaw@micron.com>,
        "tom.leiming@gmail.com" <tom.leiming@gmail.com>,
        "hch@infradead.org" <hch@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>
Subject: Re: [PATCH v7] NVMe: conversion to blk-mq
In-Reply-To: <CAOu_J6kocZZ1mRQeSidyqJ_Ew0F_POS30v2kgUZX2wDOOnuExg@mail.gmail.com>
Message-ID: <alpine.LRH.2.03.1406111641180.4699@AMR>
References: <1402392038-5268-2-git-send-email-m@bjorling.me> <alpine.LRH.2.03.1406100945250.4699@AMR> <A52B97CC-6D77-468B-9A9B-A5888AE63580@fb.com> <alpine.LRH.2.03.1406101140490.4699@AMR> <5397636F.9050209@fb.com> <alpine.LRH.2.03.1406101458470.4699@AMR>
 <5397753B.2020009@fb.com> <alpine.LRH.2.03.1406101515430.4699@AMR> <20140610213333.GA10055@linux.intel.com> <539889DC.7090704@fb.com> <20140611170917.GA12025@linux.intel.com> <CAOu_J6kocZZ1mRQeSidyqJ_Ew0F_POS30v2kgUZX2wDOOnuExg@mail.gmail.com>
User-Agent: Alpine 2.03 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-401976829-1402527074=:4699"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-401976829-1402527074=:4699
Content-Type: TEXT/PLAIN; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT

On Wed, 11 Jun 2014, Matias Bjørling wrote:
> I've rebased nvmemq_review and added two patches from Jens that add
> support for requests with single range virtual addresses.
>
> Keith, will you take it for a spin and see if it fixes 068 for you?
>
> There might still be a problem with some flushes, I'm looking into this.

So far so good: it passed the test that was previously failing. I'll
let the remaining xfstests run and see what happens.
--8323328-401976829-1402527074=:4699--
