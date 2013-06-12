Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756504Ab3FLLiB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 07:38:01 -0400
Received: from mail-db8lp0188.outbound.messaging.microsoft.com ([213.199.154.188]:51464
	"EHLO db8outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756319Ab3FLLh7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 07:37:59 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(zz98dI1432Izz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzz8275dhz2dh87h2a8h668h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1151h1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Wed, 12 Jun 2013 19:38:18 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: <rjw@sisk.pl>, <linaro-kernel@lists.linaro.org>, <patches@linaro.org>,
        <cpufreq@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <robin.randhawa@arm.com>,
        <Steve.Bannister@arm.com>, <Liviu.Dudau@arm.com>,
        <charles.garcia-tobin@arm.com>, <arvind.chauhan@arm.com>,
        <arnd@arndb.de>
Subject: Re: [PATCH 06/11] cpufreq: imx: select CPU_FREQ_TABLE
Message-ID: <20130612113817.GC13274@S2101-09.ap.freescale.net>
References: <cover.1371022830.git.viresh.kumar@linaro.org>
 <7568bf22f9e40425bb0fe86cd6f44c4dc2d0c7c5.1371022830.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <7568bf22f9e40425bb0fe86cd6f44c4dc2d0c7c5.1371022830.git.viresh.kumar@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 12, 2013 at 01:45:13PM +0530, Viresh Kumar wrote:
> CPUFreq driver of this platform uses APIs from freq_table.c and so must select
> CPU_FREQ_TABLE.
> 
> Cc: Shawn Guo <shawn.guo@linaro.org>
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>

Acked-by: Shawn Guo <shawn.guo@linaro.org>

> ---
>  drivers/cpufreq/Kconfig.arm | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/cpufreq/Kconfig.arm b/drivers/cpufreq/Kconfig.arm
> index 891dd1c..dc26303 100644
> --- a/drivers/cpufreq/Kconfig.arm
> +++ b/drivers/cpufreq/Kconfig.arm
> @@ -72,6 +72,7 @@ config ARM_IMX6Q_CPUFREQ
>  	tristate "Freescale i.MX6Q cpufreq support"
>  	depends on SOC_IMX6Q
>  	depends on REGULATOR_ANATOP
> +	select CPU_FREQ_TABLE
>  	help
>  	  This adds cpufreq driver support for Freescale i.MX6Q SOC.
>  
> -- 
> 1.7.12.rc2.18.g61b472e
> 

