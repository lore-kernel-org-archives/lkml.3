Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751834Ab3KRSgH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 13:36:07 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:60901 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751469Ab3KRSf6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 13:35:58 -0500
Date: Mon, 18 Nov 2013 18:35:55 +0000
From: Mark Brown <broonie@kernel.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Woodhouse <dwmw2@infradead.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        angus.clark@st.com
Message-ID: <20131118183555.GQ2674@sirena.org.uk>
References: <20131118133940.GC14306@sirena.org.uk>
 <20131118142447.GJ13640@lee--X1>
 <20131118144512.GB24408@sirena.org.uk>
 <20131118145614.GM13640@lee--X1>
 <20131118151651.GE24408@sirena.org.uk>
 <20131118153110.GN13640@lee--X1>
 <20131118154137.GA28334@sirena.org.uk>
 <20131118160226.GO13640@lee--X1>
 <20131118172243.GO2674@sirena.org.uk>
 <20131118173201.GP13640@lee--X1>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="A7FgPGrDEcSmmdo/"
Content-Disposition: inline
In-Reply-To: <20131118173201.GP13640@lee--X1>
X-Cookie: Drive defensively.  Buy a tank.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 02/10] mtd: st_spi_fsm: Supply all register address and
 bit logic defines
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--A7FgPGrDEcSmmdo/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Nov 18, 2013 at 05:32:01PM +0000, Lee Jones wrote:

> I can get a patch out tomorrow if the MTD guys agree. Where are they
> by the way? I haven't seen hide nor hair of them since sending out the
> patch set.

They tend to do big batches of things intermittently AFAICT.

--A7FgPGrDEcSmmdo/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSil4HAAoJELSic+t+oim9D9UP/0+UElI8z8jptE72Y2aix/6Q
WdKFJh3y/bTD8lVH9rwq9MYSAV7iZJm5W4fb89bg6KE4tPIaQ1zaFdLxaGmpODdr
TAsQwBWqbAw3qxRWJCb+OAugBQv96eOdC/CgpIXZ7frwENqx77YVCyEhSqQH8g/y
8/w3aF+fPKc1ZWlkz5aURbrHqTtUeTW6egqNIh4o7WlBnSWj2jjOcUO8GJHDYsiR
n2nOZfmaoGNNMo01uHdMX65HihJyEPpNxz7VqST+R7KNNZuQfKaAHfB1+vn2I8XP
c7lK2pF2F/nCg8dJiL5zZPlCe/B0kqOMG6744IWgfR75qicd5A34IgLZ27xhXSVP
CCmzLWnakE8SSS3hFI76aaEfOs4Ot0RUPSRthpSJC4P8XOOiXr/5dTArxSrkEHrO
f0B/BGBzSce5dW8Ir2TOAfLePciPhEM8IQqTO2Ywb1kpcYU1nnkw6MEuNtWu5xYR
HThvaxjkUJECPqXDDZhdH2k/yVnWxa0Pvx8dTqrNGk/7pkG8efSbWcZlj3jLfrMI
W4ZeC0NH57vMhI4xAz8p5fdJ9rDaTt2x09PnWi902Co01Q3i+0EIfFtDpRR0IN7f
3rsWBJCtrAScNCx0nc+NHIc1xDqjuPMg5EQtrvJmEBh4Cw/gvnvIg6y59VfatvGq
968M97CCru78NUeD1wTJ
=PG3B
-----END PGP SIGNATURE-----

--A7FgPGrDEcSmmdo/--
