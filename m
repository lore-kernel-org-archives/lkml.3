Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751738Ab3HUJfV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 05:35:21 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:13186 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751631Ab3HUJfU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 05:35:20 -0400
Message-ID: <521489EC.9090107@atmel.com>
Date: Wed, 21 Aug 2013 11:35:40 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Bo Shen <voice.shen@atmel.com>
CC: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        <ludovic.desroches@atmel.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>
Subject: Re: [PATCH v2 0/3] arm: atmel: at91sam9n12: add i2c pinctrl and qt1070
 support
References: <1373513446-18215-1-git-send-email-voice.shen@atmel.com>
In-Reply-To: <1373513446-18215-1-git-send-email-voice.shen@atmel.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/07/2013 05:30, Bo Shen :
> this patch is based on linux master branch, implementation as following:
>    - add the i2c pinctrl which needed for using at91sam9n12 TWI
>    - enable qt1070
>    - trival fix for the gpio-key pin number

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

On the whole series.

>
> Changes in v2:
>    - remove comments as use micro
>    - using micro for interrupt trigger mode
>
> Bo Shen (3):
>    arm: atmel: at91sam9n12: add pinctrl of TWI

Beware:
1/ "arm" in upper case
2/ not "atmel" as second identifier but "at91" (lower case)

>    arm: atmel: at91sam9n12: add qt1070 support
>    arm: atmel: at91sam9n12: correct pin number of gpio-key
>
>   arch/arm/boot/dts/at91sam9n12.dtsi  |   20 ++++++++++++++++++++
>   arch/arm/boot/dts/at91sam9n12ek.dts |   18 +++++++++++++++++-
>   2 files changed, 37 insertions(+), 1 deletion(-)
>


-- 
Nicolas Ferre
