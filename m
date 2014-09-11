Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752688AbaIKGkw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 02:40:52 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:37683 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752606AbaIKGkv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 02:40:51 -0400
Date: Thu, 11 Sep 2014 08:40:16 +0200
From: Markus Pargmann <mpa@pengutronix.de>
To: Nicolin Chen <nicoleotsuka@gmail.com>
Cc: Dmitry Lavnikevich <d.lavnikevich@sam-solutions.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        ijc+devicetree@hellion.org.uk, Kumar Gala <galak@codeaurora.org>,
        shawn.guo@freescale.com, kernel@pengutronix.de, linux@arm.linux.org.uk,
        "perex@perex.cz" <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Timur Tabi <timur@tabi.org>, Xiubo Li <Li.Xiubo@freescale.com>,
        grant.likely@linaro.org,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [alsa-devel] [PATCH 2/5] ASoC: fsl: add imx-tlv320aic3x machine
 driver
Message-ID: <20140911064016.GE16489@pengutronix.de>
References: <1410356809-26179-1-git-send-email-d.lavnikevich@sam-solutions.com>
 <1410356809-26179-3-git-send-email-d.lavnikevich@sam-solutions.com>
 <20140910142740.GC16489@pengutronix.de>
 <CAGoOwPSpkNy6uNVAjG2HgiHHscKZjL5wgVrkyGwWCmyU7x+gWg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qGV0fN9tzfkG3CxV"
Content-Disposition: inline
In-Reply-To: <CAGoOwPSpkNy6uNVAjG2HgiHHscKZjL5wgVrkyGwWCmyU7x+gWg@mail.gmail.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 08:37:05 up 23:24, 39 users,  load average: 0.13, 0.20, 0.13
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: mpa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qGV0fN9tzfkG3CxV
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 10, 2014 at 11:14:15AM -0700, Nicolin Chen wrote:
> On Wed, Sep 10, 2014 at 7:27 AM, Markus Pargmann <mpa@pengutronix.de> wro=
te:
> > Hi,
> >
> > On Wed, Sep 10, 2014 at 04:46:46PM +0300, Dmitry Lavnikevich wrote:
> >> This is driver for i.MX6 boards with tlv320aic3x audio codecs.
> >>
> >> Signed-off-by: Dmitry Lavnikevich <d.lavnikevich@sam-solutions.com>
> >> ---
> >>  .../bindings/sound/fsl,imx-audio-tlv320aic3x.txt   |  27 ++++
> >>  sound/soc/fsl/Kconfig                              |  13 ++
> >>  sound/soc/fsl/Makefile                             |   2 +
> >>  sound/soc/fsl/imx-tlv320aic3x.c                    | 177 ++++++++++++=
+++++++++
> >>  4 files changed, 219 insertions(+)
> >>  create mode 100644 Documentation/devicetree/bindings/sound/fsl,imx-au=
dio-tlv320aic3x.txt
> >>  create mode 100644 sound/soc/fsl/imx-tlv320aic3x.c
> >
> > Is it possible to use the simple-card
> > (Documentation/devicetree/bindings/sound/simple-card.txt) instead of
> > adding a new audio card driver? There are also DT bindings for the imx
> > audiomultiplexer (imx-audmux.txt).
>=20
> I don't know why my mutt doesn't display this mail.
>=20
> Anyway, if Simple Card supports audmux, yes, it's also a good idea.

Simple Card doesn't support it. But there are DT bindings for the audmux
device node which allow the definition of a default multiplexer setup.
That configuration is applied in the probe() function of the audmux driver.

Best regards,

Markus

--=20
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

--qGV0fN9tzfkG3CxV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJUEUPPAAoJEEpcgKtcEGQQb2YQALHB2zU9+ynWsb5H3+LO/c0t
Th397KH56+T0/i1Qgbm6OwIQ8e1xYQ09EvQdPxxZg1RDt+cLnrSwiTjlBXV95Xfs
Ez7UHGn5P+r7QRj+HBnaYfeOk7Hw2dcL4HIPUTqyZJDRIwEJQ96ka7nOBMNRpc94
xOc56AEkt0ftffKdsLzTosPl2MPcfuG5fAp8jSbAChwXny5xx28YusUbQr3zNzXQ
XRvfWt8eYB8XVF+E8OYQhMhHN2KD7dkUs0pE94ZzXp4i0oUo8jGVgPZBPZVoIVJk
EXoTjsy7pCSEYYwlulDN1ujL41sHXvhnFB1Vli2UnmNygXELdd0q3jaa5sbUBiv8
/A26yauckAqhGVDew3ayRp1UH7q4HD5KfXdBWUIt6dDecNuO3k6t1yTIeRG1hBLW
DtvY3xGOTnwlvvJeuhQ1sK2IVQfyyi2U3CnlAJWybonmurtF4s9bnrY25xqakRa8
53igpZXpS2bnUdnHVTw4LjR2t8HTBtQICcjXy+aUREMvxq7p5hwPmvSA2mvCdftb
zFujI2hluuN8r5cfIVWQ/wfKyvNXmqv2Cl+3lUeoLToWUr2lS3h9gMXu0su/Ty2Q
as34YH+roCnARk2Ddl4C2EcLAkoyeZLSSDt8X45f20tcMqXg6pKui/lsPwOcYsOu
v7P+2VCwfHsgzcK21PE7
=/KzK
-----END PGP SIGNATURE-----

--qGV0fN9tzfkG3CxV--
