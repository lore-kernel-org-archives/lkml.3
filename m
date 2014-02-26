Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753758AbaBZVAn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 16:00:43 -0500
Received: from top.free-electrons.com ([176.31.233.9]:41220 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750814AbaBZVAm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 16:00:42 -0500
Date: Wed, 26 Feb 2014 22:00:36 +0100
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>, linux-kernel@vger.kernel.org,
        b.brezillon@overkiz.com,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/7] Documentation: dt: iio: improve atmel-adc
 documentation
Message-ID: <20140226210035.GD20517@piout.net>
References: <1393434074-15600-1-git-send-email-alexandre.belloni@free-electrons.com>
 <20140226173904.GG607@lukather>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="8NvZYKFJsRX2Djef"
Content-Disposition: inline
In-Reply-To: <20140226173904.GG607@lukather>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--8NvZYKFJsRX2Djef
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On 26/02/2014 at 18:39:04 +0100, Maxime Ripard wrote :
> Hi Alexandre,
>=20
> On Wed, Feb 26, 2014 at 06:01:08PM +0100, Alexandre Belloni wrote:
> > This corrects the example by removing the unit-address, as suggested by=
 Mark
> > Rutland in
> > http://lists.infradead.org/pipermail/linux-arm-kernel/2014-February/234=
184.html
>=20
> I still belive that it's wrong, and Mark haven't answered my comments
> on his statement.
>=20

After our discussion, I'll go for the other suggestion, I'll add
#address-cells, #size-cells and a reg for each trigger.

> I'd vote for a status-quo, until he gives an answer backed with
> references to the ePAPR.
>=20
> >=20
> > Also, it removes the properties that are not used anymore, to stop prop=
agating
> > them.
> >=20
> > Finally, fixes a few typos.
>=20
> I'm fine with the rest.
>=20
> Maxime
>=20
>=20
> --=20
> Maxime Ripard, Free Electrons
> Embedded Linux, Kernel and Android engineering
> http://free-electrons.com



> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel


--=20
Alexandre Belloni, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--8NvZYKFJsRX2Djef
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBCAAGBQJTDlXzAAoJEKbNnwlvZCyzplAQAIWk31MS90E35KKlqxIkM71A
b8fWj29WagQv2oxvPMwJkBcE0bpqOfkj6+cbhShimgNYMJpbU8ZauWhdB3jNPcWM
gknRJzyCb37k3HTXd7CgT0+9/aeMYoHLTcAVNaKQGG6eAbPlY9wYnW/pwSB7QAax
oeHcluEGVHnQitHZ6oLsIIl1x1J8wmCzpQYH8pj3sJJGw5bUgov2m1zoxG3uj5XZ
E89hRYyNGKAjbGL/SpMJ5yuQJgZvSwqPXt5RxCFQLHp8WZr06yVxj8Q3HjRqWpmg
deBfK5HHN6vgOFMbd4cUBQG0pCF7W3kosy6XDZm5jp67TgPcIaYDjNhw0j4SKJ9t
dkTvkUGxdR5ISlqKtNS7THdzaKEIuhUq2zBwIxMMOWOrTFvHSs5insONA2kow0jP
yFoxEekI1n7lfDwjrjk9zdApqafn+GqOx9VtRWkT1SKDYRfALkfpAFMxtoX3jvYw
AnetWOJDtgAfHVNvpdoiMWDEpNL93lZNsskMSvHRhWw4jVeMGZ2TnfAEIaIFs2ft
EjP80djBxd92PAncjSWny4Cq9dASNsENQuxYPnjaOrJ5RBwfI8Ah9hpY+d/4A+EL
dTLzUGpOnzA9YorRFBIRzmf4PwOXHeQXP1UzKtkuICvHsudeY7JWOWFk6KrLbeRq
mCt+CroEMOvL9w0HWYOx
=11BW
-----END PGP SIGNATURE-----

--8NvZYKFJsRX2Djef--
