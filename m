Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751344Ab3HBLPD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 07:15:03 -0400
Received: from mail-ee0-f51.google.com ([74.125.83.51]:34711 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750848Ab3HBLPA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 07:15:00 -0400
Date: Fri, 2 Aug 2013 13:14:55 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Peter Zijlstra <peterz@infradead.org>, gaoyang.zyh@taobao.com,
        LKML <linux-kernel@vger.kernel.org>, stable <stable@vger.kernel.org>
Subject: Re: stable: a59f4e079d19464eebb9b06513a1d4f55fdae5ba needs backport ?
Message-ID: <20130802111455.GA29304@gmail.com>
References: <51FB7DF5.8030600@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51FB7DF5.8030600@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Li Zefan <lizefan@huawei.com> wrote:

> commit a59f4e079d19464eebb9b06513a1d4f55fdae5ba
> Author: Zhu Yanhai <gaoyang.zyh@taobao.com>
> Date:   Tue Jan 8 12:56:52 2013 +0800
> 
>     sched: Fix the broken sched_rr_get_interval()
> 
> Without this patch, syscall sched_rr_get_interval() can return wrong
> value, and the bug was introduced in 2.6.24, so this looks like a
> candidate for stable kernel.
> 
> The concern for backporting is that this might break some userspace
> programs? As the changelog says:
> 
>     [ Since this is an ABI and an old bug, we'll test this via a
>       slow upstream route, to hopefully discover any app breakage. ]

It appears to have caused no trouble.

So I'm fine with backporting it to older -stable kernels:

Acked-by: Ingo Molnar <mingo@kernel.org>

Thanks,

	Ingo
