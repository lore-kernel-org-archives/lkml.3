Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422908AbaGRNvF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 09:51:05 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:32374 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422892AbaGRNvB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 09:51:01 -0400
Message-ID: <53C92640.1000609@atmel.com>
Date: Fri, 18 Jul 2014 15:50:56 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Bo Shen <voice.shen@atmel.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>
Subject: Re: [PATCH] ARM: at91: at91sam9x5: correct typo error for ohci clock
References: <1405307294-17708-1-git-send-email-voice.shen@atmel.com> <20140714081421.5f539287@bbrezillon>
In-Reply-To: <20140714081421.5f539287@bbrezillon>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/07/2014 08:14, Boris BREZILLON :
> On Mon, 14 Jul 2014 11:08:14 +0800
> Bo Shen <voice.shen@atmel.com> wrote:
> 
>> Correct the typo error for the second "uhphs_clk".
>>
>> Signed-off-by: Bo Shen <voice.shen@atmel.com>
> 
> Acked-by: Boris Brezillon <boris.brezillon@free-electrons.com>

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

> sam9n12 dtsi has the same bug, I'll fix it

Ok, thanks to Voice and you: I try to queue them for 3.16-fixes.

Bye,

> And sorry for the mess when moving sam9n12 and sam9x5 to the CCF, I
> should have checked my clock definitions more carefully :-(.

I admit that these values are pretty hard to read: the eye get bored
quite quickly ;-)

Bye,


>> ---
>>  arch/arm/boot/dts/at91sam9x5.dtsi | 3 +--
>>  1 file changed, 1 insertion(+), 2 deletions(-)
>>
>> diff --git a/arch/arm/boot/dts/at91sam9x5.dtsi b/arch/arm/boot/dts/at91sam9x5.dtsi
>> index 2ebc421..727d3a4 100644
>> --- a/arch/arm/boot/dts/at91sam9x5.dtsi
>> +++ b/arch/arm/boot/dts/at91sam9x5.dtsi
>> @@ -1155,8 +1155,7 @@
>>  			compatible = "atmel,at91rm9200-ohci", "usb-ohci";
>>  			reg = <0x00600000 0x100000>;
>>  			interrupts = <22 IRQ_TYPE_LEVEL_HIGH 2>;
>> -			clocks = <&usb>, <&uhphs_clk>, <&udphs_clk>,
>> -				 <&uhpck>;
>> +			clocks = <&usb>, <&uhphs_clk>, <&uhphs_clk>, <&uhpck>;
>>  			clock-names = "usb_clk", "ohci_clk", "hclk", "uhpck";
>>  			status = "disabled";
>>  		};
> 
> 
> 


-- 
Nicolas Ferre
