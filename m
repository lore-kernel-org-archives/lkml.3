Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756556AbaJ2S62 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 14:58:28 -0400
Received: from mail-ob0-f173.google.com ([209.85.214.173]:34397 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754482AbaJ2S61 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 14:58:27 -0400
Message-ID: <545138F7.7080200@gmail.com>
Date: Wed, 29 Oct 2014 11:59:03 -0700
From: Santosh Shilimkar <santosh.shilimkar@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Murali Karicheri <m-karicheri2@ti.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
CC: Santosh Shilimkar <ssantosh@kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v1 2/4] ARM: keystone: defconfig: add options to enable
 PCI controller
References: <1414601134-31825-1-git-send-email-m-karicheri2@ti.com> <1414601134-31825-3-git-send-email-m-karicheri2@ti.com>
In-Reply-To: <1414601134-31825-3-git-send-email-m-karicheri2@ti.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/29/2014 09:45 AM, Murali Karicheri wrote:

Please add some change log here even if it minimum.

> Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
> CC: Santosh Shilimkar <ssantosh@kernel.org>
> CC: Russell King <linux@arm.linux.org.uk>
> CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>   v1 - fixed email ID for Santosh
>   arch/arm/configs/keystone_defconfig |    3 +++
>   1 file changed, 3 insertions(+)
>
> diff --git a/arch/arm/configs/keystone_defconfig b/arch/arm/configs/keystone_defconfig
> index 932ae40..40d3e9d 100644
> --- a/arch/arm/configs/keystone_defconfig
> +++ b/arch/arm/configs/keystone_defconfig
> @@ -20,6 +20,9 @@ CONFIG_MODULE_FORCE_UNLOAD=y
>   CONFIG_MODVERSIONS=y
>   CONFIG_ARCH_KEYSTONE=y
>   CONFIG_ARM_LPAE=y
> +CONFIG_PCI=y
> +CONFIG_PCI_MSI=y
> +CONFIG_PCI_KEYSTONE=y
>   CONFIG_SMP=y
>   CONFIG_PREEMPT=y
>   CONFIG_AEABI=y
>
