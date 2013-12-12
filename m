Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751595Ab3LLPuZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 10:50:25 -0500
Received: from top.free-electrons.com ([176.31.233.9]:55459 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751474Ab3LLPuW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 10:50:22 -0500
Message-ID: <52A9DB3C.7070107@free-electrons.com>
Date: Thu, 12 Dec 2013 16:50:20 +0100
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Organization: Free Electrons
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 3/3] pinctrl: at91: implement at91_pinconf_dbg_show
References: <1386421734-10240-1-git-send-email-alexandre.belloni@free-electrons.com>	<1386421734-10240-3-git-send-email-alexandre.belloni@free-electrons.com> <CACRpkdbAmPxVdQ_hVQSQpgVu324Jg9D6FYj-OyfsorPP2zzdLw@mail.gmail.com>
In-Reply-To: <CACRpkdbAmPxVdQ_hVQSQpgVu324Jg9D6FYj-OyfsorPP2zzdLw@mail.gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/12/2013 15:45, Linus Walleij wrote:
> On Sat, Dec 7, 2013 at 2:08 PM, Alexandre Belloni
> <alexandre.belloni@free-electrons.com> wrote:
>
>> This allows to get the pin configuration by using debugfs. On my system:
>>  # cat /sys/kernel/debug/pinctrl/pinctrl.3/pinconf-pins
>>
>> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
> This is a more invasive patch so I prefer if Laurent ACK this before
> I apply it.

Hum, just to be clear, this is an Atmel chip and the Atmel maintainers
were already in copy. I believe Laurent already has a lot on his plate
with CDF ;)


-- 
Alexandre Belloni, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

