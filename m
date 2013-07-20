Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754044Ab3GTMWj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jul 2013 08:22:39 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:42748 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753582Ab3GTMWb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jul 2013 08:22:31 -0400
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH] of: match the compatible in the order set by the dts file
To: Huang Shijie <b32955@freescale.com>, Sascha Hauer <s.hauer@pengutronix.de>
Cc: devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        rob.herring@calxeda.com, linux-arm-kernel@lists.infradead.org
In-Reply-To: <51DBC58D.90002@freescale.com>
References: <1373013818-11365-1-git-send-email-b32955@freescale.com> <20130709070541.GQ516@pengutronix.de> <51DBBFDA.70302@freescale.com> <20130709075124.GR516@pengutronix.de> <51DBC58D.90002@freescale.com>
Date: Sat, 20 Jul 2013 06:44:39 +0100
Message-Id: <20130720054439.308B33E13F0@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Jul 2013 16:10:53 +0800, Huang Shijie <b32955@freescale.com> wrote:
> 于 2013年07月09日 15:51, Sascha Hauer 写道:
> > On Tue, Jul 09, 2013 at 03:46:34PM +0800, Huang Shijie wrote:
> >> 于 2013年07月09日 15:05, Sascha Hauer 写道:
> >>> Why don't you set the matching order in the driver the way you want it
> >>> to be, i.e.:
> >>>
> >>> 	{ .compatible = "fsl,imx6q-uart", ... },
> >>> 	{ .compatible = "fsl,imx21-uart", ... },
> >>> 	{ .compatible = "fsl,imx1-uart", ... },
> >>>
> >> yes. i can set it like this.
> >>
> >> but this method looks like a ugly workaround.
> > If a driver has different ways of supporting a single device, then
> > putting the preferred or most feature rich on top doesn't look very ugly
> > to me.
> this method makes it much _coupled_ between the driver and the dts file.
> 
> IMHO, it's an unnecessary _burden_ to the driver programmer:
>     he should puts the most feature compatible on the top.
> 
> it's much graceful if we let the driver programmer be transparent about 
> this.

Absolutely true. Applied, thanks.

g.

