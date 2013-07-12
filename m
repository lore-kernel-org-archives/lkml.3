Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752003Ab3GLFYJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 01:24:09 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:39017 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750951Ab3GLFYH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 01:24:07 -0400
Message-ID: <51DF92E7.2070109@ti.com>
Date: Fri, 12 Jul 2013 10:53:51 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Jingoo Han <jg1.han@samsung.com>
CC: "'Bjorn Helgaas'" <bhelgaas@google.com>, <linux-pci@vger.kernel.org>,
        <linux-samsung-soc@vger.kernel.org>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Pratyush Anand'" <pratyush.anand@st.com>,
        "'Mohit KUMAR'" <Mohit.KUMAR@st.com>,
        "'Arnd Bergmann'" <arnd@arndb.de>, "'Sean Cross'" <xobs@kosagi.com>,
        "'SRIKANTH TUMKUR SHIVANAND'" <ts.srikanth@samsung.com>,
        <linux-kernel@vger.kernel.org>,
        "'Thierry Reding'" <thierry.reding@gmail.com>
Subject: Re: [PATCH V2] pci: exynos: split into two parts such as Synopsys
 part and Exynos part
References: <001201ce7dfa$716b3370$54419a50$@samsung.com> <51DE72CC.9050001@ti.com> <001301ce7e92$d19a04e0$74ce0ea0$@samsung.com>
In-Reply-To: <001301ce7e92$d19a04e0$74ce0ea0$@samsung.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 12 July 2013 05:30 AM, Jingoo Han wrote:
> On Thursday, July 11, 2013 5:55 PM, Kishon Vijay Abraham I wrote:
>> On Thursday 11 July 2013 11:19 AM, Jingoo Han wrote:
>>> Exynos PCIe IP consists of Synopsys specific part and Exynos
>>> specific part. Only core block is a Synopsys designware part;
>>> other parts are Exynos specific.
>>> Also, the Synopsys designware part can be shared with other
>>> platforms; thus, it can be split two parts such as Synopsys
>>> designware part and Exynos specific part.
>>>
>>> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
>>> Cc: Pratyush Anand <pratyush.anand@st.com>
>>> Cc: Mohit KUMAR <Mohit.KUMAR@st.com>
>>> ---
>> .
>> .
>> <snip>
>> .
>> .
>>> +
>>> +/* Exynos PCIe driver does not allow module unload */
>>
>> Just curious, why is this restriction?
> 
> CC'ed Thierry Reding,
> 
> Hi Kishon,
> 
> That's a good question.
> 
> Now, we don't have the solution to "be able to load and unload
> the PCI host driver in a loop definitely without crashing or exposing
> any races  or leaks", as Arnd Bergmann said.
> Please refer to the following thread in mailing-list.
> (http://archive.arm.linux.org.uk/lurker/message/20130614.123849.4ff363c5.pl.html)

That explains.

Thanks
Kishon
