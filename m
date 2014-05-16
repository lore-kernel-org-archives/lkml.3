Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757247AbaEPOhM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 10:37:12 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:36144 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757166AbaEPOhJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 10:37:09 -0400
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: Jingoo Han <jg1.han@samsung.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "Shilimkar, Santosh" <santosh.shilimkar@ti.com>,
        "'Russell King'" <linux@arm.linux.org.uk>
Subject: RE: [PATCH v1 1/5] ARM: keystone: add pcie related options
Thread-Topic: [PATCH v1 1/5] ARM: keystone: add pcie related options
Thread-Index: Ac9wV22VEP7cn5uSRMOaZ+kpTceLowARZZCAAB3MHnA=
Date: Fri, 16 May 2014 14:36:37 +0000
Message-ID: <3E54258959B69E4282D79E01AB1F32B7047413F8@DFLE11.ent.ti.com>
References: <1400169692-9677-1-git-send-email-m-karicheri2@ti.com>
 <1400169692-9677-2-git-send-email-m-karicheri2@ti.com>
 <004e01cf709d$a48b4240$eda1c6c0$%han@samsung.com>
In-Reply-To: <004e01cf709d$a48b4240$eda1c6c0$%han@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [128.247.5.50]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>-----Original Message-----
>From: Jingoo Han [mailto:jg1.han@samsung.com]
>Sent: Thursday, May 15, 2014 8:28 PM
>To: Karicheri, Muralidharan
>Cc: linux-kernel@vger.kernel.org; linux-pci@vger.kernel.org; linux-arm-
>kernel@lists.infradead.org; Shilimkar, Santosh; 'Russell King'; 'Jingoo Han'
>Subject: Re: [PATCH v1 1/5] ARM: keystone: add pcie related options
>
>On Friday, May 16, 2014 1:01 AM, Murali Karicheri wrote:
>>
>> Add pcie related options by default for keystone architecture
>>
>> CC: Santosh Shilimkar <santosh.shilimkar@ti.com>
>> CC: Russell King <linux@arm.linux.org.uk>
>>
>> Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
>> ---
>>  arch/arm/mach-keystone/Kconfig |    2 ++
>>  1 file changed, 2 insertions(+)
>>
>> diff --git a/arch/arm/mach-keystone/Kconfig
>> b/arch/arm/mach-keystone/Kconfig index f50bc93..f87844d 100644
>> --- a/arch/arm/mach-keystone/Kconfig
>> +++ b/arch/arm/mach-keystone/Kconfig
>> @@ -8,6 +8,8 @@ config ARCH_KEYSTONE
>>  	select COMMON_CLK_KEYSTONE
>>  	select ARCH_SUPPORTS_BIG_ENDIAN
>>  	select ZONE_DMA if ARM_LPAE
>> +	select MIGHT_HAVE_PCI
>> +	select ARCH_SUPPORTS_MSI
>
>Please, don't select ARCH_SUPPORTS_MSI, because this kconfig option was already
>removed in v3.12 by the commit ebd97be635
>('PCI: remove ARCH_SUPPORTS_MSI kconfig option'). So. there is NO need to select
>'ARCH_SUPPORTS_MSI'.
>

Will do. Thanks.

>Best regards,
>Jingoo Han
>
>>  	help
>>  	  Support for boards based on the Texas Instruments Keystone family of
>>  	  SoCs.
>> --
>> 1.7.9.5
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-pci"
>> in the body of a message to majordomo@vger.kernel.org More majordomo
>> info at  http://vger.kernel.org/majordomo-info.html

