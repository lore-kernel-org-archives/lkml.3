Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757996Ab3CYOL5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 10:11:57 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:17751 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756436Ab3CYOL4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 10:11:56 -0400
Message-ID: <51505B26.7040508@atmel.com>
Date: Mon, 25 Mar 2013 15:11:50 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        <tanzilli@acmesystems.it>, <dgilbert@interlog.com>,
        <Robert.Nelson@digikey.com>
Subject: Re: [PATCH] ARM: at91: add Acme Systems Aria G25 board
References: <1364201369-12047-1-git-send-email-nicolas.ferre@atmel.com> <20130325122220.GF2001@game.jcrosoft.org>
In-Reply-To: <20130325122220.GF2001@game.jcrosoft.org>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/25/2013 01:22 PM, Jean-Christophe PLAGNIOL-VILLARD :
> On 09:49 Mon 25 Mar     , Nicolas Ferre wrote:
>> From: Douglas Gilbert <dgilbert@interlog.com>
>>
>> Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
>> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
>> ---
>>  arch/arm/boot/dts/ariag25.dts | 168 ++++++++++++++++++++++++++++++++++++++++++
>>  1 file changed, 168 insertions(+)
>>  create mode 100644 arch/arm/boot/dts/ariag25.dts
>>
>> diff --git a/arch/arm/boot/dts/ariag25.dts b/arch/arm/boot/dts/ariag25.dts
>> new file mode 100644
>> index 0000000..d18ef50
>> --- /dev/null
>> +++ b/arch/arm/boot/dts/ariag25.dts
>> @@ -0,0 +1,168 @@
>> +/*
>> + * ariag25.dts - Device Tree file for Acme Systems Aria G25 (AT91SAM9G25 based)
>> + *
>> + * Copyright (C) 2013 Douglas Gilbert <dgilbert@interlog.com>,
>> + *                    Robert Nelson <robertcnelson@gmail.com>
>> + *
>> + * Licensed under GPLv2 or later.
>> + */
>> +/dts-v1/;
>> +/include/ "at91sam9g25.dtsi"
>> +
>> +/ {
>> +	model = "Acme Systems Aria G25";
>> +	compatible = "acme,ariag25", "atmel,at91sam9g25ek", "atmel,at91sam9x5ek",
>> +		     "atmel,at91sam9x5", "atmel,at91sam9";
> I doube the code is compatible with the 9g25ek
> 
> specially when you do not include it

Ok, I remove it.

>> +
>> +	aliases {
>> +		serial4 = &usart3;
>> +		serial5 = &uart0;
>> +	};
> you need to specify all

Well I do not think so: other are taken from

/include/ "at91sam9g25.dtsi"

Bye,
-- 
Nicolas Ferre
