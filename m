Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756057Ab3GBBmT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 21:42:19 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:46164 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755648Ab3GBBmS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 21:42:18 -0400
Message-ID: <51D22FDA.1020200@huawei.com>
Date: Tue, 2 Jul 2013 09:41:46 +0800
From: Xie XiuQi <xiexiuqi@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Li Zefan <lizefan@huawei.com>, Zhang Hang <bob.zhanghang@huawei.com>,
        Li Bin <huawei.libin@huawei.com>
Subject: Re: [PATCH] sched: fix cpu utilization account error
References: <51D12570.9070100@huawei.com> <20130701151916.GE17971@kroah.com>
In-Reply-To: <20130701151916.GE17971@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.69.18]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/7/1 23:19, Greg KH wrote:
> On Mon, Jul 01, 2013 at 02:45:04PM +0800, Xie XiuQi wrote:
>> We setting clock_skip_update = 1 based on the assumption that the
>> next call to update_rq_clock() will come nearly immediately
>> after being set. However, it is not always true especially on
>> non-preempt mode. In this case we may miss some clock update, which
>> would cause an error curr->sum_exec_runtime account.
>>
...
> 
> <formletter>
> 
> This is not the correct way to submit patches for inclusion in the
> stable kernel tree.  Please read Documentation/stable_kernel_rules.txt
> for how to do this properly.

Thanks Greg,
I've removed stable@vger.kernel.org from recipient list now.

> 
> </formletter>
> 



