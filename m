Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751450AbaLRT2f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 14:28:35 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:35887 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751107AbaLRT2e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 14:28:34 -0500
Date: Thu, 18 Dec 2014 19:28:16 +0000
From: Mark Brown <broonie@kernel.org>
To: Jonathan Corbet <corbet@lwn.net>
Cc: LKML <linux-kernel@vger.kernel.org>, Corey Minyard <cminyard@mvista.com>
Message-ID: <20141218192816.GC11764@sirena.org.uk>
References: <20141215105251.16913f8c@lwn.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3bVmXubYHmwTS0KQ"
Content-Disposition: inline
In-Reply-To: <20141215105251.16913f8c@lwn.net>
X-Cookie: I don't get no respect.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH RFC] Docs: Modernize SubmittingPatches
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--3bVmXubYHmwTS0KQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Dec 15, 2014 at 10:52:51AM -0500, Jonathan Corbet wrote:

> +15) Sending "git pull" requests
> +-------------------------------

> +If you have a series of patches, it may be most convenient to have the
> +maintainer pull them directly into the subsystem repository with a
> +"git pull" operation.  Note, however, that pulling patches from a developer
> +requires a higher degree of trust than taking patches from a mailing list.
> +As a result, many subsystem maintainers are reluctant to take pull
> +requests, especially from new, unknown developers.

Probably worth adding something like "If in doubt you can use the pull
request as the cover letter for a normal posting of the patch series,
giving the maintainer the option of using either or both" - that way
even if someone guesses wrong about the pull request being appropriate
things will most likely be OK anyway.

--3bVmXubYHmwTS0KQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUkyrPAAoJECTWi3JdVIfQG5gH/AutWNTFzROkHi3dArUJZlDk
dx+C+onDwji0d7o8KFCTJUl2fziuI5YkSFary9V3tturLu9AEzZyXz2LzSras1nY
1rNKjKyTFoZakvBft7Mu9hQCW1Z5cBKW5RTs9JYVsPgHaM9gJpb6HekLpNvrWX9K
2omKF8gFt4UZ1ppbqJpWjaCzsT1npycLzKl4NpXrX71fJW8oVWZN6P2KUE6LzURJ
BOUNsA15038hgZI3gw+kFnyjQfFM1dNpEfE1TDGV5k8tZUoJ/QHM4UySD5TVz5y3
b2HxBEjNqpqpAJBPFC8/iyWE476DO/AFL4tfK/o3WO6DqbIfGuMkPdadJqU0gmE=
=gi+d
-----END PGP SIGNATURE-----

--3bVmXubYHmwTS0KQ--
