Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752699Ab3FYKQS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 06:16:18 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:48171 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751054Ab3FYKQR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 06:16:17 -0400
Date: Tue, 25 Jun 2013 11:15:53 +0100
From: Mark Brown <broonie@kernel.org>
To: Girish K S <girishks2000@gmail.com>
Cc: spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Message-ID: <20130625101553.GZ27646@sirena.org.uk>
References: <1371794173-27266-1-git-send-email-ks.giri@samsung.com>
 <1371794173-27266-2-git-send-email-ks.giri@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dlFvqfizQ5ooaSx9"
Content-Disposition: inline
In-Reply-To: <1371794173-27266-2-git-send-email-ks.giri@samsung.com>
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/2] spi: s3c64xx: Added provision for dedicated cs pin
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--dlFvqfizQ5ooaSx9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 21, 2013 at 11:26:12AM +0530, Girish K S wrote:
> From: Girish K S <girishks2000@gmail.com>
>=20
> The existing driver supports gpio based /cs signal.
> For controller's that have one device per controller,

Applied both, thanks.

--dlFvqfizQ5ooaSx9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRyW3QAAoJELSic+t+oim90fEP/2y46wbntcSs+GkQcLR4ffvo
KGIDHJr612D7U5iD79yUSpGaV3WSmNyXVN0TpF8oXmUq+/Y+kmmXjICUr083+P0Y
Cf4msopAlojPet3PbQTWLl4qRr9u4VqNrwRucPCRYTirc+EVmpL0a1iCm8K1Zk3i
X0R7B+RH0oVWIh5d3a6YRqD4i0G8ILnzOnCQDM7BkzAm5hMerDHGSOoai37I/Vw2
VGAQkvB92febpzzWzea+Y8ou8Qdp0rdMah7f9jnG1PA9nmjHlszrWPoEACfBY2X0
Ctf+X0xKnnySQOZmGirXAhu1W5l9TtA+W2HlLHZX+julk3J3fpKkV6vXfB+1b+oA
jfS2MPV3xfMGsHfMNfy0kRu9+bRRTYBYR9xesnJmE5XqYsn6gNc2zoTbUgFm3kL6
RWnUaubRDo5vEJHEF9u/H7meVHnulwZNJ3Gtz4/2nzSjsGTDzVeZKV0knWFbC9j9
zfBNnhIAxqD89yJ7HBnJAJEfoF/n27apr0VJkCHm98uHgy/LafpDNGd5/KWojONR
lUt0u9eg4S3IhzCqgpvqUGhtY0I3ADLThhhrHS/tN9t8dE8MBlkkYrijRTN0nyL4
Y4SN53TMy82FmRIEYUAZkNqGpQIa84BTsadV8t/ue4wyaEQ5+xp7HzLe1j0lmvBS
SyeQW6Jl+x3xy4C5D95B
=rfNh
-----END PGP SIGNATURE-----

--dlFvqfizQ5ooaSx9--
