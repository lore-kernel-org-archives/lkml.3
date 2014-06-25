Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756812AbaFYMli (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 08:41:38 -0400
Received: from mail-pb0-f54.google.com ([209.85.160.54]:63407 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755297AbaFYMlh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 08:41:37 -0400
Message-ID: <53AAC376.7050705@linaro.org>
Date: Wed, 25 Jun 2014 20:41:26 +0800
From: zhangfei <zhangfei.gao@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Kishon Vijay Abraham I <kishon@ti.com>, mark.rutland@arm.com,
        haifeng.yan@linaro.org, jchxue@gmail.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        Jiancheng Xue <xuejiancheng@huawei.com>
Subject: Re: [PATCH v2 1/2] Documentation: Document Hisilicon hix5hd2 sata
 PHY
References: <1403687648-29082-1-git-send-email-zhangfei.gao@linaro.org> <1403687648-29082-2-git-send-email-zhangfei.gao@linaro.org> <201406251416.49561.arnd@arndb.de>
In-Reply-To: <201406251416.49561.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 06/25/2014 08:16 PM, Arnd Bergmann wrote:
> On Wednesday 25 June 2014, Zhangfei Gao wrote:
>> From: Jiancheng Xue <xuejiancheng@huawei.com>
>>
>> Add necessary binding documentation SATA PHY on Hisilicon hix5hd2 soc.
>>
>> Signed-off-by: Jiancheng Xue <xuejiancheng@huawei.com>
>> Signed-off-by: Zhangfei Gao <zhangfei.gao@linaro.org>
>
> We have had a couple of PHY drivers that were initially meant to be
> single-purpose but then turned out to be for hardware that could
> be put into multiple modes (SATA, gbit ethernet, PCIe, ...). Are
> you sure that this particular device is SATA-only?
>

Yes, double confimed.
Hix5hd2 phy diver only support sata phy, in fact, current soc only 
support synposis phy, since some internal physical link.
And hix5hd2 ethernet phy is already in hix5hd2_gmac.c.
No pcie support on hix5hd2 platfrom.

Thanks
