Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751839AbaDACZq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 22:25:46 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:43397 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751171AbaDACZo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 22:25:44 -0400
Message-ID: <533A2352.7000306@huawei.com>
Date: Tue, 1 Apr 2014 10:24:18 +0800
From: Yijing Wang <wangyijing@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
CC: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, <linux-rt-users@vger.kernel.org>,
        "Li Zefan" <lizefan@huawei.com>, Zhangwei <jovi.zhangwei@huawei.com>
Subject: Re: [BUGREPORT] Tasklet scheduled issue in Linux 3.4.x-rt
References: <53144A57.4040204@huawei.com> <20140328163753.GB14842@linutronix.de> <533669C7.0@huawei.com> <53394296.5030906@linutronix.de>
In-Reply-To: <53394296.5030906@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.27.212]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Because this patch does not exist in the latest Linus kernel, so I
>> have not reported this issue to kernel bugzilla.
> 
> This patch exists in all -RT releases up to 3.12. If there is an issue
> with it, it should be solved.
> 
> If the sched bit set is and you can't get lock later then the tasklet
> has be to active. Finally, not getting the lock in the tasklet code
> itself means it is still occupied by the "add-to-the-list" part which
> actually can't happen according to the code.
> You said, that you have an eight-way. Is this also NUMA? If so, does
> this problem happen if you disable NUMA (i.e. run only one NUMA node
> and use only the memory that is directly attached to the node).

Hi Sebastian,
   The target platform is not NUMA, there is only one node.

Thanks!
Yijing.

> 
> 


-- 
Thanks!
Yijing

