Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753669Ab3CNXDv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 19:03:51 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:51133 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753268Ab3CNXDt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 19:03:49 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: Re: [PATCH 0/5] at91: atmel_lcdfb: regression fixes and cpu_is removal
Date: Thu, 14 Mar 2013 23:03:42 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-8-generic; KDE/4.3.2; x86_64; ; )
Cc: Johan Hovold <jhovold@gmail.com>, Olof Johansson <olof@lixom.net>,
        FlorianSchandinat@gmx.de,
        "Jean-Christophe PLAGNIOL-VILLARD" <plagnioj@jcrosoft.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-fbdev@vger.kernel.org, jacmet@sunsite.dk
References: <cover.1360340791.git.nicolas.ferre@atmel.com> <5139B169.7050807@atmel.com> <51405126.3090009@atmel.com>
In-Reply-To: <51405126.3090009@atmel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201303142303.42283.arnd@arndb.de>
X-Provags-ID: V02:K0:7M89Opq5mmkzvKfKzNyYaBjN5OvseRbgXkiCuzRvQr0
 NU2CmbtndbFeGBxRn7CaxgCGHruNAdzEjW18Amcccg9JncsvVP
 QY9nU/vppKTLpUObLuOL+DD1z8LGDGZC0ARJq7wV1V3/TrLHLq
 2Lz2Z+sY7FZIfCZg0YrmmmjaI44JfC0Yec/WI9S+Cva7u/idgQ
 bBYAUHocQo+uS89NoFV/2JSy/23Vv50hm40Jxod1HY3b43BLCs
 SJO9O1XJ0pTbCkYF6MNFI2cG9FpmMdbdtO2/BHt0Ut1a4A5eVo
 AChL3JApLF6FX2a3ynbv1StNnX13gAW82ZMjAhgeNpgxHrsTSp
 mXLR7u4piktAU1pSuRiA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 13 March 2013, Nicolas Ferre wrote:
> In case we end-up with an agreement on the path those fixes should
> follow, here is the location of my updated material rebased on top of 3.9-rc2:
> 
> The following changes since commit f6161aa153581da4a3867a2d1a7caf4be19b6ec9:
> 
>   Linux 3.9-rc2 (2013-03-10 16:54:19 -0700)
> 
> are available in the git repository at:
> 
>   git://github.com/at91linux/linux-at91.git at91-3.9-fixesLCD
> 
> for you to fetch changes up to bbd44f6bd9d1aa735b180b29b5719d63a8e87b55:
> 
>   ARM: at91/avr32/atmel_lcdfb: add platform device-id table (2013-03-13 11:05:12 +0100)
> 
> ----------------------------------------------------------------
> Johan Hovold (5):
>       atmel_lcdfb: fix 16-bpp modes on older SOCs
>       ARM: at91: fix LCD-wiring mode
>       ARM: at91/avr32/atmel_lcdfb: add bus-clock entry
>       atmel_lcdfb: move lcdcon2 register access to compute_hozval
>       ARM: at91/avr32/atmel_lcdfb: add platform device-id table
> 

I have merged the first two patches into the fixes branch now, from up to commit
67cf9c0a. Please resubmit the remaining ones on top of this commit for 3.10, either
through arm-soc or through the framebuffer tree.

	Arnd
