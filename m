Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757516Ab3EXUKe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 16:10:34 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:44769 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755817Ab3EXUKc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 16:10:32 -0400
Date: Fri, 24 May 2013 22:10:30 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Emilio =?iso-8859-1?Q?L=F3pez?= <emilio@elopez.com.ar>
Cc: davem@davemloft.net, linux-arm-kernel@lists.infradead.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stefan Roese <sr@denx.de>, Florian Fainelli <florian@openwrt.org>,
        kevin@allwinnertech.com, sunny@allwinnertech.com,
        shuge@allwinnertech.com
Subject: Re: [PATCHv3 1/6] net: Add EMAC ethernet driver found on Allwinner
 A10 SoC's
Message-ID: <20130524201030.GA17847@lukather>
References: <1369387394-9453-1-git-send-email-maxime.ripard@free-electrons.com>
 <1369387394-9453-2-git-send-email-maxime.ripard@free-electrons.com>
 <519F6128.9060608@elopez.com.ar>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <519F6128.9060608@elopez.com.ar>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Emilio,

On Fri, May 24, 2013 at 09:46:32AM -0300, Emilio López wrote:
> El 24/05/13 06:23, Maxime Ripard escribió:
> > From: Stefan Roese <sr@denx.de>
> > 
> > The Allwinner A10 has an ethernet controller that seem to be developped
> > internally by them.
> > 
> > The exact feature set of this controller is unknown, since there is no
> > public documentation for this IP, and this driver is mostly the one
> > published by Allwinner that has been heavily cleaned up.
> > 
> > Signed-off-by: Stefan Roese <sr@denx.de>
> > Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> > ---
> 
> (snip)
> 
> > +
> > +config SUN4I_EMAC
> > +        tristate "Allwinner A10 EMAC support"
> > +	depends on ARCH_SUNXI
> > +	depends on OF
> > +	select CRC32
> > +	select NET_CORE
> > +	select MII
> > +	select REGULATOR_FIXED_VOLTAGE
> > +        ---help---
> > +          Support for Allwinner A10 EMAC ethernet driver.
> > +
> > +          To compile this driver as a module, choose M here.  The module
> > +          will be called sun4i-emac.
> > +
> 
> You also need to select REGULATOR when you select REGULATOR_FIXED_VOLTAGE

Actually, this should be in patch 2/6.

Thanks for noticing!

Maxime

-- 
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
