Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753195Ab3FCHyz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 03:54:55 -0400
Received: from [95.129.55.99] ([95.129.55.99]:43294 "EHLO gloria.sntech.de"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752175Ab3FCHyj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 03:54:39 -0400
From: Heiko =?iso-8859-1?q?St=FCbner?= <heiko@sntech.de>
To: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 09/10] arm: add debug uarts for rockchip rk29xx and rk3xxx series
Date: Mon, 3 Jun 2013 09:54:10 +0200
User-Agent: KMail/1.13.7 (Linux/3.2.0-3-686-pae; KDE/4.8.4; i686; ; )
Cc: linux-arm-kernel@lists.infradead.org,
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
References: <201306030055.15413.heiko@sntech.de> <201306030101.04370.heiko@sntech.de> <19033743.NUXvdvXthR@wuerfel>
In-Reply-To: <19033743.NUXvdvXthR@wuerfel>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Message-Id: <201306030954.10891.heiko@sntech.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 3. Juni 2013, 04:08:37 schrieb Arnd Bergmann:
> On Monday 03 June 2013 01:01:03 Heiko Stübner wrote:
> > +#if defined(CONFIG_DEBUG_RK29_UART0)
> > +#define ROCKCHIP_UART_DEBUG_PHYS_BASE 0x20060000
> > +#define ROCKCHIP_UART_DEBUG_VIRT_BASE 0xfe060000
> 
> 0xfed60000 maybe? looks like a typo.

ha, correct ... thanks
