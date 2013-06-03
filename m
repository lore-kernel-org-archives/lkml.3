Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756248Ab3FCCIc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jun 2013 22:08:32 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:50343 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756689Ab3FCCIT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jun 2013 22:08:19 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>,
        Mike Turquette <mturquette@linaro.org>,
        Seungwon Jeon <tgih.jun@samsung.com>,
        Linus Walleij <linus.walleij@linaro.org>, linux-mmc@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Olof Johansson <olof@lixom.net>, John Stultz <john.stultz@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>, Chris Ball <cjb@laptop.org>,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: arm: add basic support for Rockchip Cortex-A9 SoCs
Date: Mon, 03 Jun 2013 04:07:37 +0200
Message-ID: <2754292.oXzDNzH2Zs@wuerfel>
User-Agent: KMail/4.10.2 (Linux/3.10.0-rc3-next-20130527+; KDE/4.10.3; x86_64; ; )
In-Reply-To: <201306030055.15413.heiko@sntech.de>
References: <201306030055.15413.heiko@sntech.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
X-Provags-ID: V02:K0:eMBDiTrsJfhp4L1Pm+ffnjC5KOjamMCQlOKl4rU0eCb
 4cHdUWaGZnQUrhK1dWeSVjf2VRX6zXZgRlmBcfjs03/WECoITv
 /RAZ/ctaQA4DB0AVhyVsm0oGP3majZuq5Hb/63PqtDMn4I/pZT
 aOkGPz4idXOTISmndHEZpH1VMhqKYfLIz1IXzIBmbRUL8gFdIx
 FE5ZfFhVgH5XZk1Rs0iR9TrXJxcNx5qZ4hQ8pCZfp70f7ahiN8
 Ec2GWYGGT+AJoISzGE2DVLvXNM5EDcAwQ530awLxpnSN6mGDBB
 kMbjdrHbXQeMyceZMSm/yGDL3JDZELmrUE0npMxw7jRzYFspsg
 5USyMMxhgVY/K0IYO2Rw=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 03 June 2013 00:55:15 Heiko Stübner wrote:
> Prepare your eggs and tomatoes please, I got myself a second playground  .
> 
> As the title implies this series adds basic support for Rockchip's Cortex-A9
> SoCs, like the RK3066 used in many cheaper tablets.
> 
> On the periphal side it's very lightweight, as it seems someone from Rockchip
> was shopping in the DesignWare store.
> 
> This makes the pinctrl driver the biggest hunk in the series, but to get some
> bonus points I used the generic_irq implementation for the interrupt handling,
> based on Thomas' irqdomain support series.
> 
> Supported periphals are, the timers, uarts and mmc controllers, so interested
> parties will need a serial console for now.
> 
> Hopefully I didn't mess up to much 

Great stuff! I have a few small comments for later, but I'm basically fine
with it going in as-is.

Needs review from the clk and pinctrl maintainers of course.

	Arnd
