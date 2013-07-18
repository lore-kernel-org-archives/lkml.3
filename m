Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758760Ab3GRLC3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 07:02:29 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:48206 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756185Ab3GRLC2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 07:02:28 -0400
Date: Thu, 18 Jul 2013 12:02:03 +0100
From: Mark Brown <broonie@kernel.org>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>, linaro-kernel@lists.linaro.org,
        linux-kernel@vger.kernel.org
Message-ID: <20130718110203.GK22506@sirena.org.uk>
References: <1374144831-25622-1-git-send-email-broonie@kernel.org>
 <CAKohpo=VqJA7m_p7YSNZjkY6Se640RJEHSdJdX6BwY+VGSfAng@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PsoQMlSWCswIFQyi"
Content-Disposition: inline
In-Reply-To: <CAKohpo=VqJA7m_p7YSNZjkY6Se640RJEHSdJdX6BwY+VGSfAng@mail.gmail.com>
X-Cookie: Many pages make a thick book.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: core: Use the power efficient workqueue for
 delayed powerdown
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--PsoQMlSWCswIFQyi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 18, 2013 at 04:26:22PM +0530, Viresh Kumar wrote:

> Cool!! People have started to use this interface now :)

It could do with a bit more publicity - the only reason I heard of it is
that I queried what a version of it was doing in the middle of big.LITTLE=
=20
patches for the LSK and why it wasn't upstream.

--PsoQMlSWCswIFQyi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR58soAAoJELSic+t+oim9oOgP/3omeNiJ7YwOivWgxAmJ/Vcl
2bzuWsoJJ5sfccBYVf4KasaX8ntpxWciBFOaChv4TlmRFAOZr35LxAxg3Mt1bymg
J6tI71sT+0YrlWFI4l6cPJgM7PSkLret3uADzWl8UPfPvBJ8qM86yJMEicl5PUEx
2dNShXc5RBUCPy9qHoxViI1wbagI80pgViBQp7w6iGG/7Urn6MZj8y5nTRxhxEfL
6/90lsFnSrmksd3Zrv+DGAvXTH8/kwYM0wojrcN3VlxN6T873LhyWlhyttCX15n7
4Q68A9GAVIEOKZYmS404Lj5saNQ7EMb6VKTHKsSlx3fByCdTIJd/PayOMkIts759
0J18PIhJk2MpoCqM0b4KHuxuSOdx+qF5oY+w7vSK19pv1YjqcAJfi+yikW9NU9o+
/ay+wRDWgsYH34+t5cNj58/xiTyFR60hf+RPyT0vprGO6yvXcXsJ4gLYWaIyrEqJ
mLJnJZUwW8iP/6gYz6rW5Q7LKscarjSjDMQl75E7d4XemDxI9Nq5D0Xl7hvJFXYr
z2CbYzx73W0FXTXxT3q31442kHnlaOb4p2igBab2ajwU+wC7W/mqeSzPzkFa1J+S
gZe7dIIBc/gOmiXmhObRMI4T8shmwHOTB5ryh8AUk0XNRqe4rt9Drp1cnUH0fFS+
CncGYv1/mH2cFyjQI5aH
=bhnf
-----END PGP SIGNATURE-----

--PsoQMlSWCswIFQyi--
