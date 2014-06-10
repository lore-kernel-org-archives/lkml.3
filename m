Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755158AbaFJG5s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 02:57:48 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:28328 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754591AbaFJG5n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 02:57:43 -0400
X-AuditID: cbfec7f5-b7f626d000004b39-49-5396ac64b22a
Message-id: <5396AC5C.2080108@samsung.com>
Date: Tue, 10 Jun 2014 08:57:32 +0200
From: Andrzej Hajda <a.hajda@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.5.0
MIME-version: 1.0
To: David Laight <David.Laight@ACULAB.COM>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Ben Dooks <ben@trinity.fluff.org>
Cc: driverdevel <devel@driverdev.osuosl.org>,
        Linux MIPS Mailing List <linux-mips@linux-mips.org>,
        "spear-devel@list.st.com" <spear-devel@list.st.com>,
        David Daney <ddaney.cavm@gmail.com>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        "patches@opensource.wolfsonmicro.com" 
	<patches@opensource.wolfsonmicro.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "platform-driver-x86@vger.kernel.org" 
	<platform-driver-x86@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "m@bues.ch" <m@bues.ch>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        linux-samsung-soc@vger.kernel.org
Subject: Re: [PATCH 2/2] gpio: gpiolib: set gpiochip_remove retval to void
References: <20140530094025.3b78301e@canb.auug.org.au>
 <1401449454-30895-1-git-send-email-berthe.ab@gmail.com>
 <1401449454-30895-2-git-send-email-berthe.ab@gmail.com>
 <CAMuHMdV6AtjD2aqO3buzj8Eo7A7xc_+ROYnxEi2sdjMaqFiAuA@mail.gmail.com>
 <5388C0F1.90503@gmail.com> <5388CB1B.3090802@metafoo.de>
 <20140608231823.GB10112@trinity.fluff.org> <53959A93.7080308@metafoo.de>
 <5395B379.2010706@samsung.com>
 <063D6719AE5E284EB5DD2968C1650D6D17259A1F@AcuExch.aculab.com>
In-reply-to: <063D6719AE5E284EB5DD2968C1650D6D17259A1F@AcuExch.aculab.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrCIsWRmVeSWpSXmKPExsVy+t/xy7opa6YFGzRN4bL42HWbxWLH0s1M
	Fkf+vmK12HPmF7vFs1t7mSyWTJ7PajHlz3Imi02Pr7FabJ7/h9Hi5qdvrBaXd81hs5gwdRK7
	xYzz+5gs5vyZwmzxZsUddotVc5+wWhxbIGax/O1/NovVe14wW8yZsZnVQcSjf/YUNo/Zxx+x
	edzbd5jFY+esu+wed67tYfM4dLiD0ePoyrVMHicvnGTx2Lyk3mPJm0OsHi8n/mbz2H18HpPH
	501yAbxRXDYpqTmZZalF+nYJXBkLl/1gLTjLX9HwvJW1gfEsTxcjJ4eEgInEipUdLBC2mMSF
	e+vZuhi5OIQEljJK/Hy6Ccr5xCixo282M0gVr4CWxKWLbawgNouAqsS9k/OZQGw2AU2Jv5tv
	AjVwcIgKREg8viAEUS4o8WPyPbAFIgKlEnf+/2cGmcksMINdovVPDztIQljAS2Lt9RawOUIC
	N5glGlZzgMzhBIp3TZUFCTML6Ejsb53GBmHLS2xe85Z5AqPALCQrZiEpm4WkbAEj8ypG0dTS
	5ILipPRcI73ixNzi0rx0veT83E2MkJj9uoNx6TGrQ4wCHIxKPLwG/tOChVgTy4orcw8xSnAw
	K4nw/pwDFOJNSaysSi3Kjy8qzUktPsTIxMEp1cCo++m6jv8y9WvTzyY8lA1WC9aM5i4qvtvc
	snBqR9TEuPc1X78dEdgTsSzsar5eWuXHv+dW/nu/VZbL4LDyVvP9G5Yn5Jz98/H4082/7yf/
	npiw9MzEZ6cjbf8eq0zLvb9h7TKlyJbHrQlv9XNd4zjsdt9VVfJIdQtLt6mO4lUU9ehIKp2a
	/2G5EktxRqKhFnNRcSIAt6YwY7cCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/09/2014 03:43 PM, David Laight wrote:
> From: Of Andrzej Hajda
> ...
>>> You can't error out on module unload, although that's not really relevant
>>> here. gpiochip_remove() is typically called when the device that registered
>>> the GPIO chip is unbound. And despite some remove() callbacks having a
>>> return type of int you can not abort the removal of a device.
>>
>> It is a design flaw in many subsystems having providers and consumers,
>> not only GPIO. The same situation is with clock providers, regulators,
>> phys, drm_panels, ..., at least it was such last time I have tested it.
>>
>> The problem is that many frameworks assumes that lifetime of provider is
>> always bigger than lifetime of its consumers, and this is wrong
>> assumption - usually it is not possible to prevent unbinding driver from
>> device, so if the device is a provider there is no way to inform
>> consumers about his removal.
>>
>> Some solution for such problems is to use some kind of availability
>> callbacks for requesting resources (gpios, clocks, regulators,...)
>> instead of simple 'getters' (clk_get, gpiod_get). Callbacks should
>> guarantee that the resource is always valid between callback reporting
>> its availability and callback reporting its removal. Such approach seems
>> to be complicated at the first sight but it should allow to make the
>> code safe and as a bonus it will allow to avoid deferred probing.
>> Btw I have send already RFC for such framework [1].
> 
> Callbacks for delete are generally a locking nightmare.
> A two-way handshake is also usually needed to avoid problems
> with concurrent disconnect requests.

The framework I have proposed is lock-less[1] and concurrent requests
are serialized so both objections are invalid.

[1]: in fact the framework uses spinlock, but only to protect internal
list simple operations, and even this could be converted to fully
lock-less implementation.

Andrzej

> 
> 	David
> 

