Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754507AbaA0Upy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 15:45:54 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:50266 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754171AbaA0Upx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 15:45:53 -0500
Date: Mon, 27 Jan 2014 20:45:34 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Mark Brown <broonie@kernel.org>
Cc: Jean-Francois Moine <moinejf@free.fr>, alsa-devel@alsa-project.org,
        devicetree@vger.kernel.org, Dave Airlie <airlied@gmail.com>,
        dri-devel@lists.freedesktop.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Rob Clark <robdclark@gmail.com>
Subject: Re: [PATCH 3/4] ASoC: tda998x: add DT documentation
Message-ID: <20140127204534.GB15937@n2100.arm.linux.org.uk>
References: <cover.1390813480.git.moinejf@free.fr> <22fafd7e11771ffc25c84ff609d18039f07b7295.1390813481.git.moinejf@free.fr> <20140127204302.GY11841@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140127204302.GY11841@sirena.org.uk>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 27, 2014 at 08:43:02PM +0000, Mark Brown wrote:
> On Mon, Jan 27, 2014 at 09:34:49AM +0100, Jean-Francois Moine wrote:
> 
> > +	- compatible: must be "nxp,tda998x-codec".
> > +	- audio-ports: one or two values.
> > +		The first value defines the I2S input port.
> > +		The second one, if present, defines the S/PDIF input port.
> 
> I take it these are port numbers on the device and it's not possible to
> do something like having multiple I2S ports?

You can feed it with multiple synchronised I2S streams for the additional
channels.

-- 
FTTC broadband for 0.8mile line: 5.8Mbps down 500kbps up.  Estimation
in database were 13.1 to 19Mbit for a good line, about 7.5+ for a bad.
Estimate before purchase was "up to 13.2Mbit".
