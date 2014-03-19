Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933953AbaCSNSi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 09:18:38 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:35978 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933896AbaCSNEC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 09:04:02 -0400
Date: Wed, 19 Mar 2014 13:03:48 +0000
From: Mark Brown <broonie@kernel.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Sangbeom Kim <sbkim73@samsung.com>, Liam Girdwood <lgirdwood@gmail.com>,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Yadwinder Singh Brar <yadi.brar@samsung.com>
Message-ID: <20140319130348.GG11706@sirena.org.uk>
References: <1394187052-591-1-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8INPLRapBWUpgqwG"
Content-Disposition: inline
In-Reply-To: <1394187052-591-1-git-send-email-k.kozlowski@samsung.com>
X-Cookie: Turn the other cheek.
User-Agent: Mutt/1.5.22 (2013-10-16)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 0/3] regulator: s2mps11: Add support for S2MPS14
 regulators
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--8INPLRapBWUpgqwG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 07, 2014 at 11:10:49AM +0100, Krzysztof Kozlowski wrote:
> Hi,
>=20
> This patchset adds support for the S2MPS14 device to the s2mps11 regulator
> driver. It's a subset of previously sent patches for S2MPS14 device:
> http://thread.gmane.org/gmane.linux.kernel.samsung-soc/27194/focus=3D1649=
217
> along with one new patch:

Applied all, thanks.

--8INPLRapBWUpgqwG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTKZWxAAoJELSic+t+oim96RcP/j6Yp7wU+jJ8RMPrBfxQYzIP
zk9I+s9oxpLAAj2ZvX0ergze30yQUbVKxWMke3y+3dBPndgwitpj1nYCRq1vcrJC
c+QZDmzOj8kFZivZNCroZ0O4zzR4vLFOX+qHR+n7tp6Rx+ytdOtNKKMF/759uQZs
OxSs2LYJx0+82Lf+MPjRCNhbbAov4B7nwtrCIybWu77UpcWcwrI212jnOX6+Zl3k
mc1/EZ+UUQjhF3vYUAzNfo+7QySGIm2Po0qZDYFPyOWDOm5IaLO8hBhhTutOlbEL
3efj+rXpr6EsD6WAi0rn0ViuNnfqJkiX7FVUhmnndxopK1RBanBg2HBj0qw0dz8i
aiyAS/4A5OPhnZ94Tc/BpWk9b2kshxplb4kQZi6kfkyQO/w/Xg1HKa3hHe4JYJMU
q0OV2qr3dT5JYbLYyh2/qV89m69cFVINUib6Sswg4w62k7gnOLSJsn5cY0QgwbC9
yXh9mvWOWk7nNA7KwlVP2CHMN7vGJ2kGCbnt6AuoYwwHj+nixIOZInjoFe0qnp1L
FK/0+3mGUSqjeHjI6Ns/9Ry6EEELcv+HNuU37SCGeeFaZCLZHaPJGLFHK9cMHwbr
DZbTDFcg41ZDZRwWW3gsRnxRcMSy71RvUvYq0ZMcxFf7AI1gSbfOVer/4OLsU2Sx
4aIrdnMSB8WJzWHfmFDY
=m+2D
-----END PGP SIGNATURE-----

--8INPLRapBWUpgqwG--
