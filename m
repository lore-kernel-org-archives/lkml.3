Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752691Ab3LPVGB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 16:06:01 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:59351 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752434Ab3LPVGA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 16:06:00 -0500
Date: Mon, 16 Dec 2013 21:05:57 +0000
From: Mark Brown <broonie@kernel.org>
To: Alexander Shiyan <shc_work@mail.ru>
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Message-ID: <20131216210557.GC3185@sirena.org.uk>
References: <1387100211-19101-1-git-send-email-shc_work@mail.ru>
 <20131216205020.GY3185@sirena.org.uk>
 <1387227746.558174684@f210.i.mail.ru>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="y/KK5WT0dXhrzWcJ"
Content-Disposition: inline
In-Reply-To: <1387227746.558174684@f210.i.mail.ru>
X-Cookie: Yow!  I threw up on my window!
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regmap: irq: Allow using zero value for ack_base
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--y/KK5WT0dXhrzWcJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 17, 2013 at 01:02:26AM +0400, Alexander Shiyan wrote:

> > I guess this is for some driver you're upstreaming so a signed tag would
> > be useful? =20

> I plan to use regmap-irq for migration mc13xxx MFD core to use IRQ domain=
s.
> It will not be so soon.

OK, well let me know if you do need a signed tag and I'll do one.

--y/KK5WT0dXhrzWcJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSr2sxAAoJELSic+t+oim9Q0cP/iWTiy2wQJbFApABIKzQF+b6
cdpOiCSE8wGxIh9HwTaYSQ60j2SmfeQDVcH7bXcct72HFUikbkKIlCCUeSY8rKNa
xbPL2tf+mycgqXj6O9lbC3YQnDslSzjqznfG8ats2Vki/csBHPBZbh6+A5xbQhIR
Q0ukt/h9lTwjqGr+4frruExrpcHSG9IBHPaZdikmZ6uetksHqtyJL+C3ZLrzzaQk
XIeSxVruyKHWUQpM7Pe6FAUwzPjmHcpOTSzSnT//4Jk8WvDtyi/L7tQAcwQIl3lX
c24+RiPeKVmc32+/34sGR+vvY0XMi/Il8wEQdU2Gg8BgLjVMy6V6mYrp2nryYD1w
BJMSKd9YyAYkeG1e6wYJmQrC/FMxNdJ4Ix4JLIJ9rfVH6UI/yjc0oUmbf3zIo3qP
cPaOl/jDBpXVHSQGZ1nzeeR/EoBXvB96I9BomuMhrfqA6tO6nj8oEkSsOPHzR8gv
tFobw9X372kXYkADMAoDCiQv9CjkvgEOZsQrO2ReUUjuXvmwp8erw6PR+izj3Mlz
NwKDvzFoc/m5Awr2nf3Ib2FURpV15Kdlgeazldn/Q45vV/UNhtFvuFmgtkL7FpNb
Z+lkWaP9zAQhAluyjl8trhPNAW4Ynz4MGYgG1yDe5M5tA9N3D5LksP2zg7SNP1yW
T3o+D8Q3D9vq7PTO78EF
=MhEo
-----END PGP SIGNATURE-----

--y/KK5WT0dXhrzWcJ--
