Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754583AbaFKWZV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 18:25:21 -0400
Received: from sauhun.de ([89.238.76.85]:47854 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751797AbaFKWZQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 18:25:16 -0400
Date: Thu, 12 Jun 2014 00:24:44 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Boris BREZILLON <boris.brezillon@free-electrons.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Randy Dunlap <rdunlap@infradead.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Hans de Goede <hdegoede@redhat.com>, Shuge <shuge@allwinnertech.com>,
        kevin@allwinnertech.com, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org
Subject: Re: [PATCH v7 0/2] i2c: sunxi: add P2WI controller support
Message-ID: <20140611222444.GB3109@katana>
References: <1402478250-7292-1-git-send-email-boris.brezillon@free-electrons.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IrhDeMKUP4DT/M7F"
Content-Disposition: inline
In-Reply-To: <1402478250-7292-1-git-send-email-boris.brezillon@free-electrons.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--IrhDeMKUP4DT/M7F
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 11, 2014 at 11:17:28AM +0200, Boris BREZILLON wrote:
> Hello,
>=20
> This series adds support for the P2WI block used by some Allwinner boards
> to interface with the AXP221 PMIC.
>=20
> The P2WI controller looks like an SMBus controller which only supports by=
te
> data transfers. But, it differs from standard SMBus protocol on several
> aspects:
> - it supports only one slave device, and thus drop the address field
> - it adds a parity bit every 8bits of data
> - only one read access is required to read a byte (instead of a write
>   followed by a read access in standard SMBus protocol)
> - there's no Ack bit after each byte transfer
>=20
> This means this bus cannot be used to interface with standard SMBus
> devices (the only known device to support this interface is the AXP221
> PMIC).
> However the P2WI protocol is close enough to SMBus to be integrated in
> the I2C subsystem (see this thread [1] for detailed reasons that led to
> integrating this driver in the I2C subsystem).
>=20
> [1] http://www.spinics.net/lists/linux-i2c/msg15066.html

Applied to for-next, thanks!


--IrhDeMKUP4DT/M7F
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTmNcrAAoJEBQN5MwUoCm2WokP/0s7/lQmKJce9e1SGgjfhSn2
VeuDGa1n1wRApLc+BvP2EEeZzdqYNRzDEpH1Nxinye3C+ECdi3yI4hULumH4izep
lvDQYPlRqdUDct2NUSHZzq0n8svPxL9jrtWwz9zSSlx6J9rxTJpqGMNiCcauPzGU
qsF8jdBJtB62SEnPJ7zqE6w6gyPdA3+f7sCT99vGwZbyg6yeH5/QBQ92AZAFsvNV
A/YnGNndYNG9wccOi1QKMhO1TtGE3+8TZ0dCS7T8SAVpX1OZ3hopHl9YY7NhWpXI
0QMv2IRHbRab0xssISaNNoDW2Vv/aPXqdSJcCH9KejIRt/XiRWzjo/Hi86bG7a8s
KtPGl5Z9Gpfs2V+TWF7YK4zccaaXy6BSil/Cgrxqh7dBpz3uqxhGWT1HVfoHbSlv
Ygzh2RnXixF6kUxX6P/13hj38c0ck4hukxE0PCxl3Az08XThMBxcpNFmCXGjeoGB
O1u/5woqBH+OUSEg7HlAWRioHXbZxbB/UbTrVfOKAX5pnN/eQquYupPJH4D7bHTP
B7N8/ppJPI+3sE1Blhb9F22PNMMIWb1x7z5K1FfMGwl63qjjYUOijEu4sTIPk1DM
oN4zca6rCU35qq4gpbvKa9hwoqJ1hsyWJ3a6zJR5NuFlNpnwoyM33s/PbISCEREi
t/wA9oPEzHtWebFrw1Xf
=MvHO
-----END PGP SIGNATURE-----

--IrhDeMKUP4DT/M7F--
