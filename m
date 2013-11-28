Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758191Ab3K1A7g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 19:59:36 -0500
Received: from outbound-mail04.westnet.com.au ([203.10.1.245]:33710 "EHLO
	outbound-mail04.westnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754213Ab3K1A7d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 19:59:33 -0500
X-Greylist: delayed 559 seconds by postgrey-1.27 at vger.kernel.org; Wed, 27 Nov 2013 19:59:32 EST
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApMBAMySllJ8q8ai/2dsb2JhbAANTIcMtUmBN4MZAQEBBHgBEAsYBAUWDQIJAwIBAgFFBwwBBQIBAYdqAZMymmtuBpBrF4EjjV8HgmWBTgOiX4sD
X-IronPort-AV: E=Sophos;i="4.93,786,1378828800"; 
   d="scan'208";a="137486942"
X-WN-REMOTEIP: 124.171.198.162
X-WN-ENVELOPESENDER: gregungerer@westnet.com.au
X-WN-MID: 137486942
X-WN-SMTPAUTHID: gregungerer@westnet.com.au
Message-ID: <52969340.3080005@westnet.com.au>
Date: Thu, 28 Nov 2013 10:50:08 +1000
From: Greg Ungerer <gregungerer@westnet.com.au>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: eunb.song@samsung.com, geert@linux-m68k.org
CC: linux-m68k@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] m68k : Kill CONFIG_MTD_PARTITIONS
References: <11558848.81811385516934809.JavaMail.weblogic@epml11>
In-Reply-To: <11558848.81811385516934809.JavaMail.weblogic@epml11>
Content-Type: text/plain; charset=EUC-KR
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eunbong,

On 27/11/13 11:48, Eunbong Song wrote:
> This patch removes CONFIG_MTD_PARTITIONS in config files for m68k.
> Because CONFIG_MTD_PARTITIONS was removed by commit 6a8a98b22b10f1560d5f90aded4a54234b9b2724.
> 
> Signed-off-by: Eunbong Song <eunb.song@samsung.com>

Acked-by: Greg Ungerer <gerg@uclinux.org>

Did you want me to pick this up for the m68knommu git tree?

Thanks
Greg


> ---
>   arch/m68k/configs/m5208evb_defconfig |    1 -
>   arch/m68k/configs/m5249evb_defconfig |    1 -
>   arch/m68k/configs/m5272c3_defconfig  |    1 -
>   arch/m68k/configs/m5275evb_defconfig |    1 -
>   arch/m68k/configs/m5307c3_defconfig  |    1 -
>   arch/m68k/configs/m5407c3_defconfig  |    1 -
>   6 files changed, 0 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/m68k/configs/m5208evb_defconfig b/arch/m68k/configs/m5208evb_defconfig
> index c161682..e7292f4 100644
> --- a/arch/m68k/configs/m5208evb_defconfig
> +++ b/arch/m68k/configs/m5208evb_defconfig
> @@ -40,7 +40,6 @@ CONFIG_INET=y
>   # CONFIG_IPV6 is not set
>   # CONFIG_FW_LOADER is not set
>   CONFIG_MTD=y
> -CONFIG_MTD_PARTITIONS=y
>   CONFIG_MTD_CHAR=y
>   CONFIG_MTD_BLOCK=y
>   CONFIG_MTD_RAM=y
> diff --git a/arch/m68k/configs/m5249evb_defconfig b/arch/m68k/configs/m5249evb_defconfig
> index a6599e4..0cd4b39 100644
> --- a/arch/m68k/configs/m5249evb_defconfig
> +++ b/arch/m68k/configs/m5249evb_defconfig
> @@ -38,7 +38,6 @@ CONFIG_INET=y
>   # CONFIG_IPV6 is not set
>   # CONFIG_FW_LOADER is not set
>   CONFIG_MTD=y
> -CONFIG_MTD_PARTITIONS=y
>   CONFIG_MTD_CHAR=y
>   CONFIG_MTD_BLOCK=y
>   CONFIG_MTD_RAM=y
> diff --git a/arch/m68k/configs/m5272c3_defconfig b/arch/m68k/configs/m5272c3_defconfig
> index 3fa60a5..a60cb35 100644
> --- a/arch/m68k/configs/m5272c3_defconfig
> +++ b/arch/m68k/configs/m5272c3_defconfig
> @@ -36,7 +36,6 @@ CONFIG_INET=y
>   # CONFIG_IPV6 is not set
>   # CONFIG_FW_LOADER is not set
>   CONFIG_MTD=y
> -CONFIG_MTD_PARTITIONS=y
>   CONFIG_MTD_CHAR=y
>   CONFIG_MTD_BLOCK=y
>   CONFIG_MTD_RAM=y
> diff --git a/arch/m68k/configs/m5275evb_defconfig b/arch/m68k/configs/m5275evb_defconfig
> index a1230e8..e6502ab 100644
> --- a/arch/m68k/configs/m5275evb_defconfig
> +++ b/arch/m68k/configs/m5275evb_defconfig
> @@ -39,7 +39,6 @@ CONFIG_INET=y
>   # CONFIG_IPV6 is not set
>   # CONFIG_FW_LOADER is not set
>   CONFIG_MTD=y
> -CONFIG_MTD_PARTITIONS=y
>   CONFIG_MTD_CHAR=y
>   CONFIG_MTD_BLOCK=y
>   CONFIG_MTD_RAM=y
> diff --git a/arch/m68k/configs/m5307c3_defconfig b/arch/m68k/configs/m5307c3_defconfig
> index 43795f4..023812a 100644
> --- a/arch/m68k/configs/m5307c3_defconfig
> +++ b/arch/m68k/configs/m5307c3_defconfig
> @@ -38,7 +38,6 @@ CONFIG_INET=y
>   # CONFIG_IPV6 is not set
>   # CONFIG_FW_LOADER is not set
>   CONFIG_MTD=y
> -CONFIG_MTD_PARTITIONS=y
>   CONFIG_MTD_CHAR=y
>   CONFIG_MTD_BLOCK=y
>   CONFIG_MTD_RAM=y
> diff --git a/arch/m68k/configs/m5407c3_defconfig b/arch/m68k/configs/m5407c3_defconfig
> index 72746c5..557b39f 100644
> --- a/arch/m68k/configs/m5407c3_defconfig
> +++ b/arch/m68k/configs/m5407c3_defconfig
> @@ -38,7 +38,6 @@ CONFIG_INET=y
>   # CONFIG_IPV6 is not set
>   # CONFIG_FW_LOADER is not set
>   CONFIG_MTD=y
> -CONFIG_MTD_PARTITIONS=y
>   CONFIG_MTD_CHAR=y
>   CONFIG_MTD_BLOCK=y
>   CONFIG_MTD_RAM=y
> 

