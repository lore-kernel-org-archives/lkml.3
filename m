Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756191Ab3FLJLc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 05:11:32 -0400
Received: from gloria.sntech.de ([95.129.55.99]:57804 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751370Ab3FLJLa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 05:11:30 -0400
From: Heiko =?iso-8859-15?q?St=FCbner?= <heiko@sntech.de>
To: Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: [PATCH 09/11] cpufreq: S3C2416/S3C64XX: select CPU_FREQ_TABLE
Date: Wed, 12 Jun 2013 11:11:21 +0200
User-Agent: KMail/1.13.7 (Linux/3.2.0-3-686-pae; KDE/4.8.4; i686; ; )
Cc: rjw@sisk.pl, linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, arvind.chauhan@arm.com, arnd@arndb.de
References: <cover.1371022830.git.viresh.kumar@linaro.org> <2bac52af214503f7678288c8a1372915190621da.1371022830.git.viresh.kumar@linaro.org>
In-Reply-To: <2bac52af214503f7678288c8a1372915190621da.1371022830.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201306121111.22287.heiko@sntech.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 12. Juni 2013, 10:15:16 schrieb Viresh Kumar:
> CPUFreq driver of this platform uses APIs from freq_table.c and so must
> select CPU_FREQ_TABLE.
> 
> Cc: Heiko Stuebner <heiko@sntech.de>

For the s3c2416-part
Acked-by: Heiko Stuebner <heiko@sntech.de>

> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> ---
>  drivers/cpufreq/Kconfig.arm | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/cpufreq/Kconfig.arm b/drivers/cpufreq/Kconfig.arm
> index dc26303..d52261b 100644
> --- a/drivers/cpufreq/Kconfig.arm
> +++ b/drivers/cpufreq/Kconfig.arm
> @@ -101,6 +101,7 @@ config ARM_OMAP2PLUS_CPUFREQ
>  config ARM_S3C2416_CPUFREQ
>  	bool "S3C2416 CPU Frequency scaling support"
>  	depends on CPU_S3C2416
> +	select CPU_FREQ_TABLE
>  	help
>  	  This adds the CPUFreq driver for the Samsung S3C2416 and
>  	  S3C2450 SoC. The S3C2416 supports changing the rate of the
> @@ -123,6 +124,7 @@ config ARM_S3C2416_CPUFREQ_VCORESCALE
>  config ARM_S3C64XX_CPUFREQ
>  	bool "Samsung S3C64XX"
>  	depends on CPU_S3C6410
> +	select CPU_FREQ_TABLE
>  	default y
>  	help
>  	  This adds the CPUFreq driver for Samsung S3C6410 SoC.

