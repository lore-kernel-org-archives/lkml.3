Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754414AbaFXPZi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 11:25:38 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:55781 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753032AbaFXPZh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 11:25:37 -0400
Date: Tue, 24 Jun 2014 16:25:33 +0100
From: Mark Brown <broonie@kernel.org>
To: Sachin Kamat <sachin.kamat@samsung.com>
Cc: linux-kernel@vger.kernel.org, lgirdwood@gmail.com, spk.linux@gmail.com,
        anilkumar@ti.com, j-keerthy@ti.com
Message-ID: <20140624152533.GQ23300@sirena.org.uk>
References: <1403598556-22536-1-git-send-email-sachin.kamat@samsung.com>
 <1403598556-22536-2-git-send-email-sachin.kamat@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="eLe8FOcWSbbyMVJD"
Content-Disposition: inline
In-Reply-To: <1403598556-22536-2-git-send-email-sachin.kamat@samsung.com>
X-Cookie: But it does move!
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 2/2] regulator: tps65218: Fix build warnings
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--eLe8FOcWSbbyMVJD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jun 24, 2014 at 01:59:16PM +0530, Sachin Kamat wrote:
> rdev_get_id() returns an int. Convert rid to type int to avoid the
> following warnings:
> drivers/regulator/tps65218-regulator.c:132:10: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
> drivers/regulator/tps65218-regulator.c:146:10: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]

Applied, thanks.

--eLe8FOcWSbbyMVJD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTqZhpAAoJELSic+t+oim9B0sQAJSmaBvlXTToAXGZWSLdURez
Hnm2R3SZVSGoa1BD3KqKZZg/ZRsb8iRDKDZFtvBNAeggnY4Oa371YmhVdU022Rqz
ysXki6zz1k21IZFQwcbWDHHCDYRMnCpgZtybuqRr2Z7IR/B689bvPHBnvHXkg1Gx
MIUkFgBRcmUKN1GrHjuH7yj396/J6dzm5l2Qj5vD//5gojISIGcfhzyMB5bfQwwn
8HRcoeSSmIt7SvkS9Dr+t/lSnAhMLZixFpMi6GVOJWkQ3ssXqd1790XzDnUxzhTm
QaTRlHrjWz5eIPKU/9wZZFQS/RhM6YjtYEmgk3Cwdt5LpKzIzwx+od6gLGdyqOhq
ub9mPJSoilTFTiwzFXPJkNVp6R9zYcDoMokjaOy1Fq1V5eHbX20FSl+uzRg4uCI4
kJiekteTtYEMMiQ6ZIsbPt7SYdSRMHBkLf/y3JdAtj8rqU5lQSSIx3BNZ9Wp3AAL
qoqHGeHPcpVQoSCU9RJAU+PdTyIxjaknB/cNO3Wk2NRYZLZPoFyWIOtS4aVz2Pw3
dP+oaUbu4nn3PPfNkXEP3j/FdbwUsQkyUtloOOZlyEtraxx4a8J2L3YnGHJb5yj+
5PSquwmU0WMhLyMnD8Hv5EmvNzvcMEpcDCLcV1ILJXL3KKhrNMuRc6lHmpaB8ZpB
V7n527D4XVIXcQx9EEft
=jtR1
-----END PGP SIGNATURE-----

--eLe8FOcWSbbyMVJD--
