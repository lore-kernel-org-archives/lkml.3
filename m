Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754379AbaA0UE2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 15:04:28 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:60274 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754312AbaA0UEZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 15:04:25 -0500
Date: Mon, 27 Jan 2014 20:04:19 +0000
From: Mark Brown <broonie@kernel.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-spi@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>
Message-ID: <20140127200419.GI11841@sirena.org.uk>
References: <1390553044-11860-1-git-send-email-geert@linux-m68k.org>
 <1390553044-11860-8-git-send-email-geert@linux-m68k.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PaC+lnGZu4KSIdY4"
Content-Disposition: inline
In-Reply-To: <1390553044-11860-8-git-send-email-geert@linux-m68k.org>
X-Cookie: O.K., fine.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 07/14] spi: rspi: Merge qspi_send_pio() and
 qspi_receive_pio()
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--PaC+lnGZu4KSIdY4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 24, 2014 at 09:43:57AM +0100, Geert Uytterhoeven wrote:
> From: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
>=20
> qspi_send_pio() and qspi_receive_pio() are very similar: they both send
> and receive full duplex data to/from the hardware, but ignore the data
> stream in the unused direction.
> Merge them into qspi_transfer_out_in(), now supporting real full duplex.

Applied, thanks.

--PaC+lnGZu4KSIdY4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS5rvAAAoJELSic+t+oim9CcgP/2K1UJKFftlQqZzH/vpKuG2T
ucYX0CSGwoaYC1/pAm9k8tgv7liqprX1bldIlPwYwObQQBHz6bQNWmu6WV+AGK7k
QsOMTzF2sobpI0HkRf5IG3z9pG1e85Af8eA8+AZ7N0++bjabuqItrhmyF7A7+rM5
3ENdAPkWC3jovCrUeWvLs299o2TXjRD0VwSEjGpSIOM6Hci2o/VHU3aWh4MGVbEi
eWBcXoWQWCwonxZ3mW6T8y/o32iyTERxGALIi3VNQfUm5ZJZT+W01htwmEOXrFcY
6FgeyYYkmCb6IR0aerxRoiQQT0Tzp0Dc+WpXj5/JW0iqZSan9lkyWRDnxYtQA4iw
hqReijMFYVbknm8c4BCBUEeYgiOTOeRJYjMI3U9LZNFTodMhYAwFa4LyoAO5vfQc
/Py2vihYsHnJHrn6eqdvcNy3cj++4ptJaKRcbILf74voXn7vQIsr9WUZKKgpWKeO
rylE5q3Z9dWOvFsRa8v+KAdg+8xbaOtkffKfcQ5JNlWeaplPVHn+zmPEvF9tjTfl
R77pH5WLwu6VzE1DR8hfuCKZORpSB8ywn8J2jKZxjqNg0l4OwWrr++70JF9a6ZgD
1nfG8+CN153ZxenrfBV8UjbtD5D6TkSzLyHRytP7nYa3aJrRekyaYMqSooYxtJ57
D7AK+6i6WlKu7zPEZ9De
=Jyg/
-----END PGP SIGNATURE-----

--PaC+lnGZu4KSIdY4--
