Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757245AbaHGLaH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 07:30:07 -0400
Received: from top.free-electrons.com ([176.31.233.9]:33356 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754267AbaHGLaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 07:30:04 -0400
Date: Thu, 7 Aug 2014 13:25:07 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: Randy Dunlap <rdunlap@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        Sugar <shuge@allwinnertech.com>
Subject: Re: linux-next: Tree for Aug 6 (sun6i-dma.c)
Message-ID: <20140807112507.GB15297@lukather>
References: <20140806172857.44a2a900@canb.auug.org.au>
 <53E25AFF.6030409@infradead.org>
 <53E262BF.7040509@infradead.org>
 <1407398174.3373.1.camel@paszta.hi.pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="v9Ux+11Zm5mwPlX6"
Content-Disposition: inline
In-Reply-To: <1407398174.3373.1.camel@paszta.hi.pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--v9Ux+11Zm5mwPlX6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 07, 2014 at 09:56:14AM +0200, Philipp Zabel wrote:
> Am Mittwoch, den 06.08.2014, 10:15 -0700 schrieb Randy Dunlap:
> > On 08/06/14 09:42, Randy Dunlap wrote:
> > > On 08/06/14 00:28, Stephen Rothwell wrote:
> > >> Hi all,
> > >>
> > >> Please do not add code intended for v3.18 until after v3.17-rc1 is
> > >> released.
> > >>
> > >> Changes since 20140805:
> > >>
> > >=20
> > > on x86_64:
> > > when CONFIG_RESET_CONTROLLER is not enabled:
> > >=20
> > > ../drivers/dma/sun6i-dma.c: In function 'sun6i_dma_probe':
> > > ../drivers/dma/sun6i-dma.c:911:2: error: implicit declaration of func=
tion 'devm_reset_control_get' [-Werror=3Dimplicit-function-declaration]
> > >=20
> > > Add a stub for that function?
>=20
> There is no stub for this function by choice.
> Drivers that can accept stubbed out CONFIG_RESET_CONTROLLER functions
> should use devm_reset_control_get_optional instead.
>=20
> > or that driver's Kconfig entry could select RESET_CONTROLLER.
>=20
> Yes, please.

A depends on would be better I guess.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--v9Ux+11Zm5mwPlX6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJT42ITAAoJEBx+YmzsjxAgavgP/RCGy6vv89TEjrxkTWGcpGff
NKZ47+ag42zM40LkVbmhfUbCwNXnTvoTuN2ekZ3PLyOtapV5gernOjNGbrpd2BEE
fXE5s+PYrUnqF3oDuBUasx43KBWTNafB4IH4PofDOzAPA6rxGgddDGSL/8BrP8VF
KEX2M6BUSCOacX7x1IDkSVS60TwsVNmcJhE7Qt1jrUlyzTopw8NsTdWyFE+YGnpQ
lTy1jdsnA4W5VCqsEBHpbx7bavGmrlFgiHzmQ4Cn/2N2m5PtOs7SFk7krAlIWSiC
7p2eBOdMUSxcHrCIvi0L6sBI8icRPLEJ54te1Ch/2wBUOSktUhFarpBfRuDCgJ/8
Yfy8dkmjG8ppQCXESUdLPiN5NpLd1lZVMdGjV+gT35elvH0w0nAoebd5IPiSb9pG
b2LMT2hAn617Zd3ZMSMG6cx7/3jhKG7u/tc1CN/eBlTfR7w6x9bj6f5GkClMrjnI
RknW3nr/uGhGZcuuiqmWCwZ6PYwVj0m5K8WeEn/4z9NYyQzuIbx8SrK35Q2gpkwr
n1EFbTiL9gZWfca45zZoK6rVn0FUeGdeSESrVaSN7rvGOBaNZwspTFX0DPqZMho0
XTwDcthiG7Yfik0fe45I2lG1uphxX0EgxIKpFJX5IGYYrt1vY6frs//Lz+ihEDd2
/RGRmEVREbkOiJaNVO0+
=zl0W
-----END PGP SIGNATURE-----

--v9Ux+11Zm5mwPlX6--
