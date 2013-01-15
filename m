Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756262Ab3AOPsW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 10:48:22 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:55269 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752713Ab3AOPsV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 10:48:21 -0500
Message-ID: <50F57A30.10109@pengutronix.de>
Date: Tue, 15 Jan 2013 16:48:00 +0100
From: Marc Kleine-Budde <mkl@pengutronix.de>
Organization: Pengutronix e.K.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: Subodh Nijsure <snijsure@grid-net.com>
CC: linux-mtd@lists.infradead.org, Artem Bityutskiy <dedekind1@gmail.com>,
        penguin-kernel@I-love.SAKURA.ne.jp,
        linux-security-module@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [v4] Add security.* XATTR support for the UBIFS
References: <1336915488-23943-1-git-send-email-snijsure@grid-net.com>
In-Reply-To: <1336915488-23943-1-git-send-email-snijsure@grid-net.com>
X-Enigmail-Version: 1.5
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="----enig2UATRGLPVLEEOHEUWPSIP"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
------enig2UATRGLPVLEEOHEUWPSIP
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 05/13/2012 05:24 AM, Subodh Nijsure wrote:
> From: Subodh Nijsure <snijsure@grid-net.com>
>=20
> Also fix couple of bugs in UBIFS extended attribute length calculation.=

>=20
> Changes in v4:
>         Fix lock issues introduced in v3.
>         Tested with CONFIG_SECURITY enabled & disabled.
>=20
> Changes in v3:
> 	 Remove #ifdef CONFIG_UBIFS_FS_XATTR
>=20
> Changes in v2:
>          Instead of just handling security.selinux extended attribute h=
andle
>          all security.* attributes.
>=20
> TESTING: Tested on  MX28 based platforms using Micron MT29F2G08ABAEAH4 =
NAND
>          With these change we are able to label UBIFS filesystem with
>          security.selinux and run system with selinux enabled.
>          This change also allows one to set other security.* extended
>          attributes, such as security.smack security.evm, security.ima
>          Ran integck test on UBI filesystem.
>          This patch set has been tested with CONFIG_LOCKDEP=3Dy and oth=
er options
>          suggested in Submitchecklist
>=20
> Signed-off-by: Subodh Nijsure <snijsure@grid-net.com>

What's the status of this patch? Was there a v5?

Marc

--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


------enig2UATRGLPVLEEOHEUWPSIP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlD1ejQACgkQjTAFq1RaXHPlOwCgj2oFC4JYU3BoYfv0rPj+AcLP
nZMAn0VrMMC7sVTzcdMpHYjnovv2pJRb
=3CxT
-----END PGP SIGNATURE-----

------enig2UATRGLPVLEEOHEUWPSIP--
