Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753115Ab3EMNqI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 09:46:08 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:39598 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752064Ab3EMNqG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 09:46:06 -0400
Date: Mon, 13 May 2013 17:45:22 +0400
From: Mark Brown <broonie@kernel.org>
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: lgirdwood@gmail.com, perex@perex.cz, tiwai@suse.de, wfp5p@virginia.edu,
        vinod.koul@linux.intel.com, ramesh.babu@intel.com,
        namartax.kohli@intel.com, yongjun_wei@trendmicro.com.cn,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Message-ID: <20130513134522.GH6836@sirena.org.uk>
References: <CAPgLHd_RTomuGFrwReDt6w9q+nH376W=6hHD4qZ4PGQXRGnJqA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Hlh2aiwFLCZwGcpw"
Content-Disposition: inline
In-Reply-To: <CAPgLHd_RTomuGFrwReDt6w9q+nH376W=6hHD4qZ4PGQXRGnJqA@mail.gmail.com>
X-Cookie: Be different: conform.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.247.243.210
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH -next] ASoC: mid-x86: add missing iounmap() to probe
 error and remove
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Hlh2aiwFLCZwGcpw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, May 13, 2013 at 05:00:44PM +0800, Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>=20
> Add the missing iounmap() before return from snd_mfld_mc_probe()
> in the error handling case and to snd_mfld_mc_remove().

A better approach to this sort of issue is to convert to devm_,
eliminating the possibility of such errors in the future.

--Hlh2aiwFLCZwGcpw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRkO5vAAoJELSic+t+oim97N4P/0aOhaJ031WOfkGPtrtaN33L
DUMkis68oULRNfUo6JY0Hw7f43XQP7ciBeoeuijdZ0ALuu72eu0WOPQm6eh6fhaY
aPj2opIZrmoUjTun4YLX8AAqhAb1uj7ZWkgWH1pZa947NkbJP4XOsXFmaQuL5d06
Vx8ySvSn8qp3BycVsDi8Zm2y4oIUY5RaNqeePYKSQQoLAfaPaxfGZSY8BwZMD6Ed
TbOEHWeuFPn0NHu4ce0H173ZPIhIaPM2ytJ3RcsAoES5UhyqO5a9E37jWAVonJ2U
v34DWmTa6Q5eD6Cz7q+asJpUNP+RTKULVSVUHohTK/cFeENItAmyjtpACID3x7pY
bX03G+Z39MYM2qNWfIqa2UXAtSlwZ2Z36rGr6MMnIzgIQWJDQM+QNsx6hvqmMY/b
A78VmTk66oEpjhnbdHrpxhL+UVavSwjbYZx9pAtIQydGWixpAxR6kE698bzZ4LLt
z0fjqqC+y5qLqJAGprNXrTNWAM14sOGY7+mem58W5CWgzg6NB8bqpbonespdmaZG
MGvFpLOsFeuBQMCxyuiHnQuNhL0DUrnRu4eCSmlRbVfp0DgXkyxOy6AILMID7u/D
WVOuUIy8wYLfxD7mD5FEs+A8h+plL6FxUbrvxn/y9ur5KyfSP9HoDu17JNhRVNND
UC1gqLwVO6HxA5gGC65Y
=aCVU
-----END PGP SIGNATURE-----

--Hlh2aiwFLCZwGcpw--
