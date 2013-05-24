Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760034Ab3EXD5q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 23:57:46 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:28471 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759956Ab3EXD5p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 23:57:45 -0400
X-AuditID: cbfee68d-b7f096d0000043fc-7d-519ee537e65b
Message-id: <519EE53F.6010005@samsung.com>
Date: Fri, 24 May 2013 12:57:51 +0900
From: Jaehoon Chung <jh80.chung@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130510
 Thunderbird/17.0.6
MIME-version: 1.0
To: "Felipe F. Tonello" <eu@felipetonello.com>
Cc: linux-mmc@vger.kernel.org, ben-linux@fluff.org, cjb@laptop.org,
        arnd@arndb.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] mmc: sdhci-s3c: Added set_power handler to platdata
References: <1369244832-23868-1-git-send-email-eu@felipetonello.com>
 <1369244832-23868-3-git-send-email-eu@felipetonello.com>
In-reply-to: <1369244832-23868-3-git-send-email-eu@felipetonello.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrOIsWRmVeSWpSXmKPExsWyRsSkSNf86bxAgyWHRS3+TjrGbjFp3QEm
	i+2vN7JZdM4/y25xedccNosj//sZHdg8fv+axOhx9+tDdo+/q14wexy6spbR4/MmuQDWKC6b
	lNSczLLUIn27BK6Mpfe+sBQ8FKj42fqWsYHxIm8XIyeHhICJxLd/y9ggbDGJC/fWg9lCAksZ
	Jf7MioWpmby3h7GLkQsovohRYtrv1WwQzktGiX2L3rB0MXJw8ApoSXzfKAPSwCKgKrGzeR0r
	iM0moCOx/dtxJhBbVCBMYlNPM5jNKyAo8WPyPbBWEQE9ib7dVSBhZoFCiWcnjrCA2MICPhK7
	p16HuqdeYvOe32BxTgFXifO/m1kh6nUk9rdOY4Ow5SU2r3nLDHKahMApdommD3MZIe4RkPg2
	+RDYLgkBWYlNB5gh/pKUOLjiBssERrFZSC6ahWTsLCRjFzAyr2IUTS1ILihOSi8y1CtOzC0u
	zUvXS87P3cQIjLTT/5717mC8fcD6EGMy0MqJzFKiyfnASM0riTc0NjOyMDUxNTYytzQjTVhJ
	nFetxTpQSCA9sSQ1OzW1ILUovqg0J7X4ECMTB6dUA2OkDoO13M3Da9STXgdt3zq5OPg7L3ec
	p93JZNc//korG/lfpiv/eWd3bMJ8sY1HF8o6e89gDzZsbM0WMtxx+PpGs6wZxkEvjPgjBWZd
	nLzlJU/IG6X1b2KNF/GICLrVrP7ZJLE0oVxt2jwN+dT0xuM1HAyL1lSv37Euju/1ieojLP8+
	P5Hyi1diKc5INNRiLipOBAD7wrRLygIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprKKsWRmVeSWpSXmKPExsVy+t9jAV3zp/MCDRpn8Vn8nXSM3WLSugNM
	Fttfb2Sz6Jx/lt3i8q45bBZH/vczOrB5/P41idHj7teH7B5/V71g9jh0ZS2jx+dNcgGsUQ2M
	NhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+AbpumTlAJygplCXm
	lAKFAhKLi5X07TBNCA1x07WAaYzQ9Q0JgusxMkADCWsYM5be+8JS8FCg4mfrW8YGxou8XYyc
	HBICJhKT9/YwQthiEhfurWfrYuTiEBJYxCgx7fdqKOclo8S+RW9Yuhg5OHgFtCS+b5QBaWAR
	UJXY2byOFcRmE9CR2P7tOBOILSoQJrGppxnM5hUQlPgx+R5Yq4iAnkTf7iqQMLNAocSzE0dY
	QGxhAR+J3VOvs4HYQgL1Epv3/AaLcwq4Spz/3cwKUa8jsb91GhuELS+xec1b5gmMArOQbJiF
	pGwWkrIFjMyrGEVTC5ILipPScw31ihNzi0vz0vWS83M3MYIj+ZnUDsaVDRaHGAU4GJV4eGfo
	zAsUYk0sK67MPcQowcGsJMJbGAYU4k1JrKxKLcqPLyrNSS0+xJgMDICJzFKiyfnAJJNXEm9o
	bGJmZGlkbmhhZGxOmrCSOO+BVutAIYH0xJLU7NTUgtQimC1MHJxSDYyy2Zt6ekTTT57duadj
	yu6gXRmzOF4EzHtpJ54pp2YtsrZIbD2f+dwPm4uemNUfabkju+jrUsmoG5+tebcYmm0yWBur
	GlZ/9vMpizaTD0Hbe02ExPkd9Iv23OmvKrNJDe6foP3Q/HaXzNubu5b85VtgHTh92+ewHMXf
	SwVtn5vceztJcMbZNSpKLMUZiYZazEXFiQDajF15KAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Felipe,

I didn't understand this patch, why need to add set_power?
We can use to control the power with the fixed regulator.
Then we can also use the regulator framework.
And i know also control the module like wifi with rfkill.
In set_power, what is it controlled?

Best Regards,
Jaehoon Chung
On 05/23/2013 02:47 AM, Felipe F. Tonello wrote:
> From: "Felipe F. Tonello" <eu@felipetonello.com>
> 
> This is useful to turn off peripherals that are related to the mmc host. One
> common case is when the wifi module is connected as an mmc card to the host.
> 
> Signed-off-by: Felipe F. Tonello <eu@felipetonello.com>
> ---
>  drivers/mmc/host/sdhci-s3c.c                | 8 ++++++++
>  include/linux/platform_data/mmc-sdhci-s3c.h | 1 +
>  2 files changed, 9 insertions(+)
> 
> diff --git a/drivers/mmc/host/sdhci-s3c.c b/drivers/mmc/host/sdhci-s3c.c
> index c6f6246..f7e740c 100644
> --- a/drivers/mmc/host/sdhci-s3c.c
> +++ b/drivers/mmc/host/sdhci-s3c.c
> @@ -360,11 +360,19 @@ static int sdhci_s3c_platform_bus_width(struct sdhci_host *host, int width)
>  	return 0;
>  }
>  
> +static void sdhci_s3c_set_power(struct sdhci_host *host, bool power)
> +{
> +	struct sdhci_s3c *ourhost = to_s3c(host);
> +	if (ourhost->pdata->set_power)
> +		ourhost->pdata->set_power(power);
> +}
> +
>  static struct sdhci_ops sdhci_s3c_ops = {
>  	.get_max_clock		= sdhci_s3c_get_max_clk,
>  	.set_clock		= sdhci_s3c_set_clock,
>  	.get_min_clock		= sdhci_s3c_get_min_clock,
>  	.platform_bus_width	= sdhci_s3c_platform_bus_width,
> +	.set_power		= sdhci_s3c_set_power,
>  };
>  
>  static void sdhci_s3c_notify_change(struct platform_device *dev, int state)
> diff --git a/include/linux/platform_data/mmc-sdhci-s3c.h b/include/linux/platform_data/mmc-sdhci-s3c.h
> index 249f023..55be925 100644
> --- a/include/linux/platform_data/mmc-sdhci-s3c.h
> +++ b/include/linux/platform_data/mmc-sdhci-s3c.h
> @@ -50,6 +50,7 @@ struct s3c_sdhci_platdata {
>  						      int state));
>  
>  	void	(*cfg_gpio)(struct platform_device *dev, int width);
> +	void	(*set_power)(bool power);
>  };
>  
>  
> 

