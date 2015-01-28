Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764582AbbA2Dph (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 22:45:37 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:38398 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753718AbbA2BZi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 20:25:38 -0500
Date: Wed, 28 Jan 2015 19:43:51 +0000
From: Mark Brown <broonie@kernel.org>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Message-ID: <20150128194351.GM21293@sirena.org.uk>
References: <20150128191531.GD10259@mwanda>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="jaKl7zOFrmg1nrKt"
Content-Disposition: inline
In-Reply-To: <20150128191531.GD10259@mwanda>
X-Cookie: My LESLIE GORE record is BROKEN ...
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [patch] regulator: qcom-rpm: signedness bug in probe()
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--jaKl7zOFrmg1nrKt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jan 28, 2015 at 10:15:31PM +0300, Dan Carpenter wrote:
> "force_mode" is a u32 so it is never "< 0", but because of type
> promotion then comparing "== -1" will do what we want.

Applied, thanks.

--jaKl7zOFrmg1nrKt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJUyTv3AAoJECTWi3JdVIfQE54H/RbZSD2k43VaX8u003oWAN0r
aL8LZ/3qXCxrRUa5ZSQe77HhDNk3YZSAEcVyOkjjPW3QzNcJxdhYpbfEs2fIf85L
zCoyqv5nAKWhz577EhsxzqQIntWLk4T5ryGe5XaVAr45ZvsqjNeRCHsQsWge9yeu
tyjK8yEm5+xe0swpXkhJeG7Nx/lfzDEmKfjR8iRWlCAe9aosmYAnmx1w5LiAjOMd
RLfetl2LWYKqF70YWZZ5sk85qWD6obJc3u8A8OM9EVhguIvPTqcdT9DU38mj8E2E
M/8DX/rsr6YPsBnO2al/h6RVX13hUortwKNM6ueRfGgKa1urZzwCJ95BdNC3STU=
=fdCS
-----END PGP SIGNATURE-----

--jaKl7zOFrmg1nrKt--
