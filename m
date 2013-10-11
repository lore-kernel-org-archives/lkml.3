Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757661Ab3JKLaK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 07:30:10 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:59136 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753801Ab3JKLaI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 07:30:08 -0400
Date: Fri, 11 Oct 2013 12:29:44 +0100
From: Mark Brown <broonie@kernel.org>
To: Nishanth Menon <nm@ti.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Message-ID: <20131011112944.GA2443@sirena.org.uk>
References: <1381485852-18085-1-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HcAYCG3uE/tztfnV"
Content-Disposition: inline
In-Reply-To: <1381485852-18085-1-git-send-email-nm@ti.com>
X-Cookie: Time and tide wait for no man.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: ti-abb: Fix operator precedence typo
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--HcAYCG3uE/tztfnV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Oct 11, 2013 at 05:04:12AM -0500, Nishanth Menon wrote:
> commit 40b1936e (regulator: Introduce TI Adaptive Body Bias(ABB) on-chip
> LDO driver) missed a pair of brackets which cause the wrong vset data to be
> picked up from efuse, resulting in bad VBB voltage values.

Applied, thanks.

--HcAYCG3uE/tztfnV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSV+EbAAoJELSic+t+oim9b2AQAIIcemZT55MeN/IJcRdnOk4n
6wJoNsHe2jPlyZvWMwioHJV0Fthnr0wJcnqXGtlZb70v1SXgMV+uSCqSOkyVURnR
K85f83cn98iI1O04XlZmnvnqf0d0NokN1FPgPEpVXGXiomdZ2BzlTQuc2WltSvx3
oIrKZ/9Tk2y2I1QFZJwnyk+iUrbS4BtD0W1Rfy+hQuUORaRDNzwABgoTx3a6f9Va
sb524JQ0vaO9rs1pF0IUJ74yWPq+Vi6VhN7wdsllzepXS3fV7KYbfuhWkFykXoEO
lkNyfLsIabJVqOqelgIc1hQXMGGrkNoHSgCUkbElSZTsiVhhzvyGxUkZauicOSG1
kDrRNTmNwhnQem3m8rO1LR/ekGeeHl2xhu+aybR0SnbpfCR0YqY3l3z7muyJ5qRC
3A1QI9Eq7/5foQHbduuMhMeU7eEwKKghfBS8b4SMmTl1r5WEv5DKYteFtg95Xq2Z
A62JwJqk8I5PyBvj7e2jHEkL7CshNHlZYOAr9FGnhU5DQRbshSr+pTFaTZ6bB1lO
ATnZ78CnRiQCpmWxY3tlTmvM9zRIaZX4fIiwnGJhcFog6xGLlUoi6VGtd+ZyNnbQ
QgLqI+YDFBeITA681vDepEBGtHTpNPl2qWEq6zcBKsl3J0w9VbeIOLP/f/5FT+Bk
JRf+ttF+vbG72c5JqSzt
=X+oG
-----END PGP SIGNATURE-----

--HcAYCG3uE/tztfnV--
