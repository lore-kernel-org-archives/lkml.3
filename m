Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754365Ab3FELUq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 07:20:46 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:53362 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752133Ab3FELUp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 07:20:45 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: Re: [PATCHv4] ARM: at91: Fix link breakage when !CONFIG_PHYLIB
Date: Wed, 5 Jun 2013 13:17:44 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        "Jean-Christophe Plagniol-Villard" <plagnioj@jcrosoft.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Ludovic Desroches <ludovic.desroches@atmel.com>
References: <1370425843-6802-1-git-send-email-alexandre.belloni@free-electrons.com>
In-Reply-To: <1370425843-6802-1-git-send-email-alexandre.belloni@free-electrons.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201306051317.44220.arnd@arndb.de>
X-Provags-ID: V02:K0:Pauo88PeOIn2viHpK5JaGjwCRYZKO43FctEnZV6SWsA
 Gz2udzV7az+w0UHKcmpnQ5/reVVYhUznIsp50Vxhpt1F50tXup
 0aXGEK1fIwgxa1p7Ssq/60GMp+L961RFI6N6Wu4ABod3C/iW+x
 ConGVA45qB16BG+wg+F/vuA+D5d0j5veUWjpHR83D8nwaR+m6h
 ftA5It87kgFKk2dheoHSU6f/P4+g0jv26MR+haUcC2xruRhLSC
 zbOkTVuv59kwR2FIY4qjU5BS+W9WmqeKWSWk9eLfsWxVKHqJsM
 fvHuoPDx8DmUA00v23P2K5M/fjsABv3Al7haH160WrIDg8++GL
 0hpcTLT7rqFIk/wj4rCk=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 05 June 2013, Alexandre Belloni wrote:
> Fixes:
> arch/arm/mach-at91/built-in.o: In function `ksz9021rn_phy_fixup':
> :(.text+0x1174): undefined reference to `mdiobus_write'
> :(.text+0x1188): undefined reference to `mdiobus_write'
> :(.text+0x119c): undefined reference to `mdiobus_write'
> :(.text+0x11b0): undefined reference to `mdiobus_write'
> arch/arm/mach-at91/built-in.o: In function `sama5_dt_device_init':
> :(.init.text+0x1e34): undefined reference to `phy_register_fixup_for_uid'
> 
> when CONFIG_PHYLIB is not selected.
> 
> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>

Acked-by: Arnd Bergmann <arnd@arndb.de>
