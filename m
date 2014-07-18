Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759267AbaGRAq2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 20:46:28 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:59526 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758455AbaGRAq1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 20:46:27 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Nicolas Del Piano <ndel314@gmail.com>
Cc: viresh.kumar@linaro.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, ezequiel@vanguardiasur.com.ar
Subject: Re: [PATCH] Cpufreq: ARM IMX6Q: Select PM_OPP
Date: Fri, 18 Jul 2014 03:04:44 +0200
Message-ID: <1586164.nY86MdPPAo@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1405288740-3986-1-git-send-email-ndel314@gmail.com>
References: <1405288740-3986-1-git-send-email-ndel314@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, July 13, 2014 06:59:00 PM Nicolas Del Piano wrote:
> PM_OPP is a library used by several of the existing cpufreq drivers.
> ARM IMX6Q cpufreq driver uses this library for its functionality.
> Thus, it should be selected in Kconfig.
> 
> Reported-by: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
> Signed-off-by: Nicolas Del Piano <ndel314@gmail.com>

Fixed up the subject, applied.  Thanks!

> ---
>  drivers/cpufreq/Kconfig.arm |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/cpufreq/Kconfig.arm b/drivers/cpufreq/Kconfig.arm
> index ebac671..8c5cf4b 100644
> --- a/drivers/cpufreq/Kconfig.arm
> +++ b/drivers/cpufreq/Kconfig.arm
> @@ -104,6 +104,7 @@ config ARM_IMX6Q_CPUFREQ
>  	tristate "Freescale i.MX6 cpufreq support"
>  	depends on ARCH_MXC
>  	depends on REGULATOR_ANATOP
> +	select PM_OPP
>  	help
>  	  This adds cpufreq driver support for Freescale i.MX6 series SoCs.
>  
> 

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
