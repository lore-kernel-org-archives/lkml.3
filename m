Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758236Ab3FMQnt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 12:43:49 -0400
Received: from mail-lb0-f177.google.com ([209.85.217.177]:46319 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754633Ab3FMQnr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 12:43:47 -0400
MIME-Version: 1.0
In-Reply-To: <CACRpkdbGEA-GY8aU6Wh9stE00s7_+pzf2rnz3053hZEd8xm9Vg@mail.gmail.com>
References: <1371058399-31933-1-git-send-email-dianders@chromium.org>
	<1371058399-31933-2-git-send-email-dianders@chromium.org>
	<CACRpkdbGEA-GY8aU6Wh9stE00s7_+pzf2rnz3053hZEd8xm9Vg@mail.gmail.com>
Date: Thu, 13 Jun 2013 09:43:46 -0700
X-Google-Sender-Auth: xlvtCaFgQUexLSLRYgWlFiDeLEc
Message-ID: <CAD=FV=WTawJ_N08T-x9cMMxQqmnXvDEAYLmAJt0o=5bVhe2VHg@mail.gmail.com>
Subject: Re: [PATCH 2/3] pinctrl: exynos: reorder xyz_irq_unmask() so future
 patch can ack
From: Doug Anderson <dianders@chromium.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Kukjin Kim <kgene.kim@samsung.com>, Tomasz Figa <tomasz.figa@gmail.com>,
        Olof Johansson <olof@lixom.net>, Simon Glass <sjg@chromium.org>,
        Luigi Semenzato <semenzato@chromium.org>,
        Ilho Lee <ilho215.lee@samsung.com>, Eunki Kim <eunki_kim@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

On Thu, Jun 13, 2013 at 5:32 AM, Linus Walleij <linus.walleij@linaro.org> wrote:
> Patch applied with Tomasz and Kukjin's ACKs,
> I had to rebase it though, so please check the result
> on my "devel" branch when I push it out shortly
> (will be sent to linux-next as well).

It looks like you haven't pushed yet so I went ahead and sent a respin
of part 3 against the same base as before.  Hopefully it should apply
cleanly or at least be simple to rebase.

I'm happy to check the patches once I notice that they're live.

Thank you for applying!

-Doug
