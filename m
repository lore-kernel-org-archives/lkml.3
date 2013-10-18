Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756194Ab3JRPQN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 11:16:13 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:62037 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756154Ab3JRPQK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 11:16:10 -0400
From: Kevin Hilman <khilman@linaro.org>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        <arm@kernel.org>, Boris BREZILLON <b.brezillon@overkiz.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        <b.zolnierkie@samsung.com>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>
Subject: Re: [GIT PULL] at91: cleanup and preparation for the move to common clk #1
References: <1382105368-415-1-git-send-email-nicolas.ferre@atmel.com>
Date: Fri, 18 Oct 2013 08:16:07 -0700
In-Reply-To: <1382105368-415-1-git-send-email-nicolas.ferre@atmel.com>
	(Nicolas Ferre's message of "Fri, 18 Oct 2013 16:09:28 +0200")
Message-ID: <878uxqwqx4.fsf@linaro.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nicolas Ferre <nicolas.ferre@atmel.com> writes:

> Arnd, Olof, Kevin,
>
> This is the first AT91 pull-request for 3.13. I delayed the inclusion of
> material for AT91 as I wanted to build this "cleanup" series with the patches
> for moving AT91 to common clock framerowk. Now that the (big) series is nearly
> finished, I can send you the first patches that are targetted at preparing the
> landing...
>
> I plan to build another pull-request for the whole move to common clk framework
> early next week, if I manage to get the appropiate tags from Mike and the DT
> maintainers.
>
> The work that is beginning here is a big step toward AT91 integratin the
> multi-arch movement and removal of a bunch of code that bloats the mach-at91
> directory.
>
> Thanks, best regards,
>
> The following changes since commit 4a10c2ac2f368583138b774ca41fac4207911983:
>
>   Linux 3.12-rc2 (2013-09-23 15:41:09 -0700)
>
> are available in the git repository at:
>
>   git://github.com/at91linux/linux-at91.git tags/at91-cleanup
>
> for you to fetch changes up to 70e389cc7fedc4c279ef28e970658a39adc7dec7:
>
>   MAINTAINERS: Add patterns for DTS files for AT91 (2013-10-16 16:22:56 +0200)
>
> ----------------------------------------------------------------
> First cleanup series for 3.13
> - a little non-urgent fix
> - addition of DT files to MAINTAINERS
> - more important, the splitting of .dtsi files
>   that allows to precisely choose the peripherals
>   that are present for a particular SoC.
>   It is useful for upcoming move to common cloks.
>
> ----------------------------------------------------------------

Pulled into next/cleanup.

Thanks,

Kevin
