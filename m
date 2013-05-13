Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751648Ab3EMRJF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 13:09:05 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:42817 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751067Ab3EMRJD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 13:09:03 -0400
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:1b02:6e3b:e5ff:fe16:c028]
In-Reply-To: <51910C81.5050501@free-electrons.com>
References: <1368438253-28218-1-git-send-email-maxime.ripard@free-electrons.com>
	<1368438253-28218-10-git-send-email-maxime.ripard@free-electrons.com>
	<20130513151934.GM31290@titan.lakedaemon.net>
	<51910C81.5050501@free-electrons.com>
Date: Mon, 13 May 2013 10:09:00 -0700
Message-ID: <CAOesGMgD6j9BE-kVe1rJjNFRtoV=e08B=o9hyhk1xfKLjsRF2g@mail.gmail.com>
Subject: Re: [PATCH 09/14] ARM: mvebu: Remove init_irq declaration in machine description
From: Olof Johansson <olof@lixom.net>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Jason Cooper <jason@lakedaemon.net>, Arnd Bergmann <arnd@arndb.de>,
        Michal Simek <michal.simek@xilinx.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Jamie Iles <jamie@jamieiles.com>, Simon Horman <horms@verge.net.au>,
        Magnus Damm <magnus.damm@gmail.com>,
        Christian Daudt <csd@broadcom.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        David Brown <davidb@codeaurora.org>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Shawn Guo <shawn.guo@linaro.org>, Barry Song <baohua.song@csr.com>,
        Tony Prisk <linux@prisktech.co.nz>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 13, 2013 at 8:53 AM, Maxime Ripard
<maxime.ripard@free-electrons.com> wrote:
> Hi Jason,
>
> Le 13/05/2013 17:19, Jason Cooper a écrit :
>> On Mon, May 13, 2013 at 11:44:08AM +0200, Maxime Ripard wrote:
>>> Commit ebafed7a ("ARM: irq: Call irqchip_init if no init_irq function is
>>> specified") removed the need to explictly setup the init_irq field in
>>> the machine description when using only irqchip_init. Remove that
>>> declaration for mvebu as well.
>>>
>>> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
>>> ---
>>>  arch/arm/mach-mvebu/armada-370-xp.c | 1 -
>>>  1 file changed, 1 deletion(-)
>>
>> Maxime,
>>
>> Do do want the individual submaintainers to take these?  Or, send one
>> branch to Arnd and Olof?  I'm fine with either one as any merge
>> conflicts should be trivial.
>
> I don't have a strong opinion on this one, I guess both will be fine.
> Arnd, Olof, what do you prefer?
>
> I'll probably have to send a v2 anyway, I forgot to remove the include
> of the irqchip headers.

Since each and every patch applies cleanly and things work well both
before and after, let's have each maintainer that is active apply
their own. If there are platforms that don't have a significant number
of patches, i.e. if they're not collecting a branch, then we can apply
those. Please follow up with us with the stragglers, I'll assume the
rest will come in through the respective maintainers.


-Olof
