Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752708Ab3IVCZH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Sep 2013 22:25:07 -0400
Received: from mail.active-venture.com ([67.228.131.205]:61111 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752577Ab3IVCZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Sep 2013 22:25:04 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <523E54F7.9010403@roeck-us.net>
Date: Sat, 21 Sep 2013 19:24:55 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Eduardo Valentin <eduardo.valentin@ti.com>
CC: swarren@wwwdotorg.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ian.campbell@citrix.com, rob.herring@calxeda.com, rui.zhang@intel.com,
        wni@nvidia.com, grant.likely@linaro.org, durgadoss.r@intel.com,
        linux-pm@vger.kernel.org, devicetree@vger.kernel.org,
        lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org,
        Jean Delvare <khali@linux-fr.org>
Subject: Re: [PATCHv3 05/16] hwmon: lm75: expose to thermal fw via DT nodes
References: <1379457325-18192-1-git-send-email-eduardo.valentin@ti.com> <1379521314-16959-1-git-send-email-eduardo.valentin@ti.com> <523DE01F.4020607@roeck-us.net> <523E2C1B.9010307@ti.com> <523E321F.8050502@roeck-us.net> <523E388F.80707@ti.com>
In-Reply-To: <523E388F.80707@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/21/2013 05:23 PM, Eduardo Valentin wrote:
> On 21-09-2013 19:56, Guenter Roeck wrote:
>> On 09/21/2013 04:30 PM, Eduardo Valentin wrote:
>>> On 21-09-2013 14:06, Guenter Roeck wrote:
>>>> On 09/18/2013 09:21 AM, Eduardo Valentin wrote:
>>>>> This patch adds to lm75 temperature sensor the possibility
>>>>> to expose itself as thermal zone device, registered on the
>>>>> thermal framework.
>>>>>
>>>>> The thermal zone is built only if a device tree node
>>>>> describing a thermal zone for this sensor is present
>>>>> inside the lm75 DT node. Otherwise, the driver behavior
>>>>> will be the same.
>>>>>
>>>>> Cc: Jean Delvare <khali@linux-fr.org>
>>>>> Cc: Guenter Roeck <linux@roeck-us.net>
>>>>> Cc: lm-sensors@lm-sensors.org
>>>>> Cc: linux-kernel@vger.kernel.org
>>>>> Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
>>>>
>>>> Acked-by: Guenter Roeck <linux@roeck-us.net>
>>>>
>>>
>>> Cool! thanks again for taking the time to review this.
>>>
>>>> I assume this will be sent upstream through the thermal tree ?
>>>
>>> Yeah, that is the idea, at least for the core part. The hwmon changes I
>>> believe goes via hwmon tree, right?
>>>
>>
>> Not necessarily, as the hwmon code depends on the core code.
>> In such cases it is quite common that both are sent through the same tree.
>
> If this works for you I can queue these changes via the thermal tree.
>

Ok with me.

Guenter


