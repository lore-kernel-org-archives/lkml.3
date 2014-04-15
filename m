Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750983AbaDOTk3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 15:40:29 -0400
Received: from mail-ee0-f42.google.com ([74.125.83.42]:38086 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751471AbaDOTk1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 15:40:27 -0400
Message-ID: <534D8B25.3070103@gmail.com>
Date: Tue, 15 Apr 2014 21:40:21 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
CC: Olof Johansson <olof@lixom.net>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        =?ISO-8859-1?Q?Antoine_T=E9nart?= 
	<antoine.tenart@free-electrons.com>,
        Jimmy Xu <zmxu@marvell.com>, Jisheng Zhang <jszhang@marvell.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 2/2] ARM: multi_v7_defconfig: Select CONFIG_MACH_BERLIN_BG2Q
References: <1395430757-8677-1-git-send-email-alexandre.belloni@free-electrons.com> <1395430757-8677-2-git-send-email-alexandre.belloni@free-electrons.com> <532CB266.6050800@gmail.com>
In-Reply-To: <532CB266.6050800@gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/21/2014 10:43 PM, Sebastian Hesselbarth wrote:
> On 03/21/2014 08:39 PM, Alexandre Belloni wrote:
>> Now that we support Berlin BG2Q, select CONFIG_MACH_BERLIN_BG2Q so
>> that we can
>> boot BG2Q based boards like the BG2Q DMP.
>>
>> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
> 
> Applied to berlin/soc, Thanks!

After talking to Arnd on IRC, I found out it is not my business
taking patches for multi_v7_defconfig.

Instead of me taking it, you get my

Acked-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>

>> ---
>>   arch/arm/configs/multi_v7_defconfig | 1 +
>>   1 file changed, 1 insertion(+)
>>
>> diff --git a/arch/arm/configs/multi_v7_defconfig
>> b/arch/arm/configs/multi_v7_defconfig
>> index ee6982976d66..8b09b72fb688 100644
>> --- a/arch/arm/configs/multi_v7_defconfig
>> +++ b/arch/arm/configs/multi_v7_defconfig
>> @@ -15,6 +15,7 @@ CONFIG_ARCH_BCM_MOBILE=y
>>   CONFIG_ARCH_BERLIN=y
>>   CONFIG_MACH_BERLIN_BG2=y
>>   CONFIG_MACH_BERLIN_BG2CD=y
>> +CONFIG_MACH_BERLIN_BG2Q=y
>>   CONFIG_GPIO_PCA953X=y
>>   CONFIG_ARCH_HIGHBANK=y
>>   CONFIG_ARCH_HI3xxx=y
>>
> 

