Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754171Ab3HVSj3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 14:39:29 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:40705 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754152Ab3HVSj0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 14:39:26 -0400
From: Kevin Hilman <khilman@linaro.org>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        <arm@kernel.org>, Richard Genoud <richard.genoud@gmail.com>,
        <alexandre.belloni@free-electrons.com>, Bo Shen <voice.shen@atmel.com>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>
Subject: Re: [GIT PULL] at91: device tree update for 3.12 #1
References: <1377097510-14090-1-git-send-email-nicolas.ferre@atmel.com>
Date: Thu, 22 Aug 2013 11:39:21 -0700
In-Reply-To: <1377097510-14090-1-git-send-email-nicolas.ferre@atmel.com>
	(Nicolas Ferre's message of "Wed, 21 Aug 2013 17:05:10 +0200")
Message-ID: <87txihr2na.fsf@linaro.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nicolas Ferre <nicolas.ferre@atmel.com> writes:

> Arnd, Olof, Kevin,
>
> Here is the first pull request about DT on AT91 for 3.12.
> It is based on 3.11-rc5 as I saw that the branch is coming from this tag on
> your side.
>
> Thanks, best regards,
>
> The following changes since commit d4e4ab86bcba5a72779c43dc1459f71fea3d89c8:
>
>   Linux 3.11-rc5 (2013-08-11 18:04:20 -0700)
>
> are available in the git repository at:
>
>   git://github.com/at91linux/linux-at91.git tags/at91-dt
>
> for you to fetch changes up to 90d01929ad38259596371c78df8a9ecf37a7f815:
>
>   ARM: at91/dt: sam9x5ek: add sound configuration (2013-08-21 13:33:44 +0200)
>
> ----------------------------------------------------------------
> More DT work on AT91:
> - sound support for at91sam9x5 family
> - at91sam9n12: touch button, i2c and gpio-keys
> - adding missing pinctrl-names to MCI on at91rm9200 and at91sam9260/9g20
> - adding ARM Performance Monitor Unit (PMU) on sama5d3

Pulled into next/dt.

Kevin
