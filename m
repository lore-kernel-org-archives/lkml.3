Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933435AbaEFA5a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 20:57:30 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:57975 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933119AbaEFA53 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 20:57:29 -0400
Date: Mon, 5 May 2014 12:23:44 -0700
From: Mark Brown <broonie@kernel.org>
To: Qipan Li <swingboard@gmail.com>
Cc: baohua@kernel.org, linux-spi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        workgroup.linux@csr.com, Qipan Li <Qipan.Li@csr.com>,
        Barry Song <Baohua.Song@csr.com>
Message-ID: <20140505192344.GL22111@sirena.org.uk>
References: <1399185156-521-1-git-send-email-swingboard@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="iK/wEI4vkfDmI6Zw"
Content-Disposition: inline
In-Reply-To: <1399185156-521-1-git-send-email-swingboard@gmail.com>
X-Cookie: You are standing on my toes.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 216.9.110.15
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 2/2] spi: sirf: decrease the interrupt count and
 latency of PIO mode
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--iK/wEI4vkfDmI6Zw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, May 04, 2014 at 02:32:36PM +0800, Qipan Li wrote:
> From: Qipan Li <Qipan.Li@csr.com>
>=20
> current PIO tranfer method be described as follows:

I'm missing patch 1 here.

--iK/wEI4vkfDmI6Zw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTZ+U9AAoJELSic+t+oim97AsP/RCjZlhIFhZ/s1WGTwl3XBre
kRbay8CBVbeXd1Y3u0CIekE3vVobxtp7QoXxOqVeqKNl3xgsGBiJN0jmOwhd3Ptd
Y2VGno+D4jOwMOEWRm+O6s0bCrln97C/c6Wn7ffYTFNiRtttjmlOUGMj0dE8Hjuu
++5nSyFtZ8qdWcdF02NSN5NezWhGveQFnkrjVVEtH097iT1ENaNO8b5xjIsS89EV
BIk/yhfMJm9+U+Wth/NS50XCJm/cpeC1pYND3b2zJjHAxfSy6mYE38W8vrtGwuvK
N0nfcNQMAkRcd3b7GvK1GU3j8M+SZrRunsfB+JdPOwSv5Idvo/dyie5ISCFvl+51
5or8HHcLEg7uKhzl8Nbsx85gMAdHDa9HkdFit7zMK0VdXJ0nCGayGdQGdUep5YoQ
MWfY522+/ZvjOuj4YO8zuEORiIcUo+TdWmOvtNq/73SpdY6bsUXKa0BtS/mYWlAR
LGS2N4AcGPzQ4x5fQB0xMGvf3C9DXzMdbOzmWEIC2Rzrn/wiutdEfV5vk+GbJEzH
mX/t3DPkoIvNvQ1HWvU9gsRZ5hA+4zxT7FTVvPmdErDYMKQHxLSrR4byFrZycIuG
ZdgJBjQQEbCcPPdnLRY60xiTBwJ+Xn6aH3tJTL7HW65vVwxv4Rt0ZvgXIyhgBucv
RvcyhBxlNHhRDw/tuGg4
=imqF
-----END PGP SIGNATURE-----

--iK/wEI4vkfDmI6Zw--
