Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758556Ab3EGQE5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 12:04:57 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:53894 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753413Ab3EGQE4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 12:04:56 -0400
Date: Tue, 7 May 2013 17:04:31 +0100
From: Mark Brown <broonie@kernel.org>
To: "Kim, Milo" <Milo.Kim@ti.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-ID: <20130507160431.GV7478@sirena.org.uk>
References: <A874F61F95741C4A9BA573A70FE3998F82E5C95D@DQHE06.ent.ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="QILrdhYozogw5Vly"
Content-Disposition: inline
In-Reply-To: <A874F61F95741C4A9BA573A70FE3998F82E5C95D@DQHE06.ent.ti.com>
X-Cookie: You have no real enemies.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 82.42.102.178
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/2] regulator: support operating mode in the device tree
 structure
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--QILrdhYozogw5Vly
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, May 07, 2013 at 01:09:14PM +0000, Kim, Milo wrote:
> For better power efficiency, regulator subsystem provides operating mode.
> (fast, normal, idle and standby)
> The operating mode is selective by a regulator consumer.
>=20
> With this patch, regulator operating mode can be set in the DT structure.
> If any operating mode is configured, then 'valid_ops_mask' should be set =
with
> REGULATOR_CHANGE_MODE.

It's not clear to me that these modes are a useful thing to be exposing
in device tree - they've always been rather arbatrary and are becoming
less and less relevant as regulator hardware improves in its ability to
adapt to load.  I think for fixed modes that don't vary dynamically at
runtime the best thing is just to make the modes custom so they map onto
the device datasheets clearly.  That seems to be most of the usage
anyway.

--QILrdhYozogw5Vly
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRiSYLAAoJELSic+t+oim9+rUP/jSmrlwwo7p1o836rqQ9WoBu
5rpicoe05E/TEt1DNw5cVPh6wwYSAfDlxw+0bBhD51FY2OvJ3rfVV56AorW0OXhU
sUuN7FUcjo6lj2W7Um7pZu0eTWjw+xkDyuisv5Jo9RA3u7L21GE7/GOW4NaciuDZ
6F28i3R/OgmCgRCbvkNl5gBwaop6qhF1tRn6ppE1MIUl3poJzM6C70YE7M6u9W34
Lc7P+RxA888wcbNrM8xxEjQkQmcXs+BWD46j5VtHpIkzuWRGXTppT5gm69P/ii2u
xbv+AxGT/6A9pcncBnMVClpfQN+hdgW+d02brdRDLvC3dcb1IDgFSGAX+e5vzKwg
/pnb29MGRilX9EI6QC1fZEdPVtaUK3MdkjY4HXq6wCzZf6tUOwIEvzD9bKTZ8/ik
/zoP9Ptn+cguQEVWlmA+5jTL4g7RDRkBHlVgcatG4G+zt6cf9BqUBTCe9kmQTsj6
mkVn2R6I9pdSG5FcnWGB3bOSXoC6TQmuwfFGEVjk70UxJsKQYbDZWjnp/S1HoVDJ
5ErbiCNHyLsitJW+P/7x7iwC+nIFU4By0EcVvhJFHAoNonKid6WYoNaTO8IgRikc
LKfSCOD50oMEiIFGGI+WCYK1nUrqGM53b8qKrhfZI4sqm+hI1J2d4NvzPFo3pDtt
i/LqCxg8XdOR6dg7hh2+
=aa41
-----END PGP SIGNATURE-----

--QILrdhYozogw5Vly--
