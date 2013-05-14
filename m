Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756620Ab3ENIXb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 04:23:31 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:46226 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751914Ab3ENIXZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 04:23:25 -0400
Message-ID: <5191F478.4040800@free-electrons.com>
Date: Tue, 14 May 2013 10:23:20 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130404 Thunderbird/17.0.5
MIME-Version: 1.0
To: Simon Horman <horms@verge.net.au>
CC: Michal Simek <michal.simek@xilinx.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Jamie Iles <jamie@jamieiles.com>, Magnus Damm <magnus.damm@gmail.com>,
        Christian Daudt <csd@broadcom.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        David Brown <davidb@codeaurora.org>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Shawn Guo <shawn.guo@linaro.org>, Barry Song <baohua.song@csr.com>,
        Tony Prisk <linux@prisktech.co.nz>,
        linux-arm-kernel@lists.infradead.org, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>
Subject: Re: [PATCH 05/14] ARM: shmobile: Remove init_irq declaration in machine
 description
References: <1368438253-28218-1-git-send-email-maxime.ripard@free-electrons.com> <1368438253-28218-6-git-send-email-maxime.ripard@free-electrons.com> <20130514003504.GE12228@verge.net.au>
In-Reply-To: <20130514003504.GE12228@verge.net.au>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Simon,

Le 14/05/2013 02:35, Simon Horman a écrit :
> On Mon, May 13, 2013 at 11:44:04AM +0200, Maxime Ripard wrote:
>> Commit ebafed7a ("ARM: irq: Call irqchip_init if no init_irq function is
>> specified") removed the need to explictly setup the init_irq field in
>> the machine description when using only irqchip_init. Remove that
>> declaration for shmobile as well.
> 
> Hi Maxime,
> 
> If possible, I would prefer separate patches for each board and SoC.

Ok, I'll split this and send it in the v2.

Thanks,
Maxime

-- 
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
