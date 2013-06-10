Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752675Ab3FJMzo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 08:55:44 -0400
Received: from mail-oa0-f42.google.com ([209.85.219.42]:59071 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752539Ab3FJMzl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 08:55:41 -0400
MIME-Version: 1.0
In-Reply-To: <201306090201.17739.heiko@sntech.de>
References: <201306090159.05383.heiko@sntech.de>
	<201306090201.17739.heiko@sntech.de>
Date: Mon, 10 Jun 2013 14:55:41 +0200
Message-ID: <CACRpkdbiHRrP7Xun1sPJ+o45Hofp3gCe89GY0fFiuF1F7TUaxQ@mail.gmail.com>
Subject: Re: [EXAMPLE PATCH] pinctrl: add pinctrl driver for Rockchip SoCs
From: Linus Walleij <linus.walleij@linaro.org>
To: =?ISO-8859-1?Q?Heiko_St=FCbner?= <heiko@sntech.de>
Cc: Patrice Chotard <patrice.chotard.st@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 9, 2013 at 2:01 AM, Heiko Stübner <heiko@sntech.de> wrote:

> This driver adds support the Cortex-A9 based SoCs from Rockchip,
> so at least the RK2928, RK3066 (a and b) and RK3188.
> Earlier Rockchip SoCs seem to use similar mechanics for gpio
> handling so should be supportable with relative small changes.
> Pull handling on the rk3188 is currently a stub, due to it being
> a bit different to the earlier SoCs.
>
> Pinmuxing as well as gpio (and interrupt-) handling tested on
> a rk3066a based machine.
>
> Signed-off-by: Heiko Stuebner <heiko@sntech.de>

Patch applied.

You've been super-helpful, so of course I'm happy to merge this
into the pinctrl tree.

Yours,
Linus Walleij
