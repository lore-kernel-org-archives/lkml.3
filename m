Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753671Ab3COBn4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 21:43:56 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:41623 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753180Ab3COBnw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 21:43:52 -0400
X-IronPort-AV: E=Sophos;i="4.84,849,1355126400"; 
   d="scan'208";a="29858619"
Message-ID: <51427CD4.9070705@codeaurora.org>
Date: Thu, 14 Mar 2013 18:43:48 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH] ARM: Scorpion is a v7 architecture, not v6
References: <1362439159-29258-1-git-send-email-sboyd@codeaurora.org> <201303050831.37177.arnd@arndb.de>
In-Reply-To: <201303050831.37177.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/05/13 00:31, Arnd Bergmann wrote:
> On Monday 04 March 2013, Stephen Boyd wrote:
>> Scorpion processors have always been v7 CPUs. Fix the Kconfig
>> text to reflect this.
>>
>> Reported-by: Stepan Moskovchenko <stepanm@codeaurora.org>
>> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
>> ---
>>  arch/arm/Kconfig |    4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
>> index dedf02b..dc3bbbc 100644
>> --- a/arch/arm/Kconfig
>> +++ b/arch/arm/Kconfig
>> @@ -1006,12 +1006,12 @@ config ARCH_MULTI_V4_V5
>>         bool
>>  
>>  config ARCH_MULTI_V6
>> -       bool "ARMv6 based platforms (ARM11, Scorpion, ...)"
>> +       bool "ARMv6 based platforms (ARM11)"
>>         select ARCH_MULTI_V6_V7
>>         select CPU_V6
> Sorry about that, my fault.

Can you pick this patch up from the mailing list? Otherwise I can try to
route it through David's msm tree.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

