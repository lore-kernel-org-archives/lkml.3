Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753415AbaFBTJP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 15:09:15 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:48997 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752244AbaFBTJN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 15:09:13 -0400
Message-ID: <538CCBB1.4000209@ti.com>
Date: Mon, 2 Jun 2014 15:08:33 -0400
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: <linux-arm-kernel@lists.infradead.org>,
        Shawn Guo <shawn.guo@freescale.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "Strashko, Grygorii" <grygorii.strashko@ti.com>,
        Russell King <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Olof Johansson <olof@lixom.net>, Rob Herring <robh+dt@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH v3 0/7] of: setup dma parameters using dma-ranges and
 dma-coherent
References: <1398353407-2345-1-git-send-email-santosh.shilimkar@ti.com> <4197388.OE67ahhtqp@wuerfel> <538C9E3C.2000103@ti.com> <4328786.m38YGt2sIU@wuerfel>
In-Reply-To: <4328786.m38YGt2sIU@wuerfel>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 02 June 2014 03:00 PM, Arnd Bergmann wrote:
> On Monday 02 June 2014 11:54:36 Santosh Shilimkar wrote:
>>
>> On Monday 02 June 2014 11:06 AM, Arnd Bergmann wrote:
>>> On Monday 02 June 2014 09:24:50 Santosh Shilimkar wrote:
>>>> On Monday 02 June 2014 02:37 AM, Shawn Guo wrote:
>>>>> On Thu, Apr 24, 2014 at 11:30:00AM -0400, Santosh Shilimkar wrote:
>>>>>> Here is an updated v3 of the series. Series introduces support for setting up
>>>>>> dma parameters based on device tree properties like 'dma-ranges' and
>>>>>> 'dma-coherent' and also update to ARM 32 bit port. Earlier version of the
>>>>>> series can be found here [3], [2] and [1].
>>>>>
>>>>> Are these two generic device tree properties documented somewhere under
>>>>> Documentation/devicetree/bindings?
>>>>>
>>>> These bindings have been already in use before this series. But looks like
>>>> they have not been documented. I will do a patch to add description for those
>>>> couple of parameters.
>>>
>>> dma-ranges is part of ePAPR, and was documented in some ieee-1275 addenda
>>> before that, but I agree it would be nice to have something in kernel as
>>> well, at the minimum something pointing to the relevant documents.
>>>
>> We are thinking of updating 'Documentation/devicetree/bindings/dma/dma.txt'
>> to add the information for these extra two parameters.
>>
>> Is that fine or any other suggestion ?
> 
> I think that's the wrong place. That entire directory currently deals with
> the specific case of DMA engines, as opposed to the more DMA bus mastering
> in general. We could rename that to
> Documentation/devicetree/bindings/dmaengine, but renames tend to cause
> extra patch conficts, so I'd prefer finding another location for this.
> 
ok.

> How about a section in the top-level
> Documentation/devicetree/booting-without-of.txt file? After all, this
> is very generic and can impact any device that acts as a bus master.
> 
Sounds good. I can add it a section there with heading something like below.

VIII - Specifying dma bus information

Regards,
Santosh



