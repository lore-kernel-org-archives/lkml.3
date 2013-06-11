Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755076Ab3FKQCs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 12:02:48 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39923 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755046Ab3FKQCq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 12:02:46 -0400
Date: Tue, 11 Jun 2013 09:03:22 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: Stephen Warren <swarren@nvidia.com>, Kevin Hilman <khilman@linaro.org>,
        Tony Lindgren <tony@atomide.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Hebbar Gururaja <gururaja.hebbar@ti.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Wolfram Sang <wsa@the-dreams.de>, Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH] drivers: pinctrl: add active state to core
Message-ID: <20130611160322.GB20352@kroah.com>
References: <1370938616-5952-1-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370938616-5952-1-git-send-email-linus.walleij@stericsson.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 11, 2013 at 10:16:56AM +0200, Linus Walleij wrote:
> From: Linus Walleij <linus.walleij@linaro.org>
> 
> In addition to the recently introduced pinctrl core
> control, the PM runtime pin control for the OMAP platforms
> require a fourth state in addtition to the default, idle and
> sleep states already handled by the core: an explicit "active"
> state. Let's introduce this to the core in addition to the
> other states already defined.
> 
> Cc: Hebbar Gururaja <gururaja.hebbar@ti.com>
> Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> Cc: Stephen Warren <swarren@wwwdotorg.org>
> Cc: Wolfram Sang <wsa@the-dreams.de>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Mark Brown <broonie@kernel.org>
> Cc: Kevin Hilman <khilman@linaro.org>
> Suggested-by: Tony Lindgren <tony@atomide.com>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
> Greg: need your ACK on this to merge it through the pinctrl
> tree.
> ---
>  drivers/base/pinctrl.c                |  8 +++++++-
>  drivers/pinctrl/core.c                | 15 +++++++++++++++

For anything that just touches drivers/base/pinctrl.c, you don't need my
ack, that's your code, you can do whatever you want with it :)

But here you go anyway:
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
