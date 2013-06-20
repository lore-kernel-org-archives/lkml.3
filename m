Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965241Ab3FTMCx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 08:02:53 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:35258 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753085Ab3FTMCv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 08:02:51 -0400
Message-ID: <51C2EF50.3070707@ti.com>
Date: Thu, 20 Jun 2013 15:02:24 +0300
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Kevin Hilman <khilman@linaro.org>
CC: <stern@rowland.harvard.edu>, <tony@atomide.com>, <balbi@ti.com>,
        <ruslan.bilovol@ti.com>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        =?UTF-8?B?QmVub8OudCBDb3Vzc29u?= <b-cousson@ti.com>
Subject: Re: [RFC PATCH 5/6] ARM: dts: omap3beagle-xm: Add idle state pins
 for USB host
References: <1371650753-11452-1-git-send-email-rogerq@ti.com> <1371650753-11452-6-git-send-email-rogerq@ti.com> <87obb26ixm.fsf@linaro.org> <51C2EDB1.3080801@ti.com>
In-Reply-To: <51C2EDB1.3080801@ti.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/20/2013 02:55 PM, Roger Quadros wrote:
> On 06/19/2013 09:42 PM, Kevin Hilman wrote:
>> Roger Quadros <rogerq@ti.com> writes:
>>
>>> Add the Idle state pins for USB host and enable WAKEUP on
>>> DIR, DAT0-3, so that the PHY can wakeup the OMAP SoC from
>>> sleep on any USB activity (e.g. remote wakeup or connect/disconnect).
>>>
>>> CC: Benoît Cousson <b-cousson@ti.com>
>>> Signed-off-by: Roger Quadros <rogerq@ti.com>
>>
>> This one doesn't apply...
>>
>>> ---
>>>  arch/arm/boot/dts/omap3-beagle-xm.dts |   29 +++++++++++++++++++++++------
>>>  1 files changed, 23 insertions(+), 6 deletions(-)
>>>
>>> diff --git a/arch/arm/boot/dts/omap3-beagle-xm.dts b/arch/arm/boot/dts/omap3-beagle-xm.dts
>>> index d3808ed..f1d56c2 100644
>>> --- a/arch/arm/boot/dts/omap3-beagle-xm.dts
>>> +++ b/arch/arm/boot/dts/omap3-beagle-xm.dts
>>> @@ -89,12 +89,7 @@
>>>  };
>>>  
>>>  &omap3_pmx_core {
>>> -	pinctrl-names = "default";
>>> -	pinctrl-0 = <
>>> -			&hsusbb2_pins
>>> -	>;
>>> -
>>> -	hsusbb2_pins: pinmux_hsusbb2_pins {
>>
>> This omap3_pmx_core section doesn't exist upstream in the xM DTS file
>> (but does in omap3-beagle.dts.)  
>>
>> Is there a dependency patch missing?
>>
> 
> Sorry for not mentioning it earlier. This is based on Benoit's tree [1]
> and you need these patches
> 
> http://thread.gmane.org/gmane.linux.drivers.devicetree/38383

Just noticed that this no longer applies today. I'll send a revision soon.

cheers,
-roger
