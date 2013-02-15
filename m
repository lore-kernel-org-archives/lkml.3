Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754803Ab3BOMIv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 07:08:51 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:59964 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750767Ab3BOMIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 07:08:50 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Mike Turquette <mturquette@linaro.org>
Subject: Re: [PATCH 3/9] clk: sunxi: remove stale Makefile entry
Date: Fri, 15 Feb 2013 12:08:41 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-5-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Maxime Ripard <maxime.ripard@anandra.org>
References: <1360880818-4071454-1-git-send-email-arnd@arndb.de> <1360880818-4071454-4-git-send-email-arnd@arndb.de> <20130215045404.11471.91270@quantum>
In-Reply-To: <20130215045404.11471.91270@quantum>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201302151208.41628.arnd@arndb.de>
X-Provags-ID: V02:K0:oUICqcd7MupLOGLKbnCDDYmsrSO1ScuP4hj3uvH4ZXh
 LznSq39WHNfaxstuQaEB4+x9eIL+fdwV5oqayIecD/xXKKZo+y
 WDmmdLRxNgHFy51yn8+d6VDHsW+4wQyEypmTgJ9tg7CCFfcMLY
 gnqs1frqZCWv2Cml+ydn9XHPnPioc2I7lO/pEL2upYR+74cgcN
 +q9ix6zz506I7no8fKQbu11ZufRRJhPDhVQWn7I1L6LBB4k/R/
 iG/9YJyS4HpjhkvMz+8EPZAAUPjvIRI3EMYyXp0kzmR0UVc5NO
 EZermo7QenVShS+9GS4ljya87YAU5mqU4yyuim0a72P/eMvVwS
 L8eZaLcuZ5X/dqMxXeOM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 15 February 2013, Mike Turquette wrote:
> Quoting Arnd Bergmann (2013-02-14 14:26:52)
> > Patch 85a18198 "clk: sunxi: Use common of_clk_init() function"
> > removed the clk-sunxi.c file but left the Makefile entry, which
> > causes a build error in multi_v7_defconfig:
> > 
> > make[4]: *** No rule to make target `drivers/clk/clk-sunxi.o', needed by `drivers/clk/built-in.o'.
> > 
> > The obvious fix is to remove the extraneous line from the
> > Makefile.
> > 
> 
> The fix is correct.  I can't rebase my branch since there is an existing
> dependency with the tegra tree, so I have taken this patch as-is with
> the addition of my SoB.
> 

Ok, thanks!

	Arnd
