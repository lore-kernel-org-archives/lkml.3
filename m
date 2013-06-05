Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757022Ab3FESyI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 14:54:08 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34482 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756164Ab3FESyH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 14:54:07 -0400
Date: Wed, 5 Jun 2013 11:54:05 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: Stephen Warren <swarren@nvidia.com>, Kevin Hilman <khilman@linaro.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Hebbar Gururaja <gururaja.hebbar@ti.com>,
        Mark Brown <broonie@kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Wolfram Sang <wsa@the-dreams.de>
Subject: Re: [PATCH 1/3] drivers: pinctrl sleep and idle states in the core
Message-ID: <20130605185405.GA18884@kroah.com>
References: <1370439873-30053-1-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370439873-30053-1-git-send-email-linus.walleij@stericsson.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 05, 2013 at 03:44:31PM +0200, Linus Walleij wrote:
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

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

