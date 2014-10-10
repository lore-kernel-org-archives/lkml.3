Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752026AbaJJKFv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 06:05:51 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:49070 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751636AbaJJKFr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 06:05:47 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee690-f79ab6d0000046f7-df-5437af7816c5
Content-transfer-encoding: 8BIT
Message-id: <5437AF78.3060602@samsung.com>
Date: Fri, 10 Oct 2014 19:05:44 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
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
 <54379CB6.1040405@samsung.com> <1412931783.22108.2.camel@AMDC1943>
In-reply-to: <1412931783.22108.2.camel@AMDC1943>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrKIsWRmVeSWpSXmKPExsWyRsSkULdyvXmIQd9nJouNM9azWrx+YWhx
	tukNu8X9r0cZLS7vmsNmsfbIXXaL240r2CxOd7NaLNj4iNGB0+POtT1sHvNOBnr0bVnF6PF5
	k1wASxSXTUpqTmZZapG+XQJXxv/DWxgL5spVvPl5hLGB8bFEFyMnh4SAicSTCSdYIGwxiQv3
	1rN1MXJxCAksZZS4v2UOE0zRp7YpzBCJRYwS13bsYQdJ8AoISvyYfA+om4ODWUBe4silbJAw
	s4C6xKR5i6DqXzNK7Pm2lQmkhldAS+JykzVIDYuAqsTdb/+YQWw2oPD+FzfYQGxRgTCJldOv
	gB0kImAocXD3diaQOcwC+5kkDp/eAFYkLBAicffNT0aIBacYJU4cWA/WwSlgIDHx00GwhITA
	LXaJmS97mSDWCUh8m3wI7FIJAVmJTQeYIT6TlDi44gbLBEaxWUj+mYXwzywk/yxgZF7FKJpa
	kFxQnJReZKJXnJhbXJqXrpecn7uJERh7p/89m7CD8d4B60OMAhyMSjy8F2TMQ4RYE8uKK3MP
	MZoCHTGRWUo0OR8Y4Xkl8YbGZkYWpiamxkbmlmZK4ryvpX4GCwmkJ5akZqemFqQWxReV5qQW
	H2Jk4uCUamDMj5yasj7CYA7nyZv3chaYqa6aJ+T3hH9Py8M/K1XOuwZV9J5sv9zBz5EsxOeV
	c9t5mUnXE+uzC24yKHx4/+nnFcbs03uPnPi7Yu17tqaps43K+AMsqr68tdquf+jD0hdL5a2F
	/s/ln6X96feDpCWJN7n/mIlemZ+9/9G+aX/KN7/Vq8/6bBhzS4mlOCPRUIu5qDgRANk4yzu4	AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrPIsWRmVeSWpSXmKPExsVy+t9jAd2K9eYhBu3fzCw2zljPavH6haHF
	2aY37Bb3vx5ltLi8aw6bxdojd9ktbjeuYLM43c1qsWDjI0YHTo871/awecw7GejRt2UVo8fn
	TXIBLFENjDYZqYkpqUUKqXnJ+SmZeem2St7B8c7xpmYGhrqGlhbmSgp5ibmptkouPgG6bpk5
	QJcoKZQl5pQChQISi4uV9O0wTQgNcdO1gGmM0PUNCYLrMTJAAwlrGDP+H97CWDBXruLNzyOM
	DYyPJboYOTkkBEwkPrVNYYawxSQu3FvP1sXIxSEksIhR4tqOPewgCV4BQYkfk++xdDFycDAL
	yEscuZQNEmYWUJeYNG8RM0T9a0aJPd+2MoHU8ApoSVxusgapYRFQlbj77R/YfDag8P4XN9hA
	bFGBMImV06+wgNgiAoYSB3dvZwKZwyywn0ni8OkNYEXCAiESd9/8ZIRYcIpR4sSB9WAdnAIG
	EhM/HWScwCgwC8l9sxDum4XkvgWMzKsYRVMLkguKk9JzDfWKE3OLS/PS9ZLzczcxgiP7mdQO
	xpUNFocYBTgYlXh4L8iYhwixJpYVV+YeYpTgYFYS4e2eAxTiTUmsrEotyo8vKs1JLT7EaAr0
	3kRmKdHkfGDSySuJNzQ2MTOyNDI3tDAyNlcS5z3Qah0oJJCeWJKanZpakFoE08fEwSnVwLh+
	+w4HpQ1PdlwTuXHmU1nerZ6KubG3G2Odyxz8ma62frGfcmXRLYb/p/1/679V05c3cNScfnFL
	9bP9kW98Aw8t+hf6auLehHmftxlWe31ZduTyO/ZLc/ZXbpF/l5rZF8egtfZ+w3KBTXXcIu8C
	Ul9f+aTKMPGn2e3FVTXJPt+2di3orCjbNHWSEktxRqKhFnNRcSIA+XnIogIDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/10/2014 06:03 PM, Krzysztof Kozlowski wrote:
> On pią, 2014-10-10 at 17:45 +0900, Chanwoo Choi wrote:
>> On 10/10/2014 05:22 PM, Krzysztof Kozlowski wrote:
>>> All interrupts coming from MUIC were ignored because interrupt source
>>> register was masked.
>>>
>>> The Maxim 77693 has a "interrupt source" - a separate register and interrupts
>>> which give information about PMIC block triggering the individual
>>> interrupt (charger, topsys, MUIC, flash LED).
>>>
>>> By default bootloader could initialize this register to "mask all"
>>> value. In such case (observed on Trats2 board) MUIC interrupts won't be
>>> generated regardless of their mask status. Regmap irq chip was unmasking
>>> individual MUIC interrupts but the source was masked
>>>
>>> Before introducing regmap irq chip this interrupt source was unmasked,
>>> read and acked. Reading and acking is not necessary but unmasking is. Do
>>> it in extcon driver.
>>>
>>> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
>>> Cc: <stable@vger.kernel.org>
>>> Fixes: 342d669c1ee4 ("mfd: max77693: Handle IRQs using regmap")
>>> ---
>>>  drivers/extcon/extcon-max77693.c     | 16 ++++++++++++++++
>>>  include/linux/mfd/max77693-private.h |  5 +++++
>>>  2 files changed, 21 insertions(+)
>>>
>>> diff --git a/drivers/extcon/extcon-max77693.c b/drivers/extcon/extcon-max77693.c
>>> index 490e27475bac..d3adacf3187f 100644
>>> --- a/drivers/extcon/extcon-max77693.c
>>> +++ b/drivers/extcon/extcon-max77693.c
>>> @@ -1176,6 +1176,22 @@ static int max77693_muic_probe(struct platform_device *pdev)
>>>  		}
>>>  	}
>>>  
>>> +	if (i) {
>>> +		/*
>>> +		 * i>0, at least one MUIC interrupt requested so need to unmask
>>> +		 * MUIC interrupt in INTSRC register. Without that MUIC
>>> +		 * interrupts will not be reported.
>>> +		 */
>>> +		ret = regmap_update_bits(max77693->regmap,
>>> +				MAX77693_PMIC_REG_INTSRC_MASK, SRC_IRQ_MUIC,
>>> +				~SRC_IRQ_MUIC);
>>> +		if (ret < 0) {
>>> +			dev_err(&pdev->dev, "Could not unmask MUIC interrupt in INTSRC: %d\n",
>>> +					ret);
>>> +			return ret;
>>> +		}
>>> +	}
>>> +
>>
>> No,
>> The extcon-max77693 driver cannot enable IRQ_CHARGER/TOP/FLASH
>> because MAX77693_PMIC_REG_INTSRC_MASK register is common register of MAX77693.
>>
>> The IRQ_CHARGER/TOP/FLASH of MAX77693_PMIC_REG_INTSRC_MASK register should be enabled
>> in drivers/mfd/max77693.c.
> 
> The code above unmasks only SRC_IRQ_MUIC. Other bits are not touched.
> Why do you think that other IRQs will be enabled?

I think that MAX77693_PMIC_REG_INTSRC_MASK common register better to be controlled
in drivers/mfd/max77693.c. I prefer that MAX77693 extcon driver would read/write only MUIC registers.

Also, MAX77693 extcon driver have to be always unmasked.
If IRQ_MUIC is masked, MAX77693 extcon driver could not detect any external cables.

For example,
The max77836 enable MUIC_IRQ by un-masking MUIC_IRQ.
You can check it on drivers/mfd/max14577.c (line 251~258)

Best Regards,
Chanwoo Choi

> 
> Best regards,
> Krzysztof
> 
>>
>>>  	/* Initialize extcon device */
>>>  	info->edev = devm_extcon_dev_allocate(&pdev->dev,
>>>  					      max77693_extcon_cable);
>>> diff --git a/include/linux/mfd/max77693-private.h b/include/linux/mfd/max77693-private.h
>>> index e1b2b61285b9..4f1a80b66ecf 100644
>>> --- a/include/linux/mfd/max77693-private.h
>>> +++ b/include/linux/mfd/max77693-private.h
>>> @@ -438,6 +438,11 @@ enum max77693_irq_source {
>>>  	MAX77693_IRQ_GROUP_NR,
>>>  };
>>>  
>>> +#define SRC_IRQ_CHARGER			BIT(0)
>>> +#define SRC_IRQ_TOP			BIT(1)
>>> +#define SRC_IRQ_FLASH			BIT(2)
>>> +#define SRC_IRQ_MUIC			BIT(3)
>>> +
>>>  #define LED_IRQ_FLED2_OPEN		BIT(0)
>>>  #define LED_IRQ_FLED2_SHORT		BIT(1)
>>>  #define LED_IRQ_FLED1_OPEN		BIT(2)
>>>
> 
> 

