Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753641Ab3HHEJv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 00:09:51 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:21513 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750970Ab3HHEJu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 00:09:50 -0400
Message-ID: <520319CF.5000603@huawei.com>
Date: Thu, 8 Aug 2013 12:08:47 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Peter Zijlstra <peterz@infradead.org>, <gaoyang.zyh@taobao.com>,
        LKML <linux-kernel@vger.kernel.org>, stable <stable@vger.kernel.org>
Subject: Re: stable: a59f4e079d19464eebb9b06513a1d4f55fdae5ba needs backport
 ?
References: <51FB7DF5.8030600@huawei.com> <20130802111455.GA29304@gmail.com>
In-Reply-To: <20130802111455.GA29304@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Could you queue this commit for 3.0 and 3.4? It has been acked by Ingo.

On 2013/8/2 19:14, Ingo Molnar wrote:
> 
> * Li Zefan <lizefan@huawei.com> wrote:
> 
>> commit a59f4e079d19464eebb9b06513a1d4f55fdae5ba
>> Author: Zhu Yanhai <gaoyang.zyh@taobao.com>
>> Date:   Tue Jan 8 12:56:52 2013 +0800
>>
>>     sched: Fix the broken sched_rr_get_interval()
>>
>> Without this patch, syscall sched_rr_get_interval() can return wrong
>> value, and the bug was introduced in 2.6.24, so this looks like a
>> candidate for stable kernel.
>>
>> The concern for backporting is that this might break some userspace
>> programs? As the changelog says:
>>
>>     [ Since this is an ABI and an old bug, we'll test this via a
>>       slow upstream route, to hopefully discover any app breakage. ]
> 
> It appears to have caused no trouble.
> 
> So I'm fine with backporting it to older -stable kernels:
> 
> Acked-by: Ingo Molnar <mingo@kernel.org>
> 
> Thanks,
> 
> 	Ingo
> 

