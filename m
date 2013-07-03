Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755639Ab3GCJSS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 05:18:18 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:40215 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753479Ab3GCJSR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 05:18:17 -0400
Date: Wed, 3 Jul 2013 10:18:12 +0100
From: Mark Brown <broonie@sirena.org.uk>
To: Milo Kim <woogyom.kim@gmail.com>
Cc: Milo Kim <milo.kim@ti.com>, linux-kernel@vger.kernel.org
Message-ID: <20130703091812.GC27646@sirena.org.uk>
References: <1372815057-16631-1-git-send-email-milo.kim@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ylzTCAJcNegswXN2"
Content-Disposition: inline
In-Reply-To: <1372815057-16631-1-git-send-email-milo.kim@ti.com>
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: lp872x: fix a build waring and coding styles
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ylzTCAJcNegswXN2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 03, 2013 at 10:30:57AM +0900, Milo Kim wrote:
> From: Milo Kim <milo.kim@ti.com>
>=20
> Fix a warning below.
>=20
>   drivers/regulator/lp872x.c:910:33: warning: cast from pointer to intege=
r of
>                                      different size [-Wpointer-to-int-cas=
t]
>=20
> And checkpatch warnings are fixed.
>=20
>   WARNING: space prohibited before semicolon

Applied, thanks.  This should really have been two separate patches
since it fixes two different issues in unrelated parts of the code.

--ylzTCAJcNegswXN2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR0+xRAAoJELSic+t+oim9jYsP/1aYjirp3Xh2TDUwW8VcwWcm
W9mzpQRBbKn2imkIDwsU/kd3CvUX4qs3IJYvtcRFpMtRWM81L3VuTUOUkF67B0Km
H3Vhsl3qIT+2RPm2TSjXhkAoOFUs2iS3+mp10fHz1OJh3obUgFNuM3ckIRSynSB7
nqM7GyjrOae8nmx14kkYl6KSmjB97rxUsTweCPFizeBNioZFEEcsIyqEdQ75PwLl
pMxeB6V8PBFLOXKINxH2h2YPNjR7wCiYdfH6t6txuPpaq7V0Rl0KH3mwk45I9cb4
nAbXUoYeHjmtST+eXkFZFz37hc/NnnAf7lLr8OK8Ney4kggW3qo+GZ1sWT+G/uOR
4DgON5j24BH6YqeigZB980kArnJG38sHeqbTrOExEREhQjiWDY1kbfeujXtz8zK4
909d8oYx66Xsa7eaEfDYLR5jM9EogENGldOY6eGorXRG3NyhfniJko8pA1DSG/6E
J5cTBXs4xD1ibfCQPvN0I6Poxo0/ggf0nJiTGfDya2lipsLlvNhEGIDC6KBPtxwo
REilkmxEMEMt95zqctsi+++XLv0zbce2uqR6PerYLuTb1KzD/LOMl2OVJS+l06MA
Aji+aLwdjGjNdC/U13lqH9DgzjjVN+jmdQCJKiOJEgOJrdznMchdAzy2gsmqqgLe
f2VKGXYTk0CaITOzpb3O
=qQh8
-----END PGP SIGNATURE-----

--ylzTCAJcNegswXN2--
