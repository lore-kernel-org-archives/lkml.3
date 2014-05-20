Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752923AbaETJRH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 05:17:07 -0400
Received: from mga09.intel.com ([134.134.136.24]:59819 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752477AbaETJRE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 05:17:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,873,1392192000"; 
   d="scan'208";a="514675345"
Message-ID: <537B1D70.3050606@linux.intel.com>
Date: Tue, 20 May 2014 17:16:32 +0800
From: "Zhu, Lejun" <lejun.zhu@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Mathias Nyman <mathias.nyman@linux.intel.com>,
        Linus Walleij <linus.walleij@linaro.org>
CC: Alexandre Courbot <gnurou@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        bin.yang@intel.com, Darren Hart <dvhart@linux.intel.com>,
        "Holmberg, Hans" <hans.holmberg@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: Re: [PATCH] gpio: Add support for Intel SoC PMIC (Crystal Cove)
References: <1400082247-24168-1-git-send-email-lejun.zhu@linux.intel.com> <CACRpkdZ67KoaMWUzpPm5g7yvQ-_q9zxuS+4wcXP0u18MW=XovA@mail.gmail.com> <53794FDC.6080908@linux.intel.com> <537A117A.7050802@linux.intel.com>
In-Reply-To: <537A117A.7050802@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 5/19/2014 10:13 PM, Mathias Nyman wrote:
> On 05/19/2014 03:27 AM, Zhu, Lejun wrote:
>>
>>
>> On 5/17/2014 1:33 AM, Linus Walleij wrote:
>>> On Wed, May 14, 2014 at 5:44 PM, Zhu, Lejun <lejun.zhu@linux.intel.com> wrote:
>>>
>>>> Devices based on Intel SoC products such as Baytrail have a Power
>>>> Management IC. In the PMIC there are subsystems for voltage regulation,
>>>> A/D conversion, GPIO and PWMs. The PMIC in Baytrail-T platform is called
>>>> Crystal Cove.
>>>>
>>>> This patch adds support for the GPIO function in Crystal Cove.
>>>>
>>>> Signed-off-by: Yang, Bin <bin.yang@intel.com>
>>>> Signed-off-by: Zhu, Lejun <lejun.zhu@linux.intel.com>
>>>
>>> (...)
>>>
>>>> +config GPIO_INTEL_SOC_PMIC
>>>> +       bool "GPIO on Intel SoC PMIC"
>>>> +       depends on INTEL_SOC_PMIC
>>
>> Thank you. That's a long list and all of them indeed need to be fixed.
>> I'll work on them and submit v2 when ready.
>>
> 
> Shouldn't there be a .remove function undoing everything probe did?
> Freeing interrupts, removing irq domains, calling gpiochip_remove etc.
> 
> Or is there something I'm missing?
> I see there's no option to compile this as module, but It might be added later so
> proper remove function would still be nice.
> 
> -Mathias
> 

Good suggestion. I'll fix it. Thanks.

Best Regards
Lejun

