Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752464Ab3FZPWp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 11:22:45 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:59704 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751421Ab3FZPWo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 11:22:44 -0400
Date: Wed, 26 Jun 2013 16:22:10 +0100
From: Mark Brown <broonie@kernel.org>
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: lgirdwood@gmail.com, perex@perex.cz, tiwai@suse.de, wfp5p@virginia.edu,
        vinod.koul@linux.intel.com, ramesh.babu@intel.com,
        namartax.kohli@intel.com, yongjun_wei@trendmicro.com.cn,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Message-ID: <20130626152210.GR27646@sirena.org.uk>
References: <CAPgLHd89RzJrpMEs+zR8cQvGHruWvne8e0kGb1LeCqoHdKogHA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="w1WLgcEPVIWvtHEy"
Content-Disposition: inline
In-Reply-To: <CAPgLHd89RzJrpMEs+zR8cQvGHruWvne8e0kGb1LeCqoHdKogHA@mail.gmail.com>
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH -next] ASoC: mid-x86: Convert to use devm_* APIs
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--w1WLgcEPVIWvtHEy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 25, 2013 at 10:16:56AM +0800, Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>=20
> devm_* APIs are device managed and make code simpler.

Applied, thanks.

--w1WLgcEPVIWvtHEy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIbBAEBAgAGBQJRywcfAAoJELSic+t+oim93ZsP+PCyAc5HubQFBzarNnVXlhEo
zYozhcA5oLg6PqopnqavLV0Zn1lEZE14EBMRo2tdUm6UWeV7sYrdatDkLTriqgm9
I4b5cm9tRRAjwlqJrsY4nE39hPpMECFADO80vyEfKrCpNFvSGFVZhGFOH8J/al7a
N+Gy2Yr7/qU0m1paaoKpkAYeZg1v0yVqUJvryQVIQcG2RdhsEswIOyGZGRU6E1jU
pdIhy+fBsvwwitJdz5aoVUUKQiSJYlzq6r4L6TYf8Ul1aunSkrGNmL8qygeGrmv3
tCJeZ/qfmeIltKupszNm6y5lvRhpLggGBG1tK/jGqAOKM60iVloW3wUgOfzWhrav
kB4zQac3F2iNI37PBUBqfUhPN7DHEOhoBNJQSoyMZvdXut5q8ixo8A2gMq7xgYFX
1OyHvz2//0fj3jG7p2Jh0KbTNAdWrs/mDfBFGe1YCOMmi0rIohOvPjoVo5ENIMwG
tm2U/GfpF/3fvEDcy1csMVfkBBvOGqVklhoFsUxAjjRVL4Vs4Xew6UVtAIquKVLZ
1PPdfrv+Pr89O6sV7vqH6hVTKjGn9wJz6j3sKJzEFtBF3PRufjE4hWI85CxNWYds
dzUyT3/dSasdlXXMowL9w7/uEw/Aw04A9yEViOhSqWpeCB1z5Yj1WRk30P7GxlZc
ZCJFnnUN9wuqmk0dc6w=
=oLF2
-----END PGP SIGNATURE-----

--w1WLgcEPVIWvtHEy--
