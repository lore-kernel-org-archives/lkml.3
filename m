Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752942AbaGKKzX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 06:55:23 -0400
Received: from router.aksignal.cz ([188.175.113.102]:53465 "EHLO
	router.aksignal.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751974AbaGKKzW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 06:55:22 -0400
Message-ID: <53BFC294.4050502@aksignal.cz>
Date: Fri, 11 Jul 2014 12:55:16 +0200
From: =?UTF-8?B?SmnFmcOtIFByY2hhbA==?= <jiri.prchal@aksignal.cz>
Reply-To: jiri.prchal@aksignal.cz
Organization: AK signal Brno
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Bo Shen <voice.shen@atmel.com>
CC: nicolas.ferre@atmel.com, boris.brezillon@free-electrons.com,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: at91: at91sam9x5: add clocks for usb device
References: <1405074175-22444-1-git-send-email-voice.shen@atmel.com> <20140711104755.GA3112@piout.net>
In-Reply-To: <20140711104755.GA3112@piout.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks, it works now.

Dne 11.7.2014 12:47, Alexandre Belloni napsal(a):
> On 11/07/2014 at 18:22:55 +0800, Bo Shen wrote :
>> Add clocks for usb device, or else switch to CCF, the gadget
>> won't work.
>>
>> Reported-by: Jiří Prchal <jiri.prchal@aksignal.cz>
>> Signed-off-by: Bo Shen <voice.shen@atmel.com>
> Acked-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Tested-by: Jiri Prchal <jiri.prchal@aksignal.cz>
>
>> ---
>>   arch/arm/boot/dts/at91sam9x5.dtsi | 2 ++
>>   1 file changed, 2 insertions(+)
>>
>> diff --git a/arch/arm/boot/dts/at91sam9x5.dtsi b/arch/arm/boot/dts/at91sam9x5.dtsi
>> index d6133f4..2ebc421 100644
>> --- a/arch/arm/boot/dts/at91sam9x5.dtsi
>> +++ b/arch/arm/boot/dts/at91sam9x5.dtsi
>> @@ -1045,6 +1045,8 @@
>>   				reg = <0x00500000 0x80000
>>   				       0xf803c000 0x400>;
>>   				interrupts = <23 IRQ_TYPE_LEVEL_HIGH 0>;
>> +				clocks = <&usb>, <&udphs_clk>;
>> +				clock-names = "hclk", "pclk";
>>   				status = "disabled";
>>
>>   				ep0 {
>> --
>> 1.8.5.2
>>
>>
>> _______________________________________________
>> linux-arm-kernel mailing list
>> linux-arm-kernel@lists.infradead.org
>> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
>
