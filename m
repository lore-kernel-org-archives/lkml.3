Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751720AbaF2OLL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2014 10:11:11 -0400
Received: from top.free-electrons.com ([176.31.233.9]:49482 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750840AbaF2OLK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2014 10:11:10 -0400
Date: Sun, 29 Jun 2014 16:00:42 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: hdegoede@redhat.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] phy: sun4i: depend on RESET_CONTROLLER
Message-ID: <20140629140042.GH3385@lukather>
References: <1400871088-16894-1-git-send-email-maxime.ripard@free-electrons.com>
 <20140611091035.GD4254@lukather>
 <539824F9.6050302@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mhOzvPhkurUs4vA9"
Content-Disposition: inline
In-Reply-To: <539824F9.6050302@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--mhOzvPhkurUs4vA9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Kishon,

On Wed, Jun 11, 2014 at 03:14:25PM +0530, Kishon Vijay Abraham I wrote:
> Hi,
>=20
> On Wednesday 11 June 2014 02:40 PM, Maxime Ripard wrote:
> > Hi Kishon,
> >=20
> > On Fri, May 23, 2014 at 08:51:28PM +0200, Maxime Ripard wrote:
> >> The driver depend on the reset framework in a mandatory way. Make sure
> >> reset_control_get is defined by adding this dependency in Kconfig
> >>
> >> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> >> Reported-by: Arnd Bergmann <arnd@arndb.de>
> >=20
> > Ping?
>=20
> Will queue once -rc1 is tagged.

We're almost at -rc3, and I don't think you merged it. It would be
great to have it in 3.16.

Thanks,
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--mhOzvPhkurUs4vA9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTsBwKAAoJEBx+YmzsjxAgxzMQALVArPOy+0ixmQ2AnwuZ2Pti
sRPVTVBcOQctr74JFqoaYx+H0oiWciJEfzyqzXrHgDT4qPoKpq1Sq0QiNu1c8wD4
UsgN8aQy/D5EiAHS9phNE8+vs8iawcSvgFGRqhUn3s5Rr46Llk7XYHnTXE/ZsbvK
0QGlZmyb60tfd9NgUV1CPZv/5N6GHHuaDf4JLiWqZ9bHKLdbFCQkTSNzCJhy05dK
KAEDMaFGxrDyI9oemgqMNvhY2E4uhAzoau4ouxu/yeGgpvJ7avajQQkCI6ebgNGQ
wLO9Z4kBz/riltDS+1yyyz6YdvUlpofcMzSmduEhC4jxXHl4v6g8/jKOQVICYDEB
2i10unJxbdfUsdERhLYisR/Yl5GR1M9Luwl39iVLyROuyeiC7YAtx8iB39A9c7Zg
vdt+OPyvRK9vQ5DUmauL5YSuA3VgFACmweC5rVO9xjM0KgM9QhirOEi4S7E4QYVZ
ou9BvZcAnYBGVpNb5bF8H3gZZU5niFLJ2XUn+s5QQ53VMUZ/H17TCgo0yfMaHdoW
CmSUv1Zwqv7ZxyqN3RDyKgpYHq2m0BZ7VfZy7lTAhSPNrkxANYAvKE8lr9Yltj3z
TMFClgFIHbqWJ+3S3TcM8qjinEixNfM18TBixgrAaDWey52sdxlIiOX6aml0VZ+x
YD/neaFmu99OnCHQ41RD
=18ko
-----END PGP SIGNATURE-----

--mhOzvPhkurUs4vA9--
