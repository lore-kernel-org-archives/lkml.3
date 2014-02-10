Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752856AbaBJSkK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 13:40:10 -0500
Received: from mail-pd0-f178.google.com ([209.85.192.178]:63919 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751807AbaBJSkH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 13:40:07 -0500
From: Kevin Hilman <khilman@linaro.org>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        <arm@kernel.org>, Boris BREZILLON <b.brezillon@overkiz.com>,
        <jjhiblot@traphandler.com>, Bo Shen <voice.shen@atmel.com>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>
Subject: Re: [GIT PULL] at91: fixes for 3.14 #1
References: <1391790986-31936-1-git-send-email-nicolas.ferre@atmel.com>
Date: Mon, 10 Feb 2014 10:40:04 -0800
In-Reply-To: <1391790986-31936-1-git-send-email-nicolas.ferre@atmel.com>
	(Nicolas Ferre's message of "Fri, 7 Feb 2014 17:36:26 +0100")
Message-ID: <7hha8695h7.fsf@paris.lan>
User-Agent: Gnus/5.130008 (Ma Gnus v0.8) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nicolas Ferre <nicolas.ferre@atmel.com> writes:

> Arnd, Olof, Kevin,
>
> This is a first "fixes" series for AT91 on 3.14.
> The content is only DT-related and quite boring.
> I took the opportunity of this early "fixes" pull-request to collect
> some Documentation patches that were lying around and I guess that
> they can be merged by arm-soc nicely (addition of CCF to 2 drivers).
> A new board is added to the lot because it is dead simple and integrates
> well with the new sama5d36 SoC that we added earlier in this development cycle.
>
> Thanks, best regards,
>
> The following changes since commit 38dbfb59d1175ef458d006556061adeaa8751b72:
>
>   Linus 3.14-rc1 (2014-02-02 16:42:13 -0800)
>
> are available in the git repository at:
>
>   git://github.com/at91linux/linux-at91.git tags/at91-fixes
>
> for you to fetch changes up to b7c2b6157079811586180d13c44a1095b57c2d47:
>
>   ARM: at91: add Atmel's SAMA5D3 Xplained board (2014-02-07 17:20:39 +0100)
>
> ----------------------------------------------------------------
> First series of AT91 fixes for 3.14.
> All of them are DT-related.
> - fixes for typos in i2c and ohci clocks
> - addition of a USB host node for at91sam9n12ek
> - 2 DT documentation updates that have been sent a long time ago
> - a new board based on the sama5d36 SoC
>
> ----------------------------------------------------------------

Pulled into fixes,

Thanks,

Kevin
