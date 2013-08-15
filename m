Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758942Ab3HOQKB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 12:10:01 -0400
Received: from mail-we0-f178.google.com ([74.125.82.178]:58893 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758801Ab3HOQJ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 12:09:58 -0400
Message-ID: <520CFD52.4060103@baylibre.com>
Date: Thu, 15 Aug 2013 18:09:54 +0200
From: Benoit Cousson <bcousson@baylibre.com>
Organization: BayLibre
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Kishon Vijay Abraham I <kishon@ti.com>
CC: Stephen Warren <swarren@wwwdotorg.org>, mark.rutland@arm.com,
        devicetree@vger.kernel.org, george.cherian@ti.com,
        linux@arm.linux.org.uk, ian.campbell@citrix.com, pawel.moll@arm.com,
        linux-doc@vger.kernel.org, tony@atomide.com,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        rob.herring@calxeda.com, cw00.choi@samsung.com,
        myungjoo.ham@samsung.com, balbi@ti.com, rob@landley.net,
        benoit.cousson@linaro.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/2] extcon: palmas: Added a new compatible type *ti,
 palmas-usb-vid*
References: <1376302675-15795-1-git-send-email-kishon@ti.com> <1376372241-15573-1-git-send-email-kishon@ti.com> <520A8555.10401@wwwdotorg.org> <520B14A1.8030809@ti.com>
In-Reply-To: <520B14A1.8030809@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kishon,

On 14/08/2013 07:24, Kishon Vijay Abraham I wrote:
> Hi,
>
> On Wednesday 14 August 2013 12:43 AM, Stephen Warren wrote:
>> On 08/12/2013 11:37 PM, Kishon Vijay Abraham I wrote:
>>> The Palmas device contains only a USB VID detector, so added a
>>> compatible type *ti,palmas-usb-vid*. Dint remove the existing compatible
>>
>> s/Dint/Didn't/
>>
>>> diff --git a/Documentation/devicetree/bindings/extcon/extcon-twl.txt b/Documentation/devicetree/bindings/extcon/extcon-twl.txt
>>
>>>   PALMAS USB COMPARATOR
>>>   Required Properties:
>>> - - compatible : Should be "ti,palmas-usb" or "ti,twl6035-usb"
>>> + - compatible : Should be "ti,palmas-usb" or "ti,twl6035-usb" or
>>> +   "ti,palmas-usb-vid".
>>
>> So are ti,palmas-usb and ti,twl6035-usb full EHCI controllers then?
>
> No. I thought I shouldn't remove those if someone is already using those
> compatible value.

Well, I think we still have a short period of time where we can clean 
some badly defined bindings before it is really too late.

Both kernel and DTS are still in sync for the moment, so changing both 
at the same time should be safe.

Regards,
Benoit
