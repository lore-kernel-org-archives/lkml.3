Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755350AbaHLWFA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 18:05:00 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:60529 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752855AbaHLWE6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 18:04:58 -0400
Date: Tue, 12 Aug 2014 23:04:48 +0100
From: Mark Brown <broonie@kernel.org>
To: Jyri Sarha <jsarha@ti.com>
Cc: linux-kernel@vger.kernel.org, mturquette@linaro.org,
        dri-devel@lists.freedesktop.org, airlied@linux.ie,
        linux-omap@vger.kernel.org, devicetree@vger.kernel.org,
        bcousson@baylibre.com, tony@atomide.com,
        liam.r.girdwood@linux.intel.com, peter.ujfalusi@ti.com,
        detheridge@ti.com, zonque@gmail.com, t-kristo@ti.com
Message-ID: <20140812220448.GG17528@sirena.org.uk>
References: <cover.1407332062.git.jsarha@ti.com>
 <5e5987c830439e39d26a44580ebe01de631c10cc.1407332062.git.jsarha@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VZ4xAPYFtuHTmUjI"
Content-Disposition: inline
In-Reply-To: <5e5987c830439e39d26a44580ebe01de631c10cc.1407332062.git.jsarha@ti.com>
X-Cookie: 98% lean.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/9] ASoC: mcasp: Fix implicit BLCK divider setting
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--VZ4xAPYFtuHTmUjI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Aug 06, 2014 at 04:47:16PM +0300, Jyri Sarha wrote:
> The implicit BLCK divider setting was broken by "ASoC: mcasp: don't
> override bclk divider if it was provided by the machine"-patch. After
> the BCLK divider is implicitly set for the first time the
> mcasp->bclk_div gets a non zero value and the implicit setting is
> "turned off".

Applied, thanks.

--VZ4xAPYFtuHTmUjI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT6o99AAoJELSic+t+oim9ZiUP/3ZKLuAEGdJVdEDSJe5+eQ12
ZEToqUdQ90TXh9h3wLE3Y8zW6R+Al/Gm8uOR3XnLe78eKlmHO5DqepLJsjfG6CEe
VaveBkg4PQxiT9rvXgQG8r4WG4WmdcIp8Qel5Gx5jKfiIhLYpv78kfOpe/Mn6KdV
cnDUzpqc2u461papufww8nOzxay95jNv4SrYPlytYikFtwZ45/BEkWLCdjqF41tk
v34s8Sduzgu7sdr7odDDs2rc03BaI+B8M0jYMIWznZbZToPCi5+gMCqnCqXGYol8
sre+0OBBGXZUawUZDHWWdV/77wPbS8eve3Uulzl7GIZPi3r6rWS5eeKpf4QhVjW6
INqiIqsmiHX61Rwnx6d+nX+t8fks3r5TwbzD/v6U1Y77lXYt1pm5xNpxC/WPmVyB
KrW+dDTnINDISFdapJzFzffkb2SIzz4C29CCeZudS9KjXuvse0l+BCXa39Kn8hVn
iodcA9hKhV0YBTZeA0bp5W3xzgdb8vXX0ktBV/BfKCXNS3oSXIdRrjoKzN0Tq/H2
Z9KUxuYLIpDCHHJktTZqD9kV2HSwZ15f/skG7k3Vj4pn4ZJrFjV92autDF+CVymf
5Hi9UEBXPODaG0GbQKkDA4ifABV38TGnb41lMYqRUgv9iGNJkPKKBQPeqoWNagut
FtuCUMfWtz07+ceJ6lvt
=xopG
-----END PGP SIGNATURE-----

--VZ4xAPYFtuHTmUjI--
