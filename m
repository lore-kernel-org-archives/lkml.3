Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752345Ab3JNHjM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 03:39:12 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:36959 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750924Ab3JNHjK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 03:39:10 -0400
Message-ID: <525B9F93.9040001@atmel.com>
Date: Mon, 14 Oct 2013 09:38:59 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Bo Shen <voice.shen@atmel.com>, <plagnioj@jcrosoft.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>
Subject: Re: [PATCH 0/5] ARM:at91:enable sound on at91sam9n12ek board
References: <1381729113-29714-1-git-send-email-voice.shen@atmel.com>
In-Reply-To: <1381729113-29714-1-git-send-email-voice.shen@atmel.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/10/2013 07:38, Bo Shen :
> This patch series enable sound on at91sam9n12ek board with wm8904 codec
>
>
> Bo Shen (5):
>    ARM: at91: add at91sam9n12 ssc clock in look up table
>    ARM: at91: add ssc dma parameter for at91sam9n12
>    ARM: at91: enable wm8904 on at91sam9n12ek board
>    ARM: at91: enable ssc on at91sam9n12ek board
>    ARM: at91: add sound support on at91sam9n12ek board

Great!

And on the whole patch series:

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

I stack it on at91-3.13-dt branch.

Thanks.

>
>   arch/arm/boot/dts/at91sam9n12.dtsi  |    3 +++
>   arch/arm/boot/dts/at91sam9n12ek.dts |   34 ++++++++++++++++++++++++++++++++++
>   arch/arm/mach-at91/at91sam9n12.c    |    1 +
>   3 files changed, 38 insertions(+)
>


-- 
Nicolas Ferre
