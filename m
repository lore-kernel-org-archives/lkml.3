Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755224Ab3EMPxn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 11:53:43 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:43171 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755202Ab3EMPxl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 11:53:41 -0400
Message-ID: <51910C81.5050501@free-electrons.com>
Date: Mon, 13 May 2013 17:53:37 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130404 Thunderbird/17.0.5
MIME-Version: 1.0
To: Jason Cooper <jason@lakedaemon.net>, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>
CC: Michal Simek <michal.simek@xilinx.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Jamie Iles <jamie@jamieiles.com>, Simon Horman <horms@verge.net.au>,
        Magnus Damm <magnus.damm@gmail.com>,
        Christian Daudt <csd@broadcom.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        David Brown <davidb@codeaurora.org>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Shawn Guo <shawn.guo@linaro.org>, Barry Song <baohua.song@csr.com>,
        Tony Prisk <linux@prisktech.co.nz>,
        linux-arm-kernel@lists.infradead.org, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH 09/14] ARM: mvebu: Remove init_irq declaration in machine
 description
References: <1368438253-28218-1-git-send-email-maxime.ripard@free-electrons.com> <1368438253-28218-10-git-send-email-maxime.ripard@free-electrons.com> <20130513151934.GM31290@titan.lakedaemon.net>
In-Reply-To: <20130513151934.GM31290@titan.lakedaemon.net>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jason,

Le 13/05/2013 17:19, Jason Cooper a écrit :
> On Mon, May 13, 2013 at 11:44:08AM +0200, Maxime Ripard wrote:
>> Commit ebafed7a ("ARM: irq: Call irqchip_init if no init_irq function is
>> specified") removed the need to explictly setup the init_irq field in
>> the machine description when using only irqchip_init. Remove that
>> declaration for mvebu as well.
>>
>> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
>> ---
>>  arch/arm/mach-mvebu/armada-370-xp.c | 1 -
>>  1 file changed, 1 deletion(-)
> 
> Maxime,
> 
> Do do want the individual submaintainers to take these?  Or, send one
> branch to Arnd and Olof?  I'm fine with either one as any merge
> conflicts should be trivial.

I don't have a strong opinion on this one, I guess both will be fine.
Arnd, Olof, what do you prefer?

I'll probably have to send a v2 anyway, I forgot to remove the include
of the irqchip headers.

Maxime

-- 
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
