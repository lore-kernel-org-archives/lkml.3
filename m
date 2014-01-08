Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754760AbaAHB7j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 20:59:39 -0500
Received: from mail-lb0-f178.google.com ([209.85.217.178]:57693 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753750AbaAHB7c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 20:59:32 -0500
MIME-Version: 1.0
In-Reply-To: <1389145444-61816-1-git-send-email-john.tobias.ph@gmail.com>
References: <1389145444-61816-1-git-send-email-john.tobias.ph@gmail.com>
Date: Tue, 7 Jan 2014 17:59:30 -0800
Message-ID: <CACUGKYNvV2bxAUf=wVFmM2ohrBcwp2gRXPNN0Eh=BGGiu9gCOQ@mail.gmail.com>
Subject: Re: [PATCH] ARM: imx: select ARCH_HAS_CPUFREQ for iMX6SL
From: John Tobias <john.tobias.ph@gmail.com>
To: kernel@pengutronix.de, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: John Tobias <john.tobias.ph@gmail.com>, Shawn Guo <shawn.guo@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc'd Shawn Guo.

On Tue, Jan 7, 2014 at 5:44 PM, John Tobias <john.tobias.ph@gmail.com> wrote:
> iMX6SL now supported the cpufreq scaling by re-using the imx6q-cpufreq driver.
> By adding it, the user has the capability to select the said driver without
> depending it to SOC_IMX6Q.
>
> Signed-off-by: John Tobias <john.tobias.ph@gmail.com>
> ---
>  arch/arm/mach-imx/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/arch/arm/mach-imx/Kconfig b/arch/arm/mach-imx/Kconfig
> index 7a6e6f7..704e5ae 100644
> --- a/arch/arm/mach-imx/Kconfig
> +++ b/arch/arm/mach-imx/Kconfig
> @@ -808,6 +808,7 @@ config SOC_IMX6Q
>
>  config SOC_IMX6SL
>         bool "i.MX6 SoloLite support"
> +       select ARCH_HAS_CPUFREQ
>         select ARM_ERRATA_754322
>         select ARM_ERRATA_775420
>         select ARM_GIC
> --
> 1.8.3.2
>
