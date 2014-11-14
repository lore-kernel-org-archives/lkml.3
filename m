Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965803AbaKNTHi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 14:07:38 -0500
Received: from mail-wg0-f42.google.com ([74.125.82.42]:61134 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965598AbaKNTHf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 14:07:35 -0500
Message-ID: <546652F3.8050809@gmail.com>
Date: Fri, 14 Nov 2014 20:07:31 +0100
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
To: Antoine Tenart <antoine.tenart@free-electrons.com>
CC: Arnd Bergmann <arnd@arndb.de>, Peter.Chen@freescale.com, balbi@ti.com,
        p.zabel@pengutronix.de, alexandre.belloni@free-electrons.com,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-arm-kernel@lists.infradead.org,
        linux-usb@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 03/13] ARM: Berlin: select the reset controller
References: <1415978763-27345-1-git-send-email-antoine.tenart@free-electrons.com> <1415978763-27345-4-git-send-email-antoine.tenart@free-electrons.com> <3287202.nx0cnO5WUI@wuerfel> <54662192.6000403@gmail.com> <20141114172812.GD2991@kwain>
In-Reply-To: <20141114172812.GD2991@kwain>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14.11.2014 18:28, Antoine Tenart wrote:
> Sebastian,
>
> On Fri, Nov 14, 2014 at 04:36:50PM +0100, Sebastian Hesselbarth wrote:
>> On 11/14/2014 04:33 PM, Arnd Bergmann wrote:
>>> On Friday 14 November 2014 16:25:53 Antoine Tenart wrote:
>>>>   menuconfig ARCH_BERLIN
>>>>          bool "Marvell Berlin SoCs" if ARCH_MULTI_V7
>>>> +       select ARCH_HAS_RESET_CONTROLLER
>>>>          select ARCH_REQUIRE_GPIOLIB
>>>>          select ARM_GIC
>>>>          select GENERIC_IRQ_CHIP
>>>>          select DW_APB_ICTL
>>>>          select DW_APB_TIMER_OF
>>>>          select PINCTRL
>>>> +       select RESET_CONTROLLER
>>>
>>> RESET_CONTROLLER is meant to be user-selectable, don't add a 'select' here,
>>> but instead make the driver 'depends on RESET_CONTROLLER'.
>>
>> It already went into arm-soc for v3.19 - ergo, we need an extra
>> patch for removing the current 'select'.
>
> Do you want me to send the extra patch fixing this issue?

Yes, please. The patch in question is already in a tagged, stabled,
and pulled branch - so there is nothing I can do about it.

You can just send it as an independent patch, I'll pick it up quickly.

Sebastian

