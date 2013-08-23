Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755368Ab3HWL3N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 07:29:13 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:58945 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754110Ab3HWL3L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 07:29:11 -0400
Message-ID: <52174755.8030506@ti.com>
Date: Fri, 23 Aug 2013 16:58:21 +0530
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
References: <1377160283-26934-1-git-send-email-kishon@ti.com> <5216798E.8070900@wwwdotorg.org>
In-Reply-To: <5216798E.8070900@wwwdotorg.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Friday 23 August 2013 02:20 AM, Stephen Warren wrote:
> On 08/22/2013 02:31 AM, Kishon Vijay Abraham I wrote:
>> The Palmas device contains only a USB VBUS-ID detector, so added a
>> compatible type *ti,palmas-usb-vid*. Didn't remove the existing compatible
>> types for backward compatibility.
> 
>> diff --git a/Documentation/devicetree/bindings/extcon/extcon-palmas.txt b/Documentation/devicetree/bindings/extcon/extcon-palmas.txt
> 
>>  PALMAS USB COMPARATOR
>>  Required Properties:
>> - - compatible : Should be "ti,palmas-usb" or "ti,twl6035-usb"
>> + - compatible : Should be "ti,palmas-usb-vid". "ti,twl6035-usb" and
>> +   "ti,palmas-usb" is deprecated and is kept for backward compatibility.
> 
> So this defines one new value and deprecates the two old values.

yeah.
> 
> Why isn't a new "ti,twl6035-usb-vid" entry useful? Don't you still need

yeah, it should be added too.
> SoC-specific compatible values so the driver can enable any SoC-specific
> bug-fixes/workarounds later if needed?

hmm.. Palmas is external to SoC. So not sure if adding SoC specific compatible
values is such a good idea.

Thanks
Kishon
