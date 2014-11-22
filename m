Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751539AbaKVIke (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2014 03:40:34 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:57886 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751435AbaKVIka (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2014 03:40:30 -0500
Message-ID: <54704BF0.1000903@ti.com>
Date: Sat, 22 Nov 2014 14:10:16 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: <balbi@ti.com>, Vivek Gautam <gautam.vivek@samsung.com>
CC: <linux-kernel@vger.kernel.org>, <linux-samsung-soc@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        <tomasz.figa@gmail.com>, <s.nawrocki@samsung.com>,
        <robh+dt@kernel.org>, <stern@rowland.harvard.edu>,
        <kgene.kim@samsung.com>
Subject: Re: [PATCH 00/11] Exynos7: Adding USB 3.0 support
References: <1416576954-11997-1-git-send-email-gautam.vivek@samsung.com> <20141121151130.GD7508@saruman>
In-Reply-To: <20141121151130.GD7508@saruman>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Friday 21 November 2014 08:41 PM, Felipe Balbi wrote:
> On Fri, Nov 21, 2014 at 07:05:43PM +0530, Vivek Gautam wrote:
>> The series has dependency on
>> a) "[PATCH v7 0/7] Enable support for Samsung Exynos7 SoC"
>>    http://www.spinics.net/lists/linux-samsung-soc/msg38734.html
>> b) "[GIT PULL] Samsung clock changes for 3.19" - specifically the clock dt
>>    bindings header.
>>    http://comments.gmane.org/gmane.linux.kernel.samsung-soc/39142
>> c) "tty: serial: samsung: Clean-up selection of number of available UARTs"
>>    http://www.spinics.net/lists/linux-samsung-soc/msg37418.html
>> d) "dts, kbuild: Implement support for dtb vendor subdirs"(merged in linux-next)
>>    https://lkml.org/lkml/2014/10/21/654
>> e) "Samsung pinctrl patches for v3.19"
>>    http://www.spinics.net/lists/linux-samsung-soc/msg38744.html
>>
>> Tested on Exynos7-espresso board with 3.18-rc5 and above dependencies.
>>
>> Clubbing the pinctrl, clk, and usb driver changes alongwith the dt changes
>> together in this series only so as to avoid having 'n' number of dependencies.
>>
>> The USB driver patches in this series were part of [1] sent earlier.
>> [1] [PATCH v2 0/4] usb: dwc3/phy-exynos5-usbdrd: Extend support to Exynos7
>>     https://lkml.org/lkml/2014/10/7/191
> 
> I took dwc3 driver patches.

I took the phy patches.

Thanks
Kishon
