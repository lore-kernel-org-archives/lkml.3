Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932505AbaLDQ22 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 11:28:28 -0500
Received: from mout.kundenserver.de ([212.227.17.10]:54259 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932236AbaLDQ20 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 11:28:26 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Olof Johansson <olof@lixom.net>, arm@kernel.org,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>
Subject: Re: [GIT PULL] at91: defconfig for 3.19 #1
Date: Thu, 04 Dec 2014 17:28:19 +0100
Message-ID: <3905790.gg6cCb9BU6@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1417537711-15608-1-git-send-email-nicolas.ferre@atmel.com>
References: <1417537711-15608-1-git-send-email-nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:eQbpL0csvL6LIoums0KE/l/No9+J+gea+5sd8KAeVs4GHaE6dXY
 /S6knI3Rw2LtOwb4OfkbEAYeToMppZ+63aBrLzRtBFRd+NIEBimdoicHFD/5o43ASlDkI59
 xGqIGVhD3mRH4mYMb6x1XRwj8Qr9wh4reOyWwYM99XvdNT+yE+oiQcUXftLtC4hXEow+lPV
 D988DgEgO6eefoMUjWGzg==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 02 December 2014 17:28:31 Nicolas Ferre wrote:
> 
> The following changes since commit 0df1f2487d2f0d04703f142813d53615d62a1da4:
> 
>   Linux 3.18-rc3 (2014-11-02 15:01:51 -0800)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/nferre/linux-at91.git tags/at91-defconfig
> 
> for you to fetch changes up to 4cd275f762a21cf21768e327873ba2883c839281:
> 
>   ARM: at91/defconfig: add DM9000 to at91_dt (2014-12-01 16:30:00 +0100)
> 
> ----------------------------------------------------------------
> First batch of defconfigs for AT91 / 3.19:
> - use NEON for all C-A5, neon code handles the !NEON case
> - add new XDMA driver
> - add some useful drivers as we only have a single defconfig for all
>   AT91SAM9/RM9200

I just noticed that this is based on -rc3, while the next/defconfig branch
so far is based on -rc1. If you don't mind, could you rebase your
branch on -rc1 as well and send it again so I can avoid the backmerge?

Thanks,

	Arnd
