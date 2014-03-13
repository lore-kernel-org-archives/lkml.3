Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752037AbaCMMiA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 08:38:00 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:46000 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750838AbaCMMh6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 08:37:58 -0400
X-AuditID: cbfec7f5-b7fc96d000004885-1a-5321a6a4453b
Message-id: <5321A6A2.9070509@samsung.com>
Date: Thu, 13 Mar 2014 13:37:54 +0100
From: Tomasz Figa <t.figa@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.3.0
MIME-version: 1.0
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Mike Turquette <mturquette@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        Sangbeom Kim <sbkim73@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        Tushar Behera <tushar.behera@linaro.org>,
        Yadwinder Singh Brar <yadi.brar@samsung.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: Re: [PATCH v2 2/3] mfd: sec-core: Add of_compatible strings for MFD
 cells
References: <1394703425-6462-1-git-send-email-k.kozlowski@samsung.com>
 <1394703425-6462-3-git-send-email-k.kozlowski@samsung.com>
 <53219F80.9000300@samsung.com> <1394712996.20773.1.camel@AMDC1943>
In-reply-to: <1394712996.20773.1.camel@AMDC1943>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLLMWRmVeSWpSXmKPExsVy+t/xq7pLlikGG3yZI2KxccZ6VovXLwwt
	zja9Ybe4//Uoo8Wmx9dYLS7vmsNmMeP8PiaLtUfusls8nXCRzeLkn15Gi9PdrBYXV3xhsmj/
	u5fNYs70d0wOfB53ru1h85h3MtBj85J6j74tqxg9Pm+SC2CN4rJJSc3JLEst0rdL4MrYs+gO
	U8EjgYqe3RfYGhgbeLsYOTkkBEwkLrxcxwRhi0lcuLeerYuRi0NIYCmjxMtTU6Ccz4wSZyes
	ZgGp4hXQkmjeeIK9i5GDg0VAVeLG7yqQMJuAmsTnhkdsILaoQITE3Imb2SDKBSV+TL4H1ioi
	YChxcPd2JpCZzAJzWSRmvz7LDJIQFgiRaNtzHqxBSOAEo8TUb5UgNqeAgcScfedYQWxmATOJ
	Ry3rmCFseYnNa94yT2AUmIVkxywkZbOQlC1gZF7FKJpamlxQnJSea6RXnJhbXJqXrpecn7uJ
	ERIlX3cwLj1mdYhRgINRiYc3YKlCsBBrYllxZe4hRgkOZiUR3sJFisFCvCmJlVWpRfnxRaU5
	qcWHGJk4OKUaGHUNqo7N+jrHMtBp36sv0sXczGFblC4vLj43M6HdolE9tv+pfBnzkrqXGYHT
	26TSPz9aoSXr26yTsddz4ZqFPzIf6XCsjUhnWjs7Z/OKV+9PcbG+mMT2lONF1Zzjx+fd7Lm2
	0PCOu1z1Bl+mXR9z+x+1MjN9WrFeylwiw7p+uz/vzufcNX8KeJRYijMSDbWYi4oTAaDlyntw	AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13.03.2014 13:16, Krzysztof Kozlowski wrote:
> On Thu, 2014-03-13 at 13:07 +0100, Tomasz Figa wrote:
>> Hi Krzysztof,
>>
>> On 13.03.2014 10:37, Krzysztof Kozlowski wrote:
>>> Add of_compatible strings for MFD cells for regulator, clock and RTC
>>> drivers in S5M8767, S2MPS11 and S2MPS14 PMIC-s.
>>>
>>> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
>>> ---
>>>    drivers/mfd/sec-core.c |    8 ++++++++
>>>    1 file changed, 8 insertions(+)
>>>
>>> diff --git a/drivers/mfd/sec-core.c b/drivers/mfd/sec-core.c
>>> index d163c66edebb..c5b9b95b2099 100644
>>> --- a/drivers/mfd/sec-core.c
>>> +++ b/drivers/mfd/sec-core.c
>>> @@ -55,28 +55,36 @@ static const struct mfd_cell s5m8763_devs[] = {
>>>    static const struct mfd_cell s5m8767_devs[] = {
>>>    	{
>>>    		.name = "s5m8767-pmic",
>>> +		.of_compatible = "samsung,s5m8767-regulators",
>>>    	}, {
>>>    		.name = "s5m-rtc",
>>> +		.of_compatible = "samsung,s5m8767-rtc",
>>>    	}, {
>>>    		.name = "s5m8767-clk",
>>> +		.of_compatible = "samsung,s5m8767-clk",
>>>    	}
>>>    };
>>>
>>>    static const struct mfd_cell s2mps11_devs[] = {
>>>    	{
>>>    		.name = "s2mps11-pmic",
>>> +		.of_compatible = "samsung,s2mps11-regulators",
>>>    	}, {
>>>    		.name = "s2mps11-clk",
>>> +		.of_compatible = "samsung,s2mps11-clk",
>>>    	}
>>>    };
>>>
>>>    static const struct mfd_cell s2mps14_devs[] = {
>>>    	{
>>>    		.name = "s2mps14-pmic",
>>> +		.of_compatible = "samsung,s2mps14-regulators",
>>>    	}, {
>>>    		.name = "s2mps14-rtc",
>>> +		.of_compatible = "samsung,s2mps14-rtc",
>>>    	}, {
>>>    		.name = "s2mps14-clk",
>>> +		.of_compatible = "samsung,s2mps14-clk",
>>>    	}
>>>    };
>>
>> Are these compatible strings documented anywhere?
>
> The "-clk" compatible strings are (in next patch). The "-rtc" and
> "-regulators" are not.

Hmm, this doesn't sound good.

> Actually they aren't also used by child driver (each child driver parses
> from parent of_node).

Do you need to add compatible strings to mfd_cell entries of such cells 
then?

Best regards,
Tomasz
