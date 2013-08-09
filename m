Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967514Ab3HIGQW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 02:16:22 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:12409 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966056Ab3HIGQS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 02:16:18 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 08 Aug 2013 23:14:31 -0700
Message-ID: <52048936.9040809@nvidia.com>
Date: Fri, 9 Aug 2013 14:16:22 +0800
From: Wei Ni <wni@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Guenter Roeck <linux@roeck-us.net>
CC: Stephen Warren <swarren@wwwdotorg.org>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        "khali@linux-fr.org" <khali@linux-fr.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        Matthew Longnecker <MLongnecker@nvidia.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2 2/3] ARM: dt: t114 dalmore: add dt entry for nct1008
References: <1375944991-29182-1-git-send-email-wni@nvidia.com> <1375944991-29182-3-git-send-email-wni@nvidia.com> <52040146.7060703@cogentembedded.com> <52040236.2080701@wwwdotorg.org> <52040EB9.2050908@roeck-us.net>
In-Reply-To: <52040EB9.2050908@roeck-us.net>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/09/2013 05:33 AM, Guenter Roeck wrote:
> On 08/08/2013 01:40 PM, Stephen Warren wrote:
>> On 08/08/2013 02:36 PM, Sergei Shtylyov wrote:
>>> Hello.
>>>
>>> On 08/08/2013 10:56 AM, Wei Ni wrote:
>>>
>>>> Enable thermal sensor nct1008 for t114 dalmore.
>>>
>>>> Signed-off-by: Wei Ni <wni@nvidia.com>
>>>> ---
>>>>    arch/arm/boot/dts/tegra114-dalmore.dts |   10 +++++++++-
>>>>    1 file changed, 9 insertions(+), 1 deletion(-)
>>>
>>>> diff --git a/arch/arm/boot/dts/tegra114-dalmore.dts
>>>> b/arch/arm/boot/dts/tegra114-dalmore.dts
>>>> index b5a42f0..9d4d2b2 100644
>>>> --- a/arch/arm/boot/dts/tegra114-dalmore.dts
>>>> +++ b/arch/arm/boot/dts/tegra114-dalmore.dts
>>>> @@ -738,6 +738,14 @@
>>>>                realtek,ldo1-en-gpios =
>>>>                    <&gpio TEGRA_GPIO(V, 3) GPIO_ACTIVE_HIGH>;
>>>>            };
>>>> +
>>>> +        nct1008 {
>>>
>>>     ePAPR [1] says: "the name of a node should be somewhat generic,
>>> reflecting the function of the device and not its precise programming
>>> model". So I suggest "thermal"
>>
>> True, although there's quite some precedent for node-names being the
>> chip name for external chips in existing DTs. If we change this node
>> name, I'd like to see a patch that makes all the other "nct1008" nodes
>> match the new name...
>>
> 
> On the other side, one should not use a bad example as an argument or excuse
> to make the same mistake again (though I keep hearing it all the time ... ).
> I for my part tend to use something like temp-sensor or temp-sensor@1c.
> Advantage of that kind of node name is that it auto-describes the node.

Ok, so I will set the node name as "temp-sensor"
And I will send out patches to change all other "nct1008" nodes.

> 
> Guenter
> 

