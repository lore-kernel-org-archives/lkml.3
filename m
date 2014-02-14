Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753528AbaBOKK4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Feb 2014 05:10:56 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:60725 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753486AbaBOKK3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Feb 2014 05:10:29 -0500
Date: Fri, 14 Feb 2014 21:22:04 +0000
From: Mark Brown <broonie@kernel.org>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-kernel@vger.kernel.org, lgirdwood@gmail.com
Message-ID: <20140214212204.GN4451@sirena.org.uk>
References: <1392378602-32302-1-git-send-email-sachin.kamat@linaro.org>
 <1392378602-32302-16-git-send-email-sachin.kamat@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Zz8eIV9MTSc31S3o"
Content-Disposition: inline
In-Reply-To: <1392378602-32302-16-git-send-email-sachin.kamat@linaro.org>
X-Cookie: Your lucky color has faded.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 175.45.49.105
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 16/16] regulator: tps65217: Use of_get_child_by_name
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Zz8eIV9MTSc31S3o
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Feb 14, 2014 at 05:20:02PM +0530, Sachin Kamat wrote:
> of_find_node_by_name walks the allnodes list, and can thus walk
> outside of the parent node. Use of_get_child_by_name instead.

Applied, thanks.

--Zz8eIV9MTSc31S3o
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS/oj5AAoJELSic+t+oim9/O8P/2WVUOns7s4lTkjWq4VuS6GN
9BxwPP4Jj6Ayo/OKIeZosfBg5LSOqZbWGTXCjYhCHY+0rrHL/gs6C8+vvJLaVCdv
L3SNzOmaM0iabCsn91bMKr6Pd9e4nkTKzMWv0uctotuOp7fss0V0OUtIcOdHqhDc
jKecroisN3cKRKxJxMfcidGfrFmfsu4vGgCPK0xNvcutic9n2hwANinckfxmnxDB
JoqbisrKCTgagHASF8XxUuHVjwRG7gfheg46FrY2mwycrI1rbnCrF23xUw3O08bg
MTZ9NVWTSXqiR2rNYvZpQFAiuQgYX/NFtqvzUT53Gm/32QAT7EUjq5A5APY4s4+S
P3CIA/nF/CiSLkFtvwCs0dOhJ93Bl70UMdSyr3+Hms/zI0Kx2R+QuKOL5MGlbXxR
6nEKQJvIPe1Xg2hD+8IKvBpQD0OK4EszfZZDiioMrfTzbO0w07IYiNB4mXoA5bDU
D6r9tY7Z2F2/IOeVrP+v/g+d+CtRLzz5v5SD+48fA/KcHrP0TQKbAvBhAHR9SIJ7
pbqrem6DWElgIZ1z6qFyNHm0b5h14fIaswpP33/ne/k5JVSJpuQpq9kM5OBwsFuN
r0t76UTAeeHqEOlakiOUfaWP3BHekFJQ+nQ+RXGAt8YKjNz2MLMgKjh50+wyaHvc
g4GDkmzB1IaRtEqeR6Gc
=EutC
-----END PGP SIGNATURE-----

--Zz8eIV9MTSc31S3o--
