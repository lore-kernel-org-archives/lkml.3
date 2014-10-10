Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752699AbaJJIpu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 04:45:50 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:25641 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751804AbaJJIpp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 04:45:45 -0400
X-AuditID: cbfee68e-f79b46d000002b74-1d-54379cb636a6
Message-id: <54379CB6.1040405@samsung.com>
Date: Fri, 10 Oct 2014 17:45:42 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH fixes 2/2] extcon: max77693: Fix always masked MUIC
 interrupts
References: <1412929322-21908-1-git-send-email-k.kozlowski@samsung.com>
 <1412929322-21908-2-git-send-email-k.kozlowski@samsung.com>
In-reply-to: <1412929322-21908-2-git-send-email-k.kozlowski@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrKIsWRmVeSWpSXmKPExsWyRsSkWHfbHPMQg2XNwhYbZ6xntXj9wtDi
	bNMbdov7X48yWlzeNYfNYu2Ru+wWtxtXsFmc7ma1WLDxEaMDp8eda3vYPOadDPTo27KK0ePz
	JrkAligum5TUnMyy1CJ9uwSujHsvZAu+iFVMbPvM3MB4UaiLkZNDQsBEYt6H/0wQtpjEhXvr
	2boYuTiEBJYySpy6vQ3I4QArur20GiK+iFFi/abl7BDOa0aJD13LmUG6eQW0JLZOnsYOYrMI
	qEoc/7sezGYDiu9/cYMNxBYVCJNYOf0KC0S9oMSPyffAbBEBQ4mDu7czgQxlFtjPJHH49Aaw
	BmGBEIm7b34yQmxrZZQ48WkqI8hJnAIeEo+vSYDUMAvoSOxvncYGYctLbF7zlhmkXkLgErvE
	88+PmSAuEpD4NvkQC8Q7shKbDjBDvCwpcXDFDZYJjGKzkNw0C8nYWUjGLmBkXsUomlqQXFCc
	lF5kpFecmFtcmpeul5yfu4kRGHun/z3r28F484D1IUYBDkYlHt4LMuYhQqyJZcWVuYcYTYGu
	mMgsJZqcD4zwvJJ4Q2MzIwtTE1NjI3NLMyVx3gSpn8FCAumJJanZqakFqUXxRaU5qcWHGJk4
	OKUaGPvn7nO697prz2rvRYkFpS/vhG608XTq8VjQmDNZc7PFp5KImOqe96IfjI4zvtBdfFJF
	vGphXHOjgPkzpamLHkyfyfj1wu9d72dLisQrfjz9XF4wlP++zpWHuz8fXJtcvvzhZuV7zPuu
	nG/vPZYQpjVfZvOuDoXse1vaXGW1/KYsTNx6MYf7UpgSS3FGoqEWc1FxIgAS+zRxuAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrPIsWRmVeSWpSXmKPExsVy+t9jAd1tc8xDDOa85LLYOGM9q8XrF4YW
	Z5vesFvc/3qU0eLyrjlsFmuP3GW3uN24gs3idDerxYKNjxgdOD3uXNvD5jHvZKBH35ZVjB6f
	N8kFsEQ1MNpkpCampBYppOYl56dk5qXbKnkHxzvHm5oZGOoaWlqYKynkJeam2iq5+AToumXm
	AF2ipFCWmFMKFApILC5W0rfDNCE0xE3XAqYxQtc3JAiux8gADSSsYcy490K24ItYxcS2z8wN
	jBeFuhg5OCQETCRuL63uYuQEMsUkLtxbz9bFyMUhJLCIUWL9puXsEM5rRokPXcuZQap4BbQk
	tk6exg5iswioShz/ux7MZgOK739xgw3EFhUIk1g5/QoLRL2gxI/J98BsEQFDiYO7tzOBDGUW
	2M8kcfj0BrAGYYEQibtvfjJCbGtllDjxaSojyHmcAh4Sj69JgNQwC+hI7G+dxgZhy0tsXvOW
	eQKjwCwkO2YhKZuFpGwBI/MqRtHUguSC4qT0XEO94sTc4tK8dL3k/NxNjODIfia1g3Flg8Uh
	RgEORiUe3gsy5iFCrIllxZW5hxglOJiVRHj1TYFCvCmJlVWpRfnxRaU5qcWHGE2BQTCRWUo0
	OR+YdPJK4g2NTcyMLI3MDS2MjM2VxHkPtFoHCgmkJ5akZqemFqQWwfQxcXBKNTCWFSxwnris
	MWSmVGdq/n+mYD1jm5g5nEk/V4p/Fp3Q826zv/bMOQvuzQ/rCAh6wmp+xl8mpVtx7efrmlcZ
	3/lkvdkSLjBBVf1yvt7plWz6wfEzHiS+/7+69NGmF4/ef4g+84614p9HTqGT+Jf3b8Lz/uZp
	O5g8Sbuwuksr2TB5jcXn1KyTy+YqsRRnJBpqMRcVJwIAybeWuwIDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/10/2014 05:22 PM, Krzysztof Kozlowski wrote:
> All interrupts coming from MUIC were ignored because interrupt source
> register was masked.
> 
> The Maxim 77693 has a "interrupt source" - a separate register and interrupts
> which give information about PMIC block triggering the individual
> interrupt (charger, topsys, MUIC, flash LED).
> 
> By default bootloader could initialize this register to "mask all"
> value. In such case (observed on Trats2 board) MUIC interrupts won't be
> generated regardless of their mask status. Regmap irq chip was unmasking
> individual MUIC interrupts but the source was masked
> 
> Before introducing regmap irq chip this interrupt source was unmasked,
> read and acked. Reading and acking is not necessary but unmasking is. Do
> it in extcon driver.
> 
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> Cc: <stable@vger.kernel.org>
> Fixes: 342d669c1ee4 ("mfd: max77693: Handle IRQs using regmap")
> ---
>  drivers/extcon/extcon-max77693.c     | 16 ++++++++++++++++
>  include/linux/mfd/max77693-private.h |  5 +++++
>  2 files changed, 21 insertions(+)
> 
> diff --git a/drivers/extcon/extcon-max77693.c b/drivers/extcon/extcon-max77693.c
> index 490e27475bac..d3adacf3187f 100644
> --- a/drivers/extcon/extcon-max77693.c
> +++ b/drivers/extcon/extcon-max77693.c
> @@ -1176,6 +1176,22 @@ static int max77693_muic_probe(struct platform_device *pdev)
>  		}
>  	}
>  
> +	if (i) {
> +		/*
> +		 * i>0, at least one MUIC interrupt requested so need to unmask
> +		 * MUIC interrupt in INTSRC register. Without that MUIC
> +		 * interrupts will not be reported.
> +		 */
> +		ret = regmap_update_bits(max77693->regmap,
> +				MAX77693_PMIC_REG_INTSRC_MASK, SRC_IRQ_MUIC,
> +				~SRC_IRQ_MUIC);
> +		if (ret < 0) {
> +			dev_err(&pdev->dev, "Could not unmask MUIC interrupt in INTSRC: %d\n",
> +					ret);
> +			return ret;
> +		}
> +	}
> +

No,
The extcon-max77693 driver cannot enable IRQ_CHARGER/TOP/FLASH
because MAX77693_PMIC_REG_INTSRC_MASK register is common register of MAX77693.

The IRQ_CHARGER/TOP/FLASH of MAX77693_PMIC_REG_INTSRC_MASK register should be enabled
in drivers/mfd/max77693.c.

>  	/* Initialize extcon device */
>  	info->edev = devm_extcon_dev_allocate(&pdev->dev,
>  					      max77693_extcon_cable);
> diff --git a/include/linux/mfd/max77693-private.h b/include/linux/mfd/max77693-private.h
> index e1b2b61285b9..4f1a80b66ecf 100644
> --- a/include/linux/mfd/max77693-private.h
> +++ b/include/linux/mfd/max77693-private.h
> @@ -438,6 +438,11 @@ enum max77693_irq_source {
>  	MAX77693_IRQ_GROUP_NR,
>  };
>  
> +#define SRC_IRQ_CHARGER			BIT(0)
> +#define SRC_IRQ_TOP			BIT(1)
> +#define SRC_IRQ_FLASH			BIT(2)
> +#define SRC_IRQ_MUIC			BIT(3)
> +
>  #define LED_IRQ_FLED2_OPEN		BIT(0)
>  #define LED_IRQ_FLED2_SHORT		BIT(1)
>  #define LED_IRQ_FLED1_OPEN		BIT(2)
> 

