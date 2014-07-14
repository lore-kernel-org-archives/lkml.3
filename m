Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752082AbaGNELD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 00:11:03 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:44607 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750731AbaGNEKz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 00:10:55 -0400
MIME-Version: 1.0
In-Reply-To: <1405288740-3986-1-git-send-email-ndel314@gmail.com>
References: <1405288740-3986-1-git-send-email-ndel314@gmail.com>
Date: Mon, 14 Jul 2014 09:40:53 +0530
Message-ID: <CAKohpokiw7YZ_ifjNcPReBB9N3x_N96t-S-=6wF4aWcBSWrEsA@mail.gmail.com>
Subject: Re: [PATCH] Cpufreq: ARM IMX6Q: Select PM_OPP
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Nicolas Del Piano <ndel314@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ezequiel@vanguardiasur.com.ar
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14 July 2014 03:29, Nicolas Del Piano <ndel314@gmail.com> wrote:
> PM_OPP is a library used by several of the existing cpufreq drivers.
> ARM IMX6Q cpufreq driver uses this library for its functionality.
> Thus, it should be selected in Kconfig.
>
> Reported-by: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
> Signed-off-by: Nicolas Del Piano <ndel314@gmail.com>
> ---
>  drivers/cpufreq/Kconfig.arm |    1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/cpufreq/Kconfig.arm b/drivers/cpufreq/Kconfig.arm
> index ebac671..8c5cf4b 100644
> --- a/drivers/cpufreq/Kconfig.arm
> +++ b/drivers/cpufreq/Kconfig.arm
> @@ -104,6 +104,7 @@ config ARM_IMX6Q_CPUFREQ
>         tristate "Freescale i.MX6 cpufreq support"
>         depends on ARCH_MXC
>         depends on REGULATOR_ANATOP
> +       select PM_OPP
>         help
>           This adds cpufreq driver support for Freescale i.MX6 series SoCs.

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
