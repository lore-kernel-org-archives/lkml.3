Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753641Ab3GOAEg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jul 2013 20:04:36 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:42714 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753511Ab3GOAEe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jul 2013 20:04:34 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Viresh Kumar <viresh.kumar@linaro.org>, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cpufreq: s3c24xx: rename CONFIG_CPU_FREQ_S3C24XX_DEBUGFS
Date: Mon, 15 Jul 2013 02:14:27 +0200
Message-ID: <12749497.boFBrcRXQg@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1373826596.1370.59.camel@x61.thuisdomein>
References: <1373826596.1370.59.camel@x61.thuisdomein>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, July 14, 2013 08:29:56 PM Paul Bolle wrote:
> The Kconfig symbol CPU_FREQ_S3C24XX_DEBUGFS was renamed to
> ARM_S3C24XX_CPUFREQ_DEBUGFS in commit f023f8dd59 ("cpufreq: s3c24xx:
> move cpufreq driver to drivers/cpufreq"). But that commit missed one
> instance of its macro CONFIG_CPU_FREQ_S3C24XX_DEBUGFS. Rename it too.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>

Queued up as a fix for 3.11.

Thanks,
Rafael


> ---
> Untested. Needs compile testing. But please note that setting
> ARM_S3C24XX_CPUFREQ_DEBUGFS should currently lead to compile errors.
> 
>  drivers/cpufreq/s3c24xx-cpufreq.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/cpufreq/s3c24xx-cpufreq.c b/drivers/cpufreq/s3c24xx-cpufreq.c
> index 3513e74..87781eb 100644
> --- a/drivers/cpufreq/s3c24xx-cpufreq.c
> +++ b/drivers/cpufreq/s3c24xx-cpufreq.c
> @@ -49,7 +49,7 @@ static struct clk *clk_hclk;
>  static struct clk *clk_pclk;
>  static struct clk *clk_arm;
>  
> -#ifdef CONFIG_CPU_FREQ_S3C24XX_DEBUGFS
> +#ifdef CONFIG_ARM_S3C24XX_CPUFREQ_DEBUGFS
>  struct s3c_cpufreq_config *s3c_cpufreq_getconfig(void)
>  {
>  	return &cpu_cur;
> @@ -59,7 +59,7 @@ struct s3c_iotimings *s3c_cpufreq_getiotimings(void)
>  {
>  	return &s3c24xx_iotiming;
>  }
> -#endif /* CONFIG_CPU_FREQ_S3C24XX_DEBUGFS */
> +#endif /* CONFIG_ARM_S3C24XX_CPUFREQ_DEBUGFS */
>  
>  static void s3c_cpufreq_getcur(struct s3c_cpufreq_config *cfg)
>  {
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
