Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751466AbaLXDUc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 22:20:32 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:16144 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751231AbaLXDUb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 22:20:31 -0500
Message-ID: <549A30B2.5000408@hisilicon.com>
Date: Wed, 24 Dec 2014 11:19:14 +0800
From: Wei Xu <xuwei5@hisilicon.com>
Organization: hisilicon
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Wang Long <long.wanglong@huawei.com>
CC: <arnd@arndb.de>, <yanhaifeng@gmail.com>, <zhangfei.gao@linaro.org>,
        <haojian.zhuang@linaro.org>, <khilman@linaro.org>,
        <lee.jones@linaro.org>, <linux@arm.linux.org.uk>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <peifeiyue@huawei.com>, <huxinwei@huawei.com>
Subject: Re: [PATCH 0/7] ARM: hisi: enable HiP01 SoC
References: <1419390602-193123-1-git-send-email-long.wanglong@huawei.com>
In-Reply-To: <1419390602-193123-1-git-send-email-long.wanglong@huawei.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.66.75.104]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 2014/12/24 11:09, Wang Long wrote:
> Hi, Xu Wei
> 
> This series patch enable Hisilicon HiP01 SoC. The HiP01 SoC series
> chip is designed for networking product, it integrates a rich peripheral
> interfaces to support network applications and supports both one 
> core or dual cores and quad cores. The core is Cortex A9. 

Hi Wang Long,

> This series patch rebased on Linux 3.19-rc1.

Thanks!
I will pick up these patch set and sent a pull request to arm@kernel.org.

Best Regards,
Wei

> Best Regards
> 
> Wang Long (7):
>   ARM: debug: add HiP01 debug uart
>   ARM: hisi: enable HiP01 SoC
>   ARM: dts: Add hip01-ca9x2 dts file
>   ARM: config: enable ARCH_HIP01
>   ARM: hisi: add a common smp_prepares_cpus function
>   ARM: hisi: rename secondary_startup function
>   ARM: hisi: enable smp for HiP01
> 
>  .../bindings/arm/hisilicon/hisilicon.txt           |  25 +++++
>  arch/arm/Kconfig.debug                             |  10 ++
>  arch/arm/boot/dts/Makefile                         |   1 +
>  arch/arm/boot/dts/hip01-ca9x2.dts                  |  51 ++++++++++
>  arch/arm/boot/dts/hip01.dtsi                       | 110 +++++++++++++++++++++
>  arch/arm/configs/hisi_defconfig                    |   1 +
>  arch/arm/configs/multi_v7_defconfig                |   1 +
>  arch/arm/mach-hisi/Kconfig                         |   8 ++
>  arch/arm/mach-hisi/core.h                          |   5 +-
>  arch/arm/mach-hisi/headsmp.S                       |   2 +-
>  arch/arm/mach-hisi/hisilicon.c                     |  10 ++
>  arch/arm/mach-hisi/hotplug.c                       |  31 ++++++
>  arch/arm/mach-hisi/platsmp.c                       |  56 ++++++++++-
>  13 files changed, 306 insertions(+), 5 deletions(-)
>  create mode 100644 arch/arm/boot/dts/hip01-ca9x2.dts
>  create mode 100644 arch/arm/boot/dts/hip01.dtsi
> 

