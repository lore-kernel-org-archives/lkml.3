Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754281AbaCMMHe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 08:07:34 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:47543 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753534AbaCMMHc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 08:07:32 -0400
X-AuditID: cbfec7f5-b7fc96d000004885-8e-53219f829e3d
Message-id: <53219F80.9000300@samsung.com>
Date: Thu, 13 Mar 2014 13:07:28 +0100
From: Tomasz Figa <t.figa@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.3.0
MIME-version: 1.0
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Mike Turquette <mturquette@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        Sangbeom Kim <sbkim73@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: Tushar Behera <tushar.behera@linaro.org>,
        Yadwinder Singh Brar <yadi.brar@samsung.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: Re: [PATCH v2 2/3] mfd: sec-core: Add of_compatible strings for MFD
 cells
References: <1394703425-6462-1-git-send-email-k.kozlowski@samsung.com>
 <1394703425-6462-3-git-send-email-k.kozlowski@samsung.com>
In-reply-to: <1394703425-6462-3-git-send-email-k.kozlowski@samsung.com>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrHLMWRmVeSWpSXmKPExsVy+t/xy7pN8xWDDVZN4rTYOGM9q8XrF4YW
	Z5vesFvc/3qU0WLT42usFpd3zWGzmHF+H5PF2iN32S2eTrjIZnHyTy+jxeluVouLK74wWbT/
	3ctmMWf6OyYHPo871/awecw7GeixeUm9R9+WVYwenzfJBbBGcdmkpOZklqUW6dslcGVcmLWF
	qWAzT8W6tzuYGhiPcnYxcnJICJhIHJ/5jhnCFpO4cG89WxcjF4eQwFJGiT0fF7KAJIQEPjNK
	dE/nA7F5BbQk2r7/YgKxWQRUJa7dvgZmswmoSXxueMQGYosKREjMnbiZDaJeUOLH5HssIENF
	BLYwSXRducoI4jALzGKSuLC5CaxbWCBEom3PeTaIbc2MEj//i4DYnALuErP7joHVMAtYS6yc
	tI0RwpaX2LzmLfMERoFZSJbMQlI2C0nZAkbmVYyiqaXJBcVJ6blGesWJucWleel6yfm5mxgh
	cfJ1B+PSY1aHGAU4GJV4eAOWKgQLsSaWFVfmHmKU4GBWEuFVm6MYLMSbklhZlVqUH19UmpNa
	fIiRiYNTqoFx+lY2n38JSWze8lMm1N7M4w3bGeBv+MnLd+4d1/W/g55fWnU18lBwhtvWV89C
	3V8kbpnYtPdTk84biSTZd+K5G9/6csiw8MvZX5SKqJi4UcGz1up/eJLfkul3X/6vMF90Yd3y
	Tanp+kb/RDf7rzaeNNnu56kW46svUjbMEFNOf+E808WS/Qy3EktxRqKhFnNRcSIAkJE25XEC	AAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Krzysztof,

On 13.03.2014 10:37, Krzysztof Kozlowski wrote:
> Add of_compatible strings for MFD cells for regulator, clock and RTC
> drivers in S5M8767, S2MPS11 and S2MPS14 PMIC-s.
>
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> ---
>   drivers/mfd/sec-core.c |    8 ++++++++
>   1 file changed, 8 insertions(+)
>
> diff --git a/drivers/mfd/sec-core.c b/drivers/mfd/sec-core.c
> index d163c66edebb..c5b9b95b2099 100644
> --- a/drivers/mfd/sec-core.c
> +++ b/drivers/mfd/sec-core.c
> @@ -55,28 +55,36 @@ static const struct mfd_cell s5m8763_devs[] = {
>   static const struct mfd_cell s5m8767_devs[] = {
>   	{
>   		.name = "s5m8767-pmic",
> +		.of_compatible = "samsung,s5m8767-regulators",
>   	}, {
>   		.name = "s5m-rtc",
> +		.of_compatible = "samsung,s5m8767-rtc",
>   	}, {
>   		.name = "s5m8767-clk",
> +		.of_compatible = "samsung,s5m8767-clk",
>   	}
>   };
>
>   static const struct mfd_cell s2mps11_devs[] = {
>   	{
>   		.name = "s2mps11-pmic",
> +		.of_compatible = "samsung,s2mps11-regulators",
>   	}, {
>   		.name = "s2mps11-clk",
> +		.of_compatible = "samsung,s2mps11-clk",
>   	}
>   };
>
>   static const struct mfd_cell s2mps14_devs[] = {
>   	{
>   		.name = "s2mps14-pmic",
> +		.of_compatible = "samsung,s2mps14-regulators",
>   	}, {
>   		.name = "s2mps14-rtc",
> +		.of_compatible = "samsung,s2mps14-rtc",
>   	}, {
>   		.name = "s2mps14-clk",
> +		.of_compatible = "samsung,s2mps14-clk",
>   	}
>   };

Are these compatible strings documented anywhere?

Best regards,
Tomasz
