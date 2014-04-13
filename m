Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754537AbaDMMM0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2014 08:12:26 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:6067 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754122AbaDMMMZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2014 08:12:25 -0400
Message-ID: <534A7EA7.5090900@huawei.com>
Date: Sun, 13 Apr 2014 20:10:15 +0800
From: Liu hua <sdu.liu@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Nicolas Pitre <nicolas.pitre@linaro.org>
CC: <linux@arm.linux.org.uk>, <will.deacon@arm.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <wangnan0@huawei.com>, <peifeiyue@huawei.com>, <liusdu@126.com>,
        <m.szyprowski@samsung.com>
Subject: Re: [PATCH v2 1/2] ARM : DMA : remove useless information about DMA
References: <1397203252-22977-1-git-send-email-sdu.liu@huawei.com> <1397203252-22977-2-git-send-email-sdu.liu@huawei.com> <alpine.LFD.2.11.1404112252050.980@knanqh.ubzr> <5348C040.1060305@huawei.com> <alpine.LFD.2.11.1404121031170.980@knanqh.ubzr>
In-Reply-To: <alpine.LFD.2.11.1404121031170.980@knanqh.ubzr>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.111.58.238]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/4/12 22:32, Nicolas Pitre write:
> On Sat, 12 Apr 2014, Liu hua wrote:
> 
>> Hi Nicolas,
>>
>> Your version is better. you tell me this in the former letters.
>> So I am very sorry to forget to check that.
>>
>> May be I should remake this second patch to fit your change. What do
>> you think about that patch?
> 
> You may simply drop your first patch and only keep the other two.
> 
Sure. But your patch and my second one both change Document/arm/memory.txt.
I am afraid there will be conflicts when someone tests my patch before
yours getting into the mainline.

Maybe I can spilt the document-changing part to a new patch. And send it
after yours are in the mainline.

Liu Hua
> 
> Nicolas
> 
> 


