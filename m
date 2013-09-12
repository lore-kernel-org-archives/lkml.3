Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755365Ab3ILLOU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 07:14:20 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:43329 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753477Ab3ILLOR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 07:14:17 -0400
Message-ID: <5231A1FA.5040705@ti.com>
Date: Thu, 12 Sep 2013 16:44:02 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Pratyush Anand <pratyush.anand@st.com>
CC: Jingoo Han <jg1.han@samsung.com>, "'Bjorn Helgaas'" <bhelgaas@google.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        Mohit KUMAR DCG <Mohit.KUMAR@st.com>,
        "'Arnd Bergmann'" <arnd@arndb.de>, "'Sean Cross'" <xobs@kosagi.com>,
        "'Thierry Reding'" <thierry.reding@gmail.com>,
        "'SRIKANTH TUMKUR SHIVANAND'" <ts.srikanth@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH V3] pci: exynos: split into two parts such as Synopsys
 part and Exynos part
References: <000701ce8741$fe47deb0$fad79c10$@samsung.com> <51EE22DF.6090902@ti.com> <001301ce8772$522dfc50$f689f4f0$@samsung.com> <5231607C.10702@ti.com> <003501ceaf87$cda45db0$68ed1910$%han@samsung.com> <20130912093018.GA2124@pratyush-vbox> <52318CCC.4040604@ti.com> <20130912095213.GA5995@pratyush-vbox> <5231925B.3030104@ti.com> <20130912101803.GB5995@pratyush-vbox> <20130912104602.GC5995@pratyush-vbox>
In-Reply-To: <20130912104602.GC5995@pratyush-vbox>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 12 September 2013 04:16 PM, Pratyush Anand wrote:
> On Thu, Sep 12, 2013 at 03:48:03PM +0530, Pratyush Anand wrote:
>> On Thu, Sep 12, 2013 at 06:07:23PM +0800, Kishon Vijay Abraham I wrote:
>>> Hi,
>>>
>>> On Thursday 12 September 2013 03:22 PM, Pratyush Anand wrote:
>>>> Hi Kishon,
>>>>
>>>> On Thu, Sep 12, 2013 at 05:43:40PM +0800, Kishon Vijay Abraham I wrote:
>>>>> Hi,
>>>>>
>>>>> On Thursday 12 September 2013 03:00 PM, Pratyush Anand wrote:
>>>>>> Hi Jingoo,
>>>>>>
>>>>>>
>>>>>> On Thu, Sep 12, 2013 at 03:15:04PM +0800, Jingoo Han wrote:
>>>>>>> On Tuesday 23 July 2013 12:30 PM, Kishon Vijay Abraham I wrote:
>>>>>>>>>> .
>>>>>>>>>> .
>>
>> [...]
>>
>>>>> when I do ifconfig eth0 up, I get *r8169 0000:01:00.0 eth0: link up.*
>>>>> But I dont receive any packets and ping also fails and the tx and rx packet
>>>>> count is also 0. Could it be related to inbound translation?
>>>>
>>>> A PCIe analyser log would tell a definite cause. Most likely either
>>>> inbound translation is not working or INTx/MSI is not working.
>>>
>>> I have enabled only legacy interrupts. Whenever I connect or disconnect
>>> ethernet cable I get link up/link down message and also the interrupt count for
>>> eth0 increases. So I'm not doubting INTx interrupts as such.
> 
> Just a question, what is the MRRS of your RC? if it is 128, can you

it's 512.
> try with passing pci=pcie_bus_peer2peer  in your bootargs.
> 
> Again, analyser will help a lot in diagnosing such issues.

dont have a analyser here :-(

Thanks
Kishon
