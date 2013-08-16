Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751534Ab3HPFPu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 01:15:50 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:58834 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751105Ab3HPFPr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 01:15:47 -0400
Message-ID: <520DB559.80305@ti.com>
Date: Fri, 16 Aug 2013 10:45:05 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Benoit Cousson <bcousson@baylibre.com>, "J, KEERTHY" <j-keerthy@ti.com>
CC: <tony@atomide.com>, <rob.herring@calxeda.com>, <pawel.moll@arm.com>,
        <mark.rutland@arm.com>, <swarren@wwwdotorg.org>,
        <ian.campbell@citrix.com>, <linux-omap@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux@arm.linux.org.uk>, <linux-kernel@vger.kernel.org>,
        <balbi@ti.com>
Subject: Re: [PATCH] arm: omap5: dts: split SMPS10 dt node
References: <1376300221-15172-1-git-send-email-kishon@ti.com> <520A32CF.1010701@baylibre.com> <520A4685.7050503@ti.com> <520A474F.9080500@baylibre.com>
In-Reply-To: <520A474F.9080500@baylibre.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Benoit,

On Tuesday 13 August 2013 08:18 PM, Benoit Cousson wrote:
> On 13/08/2013 16:45, Kishon Vijay Abraham I wrote:
>> Hi,
>>
>> On Tuesday 13 August 2013 06:51 PM, Benoit Cousson wrote:
>>> Hi Kishon,
>>>
>>> On 12/08/2013 11:37, Kishon Vijay Abraham I wrote:
>>>> SMPS10 has two outputs OUT1 and OUT2. Hence SMPS10 is modeled as
>>>> two regulators. The dt node is split to reflect it.
>>>
>>> Mmm, I'm curious. How is it supposed to work?
>>>
>>> Do you have dedicated control on each output?
>>
>> Yes. It can be controlled by setting different values to the same bit fields.
>> You can refer [1] where we actually implement SMPS10 as two different
>> regulators.
>>
>> [1] -> http://permalink.gmane.org/gmane.linux.kernel/1542521
> 
> Great, thanks.
> 
> Can we merge that one safely if the driver changed are not done yet?

I think it shouldn't cause any issues. However Mark has already merged the
driver changes.

Thanks
Kishon
