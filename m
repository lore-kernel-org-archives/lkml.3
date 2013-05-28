Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933134Ab3E1GhA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 02:37:00 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:40304 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933056Ab3E1Gg6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 02:36:58 -0400
Message-ID: <51A45041.2030105@ti.com>
Date: Tue, 28 May 2013 12:05:45 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Kishon Vijay Abraham I <kishon@ti.com>
CC: <grant.likely@linaro.org>, <tony@atomide.com>, <balbi@ti.com>,
        <arnd@arndb.de>, <swarren@nvidia.com>, <sylvester.nawrocki@gmail.com>,
        <gregkh@linuxfoundation.org>, <akpm@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-usb@vger.kernel.org>,
        <rob.herring@calxeda.com>, <rob@landley.net>, <b-cousson@ti.com>,
        <linux@arm.linux.org.uk>, <benoit.cousson@linaro.org>,
        <mchehab@redhat.com>, <cesarb@cesarb.net>, <davem@davemloft.net>,
        <rnayak@ti.com>, <shawn.guo@linaro.org>, <santosh.shilimkar@ti.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <nsekhar@ti.com>
Subject: Re: [PATCH v6 0/9] Generic PHY Framework
References: <1367229812-30574-1-git-send-email-kishon@ti.com> <519AFF95.9060002@ti.com>
In-Reply-To: <519AFF95.9060002@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tuesday 21 May 2013 10:31 AM, Kishon Vijay Abraham I wrote:
> Hi,
>
> On Monday 29 April 2013 03:33 PM, Kishon Vijay Abraham I wrote:
>> Added a generic PHY framework that provides a set of APIs for the PHY
>> drivers
>> to create/destroy a PHY and APIs for the PHY users to obtain a
>> reference to
>> the PHY with or without using phandle.
>>
>> This framework will be of use only to devices that uses external PHY (PHY
>> functionality is not embedded within the controller).
>>
>> The intention of creating this framework is to bring the phy drivers
>> spread
>> all over the Linux kernel to drivers/phy to increase code re-use and to
>> increase code maintainability.
>>
>> Comments to make PHY as bus wasn't done because PHY devices can be
>> part of
>> other bus and making a same device attached to multiple bus leads to bad
>> design.
>>
>> If the PHY driver has to send notification on connect/disconnect, the PHY
>> driver should make use of the extcon framework. Using this susbsystem
>> to use extcon framwork will have to be analysed.
>>
>> Making omap-usb2 and twl4030 to use this framework is provided as a
>> sample.
>>
>> This patch series is developed on linux-next tree.
>
> Any comments on this patch series?

Ping..

This series is needed for usb3 phy/sata phy and can also be used by 
certain video phys. I think it's important to get this in.

Thanks
Kishon
