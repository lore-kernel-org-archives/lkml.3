Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751613AbaEUCS0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 22:18:26 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:35453 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751073AbaEUCSZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 22:18:25 -0400
X-AuditID: cbfee68f-b7fef6d000003970-9a-537c0cec1489
Message-id: <537C0CEC.5080406@samsung.com>
Date: Wed, 21 May 2014 11:18:20 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Richard Fitzgerald <rf@opensource.wolfsonmicro.com>
Cc: myungjoo.ham@samsung.com, sameo@linux.intel.com, lee.jones@linaro.org,
        broonie@linaro.org, ckeepax@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Subject: Re: [PATCH] extcon: arizona: support inverted jack detect switch
References: <20140520115632.GA13900@opensource.wolfsonmicro.com>
In-reply-to: <20140520115632.GA13900@opensource.wolfsonmicro.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrIIsWRmVeSWpSXmKPExsWyRsSkSPcNT02wwcx2S4tN16+zWvybcoPd
	4v7Xo4wWl3fNYbO43biCzWL52/9sFrMm/mGxON3N6sDhcefaHjaPeScDPV5O/M3m0bdlFaPH
	501yAaxRXDYpqTmZZalF+nYJXBl7nsxkLHghUfHm+lnWBsYtwl2MnBwSAiYS/WuPsUPYYhIX
	7q1n62Lk4hASWMoo8eL4BXaYotbPO5hAbCGBRYwSl14lQxS9ZpRYsPQqC0iCV0BLYs6N68wg
	NouAqsSpbR/ZQGw2oPj+FzfAbFGBMImV069A1QtK/Jh8D8wWETCXWHzzDiuIzSxwklFiUbsV
	iC0s4CnRunk5O8RiB4kzc+eAHcEp4Cix+f9edoh6HYn9rdPYIGx5ic1r3jKDHCchcI5d4uLN
	OYwQBwlIfJt8CGgZB1BCVmLTAWaIxyQlDq64wTKBUWwWkpNmIRk7C8nYBYzMqxhFUwuSC4qT
	0ouM9YoTc4tL89L1kvNzNzECo+/0v2f9OxjvHrA+xJgMtHIis5Rocj4wevNK4g2NzYwsTE1M
	jY3MLc1IE1YS573/MClISCA9sSQ1OzW1ILUovqg0J7X4ECMTB6dUAyNTp6LQYs6levkLPux+
	/ta27YCEVICbgDO34Ou9Tn/mTlAXkzzpp28uEnz6Br8743/21XMqrrrZ9PfXcjdtUWK7wWid
	/OH2vUdfNO+8dvjdtYKBfbJ1bNyT0jNh1w2sPofa2AVxsS6MU7dusp+3lIn7Z+btNZtimuV3
	d7Xmvj317VNgv13WJyWW4oxEQy3mouJEAI+JL/XUAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprHKsWRmVeSWpSXmKPExsVy+t9jAd03PDXBBr0/DCw2Xb/OavFvyg12
	i/tfjzJaXN41h83iduMKNovlb/+zWcya+IfF4nQ3qwOHx51re9g85p0M9Hg58TebR9+WVYwe
	nzfJBbBGNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE6Lpl
	5gCdoqRQlphTChQKSCwuVtK3wzQhNMRN1wKmMULXNyQIrsfIAA0krGHM2PNkJmPBC4mKN9fP
	sjYwbhHuYuTkkBAwkWj9vIMJwhaTuHBvPRuILSSwiFHi0qvkLkYuIPs1o8SCpVdZQBK8AloS
	c25cZwaxWQRUJU5t+wjWwAYU3//iBpgtKhAmsXL6Fah6QYkfk++B2SIC5hKLb95hBbGZBU4y
	SixqtwKxhQU8JVo3L2eHWOwgcWbuHLCDOAUcJTb/38sOUa8jsb91GhuELS+xec1b5gmMArOQ
	rJiFpGwWkrIFjMyrGEVTC5ILipPSc430ihNzi0vz0vWS83M3MYJj+5n0DsZVDRaHGAU4GJV4
	eBcUVQcLsSaWFVfmHmKU4GBWEuGd9wkoxJuSWFmVWpQfX1Sak1p8iDEZGAITmaVEk/OBaSev
	JN7Q2MTMyNLI3NDCyNicNGElcd6DrdaBQgLpiSWp2ampBalFMFuYODilGhhb1j6LOKHWc6m5
	686vmRKvXhfa7ObbLcN176TC6pvM/4+zME+da/014KErp++P7myVY30XToWZtTbf/tebf9ly
	RcLzm3t3bH6+/aD57Bf7sx5sbZzkVGQg4FC6WcEh0OymVd7N15/O79nqtvvTbP5HC7f7bTqn
	+vvLw/MnnMu321+Mm2lwXrJdW4mlOCPRUIu5qDgRAMdwKvcxAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Richard,

On 05/20/2014 08:56 PM, Richard Fitzgerald wrote:
> Add pdata option for inverted jack detect switch that
> opens when jack is inserted.
> 
> Signed-off-by: Richard Fitzgerald <rf@opensource.wolfsonmicro.com>
> ---
>  drivers/extcon/extcon-arizona.c   |   29 +++++++++++++++++++++--------
>  include/linux/mfd/arizona/pdata.h |    3 +++
>  2 files changed, 24 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/extcon/extcon-arizona.c b/drivers/extcon/extcon-arizona.c
> index 98a14f6..af926b9 100644
> --- a/drivers/extcon/extcon-arizona.c
> +++ b/drivers/extcon/extcon-arizona.c
> @@ -962,10 +962,16 @@ static irqreturn_t arizona_jackdet(int irq, void *data)
>  
>  	if (arizona->pdata.jd_gpio5) {
>  		mask = ARIZONA_MICD_CLAMP_STS;
> -		present = 0;
> +		if (arizona->pdata.jd_invert)
> +			present = ARIZONA_MICD_CLAMP_STS;
> +		else
> +			present = 0;
>  	} else {
>  		mask = ARIZONA_JD1_STS;
> -		present = ARIZONA_JD1_STS;
> +		if (arizona->pdata.jd_invert)
> +			present = 0;
> +		else
> +			present = ARIZONA_JD1_STS;
>  	}
>  
>  	ret = regmap_read(arizona->regmap, ARIZONA_AOD_IRQ_RAW_STATUS, &val);
> @@ -1096,6 +1102,7 @@ static int arizona_extcon_probe(struct platform_device *pdev)
>  	struct arizona_pdata *pdata = &arizona->pdata;
>  	struct arizona_extcon_info *info;
>  	unsigned int val;
> +	unsigned int clamp_mode;
>  	int jack_irq_fall, jack_irq_rise;
>  	int ret, mode, i, j;
>  
> @@ -1302,16 +1309,22 @@ static int arizona_extcon_probe(struct platform_device *pdev)
>  			regmap_write(arizona->regmap, ARIZONA_GPIO5_CTRL,
>  				     val);
>  
> -			regmap_update_bits(arizona->regmap,
> -					   ARIZONA_MICD_CLAMP_CONTROL,
> -					   ARIZONA_MICD_CLAMP_MODE_MASK, 0x9);
> +			if (arizona->pdata.jd_invert)
> +				clamp_mode = 0xb;

What is meaning of '0xb'?
I prefer to use defined constant instead of using hex value directly.

For exmaple,
#define XXX_CLAMP_MODE	0xb

> +			else
> +				clamp_mode = 0x9;

ditto.

>  		} else {
> -			regmap_update_bits(arizona->regmap,
> -					   ARIZONA_MICD_CLAMP_CONTROL,
> -					   ARIZONA_MICD_CLAMP_MODE_MASK, 0x4);
> +			if (arizona->pdata.jd_invert)
> +				clamp_mode = 0x5;

ditto.

> +			else
> +				clamp_mode = 0x4;

ditto.

>  		}
>  
>  		regmap_update_bits(arizona->regmap,
> +				   ARIZONA_MICD_CLAMP_CONTROL,
> +				   ARIZONA_MICD_CLAMP_MODE_MASK, clamp_mode);
> +
> +		regmap_update_bits(arizona->regmap,
>  				   ARIZONA_JACK_DETECT_DEBOUNCE,
>  				   ARIZONA_MICD_CLAMP_DB,
>  				   ARIZONA_MICD_CLAMP_DB);
> diff --git a/include/linux/mfd/arizona/pdata.h b/include/linux/mfd/arizona/pdata.h
> index 12a5c13..4578c72 100644
> --- a/include/linux/mfd/arizona/pdata.h
> +++ b/include/linux/mfd/arizona/pdata.h
> @@ -127,6 +127,9 @@ struct arizona_pdata {
>  	/** Internal pull on GPIO5 is disabled when used for jack detection */
>  	bool jd_gpio5_nopull;
>  
> +	/** set to true if jackdet contact opens on insert */
> +	bool jd_invert;
> +
>  	/** Use the headphone detect circuit to identify the accessory */
>  	bool hpdet_acc_id;
>  
> 

Thanks,
Chanwoo Choi
