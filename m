Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758251Ab3KNWed (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 17:34:33 -0500
Received: from ring0.de ([91.143.88.219]:57687 "EHLO smtp.ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754375Ab3KNWeY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 17:34:24 -0500
X-Spam-Report: * -0.0 NO_RELAYS Informational: message was not relayed via SMTP
	* -1.9 BAYES_00 BODY: Spamwahrscheinlichkeit nach Bayes-Test: 0-1%
	*      [score: 0.0000]
	* -0.0 NO_RECEIVED Informational: message has no Received headers
Date: Thu, 14 Nov 2013 22:34:19 +0000
From: Sebastian Reichel <sre@debian.org>
To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Cc: Tony Lindgren <tony@atomide.com>, Anton Vorontsov <anton@enomsg.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH 1/2] isp1704_charger: Add DT support
Message-ID: <20131114223416.GA6383@earth.universe>
Mail-Followup-To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
	Tony Lindgren <tony@atomide.com>,
	Anton Vorontsov <anton@enomsg.org>,
	David Woodhouse <dwmw2@infradead.org>,
	Grant Likely <grant.likely@linaro.org>,
	Rob Herring <rob.herring@calxeda.com>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Stephen Warren <swarren@wwwdotorg.org>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
	devicetree@vger.kernel.org
References: <1384432734-1490-1-git-send-email-sre@debian.org>
 <201311141905.11046@pali>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="fUYQa+Pmc3FrFX/N"
Content-Disposition: inline
In-Reply-To: <201311141905.11046@pali>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--fUYQa+Pmc3FrFX/N
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 14, 2013 at 07:05:06PM +0100, Pali Roh=E1r wrote:
> On Thursday 14 November 2013 13:38:53 Sebastian Reichel wrote:
> > diff --git a/drivers/power/isp1704_charger.c
> > b/drivers/power/isp1704_charger.c index fc04d19..db96778
> > 100644
> > --- a/drivers/power/isp1704_charger.c
> > +++ b/drivers/power/isp1704_charger.c
> > @@ -28,6 +28,8 @@
> >  #include <linux/platform_device.h>
> >  #include <linux/power_supply.h>
> >  #include <linux/delay.h>
> > +#include <linux/of.h>
> > +#include <linux/of_gpio.h>
> >=20
> >  #include <linux/usb/otg.h>
> >  #include <linux/usb/ulpi.h>
> > @@ -89,8 +91,8 @@ static void isp1704_charger_set_power(struct
> > isp1704_charger *isp, bool on) {
> >  	struct isp1704_charger_data	*board =3D
> > isp->dev->platform_data;
> >=20
> > -	if (board && board->set_power)
> > -		board->set_power(on);
> > +	if (board)
> > +		gpio_set_value(board->enable_gpio, on);
> >  }
> >=20
>=20
> You need to check if enable_gpio in board data was defined or not.

The device is not successful probed without valid enable_gpio.

-- Sebastian

--fUYQa+Pmc3FrFX/N
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBCAAGBQJShU/oAAoJENju1/PIO/qaJZUQAINRQ/q/vCl0i6J63Z5988fk
4WbcLre2IXWTTf8QV8U+8Qp0Z3ahF8zw7pFlpY9V2jcGINYqdylNyCPMaklmGgVR
GG65jQ50GeLrfq0F2c9Sh2SmbkT46zFZAoBJX6Wc+vQP+jVQFURptHuVZXDPlwol
3opslaPYLYxrprmSwOAyk0cJPGjvROTKkhCu22ItVdPhoXIBOADQs/mBvHbpCSQE
hxNaNNCsdRZLOQNAU/Y/QG7VWyOBCUGlX19tqHxwFH9a+Gc5RaP6MbaFUwjQAUWW
n8bwtNB3Hs8LWKMYctW/mV95RS66gPN8sl8WOnbDwtMDTHQt24QfeoTxNxEIv0I+
8Q3E3MUn99gpffv+ODr1pb1uJcHslpYM9+h592eYwAVczI85JVkgx+XRDIz8+mac
2pggzH8lLpM7BFJAIf/XYRBgeLtyyrexGbrpbfN9be6G3nUmpSvOtRD06s4w0Nsn
rf9WS9GArNrfexKtJY7dNEUQ8oi0rXqILNKswxfA3YmH96j4410vfYGSnRK9r0VT
hvo7BELlrljf81RxBsCGaQsdTm0cQSzHhBSHBdTD0Ig6hgXtLVZfuBP7D2wefLm2
UllfgHzMk2eZGTic6C97m18k/i5Yw1TgjV2MYODGw8ROQ5ksswi4+Ffkrdt7BUGp
+n09mmZJkpG2ixn2muSO
=8jvX
-----END PGP SIGNATURE-----

--fUYQa+Pmc3FrFX/N--
