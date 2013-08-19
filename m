Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751121Ab3HSKDr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 06:03:47 -0400
Received: from sauhun.de ([89.238.76.85]:57293 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750929Ab3HSKDq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 06:03:46 -0400
Date: Mon, 19 Aug 2013 12:03:44 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Vinod Koul <vinod.koul@intel.com>
Cc: linux-kernel@vger.kernel.org, Dan Williams <djbw@fb.com>
Subject: Re: [PATCH 04/27] drivers/dma: don't check resource with
 devm_ioremap_resource
Message-ID: <20130819100343.GB3091@katana>
References: <1374602524-3398-1-git-send-email-wsa@the-dreams.de>
 <1374602524-3398-5-git-send-email-wsa@the-dreams.de>
 <20130819085857.GY32147@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="aVD9QWMuhilNxW9f"
Content-Disposition: inline
In-Reply-To: <20130819085857.GY32147@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--aVD9QWMuhilNxW9f
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 19, 2013 at 02:28:57PM +0530, Vinod Koul wrote:
> On Tue, Jul 23, 2013 at 08:01:37PM +0200, Wolfram Sang wrote:
> > devm_ioremap_resource does sanity checks on the given resource. No need=
 to
> > duplicate this in the driver.
> >=20
> > Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
> Sorry looks like I missed this and instead applied a similar patch from J=
ulia
> last week. I should have taken this instead. My bad...

Fine with me, as long as the issue gets fixed :)


--aVD9QWMuhilNxW9f
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSEe1/AAoJEBQN5MwUoCm2me4P/2IyruS9y5PhPQlTaKIqTmCz
k/CkpgwGfKikJPn6JD4AU8MgAyDx7hahNiBUvvwnmoiBiN7u8ggDN+n9GiTOf7NZ
CsCxwwPYVoffy71q+C1DvKqmFuhGeIt2o0E1+CDkZmBg8qo6wGWkmWdT5WsPPDeM
wc6E8Xq8z5jTFm9rj4UD6KFh4IodBt8GIT9Mphf5i1pqYbHIOK0A92DpZx30RJ/h
/a2sgrJpr7hYOEosmxwEhzZPHkRrdq1X3duW/KIYDNew7vFGRd/j6LsXSTBNpHam
DIuDkGoifC7GtyqOVsxX6uMAdSvJvP7o+tXUTgC17/M3n40lTLGaTkfKZ8GnzACF
eSDBV8YxdbTFMt446Xww55ok67BssR1h4UANWJdFnIGMbLCAFvYd+rHlC+LkaNjL
4G0ceUY2PQerINMfo51bxZtc7DumvfSVB9McbNVR/vJmcmORXbLu7GyyJlIHfPqG
bELqYWq4pmhvg4UIJG2/WTKZrtBm+YJh6q6iUQZYyKkSA4zNFPJAC/JMP2Nl1pr5
gR5L3jJclu1jlm+KlpUtZFvW2exEP5Uhy5dLD9PW6hcxyBx5iMjhZJuNpbk50fWd
bl9+v7vpAoFZvpg2n35WJLVYb1vW0RrMiA93W/xnbeMtQbxev/I7XzihfE98gzsO
G3qtWY5+mP8Ws95qwqIM
=7D3g
-----END PGP SIGNATURE-----

--aVD9QWMuhilNxW9f--
