Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751246AbaETUIp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 16:08:45 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:60357 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751117AbaETUIm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 16:08:42 -0400
Message-ID: <537BB625.2000802@ti.com>
Date: Tue, 20 May 2014 16:08:05 -0400
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>, Kumar Gala <galak@codeaurora.org>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH v2 0/6] soc: ti: Add Keystone Navigator drivers
References: <1398296783-1176-1-git-send-email-santosh.shilimkar@ti.com> <537B5F5E.9080703@ti.com> <20140520200104.GA27786@kroah.com>
In-Reply-To: <20140520200104.GA27786@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 20 May 2014 04:01 PM, Greg Kroah-Hartman wrote:
> On Tue, May 20, 2014 at 09:57:50AM -0400, Santosh Shilimkar wrote:
>> Greg,
>>
>> On Wednesday 23 April 2014 07:46 PM, Santosh Shilimkar wrote:
>>> Here is an updated version of the Keystone Navigator drivers after
>>> addressing comments from earlier version [1].
>>>
>>> The QMSS found on Keystone SOCs is one of the main hardware sub
>>> system which forms the backbone of the Keystone Multi-core Navigator.
>>> QMSS consist of queue managers, packed-data structure processors(PDSP),
>>> linking RAM, descriptor pools and infrastructure DMA.
>>>
>>> After the discussion and alignment [2] on Navigator DMA, now we pair
>>> this driver along with QMSS. Initially this driver was proposed as DMA
>>> engine driver but since the hardware is not typical DMA engine and doesn't
>>> comply with typical DMA engine driver needs, that approach was naked.
>>>
>>> These two drivers works as infrastructure drivers for subsystems like
>>> Ethernet subsystem, SRIO subsystem, Crypto Engines etc on Keystone
>>> SOC families. Testing is done with NetCP(ethernet) subsystem drivers.
>>>
>>> I would like to get these drivers merged in upcoming(3.16) window, so
>>> any help in terms of review is appreciated. Thanks
>>>
>>> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>>> Cc: Kumar Gala <galak@codeaurora.org>
>>> Cc: Olof Johansson <olof@lixom.net>
>>> Cc: Arnd Bergmann <arnd@arndb.de>
>>> Cc: Grant Likely <grant.likely@linaro.org>
>>> Cc: Rob Herring <robh+dt@kernel.org>
>>> Cc: Mark Rutland <mark.rutland@arm.com>
>>>
>> I plan to respin v3 of the series for the few device tree related
>> comments I received from Rob H (thanks Rob). Can you please have a
>> look and gsee if you have any comments so that I can include them
>> in next version.
> 
> I am so far behind in patch review, please just redo them based on
> other's comments and resend, don't wait for me.
> 
OK. Thanks for quick response !!

regards,
Santosh

