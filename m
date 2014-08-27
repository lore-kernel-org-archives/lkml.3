Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935333AbaH0QKT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 12:10:19 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39394 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935294AbaH0QKR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 12:10:17 -0400
Message-ID: <53FE02E6.3030302@suse.de>
Date: Wed, 27 Aug 2014 18:10:14 +0200
From: =?ISO-8859-15?Q?Andreas_F=E4rber?= <afaerber@suse.de>
Organization: SUSE LINUX Products GmbH
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Kukjin Kim <kgene.kim@samsung.com>
CC: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] ARM: exynos_defconfig: Enable Control Groups support
References: <1409137341-20516-1-git-send-email-javier.martinez@collabora.co.uk>
In-Reply-To: <1409137341-20516-1-git-send-email-javier.martinez@collabora.co.uk>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 27.08.2014 13:02, schrieb Javier Martinez Canillas:
> systemd needs control groups support to be enabled in the
> kernel so let's enable it by default since is quite likely
> that a user-space with systemd will be used.
> 
> Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
> ---
>  arch/arm/configs/exynos_defconfig | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/arm/configs/exynos_defconfig b/arch/arm/configs/exynos_defconfig
> index 676c744..590abde 100644
> --- a/arch/arm/configs/exynos_defconfig
> +++ b/arch/arm/configs/exynos_defconfig
> @@ -1,6 +1,7 @@
>  CONFIG_SYSVIPC=y
>  CONFIG_NO_HZ=y
>  CONFIG_HIGH_RES_TIMERS=y
> +CONFIG_CGROUPS=y
>  CONFIG_BLK_DEV_INITRD=y
>  CONFIG_KALLSYMS_ALL=y
>  CONFIG_MODULES=y

CONFIG_FHANDLE=y is also needed for systemd to get a serial console.
multi_v7 has that already.

Regards,
Andreas

-- 
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg, Germany
GF: Jeff Hawn, Jennifer Guild, Felix Imendörffer; HRB 16746 AG Nürnberg
