Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756788Ab3FEP5p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 11:57:45 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:60860 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756648Ab3FEP5o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 11:57:44 -0400
From: Kevin Hilman <khilman@linaro.org>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Stephen Warren <swarren@nvidia.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Hebbar Gururaja <gururaja.hebbar@ti.com>,
        Mark Brown <broonie@kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Wolfram Sang <wsa@the-dreams.de>
Subject: Re: [PATCH 1/3] drivers: pinctrl sleep and idle states in the core
References: <1370439873-30053-1-git-send-email-linus.walleij@stericsson.com>
Date: Wed, 05 Jun 2013 08:57:40 -0700
In-Reply-To: <1370439873-30053-1-git-send-email-linus.walleij@stericsson.com>
	(Linus Walleij's message of "Wed, 5 Jun 2013 15:44:31 +0200")
Message-ID: <8761xszh1n.fsf@linaro.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Walleij <linus.walleij@stericsson.com> writes:

> From: Linus Walleij <linus.walleij@linaro.org>
>
> If a device have sleep and idle states in addition to the
> default state, look up these in the core and stash them in
> the pinctrl state container.
>
> Add accessor functions for pinctrl consumers to put the pins
> into "default", "sleep" and "idle" states passing nothing but
> the struct device * affected.
>
> Solution suggested by Kevin Hilman, Mark Brown and Dmitry
> Torokhov in response to a patch series from Hebbar
> Gururaja.
>
> Cc: Hebbar Gururaja <gururaja.hebbar@ti.com>
> Cc: Mark Brown <broonie@kernel.org>
> Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> Cc: Kevin Hilman <khilman@linaro.org>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Stephen Warren <swarren@wwwdotorg.org>
> Cc: Wolfram Sang <wsa@the-dreams.de>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
> I'm seeking Gregs ACK on this in the end, so we can take this
> in through the pinctrl tree. But first let's review!

Reviewed-by: Kevin Hilman <khilman@linaro.org>

