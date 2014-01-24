Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752189AbaAXRdv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 12:33:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:20566 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750997AbaAXRdu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 12:33:50 -0500
Date: Fri, 24 Jan 2014 12:33:47 -0500 (EST)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Mikael Pettersson <mikpelinux@gmail.com>
cc: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
        linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] ia64 ski emulator patches
In-Reply-To: <21218.28095.779306.523187@gargle.gargle.HOWL>
Message-ID: <alpine.LRH.2.02.1401241232090.23466@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1401232041520.16873@file01.intranet.prod.int.rdu2.redhat.com> <21218.28095.779306.523187@gargle.gargle.HOWL>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 24 Jan 2014, Mikael Pettersson wrote:

> Mikulas Patocka writes:
>  > Hi
>  > 
>  > Here I'm sending some ia64 patches to make it work in the ski emulator. 
>  > This has been broken for a long time.
> 
> Thanks.  I've recently started running 3.x kernels on ia64 via ski,
> but I'm getting random kernel crashes with 3.13.  I'll give your
> patches a try shortly.

BTW. does the kernel boot for you without that _STK_LIM_MAX change? For 
me, _STK_LIM_MAX was a showstopper, it wasn't able to spawn any userspace 
process without this patch.

Mikulkas
