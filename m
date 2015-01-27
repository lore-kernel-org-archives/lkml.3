Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757367AbbA0AOf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 19:14:35 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:35306 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756168AbbA0AO1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 19:14:27 -0500
Date: Tue, 27 Jan 2015 00:14:19 +0000
From: Mark Brown <broonie@kernel.org>
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Cc: Michal Simek <michal.simek@xilinx.com>,
        =?iso-8859-1?Q?S=F6ren?= Brinkmann <soren.brinkmann@xilinx.com>,
        linux-spi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Message-ID: <20150127001419.GO21293@sirena.org.uk>
References: <1422029330-10971-1-git-send-email-ricardo.ribalda@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="T3X/gqwmxfK0WLE8"
Content-Disposition: inline
In-Reply-To: <1422029330-10971-1-git-send-email-ricardo.ribalda@gmail.com>
X-Cookie: My LESLIE GORE record is BROKEN ...
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 00/18] spi/xilinx: Speed-up
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--T3X/gqwmxfK0WLE8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 23, 2015 at 05:08:32PM +0100, Ricardo Ribalda Delgado wrote:
> This set of patches has been developed after using the core to access a s=
pi
> nor flash. The initial performance was not as desired. The following chan=
ges
> have been done.

In general the best way to present a series is to start off with any bug
fixes (so they can be sent to Linus and stable if needed), then move on
to mechanical and stylistic cleanups (since they tend to be easy to
review and apply) and finally move on to new functionality (since that
is most likely to run into review problems and the cleanups should help
review). =20

>   spi/xilinx: Support for spi mode LOOP
>   spi/xilinx: Simplify data read from the Rx FIFO
>   spi-xilinx: Simplify spi_fill_tx_fifo

spi-xilinx?

--T3X/gqwmxfK0WLE8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJUxthaAAoJECTWi3JdVIfQvM0H/RUTIKxyqWSI0rmnTeamiy5U
LE1NUOz6tDgWDbc7vJjj13MsK1RACWRirfZDvD5GDHZXKJW8buIMSBF2jkFOSaLd
Ngn3+L7RK+dsS0Hv0wOj6Gdodrz9SGdTOCKQ56Z9yDHC7HWRZSKKVlOfTW0tShRw
RvbbEPP2dpTBe/7BUq7MQbmW+niNED00HtTKRj+ZGDMCFKrcpOsWFziW6/vsIfGH
2hFh2La3VRTa38p4q3y8YSODLV66H9f+9LJfHZO7xG38C79EdVVl1ISccPxvh21l
UOigq5GdvV2Xwm5D2B1rwsw+dzOcBwg9J9U9HJ4UrEk8tLWd0DgwlRqufYcphIs=
=+k5F
-----END PGP SIGNATURE-----

--T3X/gqwmxfK0WLE8--
