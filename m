Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755696Ab3EHMlw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 08:41:52 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:42554 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754323Ab3EHMlv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 08:41:51 -0400
Date: Wed, 8 May 2013 13:41:19 +0100
From: Mark Brown <broonie@kernel.org>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-kernel@vger.kernel.org, lgirdwood@gmail.com,
        Marek Vasut <marek.vasut@gmail.com>
Message-ID: <20130508124119.GO7478@sirena.org.uk>
References: <1368009546-20770-1-git-send-email-sachin.kamat@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gIhrS3Q23Nl70UJ5"
Content-Disposition: inline
In-Reply-To: <1368009546-20770-1-git-send-email-sachin.kamat@linaro.org>
X-Cookie: You have no real enemies.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 212.183.132.60
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/2] regulator: isl6271a: Use NULL instead of 0
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--gIhrS3Q23Nl70UJ5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 08, 2013 at 04:09:05PM +0530, Sachin Kamat wrote:
> init_data is a pointer. Use NULL instead of 0.
>=20
> Silences the following sparse warning:
> drivers/regulator/isl6271a-regulator.c:133:44:
> warning: Using plain integer as NULL pointer

Applied, thanks.

--gIhrS3Q23Nl70UJ5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRikfsAAoJELSic+t+oim91KIP/0/EQG5VW34ytnjiBEm4joHA
sdtEKktYh5vIV0ppHXUXKopGzp9zfkW7I82Dj/54ysgjfhxl1p5TUH8RA4c53+sf
CV/2otgi/DBVnS7vh6CqNdkqFAejGWYgJMG41WEXT1kxOeB2gvK/coyOIYLHLpD/
ouXQNDKqm1/rUq5Beqx34WkkO8Q+0cMrPZHJMa60kQbWwp3tLCI7BmdM2yDpmgRX
BggvaSd4HT9axBb4r5HOhpdXyGR7jzSmirBPPOvy+cXNu0Pu8NUCzYfTiE/x/7N1
gBoEYR6sw7yK0EwkJ+uakVLQ6Lw9+X135Ij5C4KNBlaSGYR7MucbZsOCcFbazezp
FFSZvlg7gEubBbKfpuJRlcExGN2GbK2Gc+leTOtayI7D4mHp2IcH+JFEEHQ5wKQ2
3vHm4ct0TmOf3ZJdfJuNkprhF/YPHVeYl9wOGqjkzqK46MgWJz18G13w9xknm8xO
uOhWBtxZJjFJQWcfKXHSn5dMVeHw8QWgK+SqvyL0Ahuddb7R9i5UUUIRfEtXQA+5
DRg6PADEBMWYCSsn5RlYkn+GeKMH/iQ7yUGmHsugJn89gFkdefBJITr6JuQh46F6
wxyEmTr/BI9cHxCX9RgrfAwLEANpPEdXPOze15d9osMKY/gcokvGqY1BU/83qdpP
rPaDlo5hm0EdUVWReFll
=Gzr/
-----END PGP SIGNATURE-----

--gIhrS3Q23Nl70UJ5--
