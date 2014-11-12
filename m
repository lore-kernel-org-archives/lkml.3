Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753247AbaKLPjY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 10:39:24 -0500
Received: from sauhun.de ([89.238.76.85]:45275 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752895AbaKLPjP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 10:39:15 -0500
Date: Wed, 12 Nov 2014 16:40:30 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Danielle Costantino <danielle.costantino@gmail.com>
Cc: linux-i2c <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] i2c: mpc: Report correct I2C error codes on Freescale
 MPC i2c bus driver
Message-ID: <20141112154030.GB4031@katana>
References: <CAAVjN7cpGzokOntyyGVBksdvAw7rGt8zvggpCeMqr+g1yHEyzg@mail.gmail.com>
 <20141110144954.GC10422@katana>
 <CAAVjN7fsZC6V7bsJQLNmEx=yOmvsDn2ZwfOHNLd_=_jAbYB2dA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4bRzO86E/ozDv8r1"
Content-Disposition: inline
In-Reply-To: <CAAVjN7fsZC6V7bsJQLNmEx=yOmvsDn2ZwfOHNLd_=_jAbYB2dA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--4bRzO86E/ozDv8r1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 12, 2014 at 05:08:09AM -0800, Danielle Costantino wrote:
> From: Danielle Costantino <danielle.costantino@gmail.com>
> Subject: [PATCH v2] i2c: mpc: report correct I2C error return codes
>=20
> This patch enforces correct I2C error returned codes from Freescale's
> MPC i2c bus driver, allowing for proper user-space/kernel error
> handling.
>=20
> Signed-off-by: Danielle Costantino <danielle.costantino@gmail.com>
>=20
> diff --git a/drivers/i2c/busses/i2c-mpc.c b/drivers/i2c/busses/i2c-mpc.c
> index 0edf630..4c5d7d9 100644

Applied to for-next, thanks!

Still, the attachment worked, not the mail itself. That is OK for now,
but not generally acceptable. There is Documentation/email-clients.txt
which has some info about GMail. Please check.


--4bRzO86E/ozDv8r1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUY39uAAoJEBQN5MwUoCm229MQALUb6uGnG52AQWBvQm1cLbbZ
FWr3RDDQUUA/N9Z+IAz2Z/tYLpi+qva0vNcTg8BcDeL4135rEsOZWTaJWKTprUgu
iOljcN2wGFwGxaBdWi83KvJFoGlbe2DQaxUKHQiFXiVd4jaS3fdPj1m41ErNKab5
F/6srRdu79soJwWeNAeVZvkwkx0YXoOqTzbGodbzCQzujnEQ6Pl62di4XKtv/b1u
EbyC28BDWoJSJT2E3O8YftGPWm9eOQzvLNLZvjfwuSiDTUCkg8m7y0dnAWC9VlwS
2lKoEIEmDxPOOQfGOrr0vruh7y9WJG8PSbpEdXIvDKs7gU1LFM5JC5tnFAiHdpJ0
09IhEFZagqzG1aHDUrktnAxuz7cCjpcyjKwqcCK633JQthlq5eCos6mZwnPp/P+8
wc5HCv6wcLgwIVcBeBOtM5abpBAZyVhotvHIM9W5wzR4cneHtx2OOre6kPdGI18u
JCee8XS5+NPPFmAys9rP2bm18lo1iwm3YO3jRG9eL6Y9PU15WhykRynCcnHGlCZh
0DwaLCI1BKE0W0uYsvz96YTj5J3emkRmZ1QUkcX+0QXh+Lac3yrdoHKr5/NrpBWg
Or1ZIMjcCAaJ9Dam8HzfgmwEmnR6ZlIKaI3pQJ1OlxtEKSKXTdfYU1gij+VelPsY
5SCJfzdpzvCbj0afKlr4
=vnmP
-----END PGP SIGNATURE-----

--4bRzO86E/ozDv8r1--
