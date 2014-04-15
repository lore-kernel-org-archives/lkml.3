Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753169AbaDOJQz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 05:16:55 -0400
Received: from mail-ee0-f48.google.com ([74.125.83.48]:65170 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751192AbaDOJQx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 05:16:53 -0400
Message-ID: <534CF901.2080400@gmail.com>
Date: Tue, 15 Apr 2014 11:16:49 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
To: =?UTF-8?B?QW50b2luZSBUw6luYXJ0?= 
	<antoine.tenart@free-electrons.com>
CC: alexandre.belloni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] ARM: berlin: add the LIBGPIO as a dependency for
 the BG2Q
References: <1397549245-3338-1-git-send-email-antoine.tenart@free-electrons.com> <1397549245-3338-2-git-send-email-antoine.tenart@free-electrons.com>
In-Reply-To: <1397549245-3338-2-git-send-email-antoine.tenart@free-electrons.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/15/2014 10:07 AM, Antoine Ténart wrote:
> The BG2Q has GPIOs driven by the dwapb GPIO driver. Add the LIBGPIO as a
> dependency to be able to support them.
>
> Signed-off-by: Antoine Ténart <antoine.tenart@free-electrons.com>
> ---
>   arch/arm/mach-berlin/Kconfig | 1 +
>   1 file changed, 1 insertion(+)
>
> diff --git a/arch/arm/mach-berlin/Kconfig b/arch/arm/mach-berlin/Kconfig
> index 291f1cac6c3d..c31968712095 100644
> --- a/arch/arm/mach-berlin/Kconfig
> +++ b/arch/arm/mach-berlin/Kconfig
> @@ -28,6 +28,7 @@ config MACH_BERLIN_BG2Q
>   	select CPU_V7
>   	select HAVE_ARM_TWD if SMP
>   	select HAVE_SMP
> +	select ARCH_REQUIRE_GPIOLIB

Apart from Jisheng's comment, I think we can directly move it
into arch/arm/Kconfig's MACH_BERLIN directly?

Sebastian

>   endmenu
>
>

