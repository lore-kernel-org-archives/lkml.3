Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758183Ab3G3Ilk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 04:41:40 -0400
Received: from merlin.infradead.org ([205.233.59.134]:40197 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755121Ab3G3Ili (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 04:41:38 -0400
Date: Tue, 30 Jul 2013 10:41:27 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Xie XiuQi <xiexiuqi@huawei.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Hanjun Guo <guohanjun@huawei.com>, Li Zefan <lizefan@huawei.com>
Subject: Re: [PATCH v2] generic-ipi: kill unnecessary variable - csd_flags
Message-ID: <20130730084127.GJ3008@twins.programming.kicks-ass.net>
References: <51F72DA1.7010401@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51F72DA1.7010401@huawei.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 30, 2013 at 11:06:09AM +0800, Xie XiuQi wrote:
> After commit:8969a5ede0f9e17da4b943712429aef2c9bcd82b
> "generic-ipi: remove kmalloc()", wait = 0 can be guaranteed.
> 
> And all callsites of generic_exec_single() do an unconditional
> csd_lock() now.
> 
> So csd_flags is unnecessary now. Remote it.
> 
> Signed-off-by: Xie XiuQi <xiexiuqi@huawei.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Link: https://patchwork.kernel.org/patch/2834744/

Thanks!
