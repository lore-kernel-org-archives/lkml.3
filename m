Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754916AbaFNPhG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2014 11:37:06 -0400
Received: from mail.kernel.org ([198.145.19.201]:44596 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754734AbaFNPhD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2014 11:37:03 -0400
Date: Sat, 14 Jun 2014 17:36:58 +0200
From: Sebastian Reichel <sre@kernel.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: linux-kernel@vger.kernel.org,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: Status of Power Supply Subsystem
Message-ID: <20140614153658.GA13614@earth.universe>
References: <20140516183812.GA17752@earth.universe>
 <1946020.rieJTheGae@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="+QahgC5+KEYLbs62"
Content-Disposition: inline
In-Reply-To: <1946020.rieJTheGae@vostro.rjw.lan>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--+QahgC5+KEYLbs62
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Rafael,

> You can volunteer to take over the maintainership, but then I guess it would
> make sense to push this through the PM tree anyway, so please feel free to
> send a pull request with those fixes to me.

I waited a bit to see if maybe Dmitry or David want to give feedback. But I
haven't received anything, so I volunteer to take this subsystem over.

For now I have prepared a branch containing a single fix, which should be
applied to 3.16 and added a signed tag. Since linux-next still uses the
unmaintained power supply git tree the patch has not been in linux-next.
Apart from that I created a new branch for 3.17 stuff (DT support for
drivers, non-critical fixes, ...).

I will also send a patch for the MAINTAINERS file in a jiffy. I have not
included it in the branch, so that all involved persons get another chance
to complain.

-- Sebastian

The following changes since commit 951e273060d15b233a7f7ccaf76ba682b5b05a03:

  Merge branch 'perf-urgent-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip (2014-06-05 12:51:05 -0700)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/sre/linux-power-supply.git tags/power-supply-for-3.16

for you to fetch changes up to 381078e8865725ee95efadf0d988d8e24cddf088:

  bq2415x_charger: Fix Atomic Sleep Bug (2014-06-08 14:46:16 +0200)

----------------------------------------------------------------
power supply changes for the 3.16 series:

- Just a fix for atomic sleep bug

----------------------------------------------------------------
Sebastian Reichel (1):
      bq2415x_charger: Fix Atomic Sleep Bug

 drivers/power/bq2415x_charger.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--+QahgC5+KEYLbs62
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJTnGwZAAoJENju1/PIO/qaewYP/RyojjinojlTTlZ27gdTAFvt
jPfbJurVf7mteSlDJwwfcTYfyPX2H5fb+fC00/nms2wuf1pHk2aRbcUUZmJs1uHM
VePrF0RFKtsxwBwzx8gDlJoCcAGx9Cl7DKV4Hs75bEr5fg9N3JvbNeaUA/l8oqxC
mzLKDJTlDtjpeMfnyCu7bb4Shu1zCJPVc2rFlLRcY++YRE+Pk2uFTVw0TDUncbOp
i0SaZmiEM5dCttYHU+SMCASj0JQkaI2G/LeYr+cSmioRqzVeCvfSaDsRM8ZAOgRK
V5INV/MEy0MZ0AxLrS65+eGUVCQatuGnwnVTepqfsNdBeCINU+ykB1DDWeH7OoX6
hUy/xOhbMHqXFZ/aqcXQf+i5el3Tk1XfoNADsbznK3CGzAX5qwjjWV3YXGYn4OxP
TTJBQxBa9E27mR9aqqjA+EnApFagKJDN97zD7xuc4r+G1lmTWpG/w6vlUAdl4l8f
H7pOv2K4uI1zFMFDwA7mhIb3DzeK+qVgbWVzn9SDOkB5AwSrluuyMWFFiuvq7/j4
dtoY/1I9+Ga86fWS8+bo8i7VC4ulFjNjpV3x7GEg/iBqhCHELgLukRgtdK1sXVj2
P5n/SOoYhdZ9ANNQdsuylrp4B0BdpXEgcAQJq0u58JpHN5sEMU+uRzZpY9fN6wHV
ZwyovR2OFVJwnGWlxA1r
=dmQw
-----END PGP SIGNATURE-----

--+QahgC5+KEYLbs62--
