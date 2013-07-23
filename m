Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932511Ab3GWNVc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 09:21:32 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:38236 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932194Ab3GWNVb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 09:21:31 -0400
Date: Tue, 23 Jul 2013 14:21:04 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Mark Brown <broonie@kernel.org>
Cc: Jean-Francois Moine <moinejf@free.fr>, Liam Girdwood <lgirdwood@gmail.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Rob Herring <rob.herring@calxeda.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH] ARM: kirkwood: enable S/PDIF
Message-ID: <20130723132104.GT24642@n2100.arm.linux.org.uk>
References: <20130723102320.56bc4555@armhf> <20130723084347.GP24642@n2100.arm.linux.org.uk> <20130723130622.GB9858@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130723130622.GB9858@sirena.org.uk>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 23, 2013 at 02:06:22PM +0100, Mark Brown wrote:
> On Tue, Jul 23, 2013 at 09:43:47AM +0100, Russell King - ARM Linux wrote:
> > On Tue, Jul 23, 2013 at 10:23:20AM +0200, Jean-Francois Moine wrote:
> > > This patch enables S/PDIF.
> 
> > > Signed-off-by: Jean-Francois Moine <moinejf@free.fr>
> 
> > I'm not submitting my patch to do this because:
> 
> > (a) we don't know what effect this has on other hardware.
> 
> This patch will do absolutely nothing unless it's used in a machine
> driver which connects a S/PDIF CODEC to it.  I see no reason not to
> apply it, someone with hardware with more complex needs can always build
> on it later.

So... what if setting this bit causes the SoC to start wiggling a pin
with the SPDIF signal which has been used for a different purpose?
