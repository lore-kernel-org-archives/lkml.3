Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932586Ab3GWNX3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 09:23:29 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:38246 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932442Ab3GWNX2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 09:23:28 -0400
Date: Tue, 23 Jul 2013 14:23:14 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Mark Brown <broonie@kernel.org>
Cc: Jean-Francois Moine <moinejf@free.fr>, Liam Girdwood <lgirdwood@gmail.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Rob Herring <rob.herring@calxeda.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@vger.kernel.org
Subject: Re: [PATCH] ARM: kirkwood: extend the kirkwood pcm/dma driver for
	DT usage
Message-ID: <20130723132314.GU24642@n2100.arm.linux.org.uk>
References: <20130723104641.6ee0b9ec@armhf> <20130723125756.GZ9858@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130723125756.GZ9858@sirena.org.uk>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 23, 2013 at 01:57:56PM +0100, Mark Brown wrote:
> On Tue, Jul 23, 2013 at 10:46:41AM +0200, Jean-Francois Moine wrote:
> 
> > +- compatible: "marvell,mvebu-pcm-audio"
> > +
> > +Example:
> > +
> > +pcm: pcm {
> > +	compatible = "marvell,mvebu-pcm-audio";
> > +};
> 
> This device has no registers or other hardware - this looks like a stub
> device which shouldn't be visible in DT but should instead be created by
> the I2S driver - look at how most of the other DT platforms using
> dmaengine work.

There is no separate DMA engine on this platform.  dmaengine is totally
irrelevant to this hardware.
