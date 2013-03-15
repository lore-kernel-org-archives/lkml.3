Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753707Ab3COK1Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 06:27:16 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:52607 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752077Ab3COK1O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 06:27:14 -0400
Message-ID: <5142F76B.2010907@ti.com>
Date: Fri, 15 Mar 2013 11:26:51 +0100
From: Benoit Cousson <b-cousson@ti.com>
Organization: Texas Instruments
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130221 Thunderbird/17.0.3
MIME-Version: 1.0
To: kishon <kishon@ti.com>
CC: <grant.likely@secretlab.ca>, <rob.herring@calxeda.com>, <rob@landley.net>,
        <tony@atomide.com>, <linux@arm.linux.org.uk>, <balbi@ti.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v3 0/7] ARM: dts: omap: Add dts data for USB
References: <1362663320-23799-1-git-send-email-kishon@ti.com> <514042BF.2090207@ti.com>
In-Reply-To: <514042BF.2090207@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kishon,

On 03/13/2013 10:11 AM, kishon wrote:
> Benoit,
> 
> Will you be queuing this patch series?

I'm reviewing them right now.

Regards,
Benoit

> 
> Thanks
> Kishon
> 
> On Thursday 07 March 2013 07:05 PM, Kishon Vijay Abraham I wrote:
>> Hi Benoit,
>>
>> Here are the dt data patches to get usb device functional in OMAP
>> platforms.
>>
>> All the patches deal with modifying arch/arm/boot except one which
>> modifies
>> Documentation/../usb/omap-usb.txt
>>
>> Changes from v2:
>> * squashed the dt data for dwc3-omap with dwc3 core into a single patch.
>>
>> Changes from v1:
>> Patch *ARM: dts: omap: Add usb_otg and glue data* has some properties
>> with
>> names that has "_". It's replaced with a "-" here.
>>
>> This patch is developed on Linux 3.9-rc1.
>>
>> Kishon Vijay Abraham I (7):
>>    ARM: dts: omap: Add omap control usb data
>>    ARM: dts: omap: Add omap-usb2 dt data
>>    ARM: dts: omap: Add usb_otg and glue data
>>    ARM: dts: omap5: Add omap control usb data
>>    ARM: dts: omap5: Add ocp2scp data
>>    ARM: dts: omap5: Add omap-usb3 and omap-usb2 dt data
>>    ARM: dts: omap5: add dwc3 omap and dwc3 core dt data
>>
>>   Documentation/devicetree/bindings/usb/omap-usb.txt |    1 +
>>   arch/arm/boot/dts/omap3-beagle-xm.dts              |    6 +++
>>   arch/arm/boot/dts/omap3-evm.dts                    |    6 +++
>>   arch/arm/boot/dts/omap3-overo.dtsi                 |    6 +++
>>   arch/arm/boot/dts/omap3.dtsi                       |   12 +++++
>>   arch/arm/boot/dts/omap4-panda.dts                  |    6 +++
>>   arch/arm/boot/dts/omap4-sdp.dts                    |    6 +++
>>   arch/arm/boot/dts/omap4.dtsi                       |   26 +++++++++++
>>   arch/arm/boot/dts/omap5.dtsi                       |   48
>> ++++++++++++++++++++
>>   arch/arm/boot/dts/twl4030.dtsi                     |    2 +-
>>   10 files changed, 118 insertions(+), 1 deletion(-)
>>
> 

