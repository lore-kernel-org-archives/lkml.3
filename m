Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752282AbaCUVnH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 17:43:07 -0400
Received: from mail-ee0-f54.google.com ([74.125.83.54]:51254 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751691AbaCUVnG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 17:43:06 -0400
Message-ID: <532CB266.6050800@gmail.com>
Date: Fri, 21 Mar 2014 22:43:02 +0100
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
CC: Olof Johansson <olof@lixom.net>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        =?ISO-8859-1?Q?Antoine_T=E9nart?= 
	<antoine.tenart@free-electrons.com>,
        Jimmy Xu <zmxu@marvell.com>, Jisheng Zhang <jszhang@marvell.com>
Subject: Re: [PATCH 2/2] ARM: multi_v7_defconfig: Select CONFIG_MACH_BERLIN_BG2Q
References: <1395430757-8677-1-git-send-email-alexandre.belloni@free-electrons.com> <1395430757-8677-2-git-send-email-alexandre.belloni@free-electrons.com>
In-Reply-To: <1395430757-8677-2-git-send-email-alexandre.belloni@free-electrons.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/21/2014 08:39 PM, Alexandre Belloni wrote:
> Now that we support Berlin BG2Q, select CONFIG_MACH_BERLIN_BG2Q so that we can
> boot BG2Q based boards like the BG2Q DMP.
>
> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>

Applied to berlin/soc, Thanks!

> ---
>   arch/arm/configs/multi_v7_defconfig | 1 +
>   1 file changed, 1 insertion(+)
>
> diff --git a/arch/arm/configs/multi_v7_defconfig b/arch/arm/configs/multi_v7_defconfig
> index ee6982976d66..8b09b72fb688 100644
> --- a/arch/arm/configs/multi_v7_defconfig
> +++ b/arch/arm/configs/multi_v7_defconfig
> @@ -15,6 +15,7 @@ CONFIG_ARCH_BCM_MOBILE=y
>   CONFIG_ARCH_BERLIN=y
>   CONFIG_MACH_BERLIN_BG2=y
>   CONFIG_MACH_BERLIN_BG2CD=y
> +CONFIG_MACH_BERLIN_BG2Q=y
>   CONFIG_GPIO_PCA953X=y
>   CONFIG_ARCH_HIGHBANK=y
>   CONFIG_ARCH_HI3xxx=y
>

