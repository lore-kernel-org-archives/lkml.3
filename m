Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753692AbaDRQO4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 12:14:56 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:27404 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751314AbaDRQOx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 12:14:53 -0400
Message-ID: <53514F7A.40502@atmel.com>
Date: Fri, 18 Apr 2014 18:14:50 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
CC: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] ARM: at91: improve at91sam9m10g45ek support
References: <1395184541-5787-1-git-send-email-alexandre.belloni@free-electrons.com>
In-Reply-To: <1395184541-5787-1-git-send-email-alexandre.belloni@free-electrons.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19/03/2014 00:15, Alexandre Belloni :
> Here are a few DT improvements for the at91sam9m10g45ek.
> 
> The first patch corrects the ADC support for the at91sam9g45.
> 
> The second patch adds ADC and touchscreen support to the at91sam9m10g45ek.
> 
> The last one corrects the PWM polarity after the polarity got right in the
> driver, following patch "PWM: atmel-pwm: Fix polarity handling"
> 
> 
> Alexandre Belloni (3):
>   ARM: at91/dt: sam9g45: improve ADC/touchscreen support
>   ARM: at91/dt: at91sam9m10g45ek: add ADC and touchscreen support
>   ARM: at91/dt: at91sam9m10g45ek PWM leds polarity is inversed

Ok, nice: the whole series stacked on top of at91-3.16-dt. Thanks.

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>


>  arch/arm/boot/dts/at91sam9g45.dtsi     | 33 +++++++++++++++++++++++++++++++--
>  arch/arm/boot/dts/at91sam9m10g45ek.dts | 20 ++++++++++++++++++--
>  2 files changed, 49 insertions(+), 4 deletions(-)
> 


-- 
Nicolas Ferre
