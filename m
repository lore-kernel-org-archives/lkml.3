Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756404AbaIWO4M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 10:56:12 -0400
Received: from mail-ig0-f173.google.com ([209.85.213.173]:35306 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932423AbaIWO4C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 10:56:02 -0400
MIME-Version: 1.0
In-Reply-To: <1410258381-7088-3-git-send-email-yamada.m@jp.panasonic.com>
References: <1410258381-7088-1-git-send-email-yamada.m@jp.panasonic.com>
	<1410258381-7088-3-git-send-email-yamada.m@jp.panasonic.com>
Date: Tue, 23 Sep 2014 16:56:01 +0200
Message-ID: <CACRpkdZxLrdvPPwrXgTn_oVntxz_f+GCdsdSbDZ0R0Mre6F_Dg@mail.gmail.com>
Subject: Re: [PATCH 2/3] kbuild: remove unnecessary variable initializaions
From: Linus Walleij <linus.walleij@linaro.org>
To: Masahiro Yamada <yamada.m@jp.panasonic.com>
Cc: linux-kbuild <linux-kbuild@vger.kernel.org>,
        Andrew Victor <linux@maxim.org.za>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Russell King <linux@arm.linux.org.uk>,
        Hartley Sweeten <hsweeten@visionengravers.com>,
        Ryan Mallon <rmallon@gmail.com>, Kukjin Kim <kgene.kim@samsung.com>,
        Greg Ungerer <gerg@uclinux.org>, Ben Dooks <ben-linux@fluff.org>,
        Tony Lindgren <tony@atomide.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Linux-OMAP <linux-omap@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 9, 2014 at 12:26 PM, Masahiro Yamada
<yamada.m@jp.panasonic.com> wrote:

> Clearing obj-y, obj-m, obj-n, obj- in each Makefile is
> a useless habit.
>
> They are non-exported variables; therefore they are always empty
> whenever descending into each subdirectory.
> (Moreorver, obj-y and obj-m are also set to empty at the beginning
> of scripts/Makefile.build)
>
> Signed-off-by: Masahiro Yamada <yamada.m@jp.panasonic.com>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
