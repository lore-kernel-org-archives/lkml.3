Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760353Ab3EXKOY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 06:14:24 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:42457 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760156Ab3EXKOW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 06:14:22 -0400
Date: Fri, 24 May 2013 12:14:19 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Florian Fainelli <florian@openwrt.org>
Cc: David Miller <davem@davemloft.net>, linux-arm-kernel@lists.infradead.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stefan Roese <sr@denx.de>, Emilio Lopez <emilio@elopez.com.ar>,
        kevin@allwinnertech.com, sunny@allwinnertech.com,
        shuge@allwinnertech.com
Subject: Re: [PATCHv3 2/6] net: Add MDIO bus driver for the Allwinner EMAC
Message-ID: <20130524101419.GC8785@lukather>
References: <1369387394-9453-1-git-send-email-maxime.ripard@free-electrons.com>
 <1369387394-9453-3-git-send-email-maxime.ripard@free-electrons.com>
 <CAGVrzcbyXiKCKxtOAj0gnG8eCQag8_xvmd9dUKACCbfW-2HN9Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGVrzcbyXiKCKxtOAj0gnG8eCQag8_xvmd9dUKACCbfW-2HN9Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Florian,

On Fri, May 24, 2013 at 10:42:30AM +0100, Florian Fainelli wrote:
> Hello Maxime,
> 
> 2013/5/24 Maxime Ripard <maxime.ripard@free-electrons.com>
> >
> > This patch adds a separate driver for the MDIO interface of the
> > Allwinner ethernet controllers.
> >
> > Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> > ---
> >  .../bindings/net/allwinner,sun4i-mdio.txt          |  26 +++
> >  drivers/net/ethernet/allwinner/Kconfig             |   8 +
> >  drivers/net/ethernet/allwinner/Makefile            |   1 +
> >  drivers/net/ethernet/allwinner/sun4i-mdio.c        | 191 +++++++++++++++++++++
> 
> Ok, so you probably followed Thomas's example here with mvneta/mvmdio,
> but all other MDIO bus drivers live in drivers/net/phy.

Indeed I shamelessly followed Thomas here.

> Unfortunately, mvmdio lives in drivers/net/ethernet/marvell/mvmdio.c
> which I should have noticed before. Whatever is good for you guys, but
> we should probably start normalizing this now before more mdio drivers
> get merged alongside their corresponding ethernet MAC users.

I'm fine with either way, just tell me where to put it and I'll happily
do so.

Maxime

-- 
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
