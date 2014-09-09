Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932654AbaIIOzO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 10:55:14 -0400
Received: from mail-lb0-f172.google.com ([209.85.217.172]:38856 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751484AbaIIOzI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 10:55:08 -0400
MIME-Version: 1.0
In-Reply-To: <20140908223314.GA26151@kroah.com>
References: <1407852737-17265-1-git-send-email-matthias.bgg@gmail.com>
	<1407852737-17265-3-git-send-email-matthias.bgg@gmail.com>
	<20140908223314.GA26151@kroah.com>
Date: Tue, 9 Sep 2014 16:55:06 +0200
Message-ID: <CABuKBe+nkR+HvQm-pacg5cJeYey-Nj+uqqLpzi1FAvzbxtJuew@mail.gmail.com>
Subject: Re: [PATCH v4 2/2] DTS: serial: Add bindings documention for the
 Mediatek UARTs
From: Matthias Brugger <matthias.bgg@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>, jslaby@suse.cz,
        Grant Likely <grant.likely@linaro.org>,
        Alan Cox <alan@linux.intel.com>,
        Varka Bhadram <varkabhadram@gmail.com>,
        Tobias Klauser <tklauser@distanz.ch>,
        =?ISO-8859-1?Q?Heiko_St=FCbner?= <heiko@sntech.de>,
        Yingjoe Chen <yingjoe.chen@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        linux-serial@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-09-09 0:33 GMT+02:00 Greg KH <gregkh@linuxfoundation.org>:
> On Tue, Aug 12, 2014 at 04:12:17PM +0200, Matthias Brugger wrote:
>> This patch adds the devicetree documentation for the Mediatek UART.
>>
>> Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>
>> ---
>>  .../devicetree/bindings/serial/mtk-uart.txt        |   20 ++++++++++++++++++++
>>  1 file changed, 20 insertions(+)
>>  create mode 100644 Documentation/devicetree/bindings/serial/mtk-uart.txt
>>
>> diff --git a/Documentation/devicetree/bindings/serial/mtk-uart.txt b/Documentation/devicetree/bindings/serial/mtk-uart.txt
>> new file mode 100644
>> index 0000000..6ca0e15
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/serial/mtk-uart.txt
>> @@ -0,0 +1,20 @@
>> +* Mediatek Universal Asynchronous Receiver/Transmitter (UART)
>> +
>> +Required properties:
>> +- compatible: "mediatek,mt6577-uart"
>> +  Compatibility with mt6577, mt6589, mt6582
>> +
>> +- reg: The base address of the UART register bank.
>> +
>> +- interrupts: A single interrupt specifier.
>> +
>> +- clocks: Clock driving the hardware.
>> +
>> +Example:
>> +
>> +     uart0: serial@11006000 {
>> +             compatible = "mediatek,mt6577-uart";
>> +             reg = <0x11006000 0x400>;
>> +             interrupts = <GIC_SPI 51 IRQ_TYPE_LEVEL_LOW>;
>> +             clocks = <&uart_clk>;
>> +     };
>> --
>> 1.7.9.5
>
> Resend this one as well with the 1/2 patch please.

Ok, I will send v5 with the comments from Mark added.

>
> thanks,
>
> greg k-h



-- 
motzblog.wordpress.com
