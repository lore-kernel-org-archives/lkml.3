Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934726Ab3DIRCS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 13:02:18 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:46900 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754997Ab3DIRCQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 13:02:16 -0400
Date: Tue, 9 Apr 2013 18:02:14 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Andreas Larsson <andreas@gaisler.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        spi-devel-general@lists.sourceforge.net,
        Mingkai Hu <Mingkai.hu@freescale.com>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Joakim Tjernlund <Joakim.Tjernlund@transmode.se>,
        Kumar Gala <galak@kernel.crashing.org>,
        Peter Korsgaard <jacmet@sunsite.dk>, linux-kernel@vger.kernel.org,
        software@gaisler.com
Subject: Re: [PATCH v3 5/7] spi: spi-fsl-spi: Add support for setting a
 maximum number of bits per word
Message-ID: <20130409170213.GV9243@opensource.wolfsonmicro.com>
References: <1360943547-2186-1-git-send-email-andreas@gaisler.com>
 <1360943547-2186-6-git-send-email-andreas@gaisler.com>
 <20130409165738.GU9243@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UEYxRAcbr7cS1UOX"
Content-Disposition: inline
In-Reply-To: <20130409165738.GU9243@opensource.wolfsonmicro.com>
X-Cookie: Your love life will be... interesting.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--UEYxRAcbr7cS1UOX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Apr 09, 2013 at 05:57:38PM +0100, Mark Brown wrote:
> On Fri, Feb 15, 2013 at 04:52:25PM +0100, Andreas Larsson wrote:
> > Acked-by: Anton Vorontsov <anton@enomsg.org>
> > Signed-off-by: Andreas Larsson <andreas@gaisler.com>

> I'll apply this on account of it being part of the series and review
> having been very slow but...

...actually it turns out Grant already applied this anyway and I missed
it somehow - sorry for the noise!

--UEYxRAcbr7cS1UOX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRZEmIAAoJELSic+t+oim9rWYP/i8V+6tgC3Sw8ekPPhf9eKmU
C1K/2kFQtaI0GSLBONAx+FrOZxiapeUUxow5CHxZF/noccUQZmvafcOOKygqVs6j
sCZWRHeK5aIv6ZJjraIdiYc5pmhsoGwMQVxXZEuMFhKljhOHw7lSGk413QsKetBc
QQBzfHMIOjetXD0YMvRuGjYxkKTm60eigYcp401GLtnNkZ2Uf1q5k40ash0WBH8R
+U6Nv1lYTci7iXsR59SAuIDjx/bFTtBiWiONEVz6ri82BkR25b+cgqHCVYCyCBsS
HyQQqaX0oCEKkm66dGmPoKH/nXm3P/OLa7jg5KCbse0eWkUMkOe6L2753H6MIi27
RMwPZqTgfGn31vSXjvg8oKyWfPEBqsbcC+cXIQCe2Rl6esSiKHSKP0uBmVV66Hyt
42XyARaTnJ0bVETRKBTy+epMFuLXIwUNKc1rT2Ln7du6O3agIv9qKq8TLPWLdHfo
AY7NqD3KLzrbWJLkha2An8TtcnnLrwPlwPEzG13nC/SqvSmvsJM/n72F9vtayBOA
j1Pbb6/6Jdu0j5WDP7E/OdNwdxzvT8PKuyx1xFvZyOgUhZqThk6iwst5hW4knwJ/
uFqASPdAZ5vSFsftFSIDHxquyBNeuVl8H1/1ftsn+gWeXz/wgXSwyoEnBGyZZit7
lpfz3hz4ALfIPZ6BoK+z
=Z+O9
-----END PGP SIGNATURE-----

--UEYxRAcbr7cS1UOX--
