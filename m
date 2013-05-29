Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966835Ab3E2URt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 16:17:49 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:61537 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965519Ab3E2URl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 16:17:41 -0400
Message-ID: <51A66262.7000305@gmail.com>
Date: Wed, 29 May 2013 21:17:38 +0100
From: Jon Hunter <jgchunter@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Afzal Mohammed <afzal@ti.com>, Russell King <linux@arm.linux.org.uk>,
        linux-doc@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@linaro.org>,
        Benoit Cousson <benoit.cousson@linaro.org>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 11/14] Documentation: dt: binding: omap: am43x timer
References: <cover.1369658705.git.afzal@ti.com> <223d90dc9eeab13d8496690d336cdf0f7d27cd22.1369658705.git.afzal@ti.com> <51A520B5.8040803@gmail.com> <51A52A16.1040204@wwwdotorg.org>
In-Reply-To: <51A52A16.1040204@wwwdotorg.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 28/05/13 23:05, Stephen Warren wrote:
> On 05/28/2013 03:25 PM, Jon Hunter wrote:
>>
>> On 27/05/13 15:37, Afzal Mohammed wrote:
>>> AM43x timer bindings.
>>>
>>> Signed-off-by: Afzal Mohammed <afzal@ti.com>
>>> ---
>>>  Documentation/devicetree/bindings/arm/omap/timer.txt | 2 ++
>>>  1 file changed, 2 insertions(+)
>>>
>>> diff --git a/Documentation/devicetree/bindings/arm/omap/timer.txt b/Documentation/devicetree/bindings/arm/omap/timer.txt
>>> index d02e27c..70cb398 100644
>>> --- a/Documentation/devicetree/bindings/arm/omap/timer.txt
>>> +++ b/Documentation/devicetree/bindings/arm/omap/timer.txt
>>> @@ -14,6 +14,8 @@ Required properties:
>>>  			ti,omap5430-timer (applicable to OMAP543x devices)
>>>  			ti,am335x-timer	(applicable to AM335x devices)
>>>  			ti,am335x-timer-1ms (applicable to AM335x devices)
>>> +			"ti,am4372-timer-1ms", "ti,am335x-timer-1ms" for AM43x 1ms timer
>>> +			"ti,am4372-timer", "ti,am335x-timer" for AM43x timers other than 1ms one
>>>  
>>>  - reg:			Contains timer register address range (base address and
>>>  			length).
>>
>> If you are adding more compatibility strings, then this implies that the
>> AM43x timers are not 100% compatible with any other device listed (such
>> as am335x or any omap device). That's fine but you should state that in
>> the changelog. If the AM43x timer registers are 100% compatible with
>> existing devices you should not add these.
> 
> I'm not sure that's true; .dts files should always include a compatible
> value that describes the most specific model of the HW, plus any
> baseline compatible value that the HW is compatible with. This allows
> any required quirks/fixes/... to be applied for the specific HW model
> later even if nobody knows right now they'll be needed. Hence, defining
> new compatible values doesn't necessarily mean incompatible HW.

Yes that does seem to agree with what Grant had told me in the past [1].
So this is ok then. However, I still think that the changelog needs to
be vastly improved and more explicit about the changes.

Cheers
Jon

[1] http://thread.gmane.org/gmane.linux.ports.arm.omap/90551/focus=26447

