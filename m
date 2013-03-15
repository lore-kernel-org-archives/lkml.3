Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755358Ab3CONdl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 09:33:41 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:32984 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754763Ab3CONdj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 09:33:39 -0400
Message-ID: <51432310.7050201@ti.com>
Date: Fri, 15 Mar 2013 19:03:04 +0530
From: kishon <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Benoit Cousson <b-cousson@ti.com>
CC: <grant.likely@secretlab.ca>, <rob.herring@calxeda.com>, <rob@landley.net>,
        <tony@atomide.com>, <linux@arm.linux.org.uk>, <balbi@ti.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Jon Hunter <jon-hunter@ti.com>
Subject: Re: [PATCH v3 0/7] ARM: dts: omap: Add dts data for USB
References: <1362663320-23799-1-git-send-email-kishon@ti.com> <514316FA.1090002@ti.com>
In-Reply-To: <514316FA.1090002@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 15 March 2013 06:11 PM, Benoit Cousson wrote:
> + Jon
>
> Hi Kishon,
>
> On 03/07/2013 02:35 PM, Kishon Vijay Abraham I wrote:
>> Hi Benoit,
>>
>> Here are the dt data patches to get usb device functional in OMAP platforms.
>>
>> All the patches deal with modifying arch/arm/boot except one which modifies
>> Documentation/../usb/omap-usb.txt
>>
>> Changes from v2:
>> * squashed the dt data for dwc3-omap with dwc3 core into a single patch.
>>
>> Changes from v1:
>> Patch *ARM: dts: omap: Add usb_otg and glue data* has some properties with
>> names that has "_". It's replaced with a "-" here.
>>
>> This patch is developed on Linux 3.9-rc1.
>
> The patches looks really good. I've just had to rebase on top of my HEAD due to some conflict with GPMC patch already applied.
>
> I cleaned as well some subject and changelog for consistency.

Ok. Thanks :-)

Regards
Kishon
