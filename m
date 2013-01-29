Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753542Ab3A2KBO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 05:01:14 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:55427 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751657Ab3A2KBL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 05:01:11 -0500
Date: Tue, 29 Jan 2013 11:00:48 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Richard Purdie <rpurdie@rpsys.net>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Landley <rob@landley.net>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-fbdev@vger.kernel.org
Subject: Re: [PATCH 4/4] pwm_backlight: Add support for the whole range of
 the PWM in DT mode
Message-ID: <20130129100048.GB16746@avionic-0098.mockup.avionic-design.de>
References: <1358861996-27194-1-git-send-email-peter.ujfalusi@ti.com>
 <1358861996-27194-5-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4bRzO86E/ozDv8r1"
Content-Disposition: inline
In-Reply-To: <1358861996-27194-5-git-send-email-peter.ujfalusi@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:veTsrLr+4scLekJYHK91zRJky94kDE+s1qLTUIoBiCc
 CHaHrCcOOz1ZLnT2kWumKBb4xc5MNW//gRHKFWwPMUn8S7eFuc
 ko2iuxa6zQUPVUpJCmfOtCYAHny/24YoDw8raC7hktbIrK0v+z
 Ud0NTtdfUkLWpyvuzYMLwY8z7Iz+OupALpTURSXpHLrR3H6j9s
 jhVaXRBxdqyNDYiWI8pKN/nQu30Kotm1/Gr74eO/TW/Vhgv4T3
 9rDYNKIicaHiQHOomBWzB2ZsjUtm51bv1JJ8TrNHit1NUscIF1
 qBPnhcKGpVWRknD66UZpYXBfATp9wHrJ0HVWoUXLfBi7BZpdLp
 V+3JP5R1hI2UHOcZib7zf7xA8/Gf/q7V8sYGQLCmh/4jt2KpVZ
 AgsEyYPh7fsICoWcKfbE1LRO9gsI2wuXTEBSsWZ9Sj3v5CgQ/P
 3QXCu
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--4bRzO86E/ozDv8r1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 22, 2013 at 02:39:56PM +0100, Peter Ujfalusi wrote:
> When booting with DT make it possible to use the whole range of the PWM w=
hen
> controlling the backlight in a same way it is possible when the kernel is
> booted in non DT mode.
> A new property "max-brightness-level" can be used to specify the maximum
> value the PWM can handle (time slots).
> DTS files can use either the "brightness-levels" or the "max-brightness-l=
evel"
> to configure the PWM.
> In case both of these properties exist the driver will prefer the
> "brightness-levels" over the "max-brightness-level".
>=20
> Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>

I don't think this is a good idea. The brightness-levels property was
specifically introduced in order to have a more reasonable interface to
specify brightness levels.

As such, all uses of the non-DT max_brightness to be deprecated. It is
only kept for backwards compatibility with non-DT boards.

Thierry

--4bRzO86E/ozDv8r1
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRB53PAAoJEN0jrNd/PrOhK6QP/36pZHyxxK8EP60C61b4fQ2D
DiIGJ4FY++Bveqc92sjV0bhTsKd/XO6u8aRZOBZZDIu+VjATupPfE+7SMEgSMXa3
7ZoYwdm0t1enfMY776vTKLNAXK6EEuGZJ/CNAE0sJCYUKhP0kwLBtJUzmt/fSZ7Y
yOH41X4mt3083vhbPphep/YBO4q4lesZl53KNLbGmPw2SB/I8uBbtupl4y59lzfd
PLmJb6Kby8eRKFdeCxatbDTbbHILFFOjKlWCtfUgUh+VmkGS73e3klWfhsmrgstU
5SlmUg5OxTWGc9+I6cBEsjx5E9TMcJk3rhuCdwJlYJ06S6bRNFftulhFLU6nMuWB
qrUZOyfh/AdzEiUMWPPqgvJh7SYbYp6mJHdi7dwzJHLTITaR6UDKtS+oJVH0jhvu
vvB9qOY1zsw6Vzovy9CQzqCw0iLCtpcRd1DFiz+krWl9VXw8pk0rXVdW/TbOJI5+
xXz3wXuqhx77ipOXx5a/V3bKBAaei7pPrOQDANOBCzJE8gPY6EtTyhD5uUZt3ilp
YqZfXsGeG5aUjpwFuuHk0YJitFTwHZZ19W2XY/tq0Pj+YQK3CcqzJFWoCFiLU1Kh
nYLxO8KGj7L0OZf2XlTMlEnAyppDURg+SNTaNL61QKv16fIXmYb6vh/nK1YppP3R
y/X1ohi/tnzCuSBkO+ng
=EerR
-----END PGP SIGNATURE-----

--4bRzO86E/ozDv8r1--
