Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753241Ab3HBN5S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 09:57:18 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:47472 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753106Ab3HBN5R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 09:57:17 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Li Zefan <lizefan@huawei.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Peter Zijlstra <peterz@infradead.org>, gaoyang.zyh@taobao.com,
        LKML <linux-kernel@vger.kernel.org>, stable <stable@vger.kernel.org>
Subject: Re: stable: a59f4e079d19464eebb9b06513a1d4f55fdae5ba needs backport ?
References: <51FB7DF5.8030600@huawei.com> <20130802111455.GA29304@gmail.com>
Date: Fri, 02 Aug 2013 14:57:03 +0100
In-Reply-To: <20130802111455.GA29304@gmail.com> (Ingo Molnar's message of
	"Fri, 2 Aug 2013 13:14:55 +0200")
Message-ID: <8761vo2o28.fsf@canonical.com>
User-Agent: Gnus/5.130008 (Ma Gnus v0.8) Emacs/24.3.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@kernel.org> writes:

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
> --
> To unsubscribe from this list: send the line "unsubscribe stable" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Thanks, I'm queuing it for the 3.5 kernel.

Cheers,
-- 
Luis
