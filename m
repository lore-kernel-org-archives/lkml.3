Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752486Ab3FKGdF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 02:33:05 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:37971 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751333Ab3FKGdD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 02:33:03 -0400
Message-ID: <51B6C495.3040001@linaro.org>
Date: Tue, 11 Jun 2013 12:02:53 +0530
From: Tushar Behera <tushar.behera@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Tomasz Figa <tomasz.figa@gmail.com>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, kgene.kim@samsung.com,
        patches@linaro.org, Sachin Kamat <sachin.kamat@linaro.org>
Subject: Re: [PATCH 1/3] ARM: dts: exynos4210: Add LCD related pinctrl entries
References: <1370603235-11193-1-git-send-email-tushar.behera@linaro.org> <4895761.sVtM2qZnU3@flatron> <51B551C3.8000003@linaro.org> <3046864.Enssr3rlNj@flatron>
In-Reply-To: <3046864.Enssr3rlNj@flatron>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/11/2013 12:00 AM, Tomasz Figa wrote:
> On Monday 10 of June 2013 09:40:43 Tushar Behera wrote:
>> On 06/08/2013 04:16 PM, Tomasz Figa wrote:
>>> Hi Tushar, Sachin,
>>>
>>> On Friday 07 of June 2013 16:37:13 Tushar Behera wrote:
>>>> From: Sachin Kamat <sachin.kamat@linaro.org>
>>>>
>>>> Adds pinctrl entries required by FIMD.
>>>>
>>>> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
>>>> Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
>>>> ---
>>>>
>>>>  arch/arm/boot/dts/exynos4210-pinctrl.dtsi |   75
>>>>
>>>> +++++++++++++++++++++++++++++ 1 file changed, 75 insertions(+)
>>>>
>>>> diff --git a/arch/arm/boot/dts/exynos4210-pinctrl.dtsi
>>>> b/arch/arm/boot/dts/exynos4210-pinctrl.dtsi index 55a2efb..d241726
>>>> 100644
>>>> --- a/arch/arm/boot/dts/exynos4210-pinctrl.dtsi
>>>> +++ b/arch/arm/boot/dts/exynos4210-pinctrl.dtsi
>>>> @@ -330,6 +330,81 @@
>>>>
>>>>  			samsung,pin-pud = <3>;
>>>>  			samsung,pin-drv = <0>;
>>>>  		
>>>>  		};
>>>>
>>>> +
>>>> +		pwm0_out: pwm0-out {
>>>> +			samsung,pins = "gpd0-0";
>>>> +			samsung,pin-function = <2>;
>>>> +			samsung,pin-pud = <0>;
>>>> +			samsung,pin-drv = <0>;
>>>> +		};
>>>> +
>>>> +		pwm1_out: pwm1-out {
>>>> +			samsung,pins = "gpd0-1";
>>>> +			samsung,pin-function = <2>;
>>>> +			samsung,pin-pud = <0>;
>>>> +			samsung,pin-drv = <0>;
>>>> +		};
>>>
>>> Hmm, these two seem to be unrelated. Rebase error? :)
>>
>> Not a rebase error. pwm0_out needs to configured to get display on LCD.
> 
> Please split this into two separate patches than, one adding LCD pin 
> configuration nodes and one adding PWM pin configuration nodes.
> 
> Also I think it would be better to just define all available PWM outputs 
> not only first two. if you are already at adding PWM pin configurations.
> 

Sure.

> Thanks,
> Tomasz
> 

Thanks.

-- 
Tushar Behera
