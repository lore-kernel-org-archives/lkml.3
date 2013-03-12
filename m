Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933037Ab3CLLyz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 07:54:55 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:37606 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932207Ab3CLLyx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 07:54:53 -0400
Message-ID: <513F177D.40500@pengutronix.de>
Date: Tue, 12 Mar 2013 12:54:37 +0100
From: Marc Kleine-Budde <mkl@pengutronix.de>
Organization: Pengutronix e.K.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130215 Thunderbird/17.0.3
MIME-Version: 1.0
To: Roger Quadros <rogerq@ti.com>
CC: balbi@ti.com, tony@atomide.com, mark.rutland@arm.com,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH 1/8] usb: phy: nop: Add some parameters to platform data
References: <1363087466-32444-1-git-send-email-rogerq@ti.com> <1363087466-32444-2-git-send-email-rogerq@ti.com>
In-Reply-To: <1363087466-32444-2-git-send-email-rogerq@ti.com>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="----enig2UKGFGHIUNOEIEPLFKHJP"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
------enig2UKGFGHIUNOEIEPLFKHJP
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 03/12/2013 12:24 PM, Roger Quadros wrote:
> Add clk_rate parameter to platform data. If supplied, the
> NOP phy driver will program the clock to that rate during probe.
>=20
> Also add 2 flags, needs_vcc and needs_reset.
> If the flag is set and the regulator couldn't be found
> then the driver will bail out with -EPROBE_DEFER.

Is there a platform which fills out pdata.needs_vcc and
pdata.needs_reset? IMHO it makes no sense to add features for the non DT
case, if there isn't any user for it.

Marc

--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


------enig2UKGFGHIUNOEIEPLFKHJP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlE/F4AACgkQjTAFq1RaXHOC4wCdEOm1cScGwIpWrSQG+S12Xbk/
/sIAnR0i4Rld+2VGgg6V2jhOD/hv8ExZ
=9+6l
-----END PGP SIGNATURE-----

------enig2UKGFGHIUNOEIEPLFKHJP--
