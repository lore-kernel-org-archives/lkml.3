Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751572Ab3FGHmF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 03:42:05 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:46910 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750987Ab3FGHmC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 03:42:02 -0400
Date: Fri, 7 Jun 2013 09:42:00 +0200
From: "maxime.ripard@free-electrons.com" <maxime.ripard@free-electrons.com>
To: Hector Palacios <hector.palacios@digi.com>
Cc: Juergen Beisert <jbe@pengutronix.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "fabio.estevam@freescale.com" <fabio.estevam@freescale.com>,
        "brian@crystalfontz.com" <brian@crystalfontz.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: Re: mxsfb: DATA_FORMAT_24_BIT flag outputs invalid colours
Message-ID: <20130607074200.GG14209@lukather>
References: <519E03B0.1080006@digi.com>
 <519F4435.5010703@digi.com>
 <201305241300.25461.jbe@pengutronix.de>
 <201305241533.19941.jbe@pengutronix.de>
 <20130607072103.GF14209@lukather>
 <51B18BA0.50506@digi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51B18BA0.50506@digi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 07, 2013 at 09:28:32AM +0200, Hector Palacios wrote:
> I wasn't sure that everybody involved agreed with the patch.
> @Juergen, would the patch break your platform?
> Additionally, the guys from Crystalfontz didn't comment on it, but
> their platform is also using a 18bit data bus width and 32bpp.

We (Free Electrons) are doing the bring up for the Crystalfontz boards,
so it's fine :)

Thanks!
Maxime
