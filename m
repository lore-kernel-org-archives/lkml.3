Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757991Ab3FLSfS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 14:35:18 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:40580 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757967Ab3FLSfQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 14:35:16 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18YFfJspTCLhKxa2l8RnSO7
Date: Wed, 12 Jun 2013 11:35:09 -0700
From: Tony Lindgren <tony@atomide.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Linus Walleij <linus.walleij@stericsson.com>,
        Stephen Warren <swarren@nvidia.com>, Kevin Hilman <khilman@linaro.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Hebbar Gururaja <gururaja.hebbar@ti.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Wolfram Sang <wsa@the-dreams.de>, Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH] drivers: pinctrl: add active state to core
Message-ID: <20130612183509.GV8164@atomide.com>
References: <1370938616-5952-1-git-send-email-linus.walleij@stericsson.com>
 <20130611160322.GB20352@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130611160322.GB20352@kroah.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Greg Kroah-Hartman <gregkh@linuxfoundation.org> [130611 09:08]:
> On Tue, Jun 11, 2013 at 10:16:56AM +0200, Linus Walleij wrote:
> > From: Linus Walleij <linus.walleij@linaro.org>
> > 
> > In addition to the recently introduced pinctrl core
> > control, the PM runtime pin control for the OMAP platforms
> > require a fourth state in addtition to the default, idle and
> > sleep states already handled by the core: an explicit "active"
> > state. Let's introduce this to the core in addition to the
> > other states already defined.
> > 
> > Cc: Hebbar Gururaja <gururaja.hebbar@ti.com>
> > Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> > Cc: Stephen Warren <swarren@wwwdotorg.org>
> > Cc: Wolfram Sang <wsa@the-dreams.de>
> > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > Cc: Mark Brown <broonie@kernel.org>
> > Cc: Kevin Hilman <khilman@linaro.org>
> > Suggested-by: Tony Lindgren <tony@atomide.com>
> > Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> > ---
> > Greg: need your ACK on this to merge it through the pinctrl
> > tree.
> > ---
> >  drivers/base/pinctrl.c                |  8 +++++++-
> >  drivers/pinctrl/core.c                | 15 +++++++++++++++
> 
> For anything that just touches drivers/base/pinctrl.c, you don't need my
> ack, that's your code, you can do whatever you want with it :)
> 
> But here you go anyway:
> Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Acked-by: Tony Lindgren <tony@atomide.com>
