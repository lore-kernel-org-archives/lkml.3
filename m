Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751969Ab3LLVOd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 16:14:33 -0500
Received: from mail-oa0-f51.google.com ([209.85.219.51]:43116 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751602Ab3LLVO2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 16:14:28 -0500
MIME-Version: 1.0
In-Reply-To: <6277163.cTcj4OY5rk@avalon>
References: <1386421734-10240-1-git-send-email-alexandre.belloni@free-electrons.com>
	<CACRpkdbAmPxVdQ_hVQSQpgVu324Jg9D6FYj-OyfsorPP2zzdLw@mail.gmail.com>
	<52A9DB3C.7070107@free-electrons.com>
	<6277163.cTcj4OY5rk@avalon>
Date: Thu, 12 Dec 2013 22:14:27 +0100
Message-ID: <CACRpkdbP71CbMuuxQkL1hQ_TawmiFZr4-9Z5X3xanWdeC8URsA@mail.gmail.com>
Subject: Re: [PATCH 3/3] pinctrl: at91: implement at91_pinconf_dbg_show
From: Linus Walleij <linus.walleij@linaro.org>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 12, 2013 at 5:04 PM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> On Thursday 12 December 2013 16:50:20 Alexandre Belloni wrote:
>> On 12/12/2013 15:45, Linus Walleij wrote:
>> > On Sat, Dec 7, 2013 at 2:08 PM, Alexandre Belloni
>> >
>> > <alexandre.belloni@free-electrons.com> wrote:
>> >> This allows to get the pin configuration by using debugfs. On my system:
>> >>  # cat /sys/kernel/debug/pinctrl/pinctrl.3/pinconf-pins
>> >>
>> >> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
>> >
>> > This is a more invasive patch so I prefer if Laurent ACK this before
>> > I apply it.
>>
>> Hum, just to be clear, this is an Atmel chip and the Atmel maintainers
>> were already in copy. I believe Laurent already has a lot on his plate
>> with CDF ;)
>
> Not to mention the rest. I'd love to help with at91 pinctrl, but I think I
> have to draw the line somewhere. I hope it won't come as a shock that I can't
> review the whole kernel :-D

Sorry about this mess, forget about it, I don't know what is wrong
we me today, probably trying to process too many patches :-)

Yours,
Linus Walleij
