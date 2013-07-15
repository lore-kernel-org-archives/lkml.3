Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754690Ab3GOJbo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 05:31:44 -0400
Received: from mail-oa0-f52.google.com ([209.85.219.52]:54140 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754641Ab3GOJbm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 05:31:42 -0400
MIME-Version: 1.0
In-Reply-To: <1373803339.1370.18.camel@x61.thuisdomein>
References: <1373803339.1370.18.camel@x61.thuisdomein>
Date: Mon, 15 Jul 2013 15:01:42 +0530
Message-ID: <CAKohpok1xvsVrssYrNJJZ2GTLJZVnY8SrCzNx+VdXbiMjL6uLw@mail.gmail.com>
Subject: Re: [PATCH] cpufreq: s3c24xx: fix typo "ARM_S3C24XX"
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14 July 2013 17:32, Paul Bolle <pebolle@tiscali.nl> wrote:
> Kconfig symbol S3C24XX_PLL depends on ARM_S3C24XX. But that symbol
> doesn't exist. Commit f023f8dd59bf ("cpufreq: s3c24xx: move cpufreq
> driver to drivers/cpufreq"), which added this typo, makes clear that
> ARM_S3C24XX_CPUFREQ was intended here.
>
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
> Untested!
>
>  arch/arm/mach-s3c24xx/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/arm/mach-s3c24xx/Kconfig b/arch/arm/mach-s3c24xx/Kconfig
> index 6d9252e..7791ac7 100644
> --- a/arch/arm/mach-s3c24xx/Kconfig
> +++ b/arch/arm/mach-s3c24xx/Kconfig
> @@ -208,7 +208,7 @@ config S3C24XX_GPIO_EXTRA128
>
>  config S3C24XX_PLL
>         bool "Support CPUfreq changing of PLL frequency (EXPERIMENTAL)"
> -       depends on ARM_S3C24XX
> +       depends on ARM_S3C24XX_CPUFREQ
>         help
>           Compile in support for changing the PLL frequency from the
>           S3C24XX series CPUfreq driver. The PLL takes time to settle

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>

@Rafael: I saw you taking other s3c patch directly. Mind taking this
one too?
