Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756211Ab3AWP6t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 10:58:49 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:49473 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754872Ab3AWP6s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 10:58:48 -0500
Date: Wed, 23 Jan 2013 23:58:37 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Vincent =?iso-8859-1?Q?Stehl=E9?= <v-stehle@ti.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regmap: debugfs: Fix compilation warning
Message-ID: <20130123155834.GD4565@opensource.wolfsonmicro.com>
References: <1358779015-25735-1-git-send-email-v-stehle@ti.com>
 <20130122064121.GC1766@opensource.wolfsonmicro.com>
 <50FE64C8.8040407@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0IvGJv3f9h+YhkrH"
Content-Disposition: inline
In-Reply-To: <50FE64C8.8040407@ti.com>
X-Cookie: You are standing on my toes.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--0IvGJv3f9h+YhkrH
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 22, 2013 at 11:07:04AM +0100, Vincent Stehl=E9 wrote:

> Do you think there is a way to "mark" the list_for_each_entry() as
> iterating at least once? an __attribute__ maybe?

No - but are you sure that's true?

--0IvGJv3f9h+YhkrH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRAAikAAoJELSic+t+oim9mM4P/jRb4Suytrl/Cw3UvRSlGrGj
qkawuuT/iWffhR4l5ZTF6+u+xkkP97nxw0WSMW7lcI652lEfc1fgYHFIj1T3Qomb
47z61Gu4GrEy9Zd6fBVc7kHzbEQYVPwDjGtK75BXLu9oz76Q92KLgXOay4oOLE8V
GabLcMqD8dkRYUbDAH/gHnoodjrh7iC/S/RdZr84Las57SICFOTdw/BN6JEiA09O
+4um5OGrF8VSloVeQbrizSjiSlQ0p+dNJxdlx5R+G9yXfSqZv3sUOHFP7uxmE570
KEYDfR9dyEovDyGAxGK0vW7NOyK4tdcZiP/naxPDlwxt9eMKRc8uftOpsXKX0sCC
LEb/7aHmc4oxyocRSsX21Px+kU3a8uqOCR45xCgWfK7KBEYenBW3iJH3y1mqoNPC
vJndc9jCu1dK/gQzWCdIupj8AIuQsnzUZKhyWUH24iS6U4HFed/9SqnmmYoHb6TR
rRsQrLgHstGsX2bAFBtnwN1mn7BLJEaxBtuwKsbDkFVsLtRlLyZkDr5+XQ7FAeZj
zI09K5rZNgqPN4o8vPNiAO0+CaBcuvwVQXrsjYRBVIBG43V37s2FVVi4P1XXygtD
uVkJUZjMsJwEFmLOQSF9+aG7/tHdbvzzb12x2qHkXPOmObNzgPiU24dQlQZrdSax
naTo9gTZgx9+0AcNbsL6
=LmiQ
-----END PGP SIGNATURE-----

--0IvGJv3f9h+YhkrH--
