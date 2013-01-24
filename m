Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753947Ab3AXEun (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 23:50:43 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:6494 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753172Ab3AXEui (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 23:50:38 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 23 Jan 2013 20:49:56 -0800
Message-ID: <5100BD49.4000003@nvidia.com>
Date: Thu, 24 Jan 2013 10:19:13 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: "sameo@linux.intel.com" <sameo@linux.intel.com>
CC: Laxman Dewangan <ldewangan@nvidia.com>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "a.zummo@towertech.it" <a.zummo@towertech.it>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>
Subject: Re: [PATCH 0/4] mfd: palma: add RTC and GPIO support
References: <1357210020-19876-1-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1357210020-19876-1-git-send-email-ldewangan@nvidia.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 03 January 2013 04:16 PM, Laxman Dewangan wrote:
> This series add the RTC and gpio driver for the TI Palma series PMIC.
> The changes are splitted so that easy to apply in different sub systems.
>
> Laxman Dewangan (4):
>    mfd: palmas: add rtc irq number as irq resource for palmas-rtc
>    mfd: palmas: add apis to access the Palmas' registers
>    gpio: palmas: Add support for Palams GPIO
>    rtc: palmas: add RTC driver Palmas series PMIC
>

Samuel,
I think you need to take all these patches to your tree as Linus has 
dropped the gpio patch due to build error. Possible same will apply for 
RTC change also.

Thanks,
Laxman
