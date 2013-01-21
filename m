Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756634Ab3AUUf5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 15:35:57 -0500
Received: from netrider.rowland.org ([192.131.102.5]:38340 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752815Ab3AUUfz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 15:35:55 -0500
Date: Mon, 21 Jan 2013 15:35:54 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Arnd Bergmann <arnd@arndb.de>
cc: balbi@ti.com, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <arm@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>,
        Manjunath Goudar <manjunath.goudar@linaro.org>,
        Shawn Guo <shawn.guo@linaro.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>
Subject: Re: [PATCH 13/15] USB: ehci: make orion and mxc bus glues coexist
In-Reply-To: <201301212014.20678.arnd@arndb.de>
Message-ID: <Pine.LNX.4.44L0.1301211533580.24224-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Jan 2013, Arnd Bergmann wrote:

> On Monday 21 January 2013, Felipe Balbi wrote:
> > On Mon, Jan 21, 2013 at 05:16:06PM +0000, Arnd Bergmann wrote:
> > > Manjunath Goudar is already working on a patch to convert
> > > both the imx and the mvebu glue drivers (along with all
> > > the other ARM specific ones) to the new probing method,
> > > but that will be too late to fix v3.8. This patch instead
> > > adds yet another hack like the existing ones to allow
> > > the ehci driver to load both back-ends.
> > 
> > NAK, should be converted to the new usage of ehci library driver. Alan
> > Stern already implemented for a few drivers, help is very welcome.
> 
> As I explained above, Manjunath already has a patch [1] for that, but I
> think it's too late to include that in v3.8 given the regression
> potential and size of the patch. Once he submits that patch for 3.9,
> my change would get taken out anyway, but it lets us build important
> configurations (including allyesconfig build tests) on 3.8.
> 
> 	Arnd
> 
> [1] http://git.linaro.org/gitweb?p=people/manjunathgoudar/usb-refactoring.git;a=commitdiff;h=d9f28dba727212d022605c955796a3a83b3978ae

Is Manjunath aware of the first patch attached to this email message?

	http://marc.info/?l=linux-usb&m=135843902916416&w=2

Alan Stern

