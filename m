Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753616AbaIHMnR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 08:43:17 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:33665 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752784AbaIHMnP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 08:43:15 -0400
Message-ID: <540DA45E.1040702@collabora.co.uk>
Date: Mon, 08 Sep 2014 14:43:10 +0200
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: =?ISO-8859-15?Q?Andreas_F=E4rber?= <afaerber@suse.de>,
        Kukjin Kim <kgene.kim@samsung.com>
CC: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] ARM: exynos_defconfig: Enable Control Groups support
References: <1409137341-20516-1-git-send-email-javier.martinez@collabora.co.uk> <53FE02E6.3030302@suse.de>
In-Reply-To: <53FE02E6.3030302@suse.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Andreas,

On 08/27/2014 06:10 PM, Andreas Färber wrote:
> Am 27.08.2014 13:02, schrieb Javier Martinez Canillas:
>> systemd needs control groups support to be enabled in the
>> kernel so let's enable it by default since is quite likely
>> that a user-space with systemd will be used.
>> 
>> Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
>> ---
>>  arch/arm/configs/exynos_defconfig | 1 +
>>  1 file changed, 1 insertion(+)
>> 
>> diff --git a/arch/arm/configs/exynos_defconfig b/arch/arm/configs/exynos_defconfig
>> index 676c744..590abde 100644
>> --- a/arch/arm/configs/exynos_defconfig
>> +++ b/arch/arm/configs/exynos_defconfig
>> @@ -1,6 +1,7 @@
>>  CONFIG_SYSVIPC=y
>>  CONFIG_NO_HZ=y
>>  CONFIG_HIGH_RES_TIMERS=y
>> +CONFIG_CGROUPS=y
>>  CONFIG_BLK_DEV_INITRD=y
>>  CONFIG_KALLSYMS_ALL=y
>>  CONFIG_MODULES=y
> 
> CONFIG_FHANDLE=y is also needed for systemd to get a serial console.
> multi_v7 has that already.
> 

That's a requirement for systemd >= 209 AFAIK. I've systemd 208 on my debian
jessie and it works without it.

I agree that it should be included but I think it can be in a follow-up patch.

> Regards,
> Andreas
> 

Best regards,
Javier
