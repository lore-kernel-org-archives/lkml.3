Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752519Ab3FGHVI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 03:21:08 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:46799 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751471Ab3FGHVG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 03:21:06 -0400
Date: Fri, 7 Jun 2013 09:21:03 +0200
From: "maxime.ripard@free-electrons.com" <maxime.ripard@free-electrons.com>
To: Juergen Beisert <jbe@pengutronix.de>
Cc: linux-arm-kernel@lists.infradead.org,
        Hector Palacios <hector.palacios@digi.com>,
        "fabio.estevam@freescale.com" <fabio.estevam@freescale.com>,
        "brian@crystalfontz.com" <brian@crystalfontz.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: Re: mxsfb: DATA_FORMAT_24_BIT flag outputs invalid colours
Message-ID: <20130607072103.GF14209@lukather>
References: <519E03B0.1080006@digi.com>
 <519F4435.5010703@digi.com>
 <201305241300.25461.jbe@pengutronix.de>
 <201305241533.19941.jbe@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201305241533.19941.jbe@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hector,

On Fri, May 24, 2013 at 03:33:19PM +0200, Juergen Beisert wrote:
> Someone told me, Qt5 cannot handle this special RGB666 mode (even not the 
> def_rgb666_shift memory layout mentioned above). My test are based on Qt4. 
> Qt5 needs a regular RGB888 mode, which should silently be converted 
> internally to RGB666 in the hardware.
> 
> So, your patch to always use the RGB888 memory layout seems to be the right 
> way to go.

Do you plan on submitting this patch? (Or did you already submit it and
I overlooked it?)

Thanks,
Maxime
