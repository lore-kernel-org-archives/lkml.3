Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755243Ab3KOAyI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 19:54:08 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:13393 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753539Ab3KOAyD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 19:54:03 -0500
X-AuditID: cbfee690-b7f3d6d000001c4a-30-528570a96b6f
Message-id: <528570A9.1070109@samsung.com>
Date: Fri, 15 Nov 2013 09:54:01 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Cc: myungjoo.ham@samsung.com, sameo@linux.intel.com, lee.jones@linaro.org,
        patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 7/7] extcon: arizona: Improve headphone detection error
 handling
References: <1384445907-12859-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
 <1384445907-12859-7-git-send-email-ckeepax@opensource.wolfsonmicro.com>
In-reply-to: <1384445907-12859-7-git-send-email-ckeepax@opensource.wolfsonmicro.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrJIsWRmVeSWpSXmKPExsWyRsSkUHdVQWuQwYmvzBb/ptxgt7j/9Sij
	xeVdc9gsbjeuYLNY/vY/m8XpblYHNo871/awecw7GejxcuJvNo++LasYPT5vkgtgjeKySUnN
	ySxLLdK3S+DKuDLpJHPBHoOKvsVT2RsY56t2MXJySAiYSNzeeI4dwhaTuHBvPVsXIxeHkMBS
	Rok3jzYwwRQdXjCRGSKxiFGi58lvRgjnFaPElcfnWUCqeAW0JG5uOAbWwSKgKvHy2hKwOBtQ
	fP+LG2wgtqhAmMTK6Veg6gUlfky+B2aLCFhITFlyC2wDs0Afo8SjlpmsIAlhgUiJbytawYYK
	CcxnlPi5XQ7E5gQa9HT5X7AaZgEdif2t09ggbHmJzWvegg2SEDjGLvH2zDR2iIsEJL5NPgS0
	jQMoISux6QAzxGuSEgdX3GCZwCg2C8lNs5CMnYVk7AJG5lWMoqkFyQXFSelFJnrFibnFpXnp
	esn5uZsYgdF2+t+zCTsY7x2wPsSYDLRyIrOUaHI+MFrzSuINjc2MLExNTI2NzC3NSBNWEudV
	e5QUJCSQnliSmp2aWpBaFF9UmpNafIiRiYNTqoHR7CDPs4fKbeFfyhJnaFgYlEyqjzLb7+hz
	WiRxioW0mlUt/56GtXG53jGby8Ra1dUWyN8QWvNtVZnRutkuLB8eNa8wk3hYNIOLe1F1zXtB
	xs16YhKKGfbiP0svKj6a8XieiBlTXsWb5ZbH5lz+efnXGrf8/jWqjYaZrGz8nGwvtY6XtX69
	7qPEUpyRaKjFXFScCADt+8ifzAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprGKsWRmVeSWpSXmKPExsVy+t9jAd2VBa1BBncnWVj8m3KD3eL+16OM
	Fpd3zWGzuN24gs1i+dv/bBanu1kd2DzuXNvD5jHvZKDHy4m/2Tz6tqxi9Pi8SS6ANaqB0SYj
	NTEltUghNS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMH6AAlhbLEnFKg
	UEBicbGSvh2mCaEhbroWMI0Rur4hQXA9RgZoIGENY8aVSSeZC/YYVPQtnsrewDhftYuRk0NC
	wETi8IKJzBC2mMSFe+vZuhi5OIQEFjFK9Dz5zQjhvGKUuPL4PAtIFa+AlsTNDceYQGwWAVWJ
	l9eWgMXZgOL7X9xgA7FFBcIkVk6/AlUvKPFj8j0wW0TAQmLKklvMIEOZBfoYJR61zGQFSQgL
	REp8W9EKNlRIYD6jxM/tciA2J9Cgp8v/gtUwC+hI7G+dxgZhy0tsXvOWeQKjwCwkO2YhKZuF
	pGwBI/MqRtHUguSC4qT0XEO94sTc4tK8dL3k/NxNjOBYfia1g3Flg8UhRgEORiUe3gjp1iAh
	1sSy4srcQ4wSHMxKIrzPEoBCvCmJlVWpRfnxRaU5qcWHGJOBQTCRWUo0OR+YZvJK4g2NTcyM
	LI3MDS2MjM1JE1YS5z3Qah0oJJCeWJKanZpakFoEs4WJg1OqgdHna6RBw8PYl69/OR2r17nJ
	8ue0S1ieSl7pNc1mjo4o8UWZX97mPRFVTOnM27gl8ZKIqohZ/6Fq0Y9n7GYXvfv0cZNwOKdH
	oaQx4+SKOYWrLk2dcybF+P2JbzKPYqcv1KxTKN7Gc5GX+cjUPNv9l458dv747JHFuxQJrud8
	h0Veqyl6ax77skqJpTgj0VCLuag4EQBr5N+wKQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Charles,

On 11/15/2013 01:18 AM, Charles Keepax wrote:
> In several places the return value of regmap operations is not checked
> whilst handling headphone detection. This patch adds checks for these
> return values. Additionally, failing to read/write a register is a
> serious enough error we should abort the headphone detection process so
> correct a couple of cases where this was not the case.
> 
> Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
> ---
>  drivers/extcon/extcon-arizona.c |   82 ++++++++++++++++++++++++++++----------
>  1 files changed, 60 insertions(+), 22 deletions(-)
> 
> diff --git a/drivers/extcon/extcon-arizona.c b/drivers/extcon/extcon-arizona.c
> index d71a738..321dcc9 100644
> --- a/drivers/extcon/extcon-arizona.c
> +++ b/drivers/extcon/extcon-arizona.c
> @@ -399,22 +399,32 @@ static int arizona_hpdet_read_ip1(struct arizona_extcon_info *info)
>  	ret = regmap_read(arizona->regmap, ARIZONA_HP_DACVAL, &val);
>  	if (ret != 0) {

I prefer following checking statement
	if (ret < 0) instead of if (ret != 0) 

>  		dev_err(arizona->dev, "Failed to read HP value: %d\n", ret);
> -		return -EAGAIN;
> +		return ret;
>  	}
>  
> -	regmap_read(arizona->regmap, ARIZONA_HEADPHONE_DETECT_1, &range);
> +	ret = regmap_read(arizona->regmap, ARIZONA_HEADPHONE_DETECT_1, &range);
>  	range = (range & ARIZONA_HP_IMPEDANCE_RANGE_MASK)
>  		   >> ARIZONA_HP_IMPEDANCE_RANGE_SHIFT;

I prefer to move 'range operation' statement after checking ret value.

> +	if (ret != 0) {

ditto.

> +		dev_err(arizona->dev, "Failed to read HP range: %d\n", ret);
> +		return ret;
> +	}
>  
>  	if (range < ARRAY_SIZE(arizona_hpdet_b_ranges) - 1 &&
>  	    (val < 100 || val >= 0x3fb)) {
>  		range++;
>  		dev_dbg(arizona->dev, "Moving to HPDET range %d\n", range);
> -		regmap_update_bits(arizona->regmap,
> -				   ARIZONA_HEADPHONE_DETECT_1,
> -				   ARIZONA_HP_IMPEDANCE_RANGE_MASK,
> -				   range <<
> -				   ARIZONA_HP_IMPEDANCE_RANGE_SHIFT);
> +		ret = regmap_update_bits(arizona->regmap,
> +					 ARIZONA_HEADPHONE_DETECT_1,
> +					 ARIZONA_HP_IMPEDANCE_RANGE_MASK,
> +					 range <<
> +					 ARIZONA_HP_IMPEDANCE_RANGE_SHIFT);
> +		if (ret != 0) {

ditto.

> +			dev_err(arizona->dev,
> +				"Failed to move range (%d): %d\n",
> +				range, ret);
> +			return ret;
> +		}
>  		return -EAGAIN;


If below statement is true, arizona_hpdet_read_ip1 always return error?
This if statement return either 'ret' or '-EAGAIN'. 

  	if (range < ARRAY_SIZE(arizona_hpdet_b_ranges) - 1 &&
  	    (val < 100 || val >= 0x3fb)) {


>  	}
>  
> @@ -454,7 +464,11 @@ static int arizona_hpdet_read_ip2(struct arizona_extcon_info *info)
>  	/* Convert to ohms, the value is in 0.5 ohm increments */
>  	val /= 2;
>  
> -	regmap_read(arizona->regmap, ARIZONA_HEADPHONE_DETECT_1, &range);
> +	ret = regmap_read(arizona->regmap, ARIZONA_HEADPHONE_DETECT_1, &range);
> +	if (ret != 0) {

ditto.

> +		dev_err(arizona->dev, "Failed to read HP range: %d\n", ret);
> +		return ret;
> +	}
>  	range = (range & ARIZONA_HP_IMPEDANCE_RANGE_MASK)
>  		   >> ARIZONA_HP_IMPEDANCE_RANGE_SHIFT;
>  
> @@ -465,11 +479,17 @@ static int arizona_hpdet_read_ip2(struct arizona_extcon_info *info)
>  		dev_dbg(arizona->dev, "Moving to HPDET range %d-%d\n",
>  			arizona_hpdet_c_ranges[range].min,
>  			arizona_hpdet_c_ranges[range].max);
> -		regmap_update_bits(arizona->regmap,
> +		ret = regmap_update_bits(arizona->regmap,
>  				   ARIZONA_HEADPHONE_DETECT_1,
>  				   ARIZONA_HP_IMPEDANCE_RANGE_MASK,
>  				   range <<
>  				   ARIZONA_HP_IMPEDANCE_RANGE_SHIFT);
> +		if (ret != 0) {

ditto.

> +			dev_err(arizona->dev,
> +				"Failed to move range (%d): %d\n",
> +				range, ret);
> +			return ret;
> +		}
>  		return -EAGAIN;

ditto.

>  	}
>  
> @@ -519,6 +539,7 @@ static int arizona_hpdet_do_id(struct arizona_extcon_info *info, int *reading,
>  {
>  	struct arizona *arizona = info->arizona;
>  	int id_gpio = arizona->pdata.hpdet_id_gpio;
> +	int ret;
>  
>  	/*
>  	 * If we're using HPDET for accessory identification we need
> @@ -531,18 +552,30 @@ static int arizona_hpdet_do_id(struct arizona_extcon_info *info, int *reading,
>  		if (id_gpio && info->num_hpdet_res == 1) {
>  			dev_dbg(arizona->dev, "Measuring mic\n");
>  
> -			regmap_update_bits(arizona->regmap,
> -					   ARIZONA_ACCESSORY_DETECT_MODE_1,
> -					   ARIZONA_ACCDET_MODE_MASK |
> -					   ARIZONA_ACCDET_SRC,
> -					   ARIZONA_ACCDET_MODE_HPR |
> -					   info->micd_modes[0].src);
> +			ret = regmap_update_bits(arizona->regmap,
> +					ARIZONA_ACCESSORY_DETECT_MODE_1,
> +					ARIZONA_ACCDET_MODE_MASK |
> +					ARIZONA_ACCDET_SRC,
> +					ARIZONA_ACCDET_MODE_HPR |
> +					info->micd_modes[0].src);
> +			if (ret != 0) {
> +				dev_err(arizona->dev,
> +					"Failed to change HPDET source: %d\n",
> +					ret);
> +				return ret;
> +			}
>  
>  			gpio_set_value_cansleep(id_gpio, 1);
>  
> -			regmap_update_bits(arizona->regmap,
> -					   ARIZONA_HEADPHONE_DETECT_1,
> -					   ARIZONA_HP_POLL, ARIZONA_HP_POLL);
> +			ret = regmap_update_bits(arizona->regmap,
> +					ARIZONA_HEADPHONE_DETECT_1,
> +					ARIZONA_HP_POLL, ARIZONA_HP_POLL);
> +			if (ret != 0) {
> +				dev_err(arizona->dev,
> +					"Failed to re-enable HPDET: %d\n",
> +					ret);
> +				return ret;
> +			}
>  			return -EAGAIN;

Always return error?

>  		}
>  
> @@ -575,10 +608,15 @@ static int arizona_hpdet_do_id(struct arizona_extcon_info *info, int *reading,
>  		}
>  
>  		/* Make sure everything is reset back to the real polarity */
> -		regmap_update_bits(arizona->regmap,
> -				   ARIZONA_ACCESSORY_DETECT_MODE_1,
> -				   ARIZONA_ACCDET_SRC,
> -				   info->micd_modes[0].src);
> +		ret = regmap_update_bits(arizona->regmap,
> +					 ARIZONA_ACCESSORY_DETECT_MODE_1,
> +					 ARIZONA_ACCDET_SRC,
> +					 info->micd_modes[0].src);
> +		if (ret != 0) {

ditto.

> +			dev_err(arizona->dev, "Failed to reset polarity: %d\n",
> +				ret);
> +			return ret;
> +		}
>  	}
>  
>  	return 0;
> 

Thanks,
Chanwoo Choi
