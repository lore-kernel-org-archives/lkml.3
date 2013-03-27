Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755989Ab3C0DX0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 23:23:26 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:25105 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754087Ab3C0DXY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 23:23:24 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(zz98dI1432Izz1f42h1ee6h1de0h1202h1e76h1d1ah1d2ahzz8275dhz2dh87h2a8h668h839h944hd25hd2bhf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Wed, 27 Mar 2013 11:23:13 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: <rjw@sisk.pl>, <cpufreq@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linaro-kernel@lists.linaro.org>,
        <arvind.chauhan@arm.com>, <robin.randhawa@arm.com>,
        <Steve.Bannister@arm.com>, <Liviu.Dudau@arm.com>,
        <charles.garcia-tobin@arm.com>, <rob.herring@calxeda.com>
Subject: Re: [PATCH] cpufreq: cpu0: Fix mistake in Documentation example
Message-ID: <20130327032310.GA2767@r65073-Latitude-E6420>
References: <225d20676ec96aa81683f23485f0339e32a22917.1364308732.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <225d20676ec96aa81683f23485f0339e32a22917.1364308732.git.viresh.kumar@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 26, 2013 at 08:10:46PM +0530, Viresh Kumar wrote:
> "clock-latency" is incorrectly written as "transition-latency" in an example
> present in Documentation of cpufreq-cpu0. Fix it.
> 
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>

Acked-by: Shawn Guo <shawn.guo@linaro.org>

> ---
>  Documentation/devicetree/bindings/cpufreq/cpufreq-cpu0.txt | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/Documentation/devicetree/bindings/cpufreq/cpufreq-cpu0.txt b/Documentation/devicetree/bindings/cpufreq/cpufreq-cpu0.txt
> index 4416ccc..051f764 100644
> --- a/Documentation/devicetree/bindings/cpufreq/cpufreq-cpu0.txt
> +++ b/Documentation/devicetree/bindings/cpufreq/cpufreq-cpu0.txt
> @@ -32,7 +32,7 @@ cpus {
>  			396000  950000
>  			198000  850000
>  		>;
> -		transition-latency = <61036>; /* two CLK32 periods */
> +		clock-latency = <61036>; /* two CLK32 periods */
>  	};
>  
>  	cpu@1 {
> -- 
> 1.7.12.rc2.18.g61b472e
> 

