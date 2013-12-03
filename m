Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752941Ab3LCCj5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 21:39:57 -0500
Received: from mail-ob0-f169.google.com ([209.85.214.169]:33222 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752019Ab3LCCjx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 21:39:53 -0500
MIME-Version: 1.0
In-Reply-To: <1389567.80471385515291622.JavaMail.weblogic@epml11>
References: <1389567.80471385515291622.JavaMail.weblogic@epml11>
Date: Tue, 3 Dec 2013 10:39:52 +0800
Message-ID: <CAMk6uBnKEnoRxtxJjc0r_r__t3uz7zjaR9CCOc6nWq5Znn=bgQ@mail.gmail.com>
Subject: Re: [PATCH] blackfin: Kill CONFIG_MTD_PARTITIONS
From: Steven Miao <realmz6@gmail.com>
To: eunb.song@samsung.com
Cc: Mike Frysinger <vapier@gentoo.org>,
        "uclinux-dist-devel@blackfin.uclinux.org" 
	<uclinux-dist-devel@blackfin.uclinux.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Applied. Thanks!

On Wed, Nov 27, 2013 at 9:21 AM, Eunbong Song <eunb.song@samsung.com> wrote:
>
> This patch removes CONFIG_MTD_PARTITIONS in config files for blackfin.
>  Because CONFIG_MTD_PARTITIONS was removed by commit 6a8a98b22b10f1560d5f90aded4a54234b9b2724.
>
>
> Signed-off-by: Eunbong Song <eunb.song@samsung.com>
> ---
>  arch/blackfin/configs/BF538-EZKIT_defconfig   |    1 -
>  arch/blackfin/configs/BF561-ACVILON_defconfig |    1 -
>  arch/blackfin/configs/BlackStamp_defconfig    |    1 -
>  arch/blackfin/configs/CM-BF533_defconfig      |    1 -
>  arch/blackfin/configs/CM-BF548_defconfig      |    1 -
>  arch/blackfin/configs/CM-BF561_defconfig      |    1 -
>  arch/blackfin/configs/DNP5370_defconfig       |    1 -
>  arch/blackfin/configs/H8606_defconfig         |    1 -
>  arch/blackfin/configs/IP0X_defconfig          |    1 -
>  arch/blackfin/configs/PNAV-10_defconfig       |    1 -
>  arch/blackfin/configs/SRV1_defconfig          |    1 -
>  arch/blackfin/configs/TCM-BF518_defconfig     |    1 -
>  12 files changed, 0 insertions(+), 12 deletions(-)
>
> diff --git a/arch/blackfin/configs/BF538-EZKIT_defconfig b/arch/blackfin/configs/BF538-EZKIT_defconfig
> index 972aa62..be03be6 100644
> --- a/arch/blackfin/configs/BF538-EZKIT_defconfig
> +++ b/arch/blackfin/configs/BF538-EZKIT_defconfig
> @@ -59,7 +59,6 @@ CONFIG_BFIN_SIR=m
>  CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
>  # CONFIG_FW_LOADER is not set
>  CONFIG_MTD=y
> -CONFIG_MTD_PARTITIONS=y
>  CONFIG_MTD_CMDLINE_PARTS=y
>  CONFIG_MTD_CHAR=m
>  CONFIG_MTD_BLOCK=y
> diff --git a/arch/blackfin/configs/BF561-ACVILON_defconfig b/arch/blackfin/configs/BF561-ACVILON_defconfig
> index 9198837..802f9c4 100644
> --- a/arch/blackfin/configs/BF561-ACVILON_defconfig
> +++ b/arch/blackfin/configs/BF561-ACVILON_defconfig
> @@ -49,7 +49,6 @@ CONFIG_SYN_COOKIES=y
>  CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
>  # CONFIG_FW_LOADER is not set
>  CONFIG_MTD=y
> -CONFIG_MTD_PARTITIONS=y
>  CONFIG_MTD_CMDLINE_PARTS=y
>  CONFIG_MTD_CHAR=y
>  CONFIG_MTD_BLOCK=y
> diff --git a/arch/blackfin/configs/BlackStamp_defconfig b/arch/blackfin/configs/BlackStamp_defconfig
> index 7b982d0..3853c47 100644
> --- a/arch/blackfin/configs/BlackStamp_defconfig
> +++ b/arch/blackfin/configs/BlackStamp_defconfig
> @@ -44,7 +44,6 @@ CONFIG_IP_PNP=y
>  CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
>  # CONFIG_FW_LOADER is not set
>  CONFIG_MTD=y
> -CONFIG_MTD_PARTITIONS=y
>  CONFIG_MTD_CMDLINE_PARTS=y
>  CONFIG_MTD_CHAR=m
>  CONFIG_MTD_BLOCK=y
> diff --git a/arch/blackfin/configs/CM-BF533_defconfig b/arch/blackfin/configs/CM-BF533_defconfig
> index c940a1e..5e0db82 100644
> --- a/arch/blackfin/configs/CM-BF533_defconfig
> +++ b/arch/blackfin/configs/CM-BF533_defconfig
> @@ -36,7 +36,6 @@ CONFIG_UNIX=y
>  # CONFIG_WIRELESS is not set
>  CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
>  CONFIG_MTD=y
> -CONFIG_MTD_PARTITIONS=y
>  CONFIG_MTD_CMDLINE_PARTS=y
>  CONFIG_MTD_CHAR=y
>  CONFIG_MTD_BLOCK=y
> diff --git a/arch/blackfin/configs/CM-BF548_defconfig b/arch/blackfin/configs/CM-BF548_defconfig
> index e961483..b9af4fa 100644
> --- a/arch/blackfin/configs/CM-BF548_defconfig
> +++ b/arch/blackfin/configs/CM-BF548_defconfig
> @@ -53,7 +53,6 @@ CONFIG_INET_XFRM_MODE_BEET=m
>  CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
>  # CONFIG_FW_LOADER is not set
>  CONFIG_MTD=y
> -CONFIG_MTD_PARTITIONS=y
>  CONFIG_MTD_CMDLINE_PARTS=y
>  CONFIG_MTD_CHAR=y
>  CONFIG_MTD_BLOCK=y
> diff --git a/arch/blackfin/configs/CM-BF561_defconfig b/arch/blackfin/configs/CM-BF561_defconfig
> index 24936b9..d6dd98e 100644
> --- a/arch/blackfin/configs/CM-BF561_defconfig
> +++ b/arch/blackfin/configs/CM-BF561_defconfig
> @@ -51,7 +51,6 @@ CONFIG_INET=y
>  # CONFIG_WIRELESS is not set
>  CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
>  CONFIG_MTD=y
> -CONFIG_MTD_PARTITIONS=y
>  CONFIG_MTD_CMDLINE_PARTS=y
>  CONFIG_MTD_CHAR=y
>  CONFIG_MTD_BLOCK=y
> diff --git a/arch/blackfin/configs/DNP5370_defconfig b/arch/blackfin/configs/DNP5370_defconfig
> index 89162d0..2b58cb2 100644
> --- a/arch/blackfin/configs/DNP5370_defconfig
> +++ b/arch/blackfin/configs/DNP5370_defconfig
> @@ -36,7 +36,6 @@ CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
>  CONFIG_MTD=y
>  CONFIG_MTD_DEBUG=y
>  CONFIG_MTD_DEBUG_VERBOSE=1
> -CONFIG_MTD_PARTITIONS=y
>  CONFIG_MTD_CHAR=y
>  CONFIG_MTD_BLOCK=y
>  CONFIG_NFTL=y
> diff --git a/arch/blackfin/configs/H8606_defconfig b/arch/blackfin/configs/H8606_defconfig
> index a26436b..f754e49 100644
> --- a/arch/blackfin/configs/H8606_defconfig
> +++ b/arch/blackfin/configs/H8606_defconfig
> @@ -36,7 +36,6 @@ CONFIG_IRTTY_SIR=m
>  # CONFIG_WIRELESS is not set
>  # CONFIG_FW_LOADER is not set
>  CONFIG_MTD=y
> -CONFIG_MTD_PARTITIONS=y
>  CONFIG_MTD_CHAR=y
>  CONFIG_MTD_BLOCK=y
>  CONFIG_MTD_RAM=y
> diff --git a/arch/blackfin/configs/IP0X_defconfig b/arch/blackfin/configs/IP0X_defconfig
> index 6479915..6295165 100644
> --- a/arch/blackfin/configs/IP0X_defconfig
> +++ b/arch/blackfin/configs/IP0X_defconfig
> @@ -43,7 +43,6 @@ CONFIG_IP_NF_TARGET_REJECT=y
>  CONFIG_IP_NF_MANGLE=y
>  # CONFIG_WIRELESS is not set
>  CONFIG_MTD=y
> -CONFIG_MTD_PARTITIONS=y
>  CONFIG_MTD_CHAR=y
>  CONFIG_MTD_BLOCK=y
>  CONFIG_MTD_CFI=y
> diff --git a/arch/blackfin/configs/PNAV-10_defconfig b/arch/blackfin/configs/PNAV-10_defconfig
> index 8fd9b44..a6a7298 100644
> --- a/arch/blackfin/configs/PNAV-10_defconfig
> +++ b/arch/blackfin/configs/PNAV-10_defconfig
> @@ -46,7 +46,6 @@ CONFIG_IP_PNP=y
>  CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
>  # CONFIG_FW_LOADER is not set
>  CONFIG_MTD=y
> -CONFIG_MTD_PARTITIONS=y
>  CONFIG_MTD_CHAR=m
>  CONFIG_MTD_BLOCK=y
>  CONFIG_MTD_RAM=y
> diff --git a/arch/blackfin/configs/SRV1_defconfig b/arch/blackfin/configs/SRV1_defconfig
> index 0520c16..bc21664 100644
> --- a/arch/blackfin/configs/SRV1_defconfig
> +++ b/arch/blackfin/configs/SRV1_defconfig
> @@ -38,7 +38,6 @@ CONFIG_IRTTY_SIR=m
>  # CONFIG_WIRELESS is not set
>  # CONFIG_FW_LOADER is not set
>  CONFIG_MTD=y
> -CONFIG_MTD_PARTITIONS=y
>  CONFIG_MTD_CHAR=m
>  CONFIG_MTD_BLOCK=y
>  CONFIG_MTD_JEDECPROBE=m
> diff --git a/arch/blackfin/configs/TCM-BF518_defconfig b/arch/blackfin/configs/TCM-BF518_defconfig
> index e4ed865..ea88158 100644
> --- a/arch/blackfin/configs/TCM-BF518_defconfig
> +++ b/arch/blackfin/configs/TCM-BF518_defconfig
> @@ -54,7 +54,6 @@ CONFIG_IP_PNP=y
>  CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
>  # CONFIG_FW_LOADER is not set
>  CONFIG_MTD=y
> -CONFIG_MTD_PARTITIONS=y
>  CONFIG_MTD_CMDLINE_PARTS=y
>  CONFIG_MTD_CHAR=y
>  CONFIG_MTD_BLOCK=y
> --
> 1.7.0.4
