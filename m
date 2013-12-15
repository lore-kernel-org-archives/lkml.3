Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751898Ab3LOSGX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Dec 2013 13:06:23 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:44307 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751679Ab3LOSGW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Dec 2013 13:06:22 -0500
Message-ID: <1387130735.12172.95.camel@deadeye.wl.decadent.org.uk>
Subject: Re: pull request: linux-firmware: update cxgb4 firmware
From: Ben Hutchings <ben@decadent.org.uk>
To: Hariprasad S <hariprasad@chelsio.com>
Cc: dwmw2@infradead.org, linux-kernel@vger.kernel.org, felix@chelsio.com
Date: Sun, 15 Dec 2013 18:05:35 +0000
In-Reply-To: <20131127081505.GB7998@hariprasad-pc>
References: <20131127081505.GB7998@hariprasad-pc>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-rtWYEP78lB4MpRlxqRFk"
X-Mailer: Evolution 3.8.5-2+b1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 82.132.217.233
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-rtWYEP78lB4MpRlxqRFk
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2013-11-27 at 13:45 +0530, Hariprasad S wrote:
> Hi,
>=20
> Can you please pull from the following URL?
>     git://git.chelsio.net/pub/git/linux-firmware.git for-upstream
>=20
> The following changes since commit 7d0c7a8cfd78388d90cc784a185b19dcbdbce8=
24:
>   Ben Hutchings (1):
>     Merge branch 'wilink4' of git://git.kernel.org/pub/scm/linux/kernel/g=
it/balbi/linux-firmware
>=20
> are available in the git repository at:
>=20
>     git://git.chelsio.net/pub/git/linux-firmware.git for-upstream
>=20
> Hariprasad Shenai (1):
>     cxgb4: Updated T4 firmware, add T5 firmware

This doesn't update the WHENCE file for the new filenames.

Ben.

>  cxgb4/t4fw-1.6.2.0.bin  |  Bin 431616 -> 0 bytes
>  cxgb4/t4fw-1.8.24.0.bin |  Bin 0 -> 479744 bytes
>  cxgb4/t4fw.bin          |    2 +-
>  cxgb4/t5fw-1.8.28.0.bin |  Bin 0 -> 462848 bytes
>  cxgb4/t5fw.bin          |    1 +
>  5 files changed, 2 insertions(+), 1 deletions(-)
>  delete mode 100644 cxgb4/t4fw-1.6.2.0.bin
>  create mode 100644 cxgb4/t4fw-1.8.24.0.bin
>  create mode 100644 cxgb4/t5fw-1.8.28.0.bin
>  create mode 120000 cxgb4/t5fw.bin

--=20
Ben Hutchings
Q.  Which is the greater problem in the world today, ignorance or apathy?
A.  I don't know and I couldn't care less.

--=-rtWYEP78lB4MpRlxqRFk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIVAwUAUq3vcOe/yOyVhhEJAQo7RhAAwucPlVNBVmqixtp2WX/sJq/GAgkC4aBh
Xts3tFvYbsgYOE9WDDvSKJQ3Vwe6pOri4TqnEhOEjBfifZ+UUllKXY1ro7vLjFZh
mLCVzfhGu7yrNcC3I0gH4PcusX79ekAHY1MmWjtzoMXpZJqvI22XloMGwzDhgBXS
SJwO8ueDF40ky5NBJjuslh+5tuRPFQBegdC8AKLny3Nl+Z3g0uTWg93ARIm9oo/T
LXdpmUe5jsijr6pI7FnLmM89dmqpUgAJIIAPrTXYccXixYVAErUTuW1xuc02wcAA
iZDTGorEJ/b2wjrE3/9daw1HhLJfkTqjRWYiuq6Q1uDfUsFwqXmoPKXoOUwhirQm
WI/fxktCN+AGZ9YF9bt4OkoTDyInkucg9yOqqZSR6Qr8GlN9fiGukmuXgArn8EV4
lJd6puEkJRg3Rd+qRI20a2wijDoBHfV9AF4qjkN8DDHaqjUWwTM9XqX8cA8LZ4tk
Y1u65kSWZ4Wn1JpsORsYvBUBRXDkYeUrsu40UnbqMIfsBsPrkumClaVyka3Z9U8b
05nTZtYJ5t0sywBKhpfW/aehaRcUuNZW9MBKrLxIeJLNdH8PL6qansyuEK6jCLg7
KkXYZ8Zpa+6KX02Gb8g5cEEH/iiaHb+CRkSv8LWAzPKn20V2Rfdsrk/I0J2FXdqU
FwotVQLYUCE=
=yYHe
-----END PGP SIGNATURE-----

--=-rtWYEP78lB4MpRlxqRFk--
