Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753128AbaBOKIN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Feb 2014 05:08:13 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:60365 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753075AbaBOKIK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Feb 2014 05:08:10 -0500
Date: Fri, 14 Feb 2014 21:14:05 +0000
From: Mark Brown <broonie@kernel.org>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-kernel@vger.kernel.org, lgirdwood@gmail.com
Message-ID: <20140214211405.GE4451@sirena.org.uk>
References: <1392378602-32302-1-git-send-email-sachin.kamat@linaro.org>
 <1392378602-32302-7-git-send-email-sachin.kamat@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="c2qmoHupxsh34lk8"
Content-Disposition: inline
In-Reply-To: <1392378602-32302-7-git-send-email-sachin.kamat@linaro.org>
X-Cookie: Your lucky color has faded.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 175.45.49.105
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 07/16] regulator: 88pm8607: Use of_get_child_by_name
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--c2qmoHupxsh34lk8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Feb 14, 2014 at 05:19:53PM +0530, Sachin Kamat wrote:
> of_find_node_by_name walks the allnodes list, and can thus walk
> outside of the parent node. Use of_get_child_by_name instead.

Applied, thanks.

--c2qmoHupxsh34lk8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS/ocaAAoJELSic+t+oim9zykP/RjBpXnot/qQjQe90/QZDyWj
RBkOAewl5w1UsNzbruLTDQ/Gcf1lu7CZ/TTdLSLE0IYf7VAlo86L0oI4UTDBoze4
6pHoFbTbbwA0EfgURnZZ51FN6jlILAOgLvg4B48XAw/FTUCLtZofh/Ifwou41s9I
KYpvtTULDCd31bc+P0/5KnsLZAsGptxgqsMdaLf/oW0RifDW1QAbY/vRBYJqtZE9
em7oeo74/+t5LhLtSeD+ltIxN57+FhAa56lSoj4kiFydboA052Kj4WJ59QjhWDP8
yQE6vM55BRh0adbS88R7jmNd1bHRs3Zn2jeLpZXKXhjVMMWOOiMIv7GlAG4F+KFN
ThN6YemqhkUO1ZSr2ZGBAn3J+2J5xRXbXTnotfVmWIdz5kFv7n8knfzdJBn+AOoU
EIeigDBZqOLsf1RPZZANjZ9VhP1lo0eZsc11Uu7TrWuSWT+sNnBy6ekajZ7HaFTA
PTDtT+lhJARGsPkGBuZlxphfZIXsPqbQY32ZZ3oG4JwLppbENChD0wI63SSrenbz
fwvmYYhY7Z420ZohvtaNig701hBYxf+gK7MwxMM6h2uzAfhL+vCb3ESFgYrOHtd1
hojoX+DBIkRMf0UrwwmKEIAjYtRgmV8HTmofw9vbj8Ppq9o2sPP7Q/aMVoAdIsbg
GOqE9KElx5Lcagpiqtxo
=r661
-----END PGP SIGNATURE-----

--c2qmoHupxsh34lk8--
