Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752508AbaE0E5N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 00:57:13 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:64935 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750772AbaE0E5M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 00:57:12 -0400
Message-ID: <53841B0A.1030404@huawei.com>
Date: Tue, 27 May 2014 12:56:42 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Yong Zhang <yong.zhang@windriver.com>
CC: <ralf@linux-mips.org>, <huawei.libin@huawei.com>,
        <linux-mips@linux-mips.org>, <linux-kernel@vger.kernel.org>,
        Xinwei Hu <huxinwei@huawei.com>
Subject: Re: [PATCH V2] MIPS: change type of asid_cache to unsigned long
References: <1400650563-1033-1-git-send-email-yong.zhang@windriver.com> <5384119E.7010606@huawei.com> <20140527043433.GA16193@pek-yzhang-d1>
In-Reply-To: <20140527043433.GA16193@pek-yzhang-d1>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.18.230]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/5/27 12:34, Yong Zhang wrote:
> On Tue, May 27, 2014 at 12:16:30PM +0800, Li Zefan wrote:
>> I'm not quite happy about what happaned here. There's a story behind
>> this patch.
>>
>> One of our Huawei product encountered a bug, and they're using WindRiver4,
>> so the kernel is 2.6.34.
>>
>> Because they bought your licnece, they asked for your help, but
>> you were reluctant on this issue, and the problem remained there
>> for about one month.
>>
>> At last they turned to us for help. We're the kernel department in
>> Huawei, but maintaining this product kernel isn't our job. Still
>> Li Bin devoted his time to analyzing this bug, and he did a great
>> job.
>>
>> Li Bin told the product team what was wrong and was about to send
>> a fix for upstream kernel.
> 
> You have time to do that but you didn't.
> 

Hah yeah, we do have time. we spent lots of time analyzing the bug,
and we were taking our time to write good changelog. As I've pointed
out that your changelog isn't informative.

>> They told you our analysis for further
>> confirmation,
> 
> So you realy didn't make the patch, right? Because you are not
> sure the right fix.
> 

We're confident about our analysis and we know how to fix it.

It's the product team wasn't sure about this, and they wasn't
able to contact with Li Bin for confirmation at that time, so they
asked you.

>> and you were so reluctant to help but so quick to
>> send the fix.
> 
> We have responsed to you.
> 

You responded to us but you did nothing to help, that's why the
product team found us.

>>
>> Li Bin never reported this bug, but he fixed it. It's a shame that
>> you took the credit from us.
> 
> I just saw a bug report and ananysis. And I agreed and confirmed it's
> a bug.
> 

And that's our work and our credit, and I don't think you're gonna
to deny it.

