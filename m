Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932216AbbALTMn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 14:12:43 -0500
Received: from smtp6-g21.free.fr ([212.27.42.6]:29362 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756785AbbALTMk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 14:12:40 -0500
Date: Mon, 12 Jan 2015 20:14:37 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Philipp Zabel <p.zabel@pengutronix.de>,
        Andrew Jackson <Andrew.Jackson@arm.com>, Jyri Sarha <jsarha@ti.com>,
        Mark Brown <broonie@kernel.org>, Dave Airlie <airlied@gmail.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v9 1/4] drm/i2c: tda998x: Add DT support for audio
Message-ID: <20150112201437.07254212@armhf>
In-Reply-To: <20150112175705.GN12302@n2100.arm.linux.org.uk>
References: <20150109130725.GN12302@n2100.arm.linux.org.uk>
	<54AFDE8D.3000504@arm.com>
	<20150109145741.GP12302@n2100.arm.linux.org.uk>
	<20150109183857.53d701a4@armhf>
	<20150109200127.GD12302@n2100.arm.linux.org.uk>
	<1421054728.3081.28.camel@pengutronix.de>
	<20150112122527.GF12302@n2100.arm.linux.org.uk>
	<1421071197.3081.44.camel@pengutronix.de>
	<20150112140456.GI12302@n2100.arm.linux.org.uk>
	<20150112181341.4a53ea24@armhf>
	<20150112175705.GN12302@n2100.arm.linux.org.uk>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Jan 2015 17:57:06 +0000
Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:

> I don't particularly like that - that makes the assumption that AP0
> always means I2S.  What if a future chip decides to allow SPDIF on
> AP0?  Why should we need to re-invent the binding?
> 
> IMHO, it would be much better to make this explicit.

OK.

> Note that the "video-ports" and "audio-ports" are just labels in the
> DT file; they aren't carried through to the resulting DT binary file,
> so they don't have any meaning to the kernel.

Right, so, either the port type must be explicitly defined, or the name
of the property giving the port value also gives the port type
(nxp,video-port / nxp,audio-port).

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
