Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751389AbaKUSOc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 13:14:32 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:33980 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750710AbaKUSOb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 13:14:31 -0500
Date: Fri, 21 Nov 2014 18:12:53 +0000
From: Mark Brown <broonie@kernel.org>
To: Christophe Leroy <christophe.leroy@c-s.fr>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-spi@vger.kernel.org
Message-ID: <20141121181253.GX3815@sirena.org.uk>
References: <20141120162418.04FAC1A9BFC@localhost.localdomain>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="RyRVxeT1fPSLkipE"
Content-Disposition: inline
In-Reply-To: <20141120162418.04FAC1A9BFC@localhost.localdomain>
X-Cookie: Some optional equipment shown.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] spi: fsl-spi: Don't use cpm_command on CPM1
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--RyRVxeT1fPSLkipE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 20, 2014 at 05:24:17PM +0100, Christophe Leroy wrote:
> On CPM1, when the SPI parameter RAM is relocated to somewhere else than t=
he
> default location, in accordance with freescale documentation
> (refer micropatch SPI application note EB662), init RX/TX params command =
shall
> not be used because it doesn't take into account the new location, and
> overwrites data that is in original location of SPI param ram at addresse=
s=20
> SCC2 param base +  (u32*)0x88 (u16*)0x90 (u32*)0x98 (u16*)0xA0, hence bre=
aking
> activity on SCC2 if SCC2 is used in a mode like QMC for instance.

Applied, thanks.

--RyRVxeT1fPSLkipE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUb4CkAAoJECTWi3JdVIfQzEIIAIBpGFtzX4a+MGQh8q+sJtEs
AwPTpoaGY/EzbgYSx39srYrjQD17FK5uogXnDRYcg62BEIbvix2PQrNgADXK0xLi
wF6VY2ApnMnyoBZQKx+yT0d1esADAswtX8pfkD2yL2WroIwIfCtC1six4uXZB2WC
UEantw8K25PTJfNLT3N82Cb21qclcuA1vUYe/Q+8dtQKJzz+kt+v4Q8dZCKqoiWf
lvA43RWlFLXfjjQnCfpb4v4Cm1sNglJkuMsJS+opiKMvjq9b1NkPL3rs3ysb5NyG
9haY99ntFjTYydZEmsQT1YBAsjfR01rCuaJnee6jWJZWMx46t5oLG1OGaymWQf8=
=uMc0
-----END PGP SIGNATURE-----

--RyRVxeT1fPSLkipE--
