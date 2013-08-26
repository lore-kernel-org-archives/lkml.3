Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756796Ab3HZMEJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 08:04:09 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:37726 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751571Ab3HZMEH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 08:04:07 -0400
Message-ID: <521B4407.2090600@ti.com>
Date: Mon, 26 Aug 2013 17:33:19 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: <bcousson@baylibre.com>, <tony@atomide.com>, <myungjoo.ham@samsung.com>,
        <cw00.choi@samsung.com>, <rob.herring@calxeda.com>,
        <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ian.campbell@citrix.com>, <rob@landley.net>, <george.cherian@ti.com>,
        <gregkh@linuxfoundation.org>, <linux-doc@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux@arm.linux.org.uk>,
        <linux-kernel@vger.kernel.org>, <balbi@ti.com>
Subject: Re: [PATCH v4] extcon: palmas: Added a new compatible type *ti,palmas-usb-vid*
References: <1377160283-26934-1-git-send-email-kishon@ti.com> <5216798E.8070900@wwwdotorg.org> <52174755.8030506@ti.com> <5217B54E.8070009@wwwdotorg.org>
In-Reply-To: <5217B54E.8070009@wwwdotorg.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 24 August 2013 12:47 AM, Stephen Warren wrote:
> On 08/23/2013 05:28 AM, Kishon Vijay Abraham I wrote:
>> Hi,
>>
>> On Friday 23 August 2013 02:20 AM, Stephen Warren wrote:
>>> On 08/22/2013 02:31 AM, Kishon Vijay Abraham I wrote:
>>>> The Palmas device contains only a USB VBUS-ID detector, so added a
>>>> compatible type *ti,palmas-usb-vid*. Didn't remove the existing compatible
>>>> types for backward compatibility.
>>>
>>>> diff --git a/Documentation/devicetree/bindings/extcon/extcon-palmas.txt b/Documentation/devicetree/bindings/extcon/extcon-palmas.txt
>>>
>>>>  PALMAS USB COMPARATOR
>>>>  Required Properties:
>>>> - - compatible : Should be "ti,palmas-usb" or "ti,twl6035-usb"
>>>> + - compatible : Should be "ti,palmas-usb-vid". "ti,twl6035-usb" and
>>>> +   "ti,palmas-usb" is deprecated and is kept for backward compatibility.
>>>
>>> So this defines one new value and deprecates the two old values.
>>
>> yeah.
>>>
>>> Why isn't a new "ti,twl6035-usb-vid" entry useful? Don't you still need
>>
>> yeah, it should be added too.
>>> SoC-specific compatible values so the driver can enable any SoC-specific
>>> bug-fixes/workarounds later if needed?
>>
>> hmm.. Palmas is external to SoC. So not sure if adding SoC specific compatible
>> values is such a good idea.
> 
> In this case, but SoC, I meant the Palmas chip rather than the
> application processor. Is twl6035 a name for Palmas or something else?

yeah, tw6035 is a name for palmas.

Thanks
Kishon
