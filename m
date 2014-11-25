Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755954AbaKYLst (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 06:48:49 -0500
Received: from mail-qa0-f44.google.com ([209.85.216.44]:34186 "EHLO
	mail-qa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753251AbaKYLso (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 06:48:44 -0500
MIME-Version: 1.0
In-Reply-To: <5470A7C5.1070302@kernel.org>
References: <1416576954-11997-1-git-send-email-gautam.vivek@samsung.com>
	<20141121151130.GD7508@saruman>
	<54704BF0.1000903@ti.com>
	<5470A7C5.1070302@kernel.org>
Date: Tue, 25 Nov 2014 17:18:43 +0530
Message-ID: <CAFp+6iE5XJ+TGu+8TvRFd3Up-kzki3VPD4k6gPXaYbscfwnz4w@mail.gmail.com>
Subject: Re: [PATCH 00/11] Exynos7: Adding USB 3.0 support
From: Vivek Gautam <gautamvivek1987@gmail.com>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Kukjin Kim <kgene@kernel.org>, Kishon Vijay Abraham I <kishon@ti.com>,
        Felipe Balbi <balbi@ti.com>, Vivek Gautam <gautam.vivek@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Tomasz Figa <tomasz.figa@gmail.com>, "robh+dt" <robh+dt@kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Kukjin Kim <kgene.kim@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sylwester,


On Sat, Nov 22, 2014 at 8:42 PM, Kukjin Kim <kgene@kernel.org> wrote:
> On 11/22/14 17:40, Kishon Vijay Abraham I wrote:
>>
>> On Friday 21 November 2014 08:41 PM, Felipe Balbi wrote:
>>> On Fri, Nov 21, 2014 at 07:05:43PM +0530, Vivek Gautam wrote:
>>>> The series has dependency on
>>>> a) "[PATCH v7 0/7] Enable support for Samsung Exynos7 SoC"
>>>>    http://www.spinics.net/lists/linux-samsung-soc/msg38734.html
>>>> b) "[GIT PULL] Samsung clock changes for 3.19" - specifically the clock dt
>>>>    bindings header.
>>>>    http://comments.gmane.org/gmane.linux.kernel.samsung-soc/39142
>>>> c) "tty: serial: samsung: Clean-up selection of number of available UARTs"
>>>>    http://www.spinics.net/lists/linux-samsung-soc/msg37418.html
>>>> d) "dts, kbuild: Implement support for dtb vendor subdirs"(merged in linux-next)
>>>>    https://lkml.org/lkml/2014/10/21/654
>>>> e) "Samsung pinctrl patches for v3.19"
>>>>    http://www.spinics.net/lists/linux-samsung-soc/msg38744.html
>>>>
>>>> Tested on Exynos7-espresso board with 3.18-rc5 and above dependencies.
>>>>
>>>> Clubbing the pinctrl, clk, and usb driver changes alongwith the dt changes
>>>> together in this series only so as to avoid having 'n' number of dependencies.
>>>>
>>>> The USB driver patches in this series were part of [1] sent earlier.
>>>> [1] [PATCH v2 0/4] usb: dwc3/phy-exynos5-usbdrd: Extend support to Exynos7
>>>>     https://lkml.org/lkml/2014/10/7/191
>>>
>>> I took dwc3 driver patches.
>>
>> I took the phy patches.
>>
> I'll take DT changes once exynos7 is landing into samsung tree :)
>

You too may want to pick the sole clock driver patch in this series
for 3.19 ? :-)
"clk: exynos7: Add required clock tree for USB"

Please let me know if the merge window is still open on your side so
that you can
pick this patch.


-- 
Best Regards
Vivek Gautam
Samsung R&D Institute, Bangalore
India
