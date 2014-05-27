Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752962AbaE0Fwj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 01:52:39 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:15192 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752639AbaE0Fwg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 01:52:36 -0400
Message-ID: <53842806.1020307@huawei.com>
Date: Tue, 27 May 2014 13:52:06 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Yong Zhang <yong.zhang@windriver.com>
CC: <ralf@linux-mips.org>, <huawei.libin@huawei.com>,
        <linux-mips@linux-mips.org>, <linux-kernel@vger.kernel.org>,
        Xinwei Hu <huxinwei@huawei.com>
Subject: Re: [PATCH V2] MIPS: change type of asid_cache to unsigned long
References: <1400650563-1033-1-git-send-email-yong.zhang@windriver.com> <5384119E.7010606@huawei.com> <20140527045038.GB16193@pek-yzhang-d1> <53841D88.3040306@huawei.com> <20140527052307.GA16493@pek-yzhang-d1>
In-Reply-To: <20140527052307.GA16493@pek-yzhang-d1>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.18.230]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/5/27 13:23, Yong Zhang wrote:
> On Tue, May 27, 2014 at 01:07:20PM +0800, Li Zefan wrote:
>> On 2014/5/27 12:50, Yong Zhang wrote:
>>> BTW, I realy don't care who credits the patch and Ralf said that
>>> he will applied the one which moves the place of udelay_val.
>>>
>>> Anyway, if your company pays you more money if you contribute to
>>> the community, just take it and talk about it with Ralf ;-)
>>>
>>
>> We don't do contribution for money, and I don't think you do,
>> but crediting properly is one of the reason that our kernel
>> community keeps prosperous for so many years, and that's one
>> of the reason we introduced Reported-by and Tested-by tags.
> 
> I'll reply this email for the last time.
> 
> To me your action is just like Reported-by, but I admit that
> you also do analysis. If you don't the way change it to whatever
> you want.
> 

Sorry if I sounded offensive. I want Li Bin to get the credit,
because he's supposed to, and I want him to be encouraged in
contributing to the mainline kernel.

The decision is on Ralf, whether to accept your patch or let
us send our fix with detailed changelog.

