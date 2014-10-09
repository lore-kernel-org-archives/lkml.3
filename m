Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757250AbaJIOET (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 10:04:19 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:40288 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752327AbaJIOEK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 10:04:10 -0400
Message-ID: <543695D2.1090504@atmel.com>
Date: Thu, 9 Oct 2014 16:04:02 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>
CC: Russell King <linux@arm.linux.org.uk>, Vinod Koul <vinod.koul@intel.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Dan Williams <dan.j.williams@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        <dmaengine@vger.kernel.org>, "Arnd Bergmann" <arnd@arndb.de>,
        =?UTF-8?B?QW50?= =?UTF-8?B?b2luZSBUw6luYXJ0?= 
	<antoine@free-electrons.com>,
        Thomas Petazzoni <thomas@free-electrons.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Boris Brezillon <boris@free-electrons.com>,
        Matt Porter <matt.porter@linaro.org>,
        "Gregory Clement" <gregory.clement@free-electrons.com>
Subject: Re: [PATCH v2 2/2] Documentation: dmaengine: Add a documentation
 for the dma controller API
References: <1411746035-15882-1-git-send-email-maxime.ripard@free-electrons.com>	<1411746035-15882-2-git-send-email-maxime.ripard@free-electrons.com>	<7725507.nuHj4C7OxF@avalon>	<5433D9AF.8020508@atmel.com>	<20141007145226.GA17925@lukather> <CAMuHMdUKk1kJwBndjiziRexOtXV-FN7568YJ9K_ZzVecTgmbuw@mail.gmail.com>
In-Reply-To: <CAMuHMdUKk1kJwBndjiziRexOtXV-FN7568YJ9K_ZzVecTgmbuw@mail.gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/10/2014 15:39, Geert Uytterhoeven :
> On Tue, Oct 7, 2014 at 4:52 PM, Maxime Ripard
> <maxime.ripard@free-electrons.com> wrote:
>>>>> +These various types will also affect how the source and destination
>>>>> +addresses change over time, as DMA_SLAVE transfers will usually have
>>>>> +one of the addresses that will increment, while the other will not,
>>>>> +DMA_CYCLIC will have one address that will loop, while the other, will
>>>>
>>>> s/the other,/the other/
>>>>
>>>>> +not change, etc.
>>>
>>> This is a little bit vague in my opinion. And usually, it is pretty
>>> implementation specific.
>>
>> Which is why we can't really be more precise. If you have any other
>> wording coming to your mind, I'm all for it :)
> 
> Perhaps:
> 
> Addresses pointing to RAM are typically incremented (or decremented) after
> each transfer. In case of a ring buffer, they may loop (DMA_CYCLIC).
> Addresses pointing to a device's register (e.g. a FIFO) are typically fixed.

+1 ;-)

Bye,
-- 
Nicolas Ferre
