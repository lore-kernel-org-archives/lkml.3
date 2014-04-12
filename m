Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751158AbaDLE2G (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2014 00:28:06 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:29327 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750816AbaDLE2E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2014 00:28:04 -0400
Message-ID: <5348C040.1060305@huawei.com>
Date: Sat, 12 Apr 2014 12:25:36 +0800
From: Liu hua <sdu.liu@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Nicolas Pitre <nicolas.pitre@linaro.org>
CC: <linux@arm.linux.org.uk>, <will.deacon@arm.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <wangnan0@huawei.com>, <peifeiyue@huawei.com>, <liusdu@126.com>,
        <m.szyprowski@samsung.com>
Subject: Re: [PATCH v2 1/2] ARM : DMA : remove useless information about DMA
References: <1397203252-22977-1-git-send-email-sdu.liu@huawei.com> <1397203252-22977-2-git-send-email-sdu.liu@huawei.com> <alpine.LFD.2.11.1404112252050.980@knanqh.ubzr>
In-Reply-To: <alpine.LFD.2.11.1404112252050.980@knanqh.ubzr>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.111.58.238]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nicolas,

Your version is better. you tell me this in the former letters.
So I am very sorry to forget to check that.

May be I should remake this second patch to fit your change. What do
you think about that patch?

Liu Hua

On 2014/4/12 11:12, Nicolas Pitre wrote:
> On Fri, 11 Apr 2014, Liu Hua wrote:
> 
>> Because commit e9da6e9905e6 has remove custom consistent dma
>> region. So the related variable and document should be removed
>>
>> Signed-off-by: Liu Hua <sdu.liu@huawei.com>
> 
> Acked-by: Nicolas Pitre <nico@linaro.org>
> 
> Incidentally I sent an identical patch to RMK's patch system:
> 
> http://www.arm.linux.org.uk/developer/patches/viewpatch.php?id=8023/1
> 
> Either version is fine with me.
> 
> 
> Nicolas
> 
> 


