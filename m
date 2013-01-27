Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756255Ab3A0Iru (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2013 03:47:50 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:17731 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756236Ab3A0Irs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2013 03:47:48 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Sun, 27 Jan 2013 00:46:58 -0800
Message-ID: <5104E937.1090008@nvidia.com>
Date: Sun, 27 Jan 2013 14:15:43 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Samuel Ortiz <sameo@linux.intel.com>
CC: "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "a.zummo@towertech.it" <a.zummo@towertech.it>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>
Subject: Re: [PATCH 0/4] mfd: palma: add RTC and GPIO support
References: <1357210020-19876-1-git-send-email-ldewangan@nvidia.com> <20130127002821.GF1174@sortiz-mobl>
In-Reply-To: <20130127002821.GF1174@sortiz-mobl>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 27 January 2013 05:58 AM, Samuel Ortiz wrote:
> Hi Laxman,
>
> On Thu, Jan 03, 2013 at 04:16:56PM +0530, Laxman Dewangan wrote:
>> This series add the RTC and gpio driver for the TI Palma series PMIC.
>> The changes are splitted so that easy to apply in different sub systems.
>>
>> Laxman Dewangan (4):
>>    mfd: palmas: add rtc irq number as irq resource for palmas-rtc
>>    mfd: palmas: add apis to access the Palmas' registers
>>    gpio: palmas: Add support for Palams GPIO
>>    rtc: palmas: add RTC driver Palmas series PMIC
> All 4 patches applied to my for-next branch, thanks.
Hi Samuel,

Thanks for taking care. But it seems 2/4 of this series is missed which 
is very important for 3/4 and 4/4 to be compile.

Can you please apply the 2/4 before 3/4 and 4/4?

Thanks,
Laxman

