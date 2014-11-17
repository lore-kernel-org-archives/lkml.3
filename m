Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752544AbaKQX0r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 18:26:47 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:45482 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751515AbaKQX0q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 18:26:46 -0500
Date: Mon, 17 Nov 2014 23:26:21 +0000
From: Mark Brown <broonie@kernel.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        Alan Tull <atull@opensource.altera.com>
Message-ID: <20141117232620.GA22111@sirena.org.uk>
References: <1413559023-18293-1-git-send-email-linux@roeck-us.net>
 <20141117210009.GA28122@roeck-us.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="G4iJoqBmSsgzjUCe"
Content-Disposition: inline
In-Reply-To: <20141117210009.GA28122@roeck-us.net>
X-Cookie: You look tired.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 149.254.182.38
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: Ensure unique regulator debugfs directory
 names
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--G4iJoqBmSsgzjUCe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 17, 2014 at 01:00:09PM -0800, Guenter Roeck wrote:
> On Fri, Oct 17, 2014 at 08:17:03AM -0700, Guenter Roeck wrote:

> > To avoid the problem, prepend the debugfs directory name for a regulator
> > with its parent device name if available, but only if no explicit
> > regulator name was provided.

> Hi Mark,
>=20
> did you have time to look into this patch ?

Please don't send contentless, quoted pings.  One of two things will be
true: either your patch got lost in which case a quoted copy is of no
use in getting the patch applied or the patch is buried under other mail
in which case you are at best adding to the email volume and at worst
your mail will never be seen as it's threaded in with the original send.

--G4iJoqBmSsgzjUCe
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUaoQWAAoJECTWi3JdVIfQWNEH/34oKKwQnuU+e+v6IrqVWc68
RQ6WXFDn0kTPkTHAHyKg5w8sGtg3fCXdSqZT1vN33U2fKLteMNKNYxBUB4tmhAiM
JttDQ9hyoLw/g+NtS6P1MZX5czpGTtzchnSjtNt0rkc9VT1DFho3dWsRb7jwBGY/
96KwjYWpWUTGpI5UV2s+av/3CxrieRH6QpW9m0qxxtrzftmhxQ2uAMQ65wLmihdH
OGoZUX6zZ6IyP4RKU/tH5p+8KafGKGFw0lt1xg3NP8q997XDNr8kjWVXuZkXdM2n
YS5QYSoPrAwtGE0430TqbASCKGVnxUwabcLcpgAj9DkiMMv+181rjdwvGab6DUg=
=wDRr
-----END PGP SIGNATURE-----

--G4iJoqBmSsgzjUCe--
