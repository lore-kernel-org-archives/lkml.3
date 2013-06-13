Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932494Ab3FMCpl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 22:45:41 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:35927 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932071Ab3FMCpj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 22:45:39 -0400
Message-ID: <1371091531.10688.34.camel@deadeye.wl.decadent.org.uk>
Subject: Re: Please backport bee980d9e9642e96351fa3ca9077b853ecf62f57
 (xen/events: Handle VIRQ_TIMER before any other hardirq in event loop.) to
 earlier kernels v3.8...and so on
From: Ben Hutchings <ben@decadent.org.uk>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: stable@vger.kernel.org, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Date: Thu, 13 Jun 2013 03:45:31 +0100
In-Reply-To: <20130603120232.GA6893@phenom.dumpdata.com>
References: <20130603120232.GA6893@phenom.dumpdata.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-H5/lbGMlwUoj+OsmInQM"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-H5/lbGMlwUoj+OsmInQM
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2013-06-03 at 08:02 -0400, Konrad Rzeszutek Wilk wrote:
> Hey Greg,
>=20
> I hadn't (by mistake) put the CC: stable@vger.kernel.org on said patch
> (Which is in the Linux kernel).
>=20
> If possible please back-port said patch to the existing stable trees.
> Attached is a version that applies to some of the earlier trees easily.

Queued up for 3.2, thanks.

Ben.

--=20
Ben Hutchings
friends: People who know you well, but like you anyway.

--=-H5/lbGMlwUoj+OsmInQM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUbkyS+e/yOyVhhEJAQpPLxAAyo1cx3foYsgEHmv9uqvTHWRM60/6nDKJ
Fd4wDMur/ixf08A3AMpeJyMYRy7pO5hro2mKm4FF0ZL06cnrikk8ucbDd7uVY/V9
ahWDqgQuhGoDtAXYOAovGq6qwtlwfrByeEWJi/BHDJkJKV+x4SDcZOeHvrm5hVqn
VGoeXpl0Ynx02OK3eZUe+Togbb0qVL5GJbqQ82dGJ5AqXV4L5AiOM/YeOm4yo4HM
YJ88+ywmZZ6QxbAnjJ8rw9TlvIPNUJnsjGYDNQj4iMbS+ELL0bdefemwrsCw9gQs
8gSFAleYzo2pSSX3FQDAxTa2Sdu5gqt+sn5LcJCSJyTRxNan8jHOPeHHZP7AYOG+
NEKiZncmo4abbBWaxcpO4M1VSq0GxfGrNoJ5bUGsn9J7QqqZsnQhphO361CUzuuj
dluGWyeQimlORe9UD2q9aS9EW6z08q/rZ95mrCAHlFfZUJAfsaeUiI6sm+4olBlx
/qej+eM9TsfKPHw6pG34ednpk/0YOWPD01tcG4u/ImuKSzpFg0TI09A3wdh5ogt5
/EqacbVfh8cBnJyVfkq8gcnO+uKHy4gKf/tXkHMDbWpetlSJrYguq5/gXYkbeH0A
5HJkvlAztdhORP+qpwtUSRf59CQJyfSUIJdFgNtjnN0DBei6Za3m8vRmNCNf0QFG
Z0pmgPSPbnw=
=62Lk
-----END PGP SIGNATURE-----

--=-H5/lbGMlwUoj+OsmInQM--
