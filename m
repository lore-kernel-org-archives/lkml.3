Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755361Ab3BEIvi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 03:51:38 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:47838 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753655Ab3BEIvh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 03:51:37 -0500
Message-ID: <5110C857.6050100@ti.com>
Date: Tue, 5 Feb 2013 14:22:39 +0530
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
CC: Russell King <linux@arm.linux.org.uk>, <js1304@gmail.com>,
        Nicolas Pitre <nico@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v5 1/3] ARM: vmregion: remove vmregion code entirely
References: <1360024314-1895-1-git-send-email-iamjoonsoo.kim@lge.com> <1360024314-1895-2-git-send-email-iamjoonsoo.kim@lge.com>
In-Reply-To: <1360024314-1895-2-git-send-email-iamjoonsoo.kim@lge.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 05 February 2013 06:01 AM, Joonsoo Kim wrote:
> Now, there is no user for vmregion.
> So remove it.
>
> Acked-by: Nicolas Pitre <nico@linaro.org>
> Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
>
> diff --git a/arch/arm/mm/Makefile b/arch/arm/mm/Makefile
> index 8a9c4cb..4e333fa 100644
> --- a/arch/arm/mm/Makefile
> +++ b/arch/arm/mm/Makefile
> @@ -6,7 +6,7 @@ obj-y				:= dma-mapping.o extable.o fault.o init.o \
>   				   iomap.o
>
>   obj-$(CONFIG_MMU)		+= fault-armv.o flush.o idmap.o ioremap.o \
> -				   mmap.o pgd.o mmu.o vmregion.o
> +				   mmap.o pgd.o mmu.o
>
>   ifneq ($(CONFIG_MMU),y)
>   obj-y				+= nommu.o
> diff --git a/arch/arm/mm/vmregion.c b/arch/arm/mm/vmregion.c
> deleted file mode 100644
> index a631016..0000000
> --- a/arch/arm/mm/vmregion.c
> +++ /dev/null
> @@ -1,205 +0,0 @@
You might want to use 'git format-patch -D'
which will just generate one line for a deleted file.

Regards,
Santosh


