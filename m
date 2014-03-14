Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755674AbaCNQ03 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 12:26:29 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:50023 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754113AbaCNQ01 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 12:26:27 -0400
Date: Fri, 14 Mar 2014 16:26:14 +0000
From: Mark Brown <broonie@kernel.org>
To: Mark Rutland <mark.rutland@arm.com>
Cc: Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Rob Landley <rob@landley.net>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <Pawel.Moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Message-ID: <20140314162614.GW366@sirena.org.uk>
References: <1394787326-14520-1-git-send-email-s.trumtrar@pengutronix.de>
 <20140314161403.GN25870@e106331-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="RBdmpsAEjcqDYAXp"
Content-Disposition: inline
In-Reply-To: <20140314161403.GN25870@e106331-lin.cambridge.arm.com>
X-Cookie: Some assembly required.
User-Agent: Mutt/1.5.22 (2013-10-16)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] spi: dw-mmio: add oftree support
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--RBdmpsAEjcqDYAXp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Mar 14, 2014 at 04:14:03PM +0000, Mark Rutland wrote:

> > +Synopsys DesignWare SPI master controller.
> > +
> > +Required properties:
> > +- compatible : "snps,dw-spi-mmio"

> Is there not a better name than "dw-spi-mmio"?

> What's the full name of the device, as on a datasheet? Is there no model
> number?

It's a Synopsis Designware IP block rather than a part - Google suggests
DW_apb_ssi.

--RBdmpsAEjcqDYAXp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTIy2jAAoJELSic+t+oim9C7sP/30oTUa1x3+VheIKQJVb2+2k
74wVEmEUjqAcudOsaxcNKIS+6w4XO0J8SSHWsDELSWQltFYjrZhPSYhXFtimYuBB
75pPCC9nhUKxawC40clGqVcbzlp5zDUg9o1SojM3qt8E3xM1phKQ2dhmvaTcH2WR
YznQDtDnddAeZ6Yqs3+ExBCZI7hGzf0JdUDcqWde0Qk0nSxQnUM6NDSMMkJo2/D3
IqN10ADUjJ8I0Cah6TPrMA52Yguq098IwVOYLj7tBJxErntSmV97/zMXquofJXF5
/h4aIsjRxQZWc8J1FmhYlAZD/LEIBkZAywImaxXw8nHhsDaUTdMOBjCDNrukpsSk
Y4TtII0KMLi1t52yPwc4GQkrRcM5tGvUcFX7yMvR9RCX9tr5R09D7XYEU+xohm4N
LwSACeOAhGaHvgzTykOe0NGGr/MXitDEOrXURxslEx+DoP1AO03vU6tT4QcyyJ2m
jhHC1Bty7wcIzx7s3wW0lEH2DHIwtI6krCQruHazvQh2IarIETXJnBq+vmnUxji7
Vw+qC2lpIBjgI9Wm9meyW7sIwt5c6/RXb74cMGmJ6LrAeR1HJ+f6plj2ydIRUZX6
Lo6zpPMzccZtxA+9mJIS618GT89M6sfzmCJ7tYsWFwAw+UXGswPSaz1Kw038DU2w
4m5AO+U7TAoMVvBFg6Ao
=lYhQ
-----END PGP SIGNATURE-----

--RBdmpsAEjcqDYAXp--
