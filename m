Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754183AbaKSJGN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 04:06:13 -0500
Received: from sauhun.de ([89.238.76.85]:52665 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750757AbaKSJGJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 04:06:09 -0500
Date: Wed, 19 Nov 2014 10:07:28 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: James Hogan <james.hogan@imgtec.com>
Cc: Andrew Bresticker <abrestic@chromium.org>,
        Ezequiel Garcia <ezequiel.garcia@imgtec.com>,
        James Hartley <james.hartley@imgtec.com>, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i2c: img-scb: Allow building for MIPS
Message-ID: <20141119090728.GA1439@katana>
References: <1416355113-8942-1-git-send-email-abrestic@chromium.org>
 <20141119000308.GL1739@jhogan-linux.le.imgtec.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5mCyUwZo2JvN/JJP"
Content-Disposition: inline
In-Reply-To: <20141119000308.GL1739@jhogan-linux.le.imgtec.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--5mCyUwZo2JvN/JJP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 19, 2014 at 12:03:08AM +0000, James Hogan wrote:
> On Tue, Nov 18, 2014 at 03:58:33PM -0800, Andrew Bresticker wrote:
> > The SCB is present on IMG SoCs other than the META-based TZ1090,
> > such as the MIPS-based Pistachio SoC.  Relax the Kconfig dependency
> > so that it can be built on any MIPS or META machine.
> >=20
> > Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
>=20
> Looks good to me.
>=20
> Acked-by: James Hogan <james.hogan@imgtec.com>
>=20
> Cheers
> James
>=20

Applied to for-next, thanks!


--5mCyUwZo2JvN/JJP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUbF3PAAoJEBQN5MwUoCm2BkkP/Rfkudxo76QE8eg2cpf2Vmjn
XjgYl6c//YO9Vi9J5MvajPGNhEgtRzq2J4VF8MlnUNVUYi00NaSuFwQF6PZFt0NS
pUpKorkcwdLOxNd4KktWxFLBA7lcivs/LTBjYP+Fpl5o/j8rDeJe+kQlHPI06YT8
0sA8MUAFXBzno3KsKQ8JgCbxMSO13El41Hhn+WedkpmGIUNkVfbUV/lOubdO55PA
pD72KDsm5B8wRPu/Pxau5TRkz6Oi1mSn6Kwk4u7541CNxsEdFXZ3r2k8y2yibZiF
CdUegGMGj1BLdgF7covYnHvYeV2w5/3t+BB4lSZXxSfmjzRdQNPsOgwTyjglQrEs
hoCG+9+H6QhOsA9SrgRNNiJ8wgvxHryGlh8nJDiciCs2c92BBp6b5FNbbrzqjZHL
BQ+iiM8UFUe/J2TlEpqhh6shC1pPDdo0KKBfEURbVmUVUGZ5bvCWLv5FuOk+HlAb
SlpbopHspdt9YjwuvuM6XjY0Z5QQixdgcmHtKR2hb8fEwEQiQvAKkfoJ/Dhcx871
EV4W9+Q9vQjrMx8Hz/0OfxakBIx/UjmDGm3mQJCyY03NgVFnxO0hXLOFb7r4vuzI
T9tn1QcAjzb/2gIYfYLTbvfOvfltc11+jRmcjFcuVsvAVZxXduj8XdxC4AE/pOLq
t+MDhU/qKfmEBl7oC29K
=lbF/
-----END PGP SIGNATURE-----

--5mCyUwZo2JvN/JJP--
