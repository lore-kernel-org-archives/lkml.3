Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753793Ab3EOWlF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 18:41:05 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:64081 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752982Ab3EOWlD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 18:41:03 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: Re: [PATCH 0/4] ARM: Remove boilerplate debug_ll_io_init code
Date: Thu, 16 May 2013 00:40:54 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-18-generic; KDE/4.3.2; x86_64; ; )
Cc: Rob Herring <robherring2@gmail.com>, Shawn Guo <shawn.guo@linaro.org>,
        Olof Johansson <olof@lixom.net>, Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <1368440169-29088-1-git-send-email-maxime.ripard@free-electrons.com>
In-Reply-To: <1368440169-29088-1-git-send-email-maxime.ripard@free-electrons.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201305160040.54399.arnd@arndb.de>
X-Provags-ID: V02:K0:yWO5N7GgnSE0St6IEAKiYzDtJ2TREre3hz9hjyR/8Wt
 UK7WH7bbKIVkw34anrZwoS/lB97TC9qrgeliU1AA8mHheVN+ZV
 CNlrj2JRfCPAt9avzTCRfcIS0frVxTnEEsDTw7UChrmq6yZlE9
 nwDWf2f+OFNVckqoVAPJ6QZYbuOVKDBNQvKaTx1t3R3ZwyhIyT
 SloABkoF84AgDhcVvT1T8wHvBX0GcYRqpzMWlI3NLg5+VviABi
 toWoo0M5ZtwiH+RCj89oCUrNkKEMteyf2cfMRHpgq+W9n3lqoq
 Udia/5YBch3r+jh+qwglG+K9L5WLIvv21Ryya/w+HcYunloeqn
 BUlJnDSEFnSE9O4PCvSQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 13 May 2013, Maxime Ripard wrote:
> The recent introduction of debug_ll_io_init made possible to not rely
> anymore on a custom map_io function but on debug_ll_io_init for the
> early mapping and then on the various drivers to do the needed mappings for
> the kernel to boot.
> 
> Some architectures begin to use only this function as the map_io callback in
> the machine description.
> 
> In order to remove some boilerplate code, make the ARM mm code call
> debug_ll_io_init by itself when no .map_io callback is defined.
> 
> This has been tested on the sunxi platform.

Great stuff!

I didn't notice the addition of debug_ll_io_init, so this is a nice surprise
for me.

Acked-by: Arnd Bergmann <arnd@arndb.de>
