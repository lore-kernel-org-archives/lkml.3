Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754063AbaIVNQv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 09:16:51 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:48448 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753956AbaIVNQu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 09:16:50 -0400
Date: Mon, 22 Sep 2014 15:16:40 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: Anders Berg <anders.berg@avagotech.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-i2c@vger.kernel.org
Subject: Re: [PATCH] i2c: axxia: Add I2C driver for AXM55xx
Message-ID: <20140922131640.GU3755@pengutronix.de>
References: <1408967482-17723-1-git-send-email-anders.berg@avagotech.com>
 <20140920121242.GA3833@katana>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140920121242.GA3833@katana>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 20, 2014 at 02:12:43PM +0200, Wolfram Sang wrote:
> Hi,
> 
> thanks for the submission.
> 
> On Mon, Aug 25, 2014 at 01:51:22PM +0200, Anders Berg wrote:
> > Add I2C bus driver for the controller found in the LSI Axxia family SoCs. The
> > driver implements 10-bit addressing and SMBus transfer modes via emulation
> > (including SMBus block data read).
> > 
> > Signed-off-by: Anders Berg <anders.berg@avagotech.com>
> 
> Looks pretty good already. Still, some comments:
> 
> > +config I2C_AXXIA
> > +	tristate "Axxia I2C controller"
> > +	depends on ARCH_AXXIA
> > +	help
> > +	  Say yes if you want to support the I2C bus on Axxia platforms.
> > +
> > +	  If you don't know, say Y.
> 
> I'd say skip this sentence and consider 'default y' if it is really
> needed on this platform.
Still better:

	depends on ARCH_AXXIA || COMPILE_TEST
	default ARCH_AXXIA

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
