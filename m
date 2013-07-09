Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753870Ab3GINcO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 09:32:14 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:58634 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752846Ab3GINcN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 09:32:13 -0400
MIME-Version: 1.0
In-Reply-To: <51DC0E26.7080508@atmel.com>
References: <1373290193-25300-1-git-send-email-richard.genoud@gmail.com>
 <1373372929-17800-1-git-send-email-richard.genoud@gmail.com>
 <1373372929-17800-4-git-send-email-richard.genoud@gmail.com>
 <CACQ1gAg8WQTaz4XkXJCH+-bNU_U3s_1pgmQYoQR3v-KHOzzBTA@mail.gmail.com> <51DC0E26.7080508@atmel.com>
From: Richard Genoud <richard.genoud@gmail.com>
Date: Tue, 9 Jul 2013 15:31:52 +0200
Message-ID: <CACQ1gAhr3gm_O1UyYSUdg8mmnGriAU=kjY6zXwMirojc78dOgg@mail.gmail.com>
Subject: Re: [PATCH v3 3/7] Documentation: DT: update atmel SSC with DMA binding
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>,
        Bo Shen <voice.shen@atmel.com>, Lars-Peter Clausen <lars@metafoo.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org, devicetree-discuss@lists.ozlabs.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/7/9 Nicolas Ferre <nicolas.ferre@atmel.com>:
> On 09/07/2013 15:19, Richard Genoud :
>
>> 2013/7/9 Richard Genoud <richard.genoud@gmail.com>:
>>>
>>> As atmel-ssc can be used with DMA, the documentation should be updated.
>>> Also, a configuration DMA example is given.
>>>
>>> Signed-off-by: Richard Genoud <richard.genoud@gmail.com>
>>> ---
>>>   .../devicetree/bindings/misc/atmel-ssc.txt         |   24
>>> ++++++++++++++++++--
>>>   1 file changed, 22 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/Documentation/devicetree/bindings/misc/atmel-ssc.txt
>>> b/Documentation/devicetree/bindings/misc/atmel-ssc.txt
>>> index 38e51ad..96958ca 100644
>>> --- a/Documentation/devicetree/bindings/misc/atmel-ssc.txt
>>> +++ b/Documentation/devicetree/bindings/misc/atmel-ssc.txt
>>> @@ -6,10 +6,30 @@ Required properties:
>>>          - atmel,at91sam9g45-ssc: support dma transfer
>>>   - reg: Should contain SSC registers location and length
>>>   - interrupts: Should contain SSC interrupt
>>> +For dma transfer:
>>> +- dmas: DMA specifier, consisting of a phandle to DMA controller node,
>>> +  the memory interface and SSC DMA channel ID (for tx and rx).
>>> +  See Documentation/devicetree/bindings/dma/atmel-dma.txt for details.
>>> +- dma-names: Must be "tx", "rx".
>>>
>>> -Example:
>>> +
>>> +Examples:
>>>   ssc0: ssc@fffbc000 {
>>>          compatible = "atmel,at91rm9200-ssc";
>>>          reg = <0xfffbc000 0x4000>;
>>> -       interrupts = <14 4 5>;
>>> +       interrupts = <14 IRQ_TYPE_LEVEL_HIGH 5>;
>>
>> maybe I should not use macro in the documentation (not sure if I should or
>> not).
>
>
> absolutely.
ok, thanks, changing that in next version.
