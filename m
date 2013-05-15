Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932739Ab3EOM4V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 08:56:21 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:54574 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932490Ab3EOM4S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 08:56:18 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: Re: [PATCHv2 00/20] Cleanup irqchip_init calls
Date: Wed, 15 May 2013 14:55:12 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-18-generic; KDE/4.3.2; x86_64; ; )
Cc: Michal Simek <michal.simek@xilinx.com>,
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
References: <1368545933-7430-1-git-send-email-maxime.ripard@free-electrons.com>
In-Reply-To: <1368545933-7430-1-git-send-email-maxime.ripard@free-electrons.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201305151455.12603.arnd@arndb.de>
X-Provags-ID: V02:K0:1M8pVtCyS1Ttsim3v2yApgqauRFiFMPGn6QpZbXEeLk
 xt61n4EKRSdRbGaRrbQfjUuJWOG1MwmBYv/g+p2Lw9uy7ZqWkp
 LIIT+fCCz+ZkYI2dmjsAid573wq6mtEKO1o+Ez4emcWnGxY1rC
 /VcHMKpnr2mRvMidcud5kH3PwzBSleTJMd8ZYevIjCRx36cXdF
 znMGKAYO9b5+86IDPTcuQoqONQpik+16Bn6f2NpMJte1U2kFbh
 2iAgSm06ID9qIfrdHa4wFKsCqY/Zrh+J2a9Kz7W8jY8LrDq/rV
 zXpyoB6S7/GEvCpErx2vasaXEBkGGSW5LJfzwKPoRl0Y0c8uTg
 KweJ9rDrPacpJFPZae+g=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 14 May 2013, Maxime Ripard wrote:
> This is a splitted up version of the patch I previously sent to
> remove the explicit declaration of irqchip_init as the init_irq callback in
> the machine descriptions.
> 
> Since it was a pretty tricky patch to merge, since it was touching a lot of
> different platforms, I splitted it for each platforms, and rebased it on top
> of 3.10-rc1.
> 
> The best way to merge it is probably that each one of us take into their tree
> the patches that are relevant for our architecture and send them to arm-soc
> later on.

Sounds good to me. I'm sure that some platform maintainers will fail to
apply this though. Could you send whatever remains as a separate branch
in a couple of weeks so we can directly apply it to next/cleanup?

	Arnd
