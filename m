Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753955Ab3DUSkZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Apr 2013 14:40:25 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:44833 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753783Ab3DUSkY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Apr 2013 14:40:24 -0400
Message-ID: <1366569606.3408.121.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [GIT PULL] Firmware files for CA0132 HD-audio codec (v2)
From: Ben Hutchings <ben@decadent.org.uk>
To: Takashi Iwai <tiwai@suse.de>
Cc: Ian Minett <ian_minett@creativelabs.com>, linux-kernel@vger.kernel.org,
        David Woodhouse <dwmw2@infradead.org>
Date: Sun, 21 Apr 2013 19:40:06 +0100
In-Reply-To: <s5hfvyrotfg.wl%tiwai@suse.de>
References: <s5hfvyrotfg.wl%tiwai@suse.de>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-PpBMehrdm5q1hXHOyebP"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:6834:ff73:7553:7f84
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-PpBMehrdm5q1hXHOyebP
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2013-04-16 at 08:56 +0200, Takashi Iwai wrote:
> Hi Ben,
>=20
> could you pull the firmware files for Creative CA0132 HD-audio codec
> driver from below?  It's the revised version.
>=20
>   git://git.kernel.org/pub/scm/linux/kernel/git/tiwai/linux-firmware.git =
tags/ca0132-fw-v2

Pulled, thanks.

Ben.

> ----------------------------------------------------------------
> Firmware files for CA0132 HD-audio codec (v2)
>=20
> This contains the external firmware files loaded by Creative CA0132
> HD-audio codec driver.  The firmwares are used optionally since 3.9
> kernel.
>=20
> v1->v2: fix the installation path of ct*.bin firmware files
>=20
> ----------------------------------------------------------------
> Ian Minett (1):
>       linux-firmware: Add firmware files for Creative CA0132 HD-audio cod=
ec
>=20
>  LICENCE.ca0132 |  48 ++++++++++++++++++++++++++++++++++++++++++++++++
>  WHENCE         |  11 +++++++++++
>  ctefx.bin      | Bin 0 -> 655436 bytes
>  ctspeq.bin     | Bin 0 -> 4120 bytes
>  4 files changed, 59 insertions(+)
>  create mode 100644 LICENCE.ca0132
>  create mode 100644 ctefx.bin
>  create mode 100644 ctspeq.bin
>=20
>=20
> Thanks!
>=20
> Takashi
>=20

--=20
Ben Hutchings
All extremists should be taken out and shot.

--=-PpBMehrdm5q1hXHOyebP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUXQyhue/yOyVhhEJAQrY0A/+LK5NHR/F5oI8SrkQOWrcecQvOlOMPlDi
4An79PYu+uEO1zOJbd2L2usAhtBsygPUM/a35myffS3c/PdGAgiOF7HTcNtp35Jd
dQfnHNbtkgk6AXk+VDeDGQMu9Rpn1Jg3omAb946g4remVqzI9SKeysLjc0dZsGQv
1wDI+PeZ78CF5hR5UMOCejSFUy/hAJ/gwaLWkwpZGXVTg8aL+I+Eil6YyvQwGU46
+pqz+CumeS5GD2dbreSociqe58zZov3Q6yhHbgznDIsNvDfkye2QkOXY8S04RXZo
GCf1623mBRqO4Uf35TP3VLtVVDrbGDlnC9dmlQjgr1SE/6gkWOXuUElWL/xvZPTH
VbZz1+IeDDtiUgZkM+pkGzbDWQfJoIhKU9L5e4yprjDg0apqWnkshSfw9wMmfFn3
w9CaYnkXao8nreFaz8vAKMUq0dZ4/eQqvDpPiVPaqqbxR7KchpcKuIMKhUkt5LPO
4a1PidTjI8rAmaWa2nXZLlbSzFr6r+Xgis3ffURehuC92cxOhqfiUoBhf7wKKDz2
krvc0eGcpvF1ZEmuYxU7r4PpBKN4BzltWaxIhLNX4GGeR0E6fRpf8Q9svmp45o5U
Uh8954k0eCwpo9EY/oz7VfxMrAB7XF5SBSFeAZGoSL28F2I3g22xta42ACDMSeYR
WDHFUF1oim4=
=M8TE
-----END PGP SIGNATURE-----

--=-PpBMehrdm5q1hXHOyebP--
