Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753933AbaJGNFQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 09:05:16 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:38003 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753831AbaJGNFM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 09:05:12 -0400
Date: Tue, 7 Oct 2014 15:05:03 +0200
From: Markus Pargmann <mpa@pengutronix.de>
To: Mark Brown <broonie@kernel.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, kernel@pengutronix.de
Subject: Re: [PATCH 2/5] regulator: Set ena_gpio_valid in regulator drivers
Message-ID: <20141007130503.GG5042@pengutronix.de>
References: <1412626635-7404-1-git-send-email-mpa@pengutronix.de>
 <1412626635-7404-3-git-send-email-mpa@pengutronix.de>
 <20141007115817.GX4609@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qftxBdZWiueWNAVY"
Content-Disposition: inline
In-Reply-To: <20141007115817.GX4609@sirena.org.uk>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 15:03:26 up 27 days,  5:50, 82 users,  load average: 0.03, 0.04,
 0.05
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: mpa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qftxBdZWiueWNAVY
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Oct 07, 2014 at 12:58:17PM +0100, Mark Brown wrote:
> On Mon, Oct 06, 2014 at 10:17:12PM +0200, Markus Pargmann wrote:
> > This patch sets the new field ena_gpio_valid for all drivers which set a
> > valid ena_gpio.
>=20
> >  	config.ena_gpio =3D arizona->pdata.ldoena;
> > +	config.ena_gpio_valid =3D true;
>=20
> This patch just unconditionally sets the flag in all drivers which will
> break any system which relies on the existing behaviour that we ignore
> GPIO 0.  We can definitely set this flag in any DT only system if we get
> the GPIO from DT but otherwise doing this defeats the point of having
> the flag in the first place.

Right, I didn't thought about the old platform data which may pass 0
gpios indicating that there is no gpio.
I will rework this patch.

Thanks,

Markus

--=20
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

--qftxBdZWiueWNAVY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJUM+T/AAoJEEpcgKtcEGQQEq0QAKVHO/6r/uJzLh4gKZii/Qsr
pCVGIx7hSyHZ68tYOIJXtojK8+wgoDjCvC+Tv+hz2n6DMSPcKG5/P16QthdcHrkf
PHdLQxbEvlXN7d4terQaZBagcpW7O55GaGGocxHO6+t+6E2PcZkrxubexz8yKB4d
+t8WjwVUAW3RMTNUEOxw+Ckc3cI4pOaLwDScuc5sRsNtq1VmoXxMjk9xlZoFDm79
90S0FY5AaSTXHQT70KwfOtEVeoJJ0+WZlJYwlsmZwFRngSjO0laYRXbaNmcR9VtO
5EcnKOYhmNKU9ssYbNmp+xG9h3E66WTCp4mrMXRtqUZQkkVaWbQG53GYfYN7F+o9
GGfRHhfUR+ccdJiCfXIx4O/O80efBxioieGRR5HFMN8FpxgPNPSCWChzTLaSomQ0
o+uBNlYsNEX1hkE9D/PVdQrIG+aZPrIl41W5PrOksjeIIezDqTaWiNrxNxXDMbaj
xjZKibxbBQUaiZPRPvE5x1oGur8Z6hdPO706TfHzg+iTAVFF8UU2IIZLs2TEJCRp
8wTK1s4c2gIq7/r4S0hoONovTuMscxQb0/4p+apN/aEejp0QwWmUjmfVrNoCxBYC
Djp5cFruhAl71Ddtc5gipVmeKCYA2BUufdqV6nQbUTb1o1rREvr+fdBvmfLlkank
NbxmUldZuqdL35aa4t8a
=kJji
-----END PGP SIGNATURE-----

--qftxBdZWiueWNAVY--
