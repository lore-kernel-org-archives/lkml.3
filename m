Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757224Ab3KMNuj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 08:50:39 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:41072 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753524Ab3KMNug (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 08:50:36 -0500
Date: Wed, 13 Nov 2013 13:50:21 +0000
From: Mark Brown <broonie@kernel.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Sangbeom Kim <sbkim73@samsung.com>, Liam Girdwood <lgirdwood@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>
Message-ID: <20131113135021.GN878@sirena.org.uk>
References: <1383923118-26921-1-git-send-email-k.kozlowski@samsung.com>
 <1384263715-5713-1-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hNG1vEeyG8BCaHbQ"
Content-Disposition: inline
In-Reply-To: <1384263715-5713-1-git-send-email-k.kozlowski@samsung.com>
X-Cookie: Long life is in store for you.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 149.254.183.27
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: s5m8767: Disable OVCB in probe
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--hNG1vEeyG8BCaHbQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Nov 12, 2013 at 02:41:55PM +0100, Krzysztof Kozlowski wrote:
> According to SW Guide the Over-Voltage Clamp may malfunction at VBatt
> 5.25V and 110'C temperature. This may result in overshooting or
> undershooting LDO's voltage outputs.
> Disable the Over-Voltage Clamp in probe by updating proper bit in all
> LDO registers.

Is there no way to detect these conditions at runtime?  The temperature
condition in particular seems very high and hence relatively unlikely to
hold most of the time, disabling the overvoltage protection all the time
seems like an uncertain tradeoff.

--hNG1vEeyG8BCaHbQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSg4OaAAoJELSic+t+oim93YIQAJu06Vc9oDokh4f7uvEGl/ff
uKS6dg5oi/gHWRes05zrHZGTgvdTFo1hXlN/b35zzSTcoTfr2CCRdrS7o1PhjN7P
d+CThYQ0w2Jil2SNCtSea+jkkNqDF2qSeCv+f+ZnEAfH2et1zQxxJCaj/K8uZeWF
8AMHVhqgRd95AaFY+32B0wX7ef3ZiPyK01SdYvBda2G9soH0xBNAM/aXquqmZ/Vj
2FmRGARhsaJQAn2UEtieSZozaIMXRjE/Jhob9QvhXFOM3mpX1d3a3EDP8ACk1vnY
lNloqfoVD0ymb8Woso9WtrrFszURZq1jNIIXrzLGcfhgxDMOXLrybIjwSnRbIBoV
Kn0P+K+yQiIQnMabJW97/WGm4AeKVdzIFZYN01CzqqsxICKJD72R5tRsg3SYHFzr
FbvTxZ3fNfodEd7YOFrUFKzpYRW5KDZheAbfIOfODq5O3sJQWmJRXibBnT2vySmc
USzhHibrfk6XpHOUq0rV5iGG3PkKf9kMyK2TgEdfy+oimgsAWeC+A5OODOV221lr
v7l0QnNLKcla+tjZvuC1QYQf7TR6dVG/FCVAx+1+yWamcavs0jbmMjK2FOqrksXV
7DrJxba2zupazkdKfO/MM0kqTi0pKmMIoBB4UpwoxecqaOqwQgTb4JLD1nioFEzf
XGy+4Z/8v2YTrgBwNCb/
=VOrT
-----END PGP SIGNATURE-----

--hNG1vEeyG8BCaHbQ--
