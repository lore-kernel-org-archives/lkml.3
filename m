Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752760AbaEMFyW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 01:54:22 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:28997 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752430AbaEMFyV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 01:54:21 -0400
Message-ID: <5371B34A.5030405@hisilicon.com>
Date: Tue, 13 May 2014 13:53:14 +0800
From: Zhou Wang <wangzhou1@hisilicon.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: <linux@arm.linux.org.uk>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
CC: <haojian.zhuang@linaro.org>, <xuwei5@hisilicon.com>
Subject: Re: [PATCH 1/2] ARM: hip04: set ARCH_NR_GPIO to 128
References: <5357A941.6080809@hisilicon.com> <5366266A.9050704@hisilicon.com>
In-Reply-To: <5366266A.9050704@hisilicon.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.66.65.131]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/5/4 19:37, Zhou Wang wrote:
> On 2014/4/23 19:51, Zhou Wang wrote:
>> set ARCH_NR_GPIO for Hisilicon Soc hip04, which has 4 GPIO
>> controllers with 32 GPIOs each.
>>
>> Signed-off-by: Zhou Wang <wangzhou1@hisilicon.com>
>> ---
>>  arch/arm/Kconfig |    1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
>> index 2961627..bb00e65 100644
>> --- a/arch/arm/Kconfig
>> +++ b/arch/arm/Kconfig
>> @@ -1664,6 +1664,7 @@ config ARCH_NR_GPIO
>>  	default 352 if ARCH_VT8500
>>  	default 288 if ARCH_SUNXI
>>  	default 264 if MACH_H4700
>> +	default 128 if ARCH_HIP04
>>  	default 0
>>  	help
>>  	  Maximum number of GPIOs in the system.
>> -- 1.7.9.5
>>
> Hi Russell
> 
>  Is there anything I should pay attention to about this patch?
> 
> Best regards
> Zhou Wang
> 
Hi Russell,

  Would you like to apply this patch? if there is some problem ,please tell me.

Best regards,
Zhou Wang

