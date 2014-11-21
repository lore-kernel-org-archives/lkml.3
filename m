Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753610AbaKUG0K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 01:26:10 -0500
Received: from mail-yh0-f50.google.com ([209.85.213.50]:39981 "EHLO
	mail-yh0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803AbaKUG0I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 01:26:08 -0500
MIME-Version: 1.0
In-Reply-To: <20141120100328.GO4042@n2100.arm.linux.org.uk>
References: <1416461968-2057-1-git-send-email-amit.daniel@samsung.com>
	<1416461968-2057-3-git-send-email-amit.daniel@samsung.com>
	<20141120100328.GO4042@n2100.arm.linux.org.uk>
Date: Fri, 21 Nov 2014 11:56:07 +0530
X-Google-Sender-Auth: zQIZUuXKI7DfAvqM4zlt58UF3KY
Message-ID: <CADGdYn6dQp2LtuQj5-ma18C-i4J4k0Cw5ZOrhfi7Lb_3Wzaung@mail.gmail.com>
Subject: Re: [PATCH v3 2/5] drivers: soc: Add support for Exynos PMU driver
From: amit daniel kachhap <amit.daniel@samsung.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Pankaj Dubey <pankaj.dubey@samsung.com>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 20, 2014 at 3:33 PM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Thu, Nov 20, 2014 at 11:09:25AM +0530, Amit Daniel Kachhap wrote:
>> diff --git a/drivers/soc/Makefile b/drivers/soc/Makefile
>> index 063113d..44d220d 100644
>> --- a/drivers/soc/Makefile
>> +++ b/drivers/soc/Makefile
>> @@ -6,3 +6,4 @@ obj-$(CONFIG_ARCH_QCOM)               += qcom/
>>  obj-$(CONFIG_ARCH_TEGRA)     += tegra/
>>  obj-$(CONFIG_SOC_TI)         += ti/
>>  obj-$(CONFIG_PLAT_VERSATILE) += versatile/
>> +obj-$(CONFIG_ARCH_EXYNOS)    += samsung/
>
> Is ARCH_EXYNOS appropriate here, or is your new SOC_SAMSUNG better?
yes, SOC_SAMSUNG is more appropriate.
>
>> diff --git a/drivers/soc/samsung/Kconfig b/drivers/soc/samsung/Kconfig
>> new file mode 100644
>> index 0000000..a424ebc
>> --- /dev/null
>> +++ b/drivers/soc/samsung/Kconfig
>> @@ -0,0 +1,20 @@
>> +#
>> +# SAMSUNG SOC drivers
>> +#
>> +menuconfig SOC_SAMSUNG
>> +     bool "Samsung SOC drivers support"
>
> If you intend to select SOC_SAMSUNG, is there any point in making this
> a user-visible symbol?
Agreed, only menu "Samsung SOC drivers support" will be fine.

Regards,
Amit
>
> --
> FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
> according to speedtest.net.
>
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
