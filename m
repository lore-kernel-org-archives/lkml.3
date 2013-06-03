Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756788Ab3FCCIw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jun 2013 22:08:52 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:64312 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755363Ab3FCCIq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jun 2013 22:08:46 -0400
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
Subject: Re: [PATCH 09/10] arm: add debug uarts for rockchip rk29xx and rk3xxx series
Date: Mon, 03 Jun 2013 04:08:37 +0200
Message-ID: <19033743.NUXvdvXthR@wuerfel>
User-Agent: KMail/4.10.2 (Linux/3.10.0-rc3-next-20130527+; KDE/4.10.3; x86_64; ; )
In-Reply-To: <201306030101.04370.heiko@sntech.de>
References: <201306030055.15413.heiko@sntech.de> <201306030101.04370.heiko@sntech.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
X-Provags-ID: V02:K0:dmAT3I9Z8J4Uf2gi78oG5bi0lspG95xQlwrKAyNZD+L
 3w/WajiAYX+7Co+LXeuG7EHV/fJBM+90SgPChjDd0yX5l4zFij
 LK08ZtBtHF8GFHzPtmMPujqn6V4OGA70nHhxdde7S7dOJ82gJh
 Vcop6i8DS+UgFb19leL8Tl352h/S2zgtkOzs85ZjlE+JTyd+HZ
 nFWJi97ELNr83k/wSlllgRU72tJjqrQXi0t7TbIUBZsGQwbcJL
 qwEMLlEc43MMIKEiQD7ac89+NhGd/by3sW7F4MFpcutxfnROK5
 ZLP3XGyai2dMktCmM/mHO07efKRd19MLLqT+LuPlTFABCmzqJF
 Jnm6MR1jL3iY/fLl1Mtk=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 03 June 2013 01:01:03 Heiko Stübner wrote:
> +#if defined(CONFIG_DEBUG_RK29_UART0)
> +#define ROCKCHIP_UART_DEBUG_PHYS_BASE 0x20060000
> +#define ROCKCHIP_UART_DEBUG_VIRT_BASE 0xfe060000

0xfed60000 maybe? looks like a typo.

	Arnd

