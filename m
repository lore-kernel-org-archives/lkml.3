Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755983Ab3LDVyv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 16:54:51 -0500
Received: from mail-qc0-f180.google.com ([209.85.216.180]:42429 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753809Ab3LDVyt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 16:54:49 -0500
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:1b02:6e3b:e5ff:fe16:f1aa]
In-Reply-To: <1386003701-29760-1-git-send-email-nicolas.ferre@atmel.com>
References: <1386003701-29760-1-git-send-email-nicolas.ferre@atmel.com>
Date: Wed, 4 Dec 2013 13:54:48 -0800
Message-ID: <CAOesGMjoK=fN-QCnRS1r2XQFrqc=KN_HPj5A=EVHL3ut58MvQA@mail.gmail.com>
Subject: Re: [GIT PULL] at91: cleanup for 3.14 #1 (aka move to CCF)
From: Olof Johansson <olof@lixom.net>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Arnd Bergmann <arnd@arndb.de>, "arm@kernel.org" <arm@kernel.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Boris BREZILLON <b.brezillon@overkiz.com>,
        Mike Turquette <mturquette@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 2, 2013 at 9:01 AM, Nicolas Ferre <nicolas.ferre@atmel.com> wrote:
> Arnd, Olof, Kevin,
>
> This is the big move of AT91 to Common Clock Framework for 3.14. I collected
> all the material as a "cleanup" topic so that the CCF can be considered as a
> base for all our AT91 patches for 3.14.
> I prefer to have the sama5d3 use of AT91 CCF included into this pull-request
> so that it can be read as an example and clearly states that it has been tested
> in real life.
> We agreed with Mike to send this work upstream through arm-soc so that we will
> be able to stack other patches for 3.14 on top of that work without having to
> deal with conflicts.
>
> For merging with the "fixes" pull-request that I sent earlier today, I also
> uploaded a little branch for reference:
> at91-3.14-next_fixes_cleanup_dt-resolution.
> In two words, the clock section of the arch/arm/mach-at91/sama5d3.c file
> has to be deleted.
>
> Do not hesitate to ask questions about this material.
>
> Thanks, best regards,
>
> The following changes since commit 6ce4eac1f600b34f2f7f58f9cd8f0503d79e42ae:
>
>   Linux 3.13-rc1 (2013-11-22 11:30:55 -0800)
>
> are available in the git repository at:
>
>   git://github.com/at91linux/linux-at91.git tags/at91-cleanup
>
> for you to fetch changes up to b46e837d8ef1f3c777bbf9513e2cdb5d87d6c374:
>
>   ARM: at91/dt: remove old clk material (2013-12-02 15:31:29 +0100)

Thanks, pulled into next/cleanup. use this branch as base for your
future at91 branches if you need it to avoid conflicts, please.

(I named it at91/sama5-ccf in our tree)


Olof
