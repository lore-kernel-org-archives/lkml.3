Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754780AbaJIDHW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 23:07:22 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:15048 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753236AbaJIDHS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 23:07:18 -0400
Message-ID: <5435FBD8.7020109@huawei.com>
Date: Thu, 9 Oct 2014 11:07:04 +0800
From: zhangzhiqiang <zhangzhiqiang.zhang@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Will Deacon <will.deacon@arm.com>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Mark Rutland <Mark.Rutland@arm.com>,
        "cov@codeaurora.org" <cov@codeaurora.org>,
        "lizefan@huawei.com" <lizefan@huawei.com>,
        "wangnan0@huawei.com" <wangnan0@huawei.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] arm: armv7: perf: fix armv7 ref-cycles error
References: <5434AA24.7010600@huawei.com> <20141008091741.GC26140@arm.com> <20141008133147.GC5119@kroah.com> <20141008133802.GO26140@arm.com>
In-Reply-To: <20141008133802.GO26140@arm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.111.58.157]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/10/8 21:38, Will Deacon wrote:
> On Wed, Oct 08, 2014 at 02:31:47PM +0100, gregkh@linuxfoundation.org wrote:
>> On Wed, Oct 08, 2014 at 10:17:41AM +0100, Will Deacon wrote:
>>> On Wed, Oct 08, 2014 at 04:06:12AM +0100, zhangzhiqiang wrote:
>>>> hi all,
>>>> ----------------------------------------
>>>>
>>>> ref-cycles event is specially to Intel core, but can still used in arm architecture
>>>> with the wrong return value with 3.10 stable. for instance:
>>>>
>>>>  perf stat -e ref-cycles sleep 1
>>>>
>>>>  Performance counter stats for 'sleep 1':
>>>>
>>>>   	0 ref-cycles
>>>>
>>>>        1.002381916 seconds time elapsed
>>>>
>>>> this patch fix the bug and make it return NOT SUPPORTED
>>>> distinctly.
>>>>
>>>> In upstream this bug has been fixed by other way(not primary for the bug), which changes more than one file
>>>> and more than 1000 lines. the primary commit is 6b7658ec8a100b608e59e3cde353434db51f5be0.
>>>> besides we can not simply cherry-pick.
>>>
>>> I thought I saw Greg pick this up the other day?
>>
>> Yes, it's in 3.16.4, did I do something wrong by accepting it?
> 
> Nah, it's a trivial patch that I struggle to get excited about. I'm just not
> sure why it's being sent again, after you already accepted it.

Yes, it's in 3.16.4, in my opinion 3.10 need it too, can we put it into 3.10 or
do we have the plan?




