Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757109Ab3JKHxI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 03:53:08 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:57386 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756946Ab3JKHxF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 03:53:05 -0400
Message-ID: <5257AE43.4020902@ti.com>
Date: Fri, 11 Oct 2013 13:22:35 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Chanwoo Choi <cw00.choi@samsung.com>
CC: Laxman Dewangan <ldewangan@nvidia.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "pawel.moll@arm.com" <pawel.moll@arm.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "rob@landley.net" <rob@landley.net>,
        "myungjoo.ham@samsung.com" <myungjoo.ham@samsung.com>,
        "gg@slimlogic.co.uk" <gg@slimlogic.co.uk>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH v6] extcon: palmas: Added a new compatible type *ti,palmas-usb-vid*
References: <1381408647-24653-1-git-send-email-kishon@ti.com> <5256A773.6060807@nvidia.com> <5257977C.1030108@ti.com> <5257A36D.80902@samsung.com>
In-Reply-To: <5257A36D.80902@samsung.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chanwoo,

On Friday 11 October 2013 12:36 PM, Chanwoo Choi wrote:
> On 10/11/2013 03:15 PM, Kishon Vijay Abraham I wrote:
>> On Thursday 10 October 2013 06:41 PM, Laxman Dewangan wrote:
>>> On Thursday 10 October 2013 06:07 PM, Kishon Vijay Abraham I wrote:
>>>> The Palmas device contains only a USB VBUS-ID detector, so added a
>>>> compatible type *ti,palmas-usb-vid*. Didn't remove the existing compatible
>>>> types for backward compatibility.
>>>>
>>> I dont have much issue on this nomenclature but just second thought:
>>>
>>> The Palmas USB module is capable of detection VBUS, ID-GND, ID-RA, ID-RB, ID-RC
>>> and ID-FLOAT as per BC1.2.
>>> This sub-module only detect the cable, does nothing more than this.
>>> In this case, should we say "ti,palmas-usb-extcon"?
>>> Again extcon is linux specific terminology and this can be defer.
>>
>> I don't mind either way. Chanwoo?
> 
> The EXTCON is subsystem name. I don't prefer to use 'extcon' word on device name.
> I agree Kishon opinion.

Cool.. can you this patch as-is?

Thanks
Kishon
