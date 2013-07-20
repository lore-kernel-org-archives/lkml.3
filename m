Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754608Ab3GTQuQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jul 2013 12:50:16 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:52024 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754438Ab3GTQuO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jul 2013 12:50:14 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: Re: [PATCH] arm: choose debug/uncompress.h include when uncompress debug is disabledo
Date: Sat, 20 Jul 2013 18:50:07 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
        Julien Grall <julien.grall@linaro.org>,
        Ian Campbell <Ian.Campbell@citrix.com>, patches@linaro.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Olof Johansson <olof@lixom.net>
References: <1373897706-15331-1-git-send-email-julien.grall@linaro.org> <20130718165007.GA24642@n2100.arm.linux.org.uk> <alpine.DEB.2.02.1307181755371.8258@kaball.uk.xensource.com>
In-Reply-To: <alpine.DEB.2.02.1307181755371.8258@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201307201850.07406.arnd@arndb.de>
X-Provags-ID: V02:K0:RP5PrC7qOJ0IO1YwJ7xOAguEMwSMgYEvrxWeFz/GHqL
 bpRi7xEokLFFI7OTGD2zsfwNsas2goFM3BbQliNeHiUXtTA/7x
 d8rVPeicBg8ch09w5dZu4SVN/wxT2ApZnUeORw1c4lmjA+HNl1
 c3mnJNqBpNiOH4KaddJ6NJy2UqAoq7292EIxErUBYJH+nHxS0z
 GF2d/lo6pwv0yv5PR4ZPdnGExxWwyAJMF4ILgPZhA6f8auFZMS
 eiSsndRU1pEW1sS1pU5We358cuxyRo/BE+wgaI6rt/KhHVkbYl
 K2lckx2LZypRCi91vurufJjKLlWYWma/iRo/BNjv8FhJur5715
 RLjTCCdQJcWEKMirsnzs=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 18 July 2013, Stefano Stabellini wrote:
> > Lastly, aren't all ARMv7 kernels (therefore Xen supporting kernels)
> > supposed to be part of the multiplatform kernel stuff now?
> 
> Most of them, yes. However some of them, like exynos5250, are not yet.

It's just a matter of time. I had a patch for 3.10 to enable multiplatform
on exynos, but it missed both the 3.10 and 3.11 merge windows by a small
margin (for different reasons). We definitely want all ARMv7 platforms
to be multiplatform in the not too distant future.

	Arnd
