Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756965Ab3KHLjf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 06:39:35 -0500
Received: from mail-ob0-f170.google.com ([209.85.214.170]:39042 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752856Ab3KHLjd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 06:39:33 -0500
MIME-Version: 1.0
In-Reply-To: <CAK9yfHwOPrMn-OTOBP8Efdw6sMFaoU8yQpQqV3o1+=Ffdryv=g@mail.gmail.com>
References: <1383634640-26869-1-git-send-email-sachin.kamat@linaro.org>
	<20131108102853.GV30901@lee--X1>
	<CAK9yfHwOPrMn-OTOBP8Efdw6sMFaoU8yQpQqV3o1+=Ffdryv=g@mail.gmail.com>
Date: Fri, 8 Nov 2013 17:09:33 +0530
Message-ID: <CAK9yfHwQWcYDZ5_KfkEjmkR9tt8bhBUpxYCte21sSfSMAC60Qg@mail.gmail.com>
Subject: Re: [PATCH 1/1] Documentation/mfd: Fix typos in s2mps11.txt
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Rob Landley <rob@landley.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8 November 2013 16:50, Sachin Kamat <sachin.kamat@linaro.org> wrote:
> On 8 November 2013 15:58, Lee Jones <lee.jones@linaro.org> wrote:
>> As this is only a trivial patch, I'll take it out the hands of the
>> already overloaded DT maintainers.
>>
>>> Fixed trivial typos to improve readability.
>>>
>>> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
>>> ---
>>>  Documentation/devicetree/bindings/mfd/s2mps11.txt |    9 +++++----
>>>  1 file changed, 5 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/Documentation/devicetree/bindings/mfd/s2mps11.txt b/Documentation/devicetree/bindings/mfd/s2mps11.txt
>>> index c9332c6..0ff4e65 100644
>>> --- a/Documentation/devicetree/bindings/mfd/s2mps11.txt
>>> +++ b/Documentation/devicetree/bindings/mfd/s2mps11.txt
>>> @@ -1,10 +1,10 @@
>>>
>>>  * Samsung S2MPS11 Voltage and Current Regulator
>>>
>>> -The Samsung S2MP211 is a multi-function device which includes voltage and
>>> +The Samsung S2MPS11 is a multi-function device which includes voltage and
>>
>> Nice catch eagle-eye!
>
> :)
>
>>
>>>  current regulators, RTC, charger controller and other sub-blocks. It is
>>> -interfaced to the host controller using a I2C interface. Each sub-block is
>>> -addressed by the host system using different I2C slave address.
>>> +interfaced to the host controller using an I2C interface. Each sub-block is
>>> +addressed by the host system using different I2C slave addresses.
>>>
>>>  Required properties:
>>>  - compatible: Should be "samsung,s2mps11-pmic".
>>> @@ -43,7 +43,8 @@ sub-node should be of the format as listed below.
>>>
>>>   BUCK[2/3/4/6] supports disabling ramp delay on hardware, so explictly
>>>   regulator-ramp-delay = <0> can be used for them to disable ramp delay.
>>> - In absence of regulator-ramp-delay property, default ramp delay will be used.
>>> + In the absence of regulator-ramp-delay property, default ramp delay will
>>> + be used.
>>
>> So if we're being pertinacity here, your correction isn't much better.
>>
>> s/of regulator-ramp-delay property,/of {the,an} regulator-ramp-delay property, the
>
> I like this one :)
>>
>> or
>>
>> s/of regulator-ramp-delay property,/of regulator-ramp-delay, the
>

Resent this patch with the above suggested changes and some more
updates and hence
with a modified subject line (Documentation/mfd: Update s2mps11.txt).

-- 
With warm regards,
Sachin
