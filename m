Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751267AbaLOWUP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 17:20:15 -0500
Received: from mail-pa0-f48.google.com ([209.85.220.48]:52665 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750822AbaLOWUN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 17:20:13 -0500
From: Kevin Hilman <khilman@kernel.org>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        <arm@kernel.org>, Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Ludovic Desroches <ludovic.desroches@atmel.com>
Subject: Re: [GIT PULL] at91: fixes for 3.19 #1
References: <1418377615-15122-1-git-send-email-nicolas.ferre@atmel.com>
Date: Mon, 15 Dec 2014 14:20:10 -0800
In-Reply-To: <1418377615-15122-1-git-send-email-nicolas.ferre@atmel.com>
	(Nicolas Ferre's message of "Fri, 12 Dec 2014 10:46:55 +0100")
Message-ID: <7hmw6oh7xh.fsf@deeprootsystems.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nicolas Ferre <nicolas.ferre@atmel.com> writes:

> Arnd, Olof, Kevin,
>
> I'm sending today a "fixes" branch which somehow continues the cleanup with
> only code removal. I was waiting for the arm-soc *and* pinctrl material to
> reach Linus T.'s tree before sending this pull-request. In fact this sequence
> was needed for the gpio header removal. The little patch about #include
> deletion just follows an earlier merge conflict in arm-soc tree: I was also
> waiting for this moment before sending the definitive fix, just to be sure.
>
> Otherwise, all is pretty straightforward.
>
> Oh, one more thing: it is based on the current Linus' git tree, I can obviously
> rebase everything on top of 3.19-rc1 once it is released if you prefer.

Yes, waiting a bit and basing on v3.19-rc1 is preferred since none of
this seems like urgent fixes needed for stuff introduced during the
merge window.

Thanks,

Kevin
