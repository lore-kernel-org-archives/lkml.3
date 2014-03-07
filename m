Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753579AbaCGRGx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 12:06:53 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:52205 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752191AbaCGRGw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 12:06:52 -0500
Message-ID: <1394212006.16309.29.camel@paszta.hi.pengutronix.de>
Subject: Re: [PATCH] reset: Add optional resets and stubs
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: linux-kernel@vger.kernel.org, Chen-Yu Tsai <wens@csie.org>,
        "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        Barry Song <Baohua.Song@csr.com>,
        Stephen Warren <swarren@wwwdotorg.org>, Pavel Machek <pavel@ucw.cz>,
        Shawn Guo <shawn.guo@linaro.org>, Marek Vasut <marex@denx.de>,
        Stephen Warren <swarren@nvidia.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        kernel@pengutronix.de
Date: Fri, 07 Mar 2014 18:06:46 +0100
In-Reply-To: <20140307153942.GD28943@katana>
References: <1394202623-20229-1-git-send-email-p.zabel@pengutronix.de>
	 <20140307153942.GD28943@katana>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:96de:80ff:fec2:9969
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wolfram,

Am Freitag, den 07.03.2014, 16:39 +0100 schrieb Wolfram Sang:
> On Fri, Mar 07, 2014 at 03:30:23PM +0100, Philipp Zabel wrote:
> > This patch adds device_reset_optional and (devm_)reset_control_get_optional
> > variants that drivers can use to indicate they can function without control
> > over the reset line. For those functions, stubs are added so the drivers can
> > be compiled with CONFIG_RESET_CONTROLLER disabled.
> > Also, device_reset is annotated with __must_check. Drivers ignoring the return
> > value should use device_reset_optional instead.
> > 
> > Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> 
> Yay, thanks for fixing that! Do you pick it up yourself?

yes, I can do that.
Does this work for all interested parties?

regards
Philipp

