Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751475Ab3JEF7J (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Oct 2013 01:59:09 -0400
Received: from sauhun.de ([89.238.76.85]:59134 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751294Ab3JEF7I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Oct 2013 01:59:08 -0400
Date: Sat, 5 Oct 2013 07:59:03 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Michal Simek <michal.simek@xilinx.com>
Cc: Michal Simek <monstr@monstr.eu>, linux-kernel@vger.kernel.org,
        Kedareswara rao Appana <appana.durga.rao@xilinx.com>,
        Kedareswara rao Appana <appanad@xilinx.com>,
        Jean Delvare <khali@linux-fr.org>, Peter Korsgaard <jacmet@sunsite.dk>,
        linux-i2c@vger.kernel.org
Subject: Re: [PATCH v2 3/3] i2c: xilinx: Use devm_* functions
Message-ID: <20131005055903.GA3008@katana>
References: <f3fd6f38d2553e59b077edff1969f4d07f8aa811.1380550490.git.michal.simek@xilinx.com>
 <83ec9558211389896f21d9682e9824cd7979466c.1380550490.git.michal.simek@xilinx.com>
 <20131004053323.GB3194@katana>
 <524E8764.4030704@monstr.eu>
 <20131004115840.GB2994@katana>
 <9b5a6672-2fd9-4900-b018-f044dee60646@VA3EHSMHS021.ehs.local>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IJpNTDwzlM2Ie8A6"
Content-Disposition: inline
In-Reply-To: <9b5a6672-2fd9-4900-b018-f044dee60646@VA3EHSMHS021.ehs.local>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--IJpNTDwzlM2Ie8A6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


> > First register the handler, then activate interrupts. You are right,
> > this needs to be fixed, too.
>=20
> Do you want me to create separate patch just about moving request irq in =
front of
> xiic_reinit()? And then devm_ conversion?

Yes, seperate, please.


--IJpNTDwzlM2Ie8A6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJST6qnAAoJEBQN5MwUoCm21XkP/1oiKL5TXbOqK5pUQUPx6SzZ
flhC+GtWZKw682ar5/odGe74L049mOul47pm8MqlwDmh5MEXw1wyIEBSNGS/+KSn
wyV1FkA+PkwWuQQeNENwLp+CsfWDABm2j1c//TKpnwU56ZS6rePUH8yjLUCHLUiB
dEKC12ZZ5F5x1jLlVaoFiFXEZPEgMTNVUkycZup4O4CBitsOYKuUjWeKn/evt1lM
wGqBVPqjw0mSNfDWyoSpz3EmUK/Ap+6IDmh0MLlMQpb9/NEH0+p4VtJ+0Eu7z7gX
2NvGGldms8g2j6V/Hx89n2ne8QhL0LCTrt2x+0gdJY0r0rjCGeXTnjASQEKZFQ6s
t/PeCKUhoBxnV9Q8Sg5Llm7zUCW49Em+7Wes+y3YJm3p8BEzZP1eB1AeMJjIo40s
8Q6bC1x4hBIPdu1n44e3soPNG3yw2og3awAXHcMYcHjdg1BKxm6simxVZqpmD2GL
HR+7v4yUcZj4dbLVsnevSWfTmFd9VgXcD4zgu/oAr5yyH4CZ+1pY6IuYi4m/1ADL
H2qWkF2OXFW2QNHNnsj1zEpPhrpAbxvSC266VmF9q1eUrr5Cz0WODMzC47M302eK
mE/NRdtBUR6t5YokvTSE9mwQJDf/CCP6XgL6AAyXHkXhWdgRoHXqjAZOcC8ptIo6
gaqVz2QmcO2EyznTHCN8
=61ae
-----END PGP SIGNATURE-----

--IJpNTDwzlM2Ie8A6--
