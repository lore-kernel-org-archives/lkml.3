Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755759AbaLJLTm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 06:19:42 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:54161 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752138AbaLJLTk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 06:19:40 -0500
Date: Wed, 10 Dec 2014 11:19:25 +0000
From: Mark Brown <broonie@kernel.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: Fabio Estevam <festevam@gmail.com>, sameo@linux.intel.com,
        anthony.olech.opensource@diasemi.com, support.opensource@diasemi.com,
        johan@kernel.org, linux-kernel@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>
Message-ID: <20141210111925.GP11764@sirena.org.uk>
References: <1418175593-23474-1-git-send-email-festevam@gmail.com>
 <20141210094649.GA23481@x1>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IjzautVOrq+IorBk"
Content-Disposition: inline
In-Reply-To: <20141210094649.GA23481@x1>
X-Cookie: I don't get no respect.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] mfd: da9052-core: Fix platform-device id collision
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--IjzautVOrq+IorBk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 10, 2014 at 09:46:50AM +0000, Lee Jones wrote:
> On Tue, 09 Dec 2014, Fabio Estevam wrote:

> > Tested on a imx53-qsb board, where multiple DA9053 regulators can be=20
> > successfully probed.

> Applied for v3.20, thanks.

Fabio was saying that -next is broken which presumably means that v3.19
will be broken unless this gets sent as a fix.

--IjzautVOrq+IorBk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUiCw8AAoJECTWi3JdVIfQYu4H/jPeHZtF+awUDuAHBZt0MzaF
RwQYJ+Bxxsv70nqPhf/MC097Gox5HiR5n6RYKHwVRggX4qpt4mP9G4smo+27cXRb
l84svHbVXK4QOJ4xLPzq2gh4Rngr75xzX01MmgdkDz6pjEWG1NiN7/1ry5BAVX9L
uMEURafq7mUr/PY2X6BMwg+y31BXBYhOlh0lVK0SbblVfbPdkj7rwJZmBEYXxZcQ
eAkOBrohDagMBNCcfx+aRF1E9fCCcs8xj9MFM0MR9u/wRG/NiCgjtDixUUQ9nqEY
pRAdCkh9W3LNqYoXnyyGe6zjRKVuqXZ1JNtt2SG+0aw7lVuDOs3+hyWOnQ8bsBQ=
=0sVH
-----END PGP SIGNATURE-----

--IjzautVOrq+IorBk--
