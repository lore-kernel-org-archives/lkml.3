Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758885AbaDBOYV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 10:24:21 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:50331 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758816AbaDBOYT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 10:24:19 -0400
Date: Wed, 2 Apr 2014 15:23:56 +0100
From: Mark Brown <broonie@kernel.org>
To: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Cc: lgirdwood@gmail.com, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com
Message-ID: <20140402142356.GE2269@sirena.org.uk>
References: <1396447614-3048-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gfkS+pgRssjg/Rwm"
Content-Disposition: inline
In-Reply-To: <1396447614-3048-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Cookie: Printed on recycled paper.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: core: Get and put regulator of_node
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--gfkS+pgRssjg/Rwm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Apr 02, 2014 at 03:06:54PM +0100, Charles Keepax wrote:

> We should be incrementing the reference count of the of_node for the
> regulator when we take a copy of it. This patch does so.

Why?

Note that in any case this is going to have absolutely no impact on
practical systems since everything using regulators uses FDT at the
minute.

--gfkS+pgRssjg/Rwm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTPB15AAoJELSic+t+oim9AoUP/jJ2ditqOURGHqXIEOUg8kZi
0bJc3QT4G4aqL4fZPHMyQoNMdDa6gxDMwVhGdnXdyx1umFZUX8H5mhbTFAITy1w5
eHa2y1b6wQFHPpzzfODrecXbAc11OfsMobS3AxBwoSp0Pt0BCn08WtMSZcIPAuwJ
oyl1UNy7yQmW7j4PZ9TJ0L7ivxB3dHy1FiVM113XVOqN6gmmd7WNGnHddQWVCKv0
B4FMiK8Lz4HyPlW07gQh9mbN5mYU4FczAWMWbTjOi4IWpwqqJmv+J1YkLcYcTGpb
nKAGOKHFh3VxenaYmZiww9DsnQmMbIHDwlBps3NIdtmNN3lSANtPF2BlZ1bYXVbu
h6PXFWc5QQt6l2qxM3QFkIkoI1UgaNMhvzsyairTiNW9GUMbfNvCi5ZiuvVb11Hz
G5TwZlZfwV9A83u+8CZp2qJSGOvSZ7/mAB4Y0cCbk/C8p3Af1FDluXaQ3QkrcY0z
H9stdBk1JAlpE4S2/5yOvPQYVw15NoS9DF2/RXd7+3r2w+8ij2u64tNWpm9Jyj4P
PPTxaZk+21yfcX/JTeVoSNZbL3SsW9fu5m/VMj4Y+Sd0ZqtVGaWlSMp2uNV8aDbS
RgILbmWtBsnA6MCgPBsfTiX3jnJx75RcM/cyz3SsjCvUr31DHT0Mx2KlJt1qB0I0
/rJHeXjqVoXCeVrGdnE4
=dGlu
-----END PGP SIGNATURE-----

--gfkS+pgRssjg/Rwm--
