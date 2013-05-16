Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756345Ab3EPIS1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 04:18:27 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:57901 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755310Ab3EPISX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 04:18:23 -0400
Message-ID: <51949646.4000107@free-electrons.com>
Date: Thu, 16 May 2013 10:18:14 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130404 Thunderbird/17.0.5
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Michal Simek <michal.simek@xilinx.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Jamie Iles <jamie@jamieiles.com>, Simon Horman <horms@verge.net.au>,
        Magnus Damm <magnus.damm@gmail.com>,
        Christian Daudt <csd@broadcom.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        David Brown <davidb@codeaurora.org>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Shawn Guo <shawn.guo@linaro.org>, Barry Song <baohua.song@csr.com>,
        Tony Prisk <linux@prisktech.co.nz>,
        linux-arm-kernel@lists.infradead.org, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Olof Johansson <olof@lixom.net>
Subject: Re: [PATCHv2 00/20] Cleanup irqchip_init calls
References: <1368545933-7430-1-git-send-email-maxime.ripard@free-electrons.com> <201305151455.12603.arnd@arndb.de>
In-Reply-To: <201305151455.12603.arnd@arndb.de>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

Le 15/05/2013 14:55, Arnd Bergmann a écrit :
> On Tuesday 14 May 2013, Maxime Ripard wrote:
>> This is a splitted up version of the patch I previously sent to
>> remove the explicit declaration of irqchip_init as the init_irq callback in
>> the machine descriptions.
>>
>> Since it was a pretty tricky patch to merge, since it was touching a lot of
>> different platforms, I splitted it for each platforms, and rebased it on top
>> of 3.10-rc1.
>>
>> The best way to merge it is probably that each one of us take into their tree
>> the patches that are relevant for our architecture and send them to arm-soc
>> later on.
> 
> Sounds good to me. I'm sure that some platform maintainers will fail to
> apply this though. Could you send whatever remains as a separate branch
> in a couple of weeks so we can directly apply it to next/cleanup?

Ok, I will.

Thanks,
Maxime

-- 
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
