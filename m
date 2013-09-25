Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755492Ab3IYNPL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 09:15:11 -0400
Received: from top.free-electrons.com ([176.31.233.9]:38273 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754612Ab3IYNPJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 09:15:09 -0400
Message-ID: <5242E1D5.5000503@free-electrons.com>
Date: Wed, 25 Sep 2013 15:15:01 +0200
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Organization: Free Electrons
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Nicolas Ferre <nicolas.ferre@atmel.com>, Bo Shen <voice.shen@atmel.com>,
        Thierry Reding <thierry.reding@gmail.com>
CC: linux-pwm@vger.kernel.org, plagnioj@jcrosoft.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v4] PWM: atmel-pwm: add PWM controller driver
References: <1380079664-21959-1-git-send-email-voice.shen@atmel.com> <524290F5.2090406@atmel.com>
In-Reply-To: <524290F5.2090406@atmel.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25/09/2013 09:29, Nicolas Ferre wrote:
> On 25/09/2013 05:27, Bo Shen :
>> Add Atmel PWM controller driver based on PWM framework.
>>
>> This is the basic function implementation of Atmel PWM controller.
>> It can work with PWM based led and backlight.
>>
>> Signed-off-by: Bo Shen <voice.shen@atmel.com>
>
> It seems simple and nice.
>
> Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

Tested on a sama5d31 board with leds-pwm.

Tested-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
>

-- 
Alexandre Belloni, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

