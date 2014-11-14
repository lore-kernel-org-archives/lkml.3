Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965656AbaKNPg6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 10:36:58 -0500
Received: from mail-wg0-f54.google.com ([74.125.82.54]:52229 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964875AbaKNPg4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 10:36:56 -0500
Message-ID: <54662192.6000403@gmail.com>
Date: Fri, 14 Nov 2014 16:36:50 +0100
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
To: Arnd Bergmann <arnd@arndb.de>,
        Antoine Tenart <antoine.tenart@free-electrons.com>
CC: Peter.Chen@freescale.com, balbi@ti.com, p.zabel@pengutronix.de,
        alexandre.belloni@free-electrons.com,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-arm-kernel@lists.infradead.org,
        linux-usb@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 03/13] ARM: Berlin: select the reset controller
References: <1415978763-27345-1-git-send-email-antoine.tenart@free-electrons.com> <1415978763-27345-4-git-send-email-antoine.tenart@free-electrons.com> <3287202.nx0cnO5WUI@wuerfel>
In-Reply-To: <3287202.nx0cnO5WUI@wuerfel>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/14/2014 04:33 PM, Arnd Bergmann wrote:
> On Friday 14 November 2014 16:25:53 Antoine Tenart wrote:
>>   menuconfig ARCH_BERLIN
>>          bool "Marvell Berlin SoCs" if ARCH_MULTI_V7
>> +       select ARCH_HAS_RESET_CONTROLLER
>>          select ARCH_REQUIRE_GPIOLIB
>>          select ARM_GIC
>>          select GENERIC_IRQ_CHIP
>>          select DW_APB_ICTL
>>          select DW_APB_TIMER_OF
>>          select PINCTRL
>> +       select RESET_CONTROLLER
>
> RESET_CONTROLLER is meant to be user-selectable, don't add a 'select' here,
> but instead make the driver 'depends on RESET_CONTROLLER'.

It already went into arm-soc for v3.19 - ergo, we need an extra
patch for removing the current 'select'.

Sebastian


