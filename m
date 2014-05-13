Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758756AbaEMGn5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 02:43:57 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:59025 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758635AbaEMGnx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 02:43:53 -0400
Message-ID: <5371BEFD.6000407@ti.com>
Date: Tue, 13 May 2014 12:13:09 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Vivek Gautam <gautam.vivek@samsung.com>
CC: Linux USB Mailing List <linux-usb@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        <linux-doc@vger.kernel.org>, Greg KH <gregkh@linuxfoundation.org>,
        Mark Rutland <mark.rutland@arm.com>, robh+dt <robh+dt@kernel.org>,
        Felipe Balbi <balbi@ti.com>, Kukjin Kim <kgene.kim@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
        Kamil Debski <k.debski@samsung.com>, Jingoo Han <jg1.han@samsung.com>
Subject: Re: [PATCH v8 1/2] phy: Add new Exynos5 USB 3.0 PHY driver
References: <1399643877-14528-1-git-send-email-gautam.vivek@samsung.com>	<5370C689.2090402@ti.com> <CAFp+6iH-bLd9WUYyK8d8i=UNUm4DHpEYz=Am_qzPyX6gDovyKA@mail.gmail.com>
In-Reply-To: <CAFp+6iH-bLd9WUYyK8d8i=UNUm4DHpEYz=Am_qzPyX6gDovyKA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tuesday 13 May 2014 11:37 AM, Vivek Gautam wrote:
> Hi Kishon,
> 
> 
> On Mon, May 12, 2014 at 6:33 PM, Kishon Vijay Abraham I <kishon@ti.com> wrote:
>> Hi Gautam,
>>
>> On Friday 09 May 2014 07:27 PM, Vivek Gautam wrote:
>>> Add a new driver for the USB 3.0 PHY on Exynos5 series of SoCs.
>>> The new driver uses the generic PHY framework and will interact
>>> with DWC3 controller present on Exynos5 series of SoCs.
>>>
>>> Also, created a new header file in linux/mfd/syscon/ for
>>> Exynos5 SoCs and put the required PMU offset definitions
>>> for the basic available PHYs.
>>>
>>
>>
>> I get the following checkpatch warnings
>>
>> WARNING: please write a paragraph that describes the config symbol fully
>> #163: FILE: drivers/phy/Kconfig:163:
>> +config PHY_EXYNOS5_USBDRD
>>
>> WARNING: DT compatible string "samsung,exynos5250-usbdrd-phy" appears
>> un-documented -- check ./Documentation/devicetree/bindings/
>> #708: FILE: drivers/phy/phy-exynos5-usbdrd.c:516:
>> +               .compatible = "samsung,exynos5250-usbdrd-phy",
>>
>> WARNING: DT compatible string "samsung,exynos5420-usbdrd-phy" appears
>> un-documented -- check ./Documentation/devicetree/bindings/
>> #711: FILE: drivers/phy/phy-exynos5-usbdrd.c:519:
>> +               .compatible = "samsung,exynos5420-usbdrd-phy",.
>>
>>
>> I think you just need to separate the Documentation into a separate patch
>> before applying the driver patch.
>>
> 
> I somehow don't see the Documentation warning. Below is the checkpatch
> output which i ran on this v8 patch version.
>   linux-phy$ ./scripts/checkpatch.pl phy.patch
>   WARNING: please write a paragraph that describes the config symbol fully
>   #127: FILE: drivers/phy/Kconfig:163:
>   +config PHY_EXYNOS5_USBDRD
> 
>   total: 0 errors, 1 warnings, 760 lines checked
> 
>   phy.patch has style problems, please review.
> 
>   If any of these errors are false positives, please report
>   them to the maintainer, see CHECKPATCH in MAINTAINERS.
> 
> am i missing something ?

Yeah.. the checkpatch.pl has got updated recently. If you use the latest kernel
you should see it.

Thanks
Kishon
