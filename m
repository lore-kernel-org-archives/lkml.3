Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754346Ab3FLOXy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 10:23:54 -0400
Received: from co9ehsobe001.messaging.microsoft.com ([207.46.163.24]:34041
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751438Ab3FLOXw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 10:23:52 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VPS-3(zz98dI148cI1432Izz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzz8275bh8275dhz2dh668h839h944hd25hd2bhf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1155h)
X-WSS-ID: 0MOAANL-01-69B-02
X-M-MSG: 
Date: Wed, 12 Jun 2013 09:23:43 -0500
From: Jacob Shin <jacob.shin@amd.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: <rjw@sisk.pl>, <linaro-kernel@lists.linaro.org>, <patches@linaro.org>,
        <cpufreq@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <robin.randhawa@arm.com>,
        <Steve.Bannister@arm.com>, <Liviu.Dudau@arm.com>,
        <charles.garcia-tobin@arm.com>, <arvind.chauhan@arm.com>,
        <arnd@arndb.de>
Subject: Re: [PATCH 11/11] cpufreq: X86_AMD_FREQ_SENSITIVITY: select
 CPU_FREQ_TABLE
Message-ID: <20130612142343.GA15934@jshin-Toonie>
References: <cover.1371022830.git.viresh.kumar@linaro.org>
 <3f143e3112c038c805ea4e66ea91d12c5800acdf.1371022830.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <3f143e3112c038c805ea4e66ea91d12c5800acdf.1371022830.git.viresh.kumar@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 12, 2013 at 01:45:18PM +0530, Viresh Kumar wrote:
> This CPUFreq driver uses APIs from freq_table.c and so must select
> CPU_FREQ_TABLE.
> 

Ah, thanks for cathcing this!

> Cc: Jacob Shin <jacob.shin@amd.com>
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>

Acked-by: Jacob Shin <jacob.shin@amd.com>

> ---
>  drivers/cpufreq/Kconfig.x86 | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/cpufreq/Kconfig.x86 b/drivers/cpufreq/Kconfig.x86
> index 6bd63d6..e2b6eab 100644
> --- a/drivers/cpufreq/Kconfig.x86
> +++ b/drivers/cpufreq/Kconfig.x86
> @@ -132,6 +132,7 @@ config X86_POWERNOW_K8
>  config X86_AMD_FREQ_SENSITIVITY
>  	tristate "AMD frequency sensitivity feedback powersave bias"
>  	depends on CPU_FREQ_GOV_ONDEMAND && X86_ACPI_CPUFREQ && CPU_SUP_AMD
> +	select CPU_FREQ_TABLE
>  	help
>  	  This adds AMD-specific powersave bias function to the ondemand
>  	  governor, which allows it to make more power-conscious frequency
> -- 
> 1.7.12.rc2.18.g61b472e
> 
> 

