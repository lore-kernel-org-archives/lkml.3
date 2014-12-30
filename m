Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752081AbaL3Kmg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 05:42:36 -0500
Received: from mail-la0-f45.google.com ([209.85.215.45]:40378 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751756AbaL3Kmf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 05:42:35 -0500
Message-ID: <54A28195.4070102@cogentembedded.com>
Date: Tue, 30 Dec 2014 13:42:29 +0300
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Stefan Agner <stefan@agner.ch>, shawn.guo@linaro.org,
        kernel@pengutronix.de, linux@arm.linux.org.uk,
        u.kleine-koenig@pengutronix.de, jason@lakedaemon.net, olof@lixom.net,
        arnd@arndb.de, daniel.lezcano@linaro.org, tglx@linutronix.de,
        mark.rutland@arm.com, pawel.moll@arm.com, robh+dt@kernel.org,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        marc.zyngier@arm.com
CC: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 07/12] ARM: imx: depend MXC debug board on 3DS machines
References: <1419895935-22966-1-git-send-email-stefan@agner.ch> <1419895935-22966-8-git-send-email-stefan@agner.ch>
In-Reply-To: <1419895935-22966-8-git-send-email-stefan@agner.ch>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 12/30/2014 2:32 AM, Stefan Agner wrote:

> Depend the MXC debug board on machines which actually support it.

> Signed-off-by: Stefan Agner <stefan@agner.ch>
> ---
> This configuration appeared lonely when I enabled ARCH_MULTI_V7M.
> Afaik, the selection of it only makes sense with one of the supported
> boards...

>   arch/arm/mach-imx/Kconfig | 1 +
>   1 file changed, 1 insertion(+)

> diff --git a/arch/arm/mach-imx/Kconfig b/arch/arm/mach-imx/Kconfig
> index 3c5859e..96c8eb8 100644
> --- a/arch/arm/mach-imx/Kconfig
> +++ b/arch/arm/mach-imx/Kconfig
> @@ -21,6 +21,7 @@ config MXC_AVIC
>
>   config MXC_DEBUG_BOARD
>   	bool "Enable MXC debug board(for 3-stack)"
> +	depends on CONFIG_MACH_MX27_3DS || CONFIG_MACH_MX31_3DS || CONFIG_MACH_MX35_3DS

    CONFIG_ prefixes are not needed in Kconfig.

[...]

WBR, Sergei

