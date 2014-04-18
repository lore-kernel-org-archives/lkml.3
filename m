Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752772AbaDROPj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 10:15:39 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:31929 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751143AbaDROPh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 10:15:37 -0400
Message-ID: <53513386.4040000@atmel.com>
Date: Fri, 18 Apr 2014 16:15:34 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
CC: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] Add more peripherals to the sam9rlek
References: <1397560063-7439-1-git-send-email-alexandre.belloni@free-electrons.com>
In-Reply-To: <1397560063-7439-1-git-send-email-alexandre.belloni@free-electrons.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15/04/2014 13:07, Alexandre Belloni :
> Hi, this patch set adds support for SPI, LCD, i2c, ADC and touchscreen, USB
> gadget and PWM on the at91sam9rlek.
> 
> The only missing piece is now audio/ac97 support, then the SoC will be entirely
> supported using DT.
> 
> Alexandre Belloni (2):
>   ARM: at91/dt: sam9rl: add lcd, adc, usb gadget and pwm support
>   ARM: at91/dt: add peripherals to the at91sam9rlek board

Ok: both added to at91-3.16-dt

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

> 
>  arch/arm/boot/dts/at91sam9rl.dtsi  | 265 +++++++++++++++++++++++++++++++++++--
>  arch/arm/boot/dts/at91sam9rlek.dts |  90 ++++++++++++-
>  2 files changed, 342 insertions(+), 13 deletions(-)
> 


-- 
Nicolas Ferre
