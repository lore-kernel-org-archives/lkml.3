Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932536AbaLAQJt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 11:09:49 -0500
Received: from mout.kundenserver.de ([212.227.126.187]:63651 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932205AbaLAQJr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 11:09:47 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Paul Bolle <pebolle@tiscali.nl>, Nicolas Ferre <nicolas.ferre@atmel.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        linux-kernel@vger.kernel.org,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Valentin Rothberg <valentinrothberg@gmail.com>
Subject: Re: [PATCH 3/4] ARM: at91: remove at91sam9260/at91sam9g20 legacy board support
Date: Mon, 01 Dec 2014 17:09:39 +0100
Message-ID: <5538141.cVWd2O2c59@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1417434919.30245.31.camel@x220>
References: <cover.1416392687.git.nicolas.ferre@atmel.com> <4ea21d8c3309cde82c88eb6624cf2aaf08cb8bca.1416392687.git.nicolas.ferre@atmel.com> <1417434919.30245.31.camel@x220>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:zgW+Qjlgkou9Vz7WbpTeZ/MDBQF/7EBNdpgQ1sdifu8
 UxQ48dSRi2uLHgPNdiYmr29Ww7cDMPZEOZ+W6Uylfxfwxlva4E
 sUx5cbr94zGp7/1GYwTySjse8RVvX0vMMcALOv8txYhDY1sxGo
 vvO3v0JMmR8ciBfUYyTZs1gRy/E4Fe5f15SEz3f6ACFDU8Ykse
 8o3VbL4udNG49kDK13CbukAP0pFFt/0hD9HVBVdpl7YAPjs738
 oE2dfWI80TjtjDMqEJ+thXplgjVQmezzoZh7/xN6T2oy2PLd1Y
 p1Ba6q7LSdCBh3Wnf3zEPGKkGa3+EhtLT4Yp/IkvoCr0Jo7zvO
 gcsrC7+eKqVcUQJEIOSY=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 01 December 2014 12:55:19 Paul Bolle wrote:
> 
> There might be a problem with this patch. Or maybe it only needs some
> follow up cleanup. I noticed that when it landed in today's linux-next
> (ie, next-20141201) as commit b2026f708e09 ("ARM: at91: remove
> at91sam9260/at91sam9g20 legacy board support").

Good catch!

> The Kconfig symbol SND_AT91_SOC_AFEB9260 (see sound/soc/atmel/Kconfig)
> still depends on MACH_AFEB9260. So it can't be set anymore. Is that
> Kconfig symbol still needed or should it be removed too? Maybe a patch
> that fixes that is queued somewhere already.

I already found some other code that is now unused. I would guess that
this is in the same category, but the maintainers should comment if
they know better.

	Arnd
