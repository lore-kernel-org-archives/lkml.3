Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754415Ab3AYIqi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 03:46:38 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:36113 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751837Ab3AYIqg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 03:46:36 -0500
Message-ID: <5102465E.4030305@ti.com>
Date: Fri, 25 Jan 2013 14:16:22 +0530
From: kishon <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: <balbi@ti.com>
CC: Stephen Warren <swarren@wwwdotorg.org>, <rob.herring@calxeda.com>,
        <rob@landley.net>, <tony@atomide.com>, <b-cousson@ti.com>,
        <linux-usb@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <gregkh@linuxfoundation.org>, <linux@arm.linux.org.uk>
Subject: Re: [PATCH v3 1/4] drivers: usb: phy: add a new driver for usb part
 of control module
References: <1359080391-5120-1-git-send-email-kishon@ti.com> <1359080391-5120-2-git-send-email-kishon@ti.com> <510218FE.8080606@wwwdotorg.org> <20130125074818.GF15886@arwen.pp.htv.fi> <51024581.6020301@ti.com> <20130125084501.GI15886@arwen.pp.htv.fi>
In-Reply-To: <20130125084501.GI15886@arwen.pp.htv.fi>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 25 January 2013 02:15 PM, Felipe Balbi wrote:
> hi,
>
> On Fri, Jan 25, 2013 at 02:12:41PM +0530, kishon wrote:
>> On Friday 25 January 2013 01:18 PM, Felipe Balbi wrote:
>>> On Thu, Jan 24, 2013 at 09:32:46PM -0800, Stephen Warren wrote:
>>>> On 01/24/2013 06:19 PM, Kishon Vijay Abraham I wrote:
>>>>> Added a new driver for the usb part of control module. This has an API
>>>>> to power on the USB2 phy and an API to write to the mailbox depending on
>>>>> whether MUSB has to act in host mode or in device mode.
>>>>>
>>>>> Writing to control module registers for doing the above task which was
>>>>> previously done in omap glue and in omap-usb2 phy will be removed.
>>>>
>>>>> diff --git a/Documentation/devicetree/bindings/usb/usb-phy.txt b/Documentation/devicetree/bindings/usb/usb-phy.txt
>>>>
>>>> This file seems to be specific to the TI USB PHYs, not all USB PHYs;
>>>> shouldn't it be renamed ti-usb-phy.txt, or even better renamed to match
>>>> the compatible value it documents, giving ti,omap-usb2.txt?
>>>
>>> could be, but that can be done as a separate patch. It's not part of
>>> $SUBJECT.
>>>
>>>>>   add the address of control module dev conf register until a driver for
>>>>>   control module is added
>>>>>
>>>>> +Optional properties:
>>>>> + - ctrl_module : phandle of the control module used by PHY driver to power on
>>>>> +   the PHY.
>>>>
>>>> DT property names generally use - not _ as the word separator.
>>>
>>> fair enough, Kishon, can you fix this up ?
>>
>> Sure. Will post a patch..
>
> Great, notice that I've already applied some of your patches to my tree.
>
Cool. Thanks :-)

Regards
Kishon
