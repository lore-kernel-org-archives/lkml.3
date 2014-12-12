Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759410AbaLLSCn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 13:02:43 -0500
Received: from gloria.sntech.de ([95.129.55.99]:41398 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752179AbaLLSCm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 13:02:42 -0500
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Romain Perier <romain.perier@gmail.com>
Cc: Julien CHAUVEAU <julien.chauveau@neo-technologies.fr>,
        Mike Turquette <mturquette@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        "moderated list:ARM/Rockchip SoC..." 
	<linux-arm-kernel@lists.infradead.org>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        "open list:COMMON CLK FRAMEWORK" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] clk: rockchip: add CLK_IGNORE_UNUSED flag to fix USB Host
Date: Fri, 12 Dec 2014 19:02:24 +0100
Message-ID: <3548627.UnLcRkWMrC@phil>
User-Agent: KMail/4.14.2 (Linux/3.16-3-amd64; KDE/4.14.1; x86_64; ; )
In-Reply-To: <CABgxDoKKjwDf8+OuWiTjzpbGonshZ0fHXXMvSkJi1Z1U_7AsNA@mail.gmail.com>
References: <1418396066-31360-1-git-send-email-julien.chauveau@neo-technologies.fr> <CABgxDoKKjwDf8+OuWiTjzpbGonshZ0fHXXMvSkJi1Z1U_7AsNA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, 12. Dezember 2014, 16:44:06 schrieb Romain Perier:
> Hi,
> 
> 2014-12-12 15:54 GMT+01:00 Julien CHAUVEAU
> 
> <julien.chauveau@neo-technologies.fr>:
> > This patch adds CLK_IGNORE_UNUSED flag to hclk_usb_peri, hclk_usbotg0 and
> > hclk_usbotg1 because these clocks must remain enabled to use the USB
> > controllers in host mode.
> > 
> > This fixes a regression introduced by patch "clk: rockchip: disable unused
> > clocks"
> > https://lkml.kernel.org/g/1415092270-24932-1-git-send-email-kever.yang@ro
> > ck-chips.com
> Could you refer the commit id instead ? something like "commit <ID>
> ("title of the corresponding commit")  (and use scripts/checkpatch.pl
> on your patch to be sure that the commit form is okay).

I can also fix this up when applying the patch


> 
> 
> I confirm the regression.

instead of prose-confirmation please provide appropriate tags, like

Reviewed-by: Romain Perier <romain.perier@gmail.com>
Tested-by: Romain Perier <romain.perier@gmail.com>

Tested-by when you have tested the fix on actual hardware and Reviewed-by when 
you have reviewed the actual change for correctnes


Thanks
Heiko
