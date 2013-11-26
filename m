Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753408Ab3KZNO4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 08:14:56 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:41680 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751852Ab3KZNOy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 08:14:54 -0500
Date: Tue, 26 Nov 2013 13:14:52 +0000
From: Mark Brown <broonie@kernel.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Message-ID: <20131126131452.GL14725@sirena.org.uk>
References: <1385417567-7693-1-git-send-email-swarren@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7ARfeEU66NqbnwsW"
Content-Disposition: inline
In-Reply-To: <1385417567-7693-1-git-send-email-swarren@wwwdotorg.org>
X-Cookie: Your supervisor is thinking about you.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regmap: use IS_ERR() to check clk_get() results
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--7ARfeEU66NqbnwsW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 25, 2013 at 03:12:47PM -0700, Stephen Warren wrote:
> From: Stephen Warren <swarren@nvidia.com>
>=20
> clk_get() returns an error pointer, or a valid token to pass back to the
> clock API. Hence, the result must be checked with IS_ERR(), not by
> comparison against NULL.

Applied, thanks.

--7ARfeEU66NqbnwsW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSlJ7IAAoJELSic+t+oim9OcsP/i5uqTRwme1Lftzpd5RJ/e0P
vYriyXuRJhm9NVqJ61A0a6/06AfEAnnAgpOY78ybuzINK2HVhZ6GFP8JXzmlLlG9
YDEvn7VwVPOCuTdxNF6r96bCys8LCeLE5q2hvquPewLre34BhbN5cTxtSLDLYz+1
HnowySgs4KTXD+41bq5KhYhi7sJD97r+fMzw62bbqMAN1FqDwo6roKRuD0wTXR2X
zE+de4MWU0lVFU0Z1PBXQ5BmNPdsJCK8zM6yNDRWhUkfuUMicNnE1SfRT8k7QLTE
m3h0PfLqzpZFZ8wds7jTlOIQYle8y1ANP2YyvpUkBOkj7oHTBaMpy/0qoJ2Pm3YJ
xPpswFHZjjsoPHmC8HdquPEXNG5LCMACAjN6ccZW6ysn3aS7Yd3fmyTDh13qtbP8
dWmrvn/hOyUIoyHCOUh69YhOkz8pz3GRE1dIPd7vOAhN+irzkbzdHo4dgiB1Q5O3
Taicc1l7Yhwh4/IcYl7MdDMr9jK2Cw15OhCCXGkrPJ6krnsXyy/lXtfod2UOxYQ1
aN164B+cFbyN3i8EEIXpDRtRFAMIY7RazQVgYLfRdMnrmYT/bzGzPqSDy9S9aZ6U
cLWnKijqScKlkSyZ8N6joU16KvJunCkN2QuudR6oduUzE77xFtSTOgv+jCit3xIB
2Zk/jwXd5U83/mIcrV5I
=vWbZ
-----END PGP SIGNATURE-----

--7ARfeEU66NqbnwsW--
