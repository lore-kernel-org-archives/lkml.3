Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752164Ab3AVFNp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 00:13:45 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:17907 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750942Ab3AVFNn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 00:13:43 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 21 Jan 2013 21:12:21 -0800
Message-ID: <50FE1FE4.5080802@nvidia.com>
Date: Tue, 22 Jan 2013 10:43:08 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>
CC: Linus Walleij <linus.walleij@linaro.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: build failure after merge of the final tree (gpio-lw
 tree related)
References: <20130122151048.e47ecfe9432b747f79544c25@canb.auug.org.au> <50FE1F95.4050000@nvidia.com>
In-Reply-To: <50FE1F95.4050000@nvidia.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To to Samuel.


On Tuesday 22 January 2013 10:41 AM, Laxman Dewangan wrote:
> On Tuesday 22 January 2013 09:40 AM, Stephen Rothwell wrote:
>> * PGP Signed by an unknown key
>>
>> Hi all,
>>
>> After merging the final tree, today's linux-next build (powerpc
>> allyesconfig) failed like this:
>>
>> drivers/gpio/gpio-palmas.c: In function 'palmas_gpio_get':
>> drivers/gpio/gpio-palmas.c:46:2: error: implicit declaration of 
>> function 'palmas_read' [-Werror=implicit-function-declaration]
>> drivers/gpio/gpio-palmas.c: In function 'palmas_gpio_set':
>> drivers/gpio/gpio-palmas.c:62:3: error: implicit declaration of 
>> function 'palmas_write' [-Werror=implicit-function-declaration]
>> drivers/gpio/gpio-palmas.c: In function 'palmas_gpio_output':
>> drivers/gpio/gpio-palmas.c:83:2: error: implicit declaration of 
>> function 'palmas_update_bits' [-Werror=implicit-function-declaration]
>> drivers/gpio/gpio-palmas.c: In function 'palmas_gpio_to_irq':
>> drivers/gpio/gpio-palmas.c:108:2: error: implicit declaration of 
>> function 'palmas_irq_get_virq' [-Werror=implicit-function-declaration]
>>
>> Caused by commit 4bb49f0dc999 ("gpio: palmas: Add support for Palams
>> GPIO").
>>
>> I have reverted that commit for today.
> The changes from the series need to apply on mfd subsystem also. The 
> changes are not yet merged and hence the issue.
>
> Requesting Samuel for considering the patch series
> [PATCH 0/4] mfd: palma: add RTC and GPIO support
>
> and atleast apply
> [PATCH 2/4] mfd: palmas: add apis to access the Palmas' registers
>

