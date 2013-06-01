Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752926Ab3FASrc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jun 2013 14:47:32 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:38116 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751131Ab3FASrZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jun 2013 14:47:25 -0400
Date: Sat, 1 Jun 2013 19:46:59 +0100
From: Mark Brown <broonie@kernel.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Grant Likely <grant.likely@linaro.org>, linux-spi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Message-ID: <20130601184659.GD16790@sirena.org.uk>
References: <1369929581-30258-1-git-send-email-swarren@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="fXStkuK2IQBfcDe+"
Content-Disposition: inline
In-Reply-To: <1369929581-30258-1-git-send-email-swarren@wwwdotorg.org>
X-Cookie: Advancement in position.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 82.42.102.178
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/3] spi: fix undefined behaviour in SPI_BPW_RANGE_MASK
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--fXStkuK2IQBfcDe+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 30, 2013 at 09:59:39AM -0600, Stephen Warren wrote:
> From: Stephen Warren <swarren@nvidia.com>
>=20
> The parameters to SPI_BPW_RANGE_MASK() are in the range 1..32. If 32 is
> used as a parameter, part of the expression is "1 << 32". Since 32 is >=3D
> the size of the type in use, such a shift is undefined behaviour. Add

Applied all, thanks.

--fXStkuK2IQBfcDe+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRqkGgAAoJELSic+t+oim9I0cP/0hBLjJun+7a3kmjd9Kv5YaD
tjGUvgfDSX9M/9xEHwZrEAY8RajdMxTgCibCKUV4Nl2YasjPLAnsvFP3fr5KOEul
FQnQ+rJ9PpfxmnHNn8wfI0Z/FeavbmvWfl7va1L5R4QLbdkMR93V8W9wul0T2AqL
Bnq9G1KGzXFfExkv4488zP4tu/uADkJDq1YxvZ7jFUXe19zbAzsp+pfvu4b7clhw
symKlPsBBKxFGPygsbg8JTF9gCiE/TuPzylHJcd6klxPTbt8c2Mo1l1uyERpzlli
GHnQlxcPvda1k9v/OP2X6810qao7pfL8p23X9K2Sv/AqZY2ljONqZvE9LhmatP/C
lrswbNsDo11jO4n/fDymYqynGltZvRNhltQuKCmriz7Ngw1bkusnjdYIjg2JEtdj
W8boUTEN0IxRSWCSJQ3x03/SVpOEVt29XrrtD40M503LsL37X5ZlRqI1vwRkkoA0
Oa/PtdYBiYB/EAUC33xGH8pqYCCvJ/kxeA+QsZmSOU/7Kc5z0Ln81OD+26LV+w6C
5FsNFL17vaYnIYYnbZ9NizvloRIFV/mShn8Yk51WkKwWZjVrTEB75sQQbhgqSerS
rnbLFbi57SJvMm20JEG5Pti6rCVrgCiGDA425SMIoAJVfMnOsOn8Mo1lo3KMUVSq
DRTUS4v7HcQ4wSC+moYE
=E+Ss
-----END PGP SIGNATURE-----

--fXStkuK2IQBfcDe+--
