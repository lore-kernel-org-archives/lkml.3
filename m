Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752793Ab3KDNJi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 08:09:38 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:48112 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751632Ab3KDNJg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 08:09:36 -0500
Message-ID: <52779C6C.1090603@ti.com>
Date: Mon, 4 Nov 2013 18:39:00 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Tomasz Figa <t.figa@samsung.com>
CC: Vivek Gautam <gautam.vivek@samsung.com>, <linux-usb@vger.kernel.org>,
        <linux-samsung-soc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-doc@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        <kgene.kim@samsung.com>, <k.debski@samsung.com>,
        <s.nawrocki@samsung.com>, <balbi@ti.com>, <jwerner@chromium.org>,
        <jg1.han@samsung.com>
Subject: Re: [PATCH RFC 1/4] phy: Add new Exynos5 USB 3.0 PHY driver
References: <1383205544-32244-1-git-send-email-gautam.vivek@samsung.com> <1383205544-32244-2-git-send-email-gautam.vivek@samsung.com> <527744B2.4090303@ti.com> <1539581.zprt32081v@amdc1227>
In-Reply-To: <1539581.zprt32081v@amdc1227>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 04 November 2013 05:56 PM, Tomasz Figa wrote:
> Hi Kishon,
>
> On Monday 04 of November 2013 12:24:42 Kishon Vijay Abraham I wrote:
>> Hi Vivek,
>>
>> On Thursday 31 October 2013 01:15 PM, Vivek Gautam wrote:
>>> Add a new driver for the USB 3.0 PHY on Exynos5 series of SoCs.
>>> The new driver uses the generic PHY framework and will interact
>>> with DWC3 controller present on Exynos5 series of SoCs.
>>
>> In Exynos, you have a single IP that supports both USB3 and USB2 PHY
>> right? I think that needs to be mentioned here.
>
> Nope. There are two separate, different IPs.

Alright. Thanks for the clarification.

Cheers
Kishon

>
>> Do you have separate registers that should be used for
>> initializing/powerin_on/powering_off etc.. for usb2 phy and usb3 phy? If
>> so, then you should model this driver as a single driver that supports
>> two PHYs similar to what Sylwester has done before?
>
> Sylwester's MIPI PHY uses such model because it has a single register
> that controls both PHYs.
>
> Best regards,
> Tomasz
>

