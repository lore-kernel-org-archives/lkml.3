Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752686AbaHDAFu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2014 20:05:50 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54273 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751871AbaHDAFs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2014 20:05:48 -0400
Message-ID: <1407110740.8341.8.camel@deadeye.wl.decadent.org.uk>
Subject: Re: Linux 3.4.95 breaks LZO tests (additional pull needed)
From: Ben Hutchings <ben@decadent.org.uk>
To: Derrick Pallas <pallas@meraki.com>
Cc: stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        Derrick Pallas <derrick@pallas.us>
Date: Mon, 04 Aug 2014 01:05:40 +0100
In-Reply-To: <CAFqNYV4_yW60oKmb4edH8CQtFiyT491eWOPheBrDse9j-jCYZg@mail.gmail.com>
References: <CAFqNYV4_yW60oKmb4edH8CQtFiyT491eWOPheBrDse9j-jCYZg@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-AS3AZRFIuT0gz1u+oe63"
X-Mailer: Evolution 3.12.2-1+b1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-AS3AZRFIuT0gz1u+oe63
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2014-07-17 at 20:57 -0700, Derrick Pallas wrote:
> An LZO update was backported in Linux 3.4.95 but fails to work if
> crypto tests are enabled. It turns out that
> 0ec7382036922be063b515b2a3f1d6
> f7a607392c, which updates the test vectors, did not come along for the
> ride. Thanks, ~Derrick

As this is also true of 3.2.61, I've queued it up for the next update to
3.2.

Ben.

--=20
Ben Hutchings
Tomorrow will be cancelled due to lack of interest.

--=-AS3AZRFIuT0gz1u+oe63
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUAU97OVOe/yOyVhhEJAQrjvRAAylDOoxDEOZRvtUWEOG4EfktU0nFDA95G
iSkhAE/qOOL8+eeziAx5B8jzpN467UzY9MrcY9k/b49duiqusI+LAE9oQtHDXtOT
thv+I0yqlr9UhHnX+Q0gzjqXwHnTa1jXqAk5v1oC/8vI8ht1Y/42mLATm+0ixqk5
SVVOmS0f0EjpQDFOygo0YfuLcH7fxaYHc6CC7DR2E/sbO3UfrYyrgrr2EupJXrVi
D5ofuqEbL39C+s+qbRJg4jZdNoJjvOQIs9EBWa6TtbqHJJJ0qm3DA3pUGRL8IiKi
fIJIxnkLxeWQG6hTnGeLcXsITzh0FIQ/Q9LkNwox+gSGVVXM5rMn2sSxXBcAYYJu
qpmyiD0slC8fdZJB6QPGVX355fKYqo/kJ1/gZLpB160I7zyrpaiwGwyb9vLglemJ
ZjCsw5/avIGh7LIqzfio/6a9TuN0BLTJf+c2dicXcujg3wGhaAjf9DWqorsiKs4x
ZAoFiwysr/ULGBJcH6N/uSFxBV/bB+rd3O10AsuHAY9m8dtvSpn15u05HM31mgnM
D1MwKBNK4lwbxv3FRhEFDykKIVX1GdNftXhDnUZHbpe81r7m2IJ61Rg5bIyJuW40
CvB10Z/J4irvWJHJnFgFTBHv+DPYJTnXvE4iri1ildfCA0e9RNyGO98fR9MhL2Gs
bLhjzmsyxD8=
=mz42
-----END PGP SIGNATURE-----

--=-AS3AZRFIuT0gz1u+oe63--
