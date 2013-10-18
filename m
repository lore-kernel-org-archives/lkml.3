Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756040Ab3JRPXp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 11:23:45 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:33197 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755764Ab3JRPXo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 11:23:44 -0400
From: Kevin Hilman <khilman@linaro.org>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        <arm@kernel.org>, Bo Shen <voice.shen@atmel.com>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>
Subject: Re: [GIT PULL] at91: dt for 3.13 #1
References: <1382108324-9080-1-git-send-email-nicolas.ferre@atmel.com>
Date: Fri, 18 Oct 2013 08:23:41 -0700
In-Reply-To: <1382108324-9080-1-git-send-email-nicolas.ferre@atmel.com>
	(Nicolas Ferre's message of "Fri, 18 Oct 2013 16:58:44 +0200")
Message-ID: <874n8ewqki.fsf@linaro.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nicolas Ferre <nicolas.ferre@atmel.com> writes:

> Arnd, Olof, Kevin,
>
> First AT91 DT-related pull-request for 3.13. These patches will not mess with my other
> "cleanup" pull-request sent today.
> It allows to enable sound on the at91sam9n12ek board.
>
> Thanks, best regards,
>
> The following changes since commit 4a10c2ac2f368583138b774ca41fac4207911983:
>
>   Linux 3.12-rc2 (2013-09-23 15:41:09 -0700)
>
> are available in the git repository at:
>
>   git://github.com/at91linux/linux-at91.git tags/at91-dt
>
> for you to fetch changes up to e483341ce82750a1b526b65b7178213dcf967a7a:
>
>   ARM: at91: remove pinctrl conflict between mmc and SPI for at91sam9g20ek (2013-10-18 16:50:13 +0200)
>
> ----------------------------------------------------------------
> First DT series for 3.13
> - addition of sound for at91sam9n12
> - a little fix for MMC vs. SPI on at91sam9g20ek
>
> ----------------------------------------------------------------

Pulled into next/dt.

Thanks,

Kevin
