Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752544Ab3FQQaM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 12:30:12 -0400
Received: from mail-oa0-f54.google.com ([209.85.219.54]:65246 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751170Ab3FQQaK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 12:30:10 -0400
MIME-Version: 1.0
In-Reply-To: <3037061.7rG6iWz9IX@wuerfel>
References: <1370439873-30053-1-git-send-email-linus.walleij@stericsson.com>
	<3037061.7rG6iWz9IX@wuerfel>
Date: Mon, 17 Jun 2013 18:30:09 +0200
Message-ID: <CACRpkdbeFmEx6yZFvUa6B+v9Pd+CieTQR6nvJOUHa9MzQrSufg@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: export pinctrl_pm_select_*_state
From: Linus Walleij <linus.walleij@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Linus Walleij <linus.walleij@stericsson.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Stephen Warren <swarren@nvidia.com>, Kevin Hilman <khilman@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Hebbar Gururaja <gururaja.hebbar@ti.com>,
        Mark Brown <broonie@kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Wolfram Sang <wsa@the-dreams.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 17, 2013 at 5:12 PM, Arnd Bergmann <arnd@arndb.de> wrote:

> The three functions pinctrl_pm_select_default_state,
> pinctrl_pm_select_sleep_state, and pinctrl_pm_select_idle_state
> are used in drivers that can be loadable modules, and should
> be exported.
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

That's right, sorry for missing this :-(

Patch applied!

Yours,
Linus Walleij
