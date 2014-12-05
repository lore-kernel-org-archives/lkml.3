Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932943AbaLEAgJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 19:36:09 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:58926 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752093AbaLEAgG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 19:36:06 -0500
Message-ID: <5480FD7A.6030802@hisilicon.com>
Date: Fri, 5 Dec 2014 08:34:02 +0800
From: Wei Xu <xuwei5@hisilicon.com>
Organization: hisilicon
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, <linux-arm-kernel@lists.infradead.org>
CC: Wang Long <long.wanglong@huawei.com>, <yanhaifeng@gmail.com>,
        <zhangfei.gao@linaro.org>, <haojian.zhuang@linaro.org>,
        <galak@codeaurora.org>, <ijc+devicetree@hellion.org.uk>,
        <jason@lakedaemon.net>, <jh80.chung@samsung.com>, <khilman@linaro.org>,
        <lee.jones@linaro.org>, <linux@arm.linux.org.uk>,
        <mark.rutland@arm.com>, <maxime.ripard@free-electrons.com>,
        <obh+dt@kernel.org>, <olof@lixom.net>, <pawel.moll@arm.com>,
        <swarren@nvidia.com>, <thomas.petazzoni@free-electrons.com>,
        <huxinwei@huawei.com>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <peifeiyue@huawei.com>
Subject: Re: [PATCH 0/7] ARM: hisi: enable HiP01 SoC
References: <1417140950-67103-1-git-send-email-long.wanglong@huawei.com> <3601066.g7Jvjk5UFL@wuerfel>
In-Reply-To: <3601066.g7Jvjk5UFL@wuerfel>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.66.75.104]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 2014/12/4 20:58, Arnd Bergmann wrote:
> On Friday 28 November 2014 02:15:43 Wang Long wrote:
>> This series patch enable Hisilicon HiP01 SoC. The HiP01 SoC series
>> chip is designed for networking product, it integrates a rich peripheral
>> interfaces to support network applications and supports both one 
>> core or dual cores and quad cores. The core is Cortex A9. 
> 
> Sorry for the delay in my reply. The patches look good to me, but I'm
> not sure what you expect to happen to them. You have a number of
> people listed as recipients, but it's not clear if you expect any of
> us to apply them into a git tree.

Hi Arnd,

> Is Xu Wei going to pick these up in a git tree and send a pull request
> to arm@kernel.org?

I will send a pull request about it.
Thanks!

Best Regards,
Wei

> 	Arnd
> 
> .
> 

