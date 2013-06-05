Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754556Ab3FELVX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 07:21:23 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:52064 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752978Ab3FELVW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 07:21:22 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: Re: [PATCHv2 1/3] net: phy: prevent linking breakage
Date: Wed, 5 Jun 2013 13:21:00 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Florian Fainelli <florian@openwrt.org>,
        linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel <kernel@pengutronix.de>,
        "shawn.guo" <shawn.guo@linaro.org>, David Miller <davem@davemloft.net>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
References: <1369741403-25315-2-git-send-email-alexandre.belloni@free-electrons.com> <CAGVrzcZcVB5+NqLop+ALrX4Jx_SyNatczLt4oNzXr7bjgKMXhg@mail.gmail.com> <51AF03AF.3080106@free-electrons.com>
In-Reply-To: <51AF03AF.3080106@free-electrons.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201306051321.00264.arnd@arndb.de>
X-Provags-ID: V02:K0:jElz1htTD5pBAx5KxUZj8noMf8YDij+rK+xvsgNXHdy
 iNWSjVg5f4q9tFMqZWv4bINOk4FMZa9h4HYpAUDbnL0uskuNQu
 yJbJyucYpX58NopH3I15rlZqO9LwKQiganQRUXgLZEln1r11Rw
 SONYrH8NOrIJnwQlxow4NL9C8rl9iYq+acTiZPzF8zwTx3jyYL
 1wdd6NBjjjo/HhQPC/c5RE5475CykU172w28/rbwGDCQhl9zDO
 Z3TJ3MXdciUrcoE/U87zA1Y7zCL5JSxjZzf2tngkXXT2dstDYn
 eJtkuedg/vXXAxmgTRZADB+Y1k5XBD3mYISIvKmP5KRye9Mvtn
 4gncEJP+Dlp1rVwPVY3M=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 05 June 2013, Alexandre Belloni wrote:
> However, it is becoming urgent for Atmel to get the fix in 3.10 so that
> they never get a kernel compilation that breaks.

I don't think it's urgent since this is only about rare configurations,
and not a regression. We can queue the patch "ARM: at91: Fix link
breakage when !CONFIG_PHYLIB" you just sent to fix this, but I
would not consider it a serious problem to have it only in 3.11.

	Arnd
