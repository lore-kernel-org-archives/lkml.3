Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755086AbaJJTMj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 15:12:39 -0400
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:57844 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751867AbaJJTMh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 15:12:37 -0400
X-IronPort-AV: E=Sophos;i="5.04,693,1406617200"; 
   d="scan'208";a="47788817"
Message-ID: <54382FA0.3070506@broadcom.com>
Date: Fri, 10 Oct 2014 12:12:32 -0700
From: Scott Branden <sbranden@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, <linux-arm-kernel@lists.infradead.org>
CC: Christian Daudt <bcm@fixthebug.org>, Matt Porter <mporter@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        <bcm-kernel-feedback-list@broadcom.com>,
        Mike Turquette <mturquette@linaro.org>, Alex Elder <elder@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        "Kumar Gala" <galak@codeaurora.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joe Perches <joe@perches.com>,
        "Mauro Carvalho Chehab" <m.chehab@samsung.com>,
        Antti Palosaari <crope@iki.fi>, <devicetree@vger.kernel.org>,
        Ray Jui <rjui@broadcom.com>, <linux-kernel@vger.kernel.org>,
        JD Zheng <jdzheng@broadcom.com>
Subject: Re: [PATCH V4 7/7] ARM: multi_v7_defconfig: Enable ARCH_BCM_CYGNUS
 config
References: <1412894671-5921-8-git-send-email-sbranden@broadcom.com> <8180880.ZD9iHlqhNz@wuerfel>
In-Reply-To: <8180880.ZD9iHlqhNz@wuerfel>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14-10-10 02:59 AM, Arnd Bergmann wrote:
> On Thursday 09 October 2014 15:44:31 Scott Branden wrote:
>> Enabled Broadcom Cygnus SoC family in multi_v7_defconfig by using
>> CONFIG_ARCH_BCM_CYGNUS=y.
>>
>> Signed-off-by: Scott Branden <sbranden@broadcom.com>
>> ---
>>   arch/arm/configs/multi_v7_defconfig |    1 +
>>   1 file changed, 1 insertion(+)
>>
>> diff --git a/arch/arm/configs/multi_v7_defconfig b/arch/arm/configs/multi_v7_defconfig
>> index 5fb95fb..d02f56d 100644
>> --- a/arch/arm/configs/multi_v7_defconfig
>> +++ b/arch/arm/configs/multi_v7_defconfig
>> @@ -17,6 +17,7 @@ CONFIG_MACH_ARMADA_38X=y
>>   CONFIG_MACH_ARMADA_XP=y
>>   CONFIG_MACH_DOVE=y
>>   CONFIG_ARCH_BCM=y
>> +CONFIG_ARCH_BCM_CYGNUS=y
>>   CONFIG_ARCH_BCM_MOBILE=y
>>   CONFIG_ARCH_BCM_5301X=y
>>   CONFIG_ARCH_BRCMSTB=y
>>
>
> Does this contain all the drivers you need that are enabled in cygnus_defconfig?
Will enable more - thanks for reminding.
>
> 	Arnd
>

