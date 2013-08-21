Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751902Ab3HUK0D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 06:26:03 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:19094 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751617Ab3HUK0B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 06:26:01 -0400
Message-ID: <521495CE.5040205@atmel.com>
Date: Wed, 21 Aug 2013 12:26:22 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Richard Genoud <richard.genoud@gmail.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/4] Add sound in SAM9x5 DTS
References: <1376310662-20003-1-git-send-email-richard.genoud@gmail.com>
In-Reply-To: <1376310662-20003-1-git-send-email-richard.genoud@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/08/2013 14:30, Richard Genoud :
> As the sam9x5-wm8731 machine driver has been merged, we have now to add
> the device tree nodes...
> And here they are !
>
> (Based on next-20130812)
> Tested on at91sam9g35-ek
>
> [I didn't add the DT list, as far as there's no new binding, we don't
> have to bother themi, right ?]

Yep!

On the whole series:

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

Stacked on top of at91-3.12-dt

Thanks a lot Richard!

> Richard Genoud (4):
>    ARM: AT91: DTS: sam9x5: add SSC DMA parameters
>    ARM: AT91: DTS: sam9x5ek: add WM8731 codec
>    ARM: AT91: DTS: sam9x5ek: enable SSC
>    ARM: AT91: DTS: sam9x5ek: add sound configuration
>
>   arch/arm/boot/dts/at91sam9x5.dtsi   |    3 +++
>   arch/arm/boot/dts/at91sam9x5ek.dtsi |   24 ++++++++++++++++++++++++
>   2 files changed, 27 insertions(+)
>


-- 
Nicolas Ferre
