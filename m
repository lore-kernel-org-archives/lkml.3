Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933952Ab3CMPwx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 11:52:53 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:48183 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932656Ab3CMPwv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 11:52:51 -0400
Message-ID: <5140A0C0.2020400@pengutronix.de>
Date: Wed, 13 Mar 2013 16:52:32 +0100
From: Marc Kleine-Budde <mkl@pengutronix.de>
Organization: Pengutronix e.K.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130215 Thunderbird/17.0.3
MIME-Version: 1.0
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
CC: Roger Quadros <rogerq@ti.com>, balbi@ti.com, tony@atomide.com,
        mark.rutland@arm.com, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-omap@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH 1/8] usb: phy: nop: Add some parameters to platform data
References: <1363087466-32444-1-git-send-email-rogerq@ti.com> <1363087466-32444-2-git-send-email-rogerq@ti.com> <513F177D.40500@pengutronix.de> <513F37DD.9030301@ti.com> <513F38DF.5040404@pengutronix.de> <513F3B7E.8000002@ti.com> <513F3EF0.3030609@pengutronix.de> <513F47B4.2060004@ti.com> <514098A0.1030809@ti.com>
In-Reply-To: <514098A0.1030809@ti.com>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="----enig2VSQWLJGFVQMMDJBGABCI"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
------enig2VSQWLJGFVQMMDJBGABCI
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 03/13/2013 04:17 PM, Peter Ujfalusi wrote:
> On 03/12/2013 04:20 PM, Roger Quadros wrote:
>> Adding Peter to the loop. I faintly remember him mentioning this issue=
 before
>> for beagle. We really need the deferred probe mechanism or we need to =
resort
>> to device registering order.
>=20
> Yes, BeagleBoard is a good example. Long story short: we have external
> dependency and the correct way to handle that is via deferred probe.

Sure.

> As of now we are not ready to kill the legacy support but over time we =
should
> move as much as we can to DT only mode.

I was assuming you're already on DT only :)

Marc

--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


------enig2VSQWLJGFVQMMDJBGABCI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlFAoMMACgkQjTAFq1RaXHOvSgCfe/FyruXVcXy6bI4rU8nm5y/a
TQIAnRWAEC32Ki0ut/3sQ3O86ZidUWch
=GVDF
-----END PGP SIGNATURE-----

------enig2VSQWLJGFVQMMDJBGABCI--
