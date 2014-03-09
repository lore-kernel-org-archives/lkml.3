Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752689AbaCIIqh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2014 04:46:37 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:55967 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752334AbaCIIqd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2014 04:46:33 -0400
Date: Sun, 9 Mar 2014 08:46:12 +0000
From: Mark Brown <broonie@kernel.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Balaji T K <balajitk@ti.com>, Chris Ball <chris@printf.net>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Florian Vaussard <florian.vaussard@epfl.ch>, Stefan Roese <sr@denx.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-mmc@vger.kernel.org
Message-ID: <20140309084612.GV28112@sirena.org.uk>
References: <1394111433.21007.2.camel@phoenix>
 <5319E4E9.5010207@ti.com>
 <CAFRkauACGODncvyPs0nNC+pkr4f55Xrhgn1hmAJbKHB+GoaVWA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SSL0Wx1ZzjCczihW"
Content-Disposition: inline
In-Reply-To: <CAFRkauACGODncvyPs0nNC+pkr4f55Xrhgn1hmAJbKHB+GoaVWA@mail.gmail.com>
X-Cookie: Oh no, not again.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.89.236
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH RFT] regulator: pbias: Convert to use regmap helper
 functions
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--SSL0Wx1ZzjCczihW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Mar 07, 2014 at 11:57:03PM +0800, Axel Lin wrote:
> 2014-03-07 23:25 GMT+08:00 Balaji T K <balajitk@ti.com>:

> > The intention was to set vmode to 0 for any voltage request lesser than
> > 1.8V.

> This statement sounds wrong to me.
> For example, If the request voltage range is 1.0V ~ 1.5V.
> We should return error rather than set the voltage to 1.8V (which may
> damage the device).

Yes, that's the expected behaviour - the selected voltage still needs to
be within spec.

--SSL0Wx1ZzjCczihW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTHCpRAAoJELSic+t+oim9Gy0P/2BT85rO87tbZzVJWZA//Z1u
vUADvZ9F6+Ev87CMIRg8Rmp/JOFp5jgDIbvbcKYH2GO0FaVLOFixurkpyLw4mJRx
sPHFvJa+QFRyl9IlgAm9PDoK9OwZKG5jBTcgFNYOXO0+ABCxG59ClpmKFHfDQMrf
uDKgC9FpG4pHqzJal9E3l1fZKjDqUGnUgVnGdT7nVtQtchZV35Fa0cA5iOWOxalP
YWcZ6koj9W5KEpyJg1kOBtlmyepkeYnBND13DEtNR5a4IqIyfP84zIPkIgHZsrZR
yLtv+BlqSJY0n7W1PRuOwjXv0NQgd8afP52clziz/ykcjzSoZMYiwafTxXnnNsxR
HA5VG0zMmt9mabC0pjPcMpcaLCaqUtjF6r0Ls3bMcAVa8F5JjzD3mjqA8P5fCKJd
ajKyrWxd6k7Ab5Iji1YJl5cpsz6/I0LwWeiQ5DU0lp4jciDkaDktGFkHXwwf+4fd
NnLpASO3ZVkfq+f5e3NaGAfJlEJor+mdKmZ3EfmV9soFIFpSZaRk0HU+HBK70O15
ENOsxWoX4shdlIZuvX5Fpx5Uu76vPuZINQMTRT76pTx0wHEREfLKr3L2Mo2mBAnI
vu2ftQPuN6jYsGsE2AiYTk6Z68+Q8x4xi+Y0UW9Vl4ucc/xY+WGuzq8kowAul/oI
3nbW8eA8tUiOl4KW0q83
=jJfK
-----END PGP SIGNATURE-----

--SSL0Wx1ZzjCczihW--
