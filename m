Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754275Ab3FAHka (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jun 2013 03:40:30 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:60347 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751034Ab3FAHkW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jun 2013 03:40:22 -0400
MIME-Version: 1.0
X-Originating-IP: [2001:470:1f05:1640:2d44:e7c8:9123:6575]
In-Reply-To: <1370035039-17757-1-git-send-email-nicolas.ferre@atmel.com>
References: <1370035039-17757-1-git-send-email-nicolas.ferre@atmel.com>
Date: Sat, 1 Jun 2013 00:40:20 -0700
Message-ID: <CAOesGMgz6AnQr2TMEMJdxtYpcQ=Ye2ZsTRt3QPM+gckzE1iCHQ@mail.gmail.com>
Subject: Re: [GIT PULL] at91: Device Tree update for 3.11 #1
From: Olof Johansson <olof@lixom.net>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Arnd Bergmann <arnd@arndb.de>, "b.brezillon" <b.brezillon@overkiz.com>,
        Douglas Gilbert <dgilbert@interlog.com>, wenyou.yang@atmel.com,
        Richard Genoud <richard.genoud@gmail.com>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 31, 2013 at 2:17 PM, Nicolas Ferre <nicolas.ferre@atmel.com> wrote:
> Arnd, Olof,
>
> This is the pull-request for DT update on AT91. As said earlier, and like any
> other patches that will be produced for 3.11, it is based on material already
> included in arm-soc/at91/cleanup branch.
>
> A little conflict may appear while merging with already-sent pull-request for
> the USBA driver ([GIT PULL] at91: USBA DT support for 3.11). I have resolved
> the conflict and pushed the result branch as: at91-at91-3.11-driver-usba-dt+resolved
>
> Thanks, best regards,
>
> The following changes since commit b3f442b0eedbc20b5ce3f4a96530588d14901199:
>
>   ARM: at91: udpate defconfigs (2013-05-17 15:05:08 +0200)
>
> are available in the git repository at:
>
>   git://github.com/at91linux/linux-at91.git tags/at91-dt
>
> for you to fetch changes up to 028633c238f91dc113520a7ad25d37b2ba9068af:
>
>   ARM: at91/dt: add pinctrl definition for at91 tc blocks (2013-05-31 22:40:37 +0200)

Pulled, thanks.


-Olof
