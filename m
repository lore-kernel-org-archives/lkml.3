Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756327Ab3LaRUD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Dec 2013 12:20:03 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:53011 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756291Ab3LaRUA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Dec 2013 12:20:00 -0500
Date: Tue, 31 Dec 2013 17:19:41 +0000
From: Mark Brown <broonie@kernel.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Fabio Estevam <fabio.estevam@freescale.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Message-ID: <20131231171941.GM31886@sirena.org.uk>
References: <1388509244.3924.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="klUO3blZLrAR18XW"
Content-Disposition: inline
In-Reply-To: <1388509244.3924.1.camel@phoenix>
X-Cookie: Go climb a gravity well!
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: regulator: question about commit d886a041646 pfuze100-regulator:
 Fix MODULE_ALIAS()
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--klUO3blZLrAR18XW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 01, 2014 at 01:00:44AM +0800, Axel Lin wrote:

> I just found this commit after pull regulator updates.
> So why to use 'platform' prefix in MODULE_ALIAS for i2c driver?
> Does it really work?=20

No, it shouldn't work - I'll drop that commit for now.  Sorry, such a
mistake didn't occur to me when reviewing.  The reason most regulators
are platform devices is that they are part of MFDs.

--klUO3blZLrAR18XW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSwvypAAoJELSic+t+oim9Nd4QAIZMYcOb0mWBNc3Ly2Guk3JS
jc5wQoftDjNkqPcnz+XgxfVUgh/6iWWPXlUVp0u4YiEDeE3EPLSkE1MW8gyVNyMT
KcMUgA6wzwTGNAf/fFKDueC2cs0IM3yXOqbUyna11pOT9BDk+ZRK2IiJ8EELpH7i
UmC8iDjhVBA4pwzgI//P9O39ZHY1JzaUzQsLE8QBcKYd5VljFq8cuTcSxKtp8xiY
LiEJjozwjcUacLKTTU5dzpninNA8Qvz/jzRGCu7+9BzavAAs0bgxZ+7u1FbCOzTV
ZT9oEMk0602fJmCDW7Xad36s3JKO8f0hrGTn6M/WgmcbPNEHoAzi4KHij/LeHktQ
udjktcOwQq1POat6Zmnsj5W2PmhkCNy9Eq/sLnUoQbJhX2SQ256uZ3+He0lXQbB8
DQ/gKEF/i83PsqTbjfG+dPWYZMk7pugFkwJ0eZoI5X2ANHCaIOoQfEoiHkzcnRJb
aCuVEtXs3SUha7HwzM84xolyqXskRn61N4DoHBPVYVaKgXQMIJIQAiZi1kDdIlyD
JjnpYJOiRCw7fnCePff7GP5/hR7kwFpdMrej/hD0AOP+TgiVf2vRlZqHw9cUAZHP
qZ2yJKXJrkUrxRfZrwOkYAYivcO2O6WBl3YM4VtxK9f/0vnIr0gvEqQyjhHoMdDb
tsX9oKqnq+17pjRKN7Lz
=s0xZ
-----END PGP SIGNATURE-----

--klUO3blZLrAR18XW--
