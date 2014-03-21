Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751395AbaCUTIU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 15:08:20 -0400
Received: from www.linutronix.de ([62.245.132.108]:52650 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751081AbaCUTIS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 15:08:18 -0400
Message-ID: <532C8E1F.8080400@linutronix.de>
Date: Fri, 21 Mar 2014 20:08:15 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.3.0
MIME-Version: 1.0
To: delicious quinoa <delicious.quinoa@gmail.com>
CC: Alan Tull <atull@altera.com>, Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Dinh Nguyen <dinguyen@altera.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH 3/3] ARM: dts: socfpga: add gpio pieces
References: <1395345324-18299-1-git-send-email-bigeasy@linutronix.de>	<1395345324-18299-4-git-send-email-bigeasy@linutronix.de> <CANk1AXRa4V1ADNaT+T3pYF4zyxni9Y8rmU9UYRoA_7NxW8KWEg@mail.gmail.com>
In-Reply-To: <CANk1AXRa4V1ADNaT+T3pYF4zyxni9Y8rmU9UYRoA_7NxW8KWEg@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/21/2014 07:14 PM, delicious quinoa wrote:
>> +               gpio@ff708000 {
>> +                       #address-cells = <1>;
>> +                       #size-cells = <0>;
>> +                       compatible = "snps,dw-apb-gpio";
>> +                       reg = <0xff708000 0x1000>;
>> +                       clocks = <&per_base_clk>;
>> +                       status = "disabled";
>> +
>> +                       gpio0: gpio-controller@0 {
>> +                               compatible = "snps,dw-apb-gpio-port";
>> +                               gpio-controller;
>> +                               #gpio-cells = <1>;
> 
> #gpio-cells = <2>;
> 
> I applied this patch, fixed the gpio-cells, tested on a cyclone5 soc
> devkit, and see that it breaks the interrupts.  Did you test this?

No, as I said. in 0/3. Will take a look on that at somepoint next week.

> 
> Alan

Sebastian
