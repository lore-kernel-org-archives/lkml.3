Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755129AbaKRT2l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 14:28:41 -0500
Received: from mail-wg0-f51.google.com ([74.125.82.51]:63151 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755042AbaKRT2k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 14:28:40 -0500
Message-ID: <546B9DE3.705@gmail.com>
Date: Tue, 18 Nov 2014 20:28:35 +0100
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
To: Antoine Tenart <antoine.tenart@free-electrons.com>, kishon@ti.com,
        p.zabel@pengutronix.de
CC: arnd@arndb.de, alexandre.belloni@free-electrons.com,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] ARM: berlin: do not select RESET_CONTROLLER
References: <1416231192-27056-1-git-send-email-antoine.tenart@free-electrons.com> <1416231192-27056-3-git-send-email-antoine.tenart@free-electrons.com>
In-Reply-To: <1416231192-27056-3-git-send-email-antoine.tenart@free-electrons.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17.11.2014 14:33, Antoine Tenart wrote:
> RESET_CONTROLLER is meant to be user-selectable. To respect that,
> do not select it automatically when using ARCH_BERLIN.
>
> Signed-off-by: Antoine Tenart <antoine.tenart@free-electrons.com>

Applied to berlin/soc.

Thanks!

> ---
>   arch/arm/mach-berlin/Kconfig | 1 -
>   1 file changed, 1 deletion(-)
>
> diff --git a/arch/arm/mach-berlin/Kconfig b/arch/arm/mach-berlin/Kconfig
> index 5803f773a065..51582c73a53f 100644
> --- a/arch/arm/mach-berlin/Kconfig
> +++ b/arch/arm/mach-berlin/Kconfig
> @@ -7,7 +7,6 @@ menuconfig ARCH_BERLIN
>   	select DW_APB_ICTL
>   	select DW_APB_TIMER_OF
>   	select PINCTRL
> -	select RESET_CONTROLLER
>
>   if ARCH_BERLIN
>
>

