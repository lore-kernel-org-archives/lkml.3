Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755493Ab3DWKkB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 06:40:01 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:34289 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755348Ab3DWKj7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 06:39:59 -0400
Date: Tue, 23 Apr 2013 11:39:56 +0100
From: Mark Brown <broonie@kernel.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] regulator: lp3971: Convert to use
 regulator_map_voltage_ascend
Message-ID: <20130423103956.GG5019@opensource.wolfsonmicro.com>
References: <1366475731.7038.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="YH9Qf6Fh2G5kB/85"
Content-Disposition: inline
In-Reply-To: <1366475731.7038.1.camel@phoenix>
X-Cookie: Caution: Keep out of reach of children.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--YH9Qf6Fh2G5kB/85
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Apr 21, 2013 at 12:35:31AM +0800, Axel Lin wrote:
> All regulators have ascendant voltage list in this driver.
> Thus use regulator_map_voltage_ascend is more efficient than the default
> regulator_map_voltage_iterate.

Applied both, thanks.

--YH9Qf6Fh2G5kB/85
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRdmTyAAoJELSic+t+oim9MY0P+gIhf8mDZ1/kPIWkNiqL+oyu
FntBIFr3joT+0wE29SzXiCBzkFpcrl7/z6/peP/jCOcyYeuDYKhZhcLkQQsvlphs
x+aa/7jGD3hH4AFpGGROwABTzZk5kwCLX/tI6ChPUlQ5UHz5lDEmnWpIJUqKLQWB
aDdhRyPhlYnt/DG7CyQnxwuEVkqzsYUt5VgBXvZeQQkjfulXGFqqprqNOAYsf5QT
WYsVlJEXaORKuAHtsqiwQtHqbwvbNiPQ1/pEO/nCGTTuhuP5EIFCKScvvPPRWbMZ
+HrxHa/C9aEFiYBCYu7Ih6YSDwPg5QfYlQCFmIPeMCrhnwFMSPGF0KU0yyIkwXz5
wsKWnUyv3HuqbOt0qh09F/sMl7Fja8RzTd/L1mjlR9jMd07rfyJTerWkHornA9Hj
ysCPbZmduT5OChV//Ji6ZcwQYiGpZV/Wc+wXoBUVxjUo88EPuelu1O0OIpqOxZF4
zj5r9DOUXkI7ElV3MSN+upcHMRXR53JYiu2++vGUcwPMZI4j0YR90uAipBKAGZIG
QqWWd0f2ErLwkGDqbrw3RsB2ALjU8IoeFFa6dxj+FmwzagM2tuQrQnP4Owxpz06H
JnjTVvYG0Ndb+ROYXCzEEveYQ/QKunCq15sYUvEMjeEhOFwK1Ku8zGyMWKKfnHj3
HtfAF4Rf2cqWrXjtYZGN
=jtLf
-----END PGP SIGNATURE-----

--YH9Qf6Fh2G5kB/85--
