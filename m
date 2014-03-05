Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756040AbaCEEds (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 23:33:48 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:56008 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754777AbaCEEdr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 23:33:47 -0500
Date: Wed, 5 Mar 2014 12:33:29 +0800
From: Mark Brown <broonie@kernel.org>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "'Liam Girdwood'" <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        "'Laxman Dewangan'" <ldewangan@nvidia.com>
Message-ID: <20140305043329.GL13126@sirena.org.uk>
References: <002e01cf3290$ccda9430$668fbc90$%han@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="nF3lCw8ylmf6enK0"
Content-Disposition: inline
In-Reply-To: <002e01cf3290$ccda9430$668fbc90$%han@samsung.com>
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 202.175.88.218
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/3] regulator: tps80031: remove unnecessary parentheses
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nF3lCw8ylmf6enK0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 26, 2014 at 10:19:30AM +0900, Jingoo Han wrote:
> Remove unnecessary parentheses in order to fix the following
> checkpatch error.
>=20
>   ERROR: return is not a function, parentheses are not required

Applied, thanks.

--nF3lCw8ylmf6enK0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTFqkWAAoJELSic+t+oim95cIQAIvByGvFrI+iQCHtyk2f6oMC
peGEV9vQywKMXHxHw6rPzv8kAp1W82DYxCQw7767+ebUEuUNVgcayko1irtHPNhv
Ei1f6Lz/J7dU/a4RJt73l1mkbuCzem3P0EAitLJryjWshBRl6txQUVaPq6uA9oGX
osbYLz5l/Vv1Lcifr07rKLDF1IxxpIUSleD4NYVBdI5SJ25y1KJooJyHuDoRKQq7
RfWWwkz11fFZI15ax6N7MNW3M0lr7vTVtYnNeAbSQ42bMjfWVQnWW1xTDrpwRJmq
h83e/VI5yNLgnLs+BRz8KNEAGyQpQkVxtGYa2Zp0fV86s3ht/ewGbd1Dvm40x/XW
qKleYFrleOADngw/yTQjvFtL90hNB/vVPR7wNQvlJ6jrm+JHw43wowYMIb/jGvm+
plRkrApzcQOS/uCRpOQ1bOrX7YBpdFbe1inxx3CeBxgiu/kgr5+hq8LgxSQBeg17
w4XLrUV2kESxozD84Cpxlspnd9QcNM0SyNkswzOs+6dfyZcQR/41ZPoIInWKvYS7
fU0jeJIhys9bAAnEW/IwXRgXZuRe6pG0rSnULLRor7kfHTpOz1srb8UwSWvI8PJ1
iZkH2fhYz2lrYrpe6O4L7ty3teRUrTtes4v0+qHeNC0A7PZBWKbErc3hCHuQ2wTi
TOPc3J+C2w76rBMwNrop
=rOyS
-----END PGP SIGNATURE-----

--nF3lCw8ylmf6enK0--
