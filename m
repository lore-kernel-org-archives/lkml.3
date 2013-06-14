Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753226Ab3FNPV1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 11:21:27 -0400
Received: from sauhun.de ([89.238.76.85]:44931 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752021Ab3FNPVZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 11:21:25 -0400
Date: Fri, 14 Jun 2013 17:23:21 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Gregory CLEMENT <gregory.clement@free-electrons.com>
Cc: linux-i2c@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        linux-arm-kernel@lists.infradead.org,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Nicolas Pitre <nico@fluxnic.net>, Lior Amsalem <alior@marvell.com>,
        Maen Suleiman <maen@marvell.com>, Tawfik Bayouk <tawfik@marvell.com>,
        Shadi Ammouri <shadi@marvell.com>, Eran Ben-Avi <benavi@marvell.com>,
        Yehuda Yitschak <yehuday@marvell.com>,
        Nadav Haklai <nadavh@marvell.com>, Ike Pan <ike.pan@canonical.com>,
        Chris Van Hoof <vanhoof@canonical.com>,
        Dan Frazier <dann.frazier@canonical.com>,
        Leif Lindholm <leif.lindholm@arm.com>, Jon Masters <jcm@redhat.com>,
        David Marlin <dmarlin@redhat.com>, linux-kernel@vger.kernel.org,
        Zbigniew Bodek <zbb@semihalf.com>
Subject: Re: [PATCH 2/2] i2c-mv64xxx: Abort the mv64xxx_of_config if
 clock-frequency is not provided
Message-ID: <20130614152321.GE2929@katana>
References: <1370620140-17177-1-git-send-email-gregory.clement@free-electrons.com>
 <1370620140-17177-3-git-send-email-gregory.clement@free-electrons.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hwvH6HDNit2nSK4j"
Content-Disposition: inline
In-Reply-To: <1370620140-17177-3-git-send-email-gregory.clement@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--hwvH6HDNit2nSK4j
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 07, 2013 at 05:49:00PM +0200, Gregory CLEMENT wrote:
> From: Zbigniew Bodek <zbb@semihalf.com>
>=20
> This commit adds checking whether clock-frequency property acquisition
> has succeeded. Do not waste time to find baud factors if there is no
> information about the desired bus frequency in dts.
>=20
> [gregory.clement@free-electrons.com: Reword the commit log]
>=20
> Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
> Signed-off-by: Zbigniew Bodek <zbb@semihalf.com>

Please run checkpatch.pl on your patches!


--hwvH6HDNit2nSK4j
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRuzVpAAoJEBQN5MwUoCm2CSAP/irODxSBxuj5IP/oFtEIofAz
aBHOfZ8gGu1/yG49gQlVnfts0h1cEHzgoeWPiiPdmQOqsJNi4DaOCTxDYoFLSJFv
H5ttu8xxkRuUzmKpQ3QsZ7GLOn4Qo+qh06yNlioc/bCZudBF5EC0xyPPXYYb09NV
qiUVIOtsmvdoGVhV5BfY6pXR8shmekpbXlumRKZFbujy/Z6oaWxxrww4FRiha3BN
Cp8esJPreUKFotLY0X5zyonP3q2BoIzLsT8N2bl84lhgyK3KTkflCm6QuNTcYkKX
OKgap/ow3begYByDFTCFRjgyot/xcIXBgaoJ+exJe4yD4wHwfp4zRgE8SkwKKxHy
BZbme6dDXJDXeOE8+mNmGYIZeLMLkeUPwpW4FEiQSnBxq4YRHYq/fdTyp2bzGV3i
scWdeH5WdCGDab487r4c8Nt7NBFIXyuLjSoNX1LUcTTa80kyRotwOcTPcAUI5PID
Wb0Te5o3ALDlC2+teDTYrYmA9jApU31Tjqqz3yfXYZNaaYzrSbSCLSDWm1lQ/gFa
07j2iHzEFg2FUagCrDyDBMipJh3w5/NPXYbB1rSmYwmmTlSkkKX40w7BbNGc/o6M
NK5dGIznYVufWVElWEILe0gygBimnboj37/B14Ev9arUOj1j9zZbs/DAF8g67pGf
dWgpfuoqUDxh2L+8cuoL
=1AoX
-----END PGP SIGNATURE-----

--hwvH6HDNit2nSK4j--
