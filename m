Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751630AbbAMGRe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 01:17:34 -0500
Received: from mail-ig0-f181.google.com ([209.85.213.181]:51229 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751248AbbAMGRa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 01:17:30 -0500
MIME-Version: 1.0
In-Reply-To: <1418226513-14105-6-git-send-email-a.hajda@samsung.com>
References: <1418226513-14105-1-git-send-email-a.hajda@samsung.com>
	<1418226513-14105-6-git-send-email-a.hajda@samsung.com>
Date: Tue, 13 Jan 2015 07:17:29 +0100
Message-ID: <CACRpkdZLw=dTQ0zcHYSJ7rC5k3hjTJ-i__25eDyY8gz6PpnpsA@mail.gmail.com>
Subject: Re: [RFC 05/15] gpio: move DT parsing code to separate functions
From: Linus Walleij <linus.walleij@linaro.org>
To: Andrzej Hajda <a.hajda@samsung.com>, Alexandre Courbot <gnurou@gmail.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>
Cc: open list <linux-kernel@vger.kernel.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mike Turquette <mturquette@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        Thierry Reding <thierry.reding@gmail.com>,
        Inki Dae <inki.dae@samsung.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        "moderated list:ARM/CLKDEV SUPPORT" 
	<linux-arm-kernel@lists.infradead.org>,
        "open list:DRM PANEL DRIVERS" <dri-devel@lists.freedesktop.org>,
        "moderated list:ARM/S5P EXYNOS AR..." 
	<linux-samsung-soc@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 10, 2014 at 4:48 PM, Andrzej Hajda <a.hajda@samsung.com> wrote:

> The patch moves Device Tree parsing logic to separate
> function.
>
> Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>

I think this patch need to be rebased on the GPIO devel branch, but
looks like it makes things cleaner so can stand on its own merits.
We moves stuff around a bit in the OF code though.

Please remember to send this patch to the linux-gpio list and comaintainer
Alexandre Courbot on reposts. (Cc-tags in the patch are good
for this.)

Yours,
Linus Walleij
